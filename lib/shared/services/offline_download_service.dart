import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'github_service.dart';

/// Offline Download Service
/// Manages downloading and caching of device packages for offline use
class OfflineDownloadService {
  static const String _offlinePackagesKey = 'offline_packages';
  static const String _downloadProgressKey = 'download_progress';
  
  final GitHubService _githubService;
  
  OfflineDownloadService(this._githubService);
  
  /// Get the local storage directory for offline files
  Future<Directory> get _localDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final offlineDir = Directory('${appDir.path}/offline_packages');
    if (!await offlineDir.exists()) {
      await offlineDir.create(recursive: true);
    }
    return offlineDir;
  }
  
  /// Get list of downloaded offline packages
  Future<List<OfflinePackage>> getDownloadedPackages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final packagesJson = prefs.getString(_offlinePackagesKey);
      
      if (packagesJson == null) return [];
      
      final List<dynamic> decoded = jsonDecode(packagesJson);
      return decoded.map((e) => OfflinePackage.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting downloaded packages: $e');
      return [];
    }
  }
  
  /// Check if a device package is downloaded
  Future<bool> isPackageDownloaded(String manufacturer, String model) async {
    final packages = await getDownloadedPackages();
    return packages.any((p) => 
      p.manufacturer.toLowerCase() == manufacturer.toLowerCase() &&
      p.model.toLowerCase() == model.toLowerCase()
    );
  }
  
  /// Get download progress for a package
  Future<double> getDownloadProgress(String manufacturer, String model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString('$_downloadProgressKey\_$manufacturer\_$model');
      
      if (progressJson == null) return 0.0;
      
      return jsonDecode(progressJson) as double;
    } catch (e) {
      return 0.0;
    }
  }
  
  /// Download a complete device package for offline use
  Future<OfflinePackage> downloadPackage({
    required String manufacturer,
    required String model,
    required List<String> schematicPaths,
    required List<String> solutionPaths,
    Function(double progress, String status)? onProgress,
  }) async {
    final packageId = '${manufacturer}_$model'.toLowerCase().replaceAll(' ', '_');
    final localDir = await _localDirectory;
    final packageDir = Directory('${localDir.path}/$packageId');
    
    if (!await packageDir.exists()) {
      await packageDir.create(recursive: true);
    }
    
    final downloadedFiles = <String>[];
    final totalFiles = schematicPaths.length + solutionPaths.length;
    var completedFiles = 0;
    
    // Download schematics
    for (final path in schematicPaths) {
      try {
        onProgress?.call(
          completedFiles / totalFiles,
          'Downloading ${path.split('/').last}...',
        );
        
        final localPath = await _downloadFile(path, packageDir.path);
        if (localPath != null) {
          downloadedFiles.add(localPath);
        }
        
        completedFiles++;
        await _saveProgress(manufacturer, model, completedFiles / totalFiles);
      } catch (e) {
        debugPrint('Error downloading $path: $e');
      }
    }
    
    // Download solutions
    for (final path in solutionPaths) {
      try {
        onProgress?.call(
          completedFiles / totalFiles,
          'Downloading ${path.split('/').last}...',
        );
        
        final localPath = await _downloadFile(path, packageDir.path);
        if (localPath != null) {
          downloadedFiles.add(localPath);
        }
        
        completedFiles++;
        await _saveProgress(manufacturer, model, completedFiles / totalFiles);
      } catch (e) {
        debugPrint('Error downloading $path: $e');
      }
    }
    
    // Create package metadata
    final package = OfflinePackage(
      id: packageId,
      manufacturer: manufacturer,
      model: model,
      downloadedAt: DateTime.now(),
      files: downloadedFiles,
      schematicCount: schematicPaths.length,
      solutionCount: solutionPaths.length,
      sizeBytes: await _calculateDirectorySize(packageDir),
    );
    
    // Save package metadata
    await _savePackageMetadata(package);
    
    onProgress?.call(1.0, 'Download complete!');
    
    return package;
  }
  
  /// Download a single file
  Future<String?> _downloadFile(String path, String localDir) async {
    try {
      final url = _githubService.getRawFileUrl(path);
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final fileName = path.split('/').last;
        final localPath = '$localDir/$fileName';
        final file = File(localPath);
        await file.writeAsBytes(response.bodyBytes);
        return localPath;
      }
    } catch (e) {
      debugPrint('Error downloading file $path: $e');
    }
    return null;
  }
  
  /// Save download progress
  Future<void> _saveProgress(String manufacturer, String model, double progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_downloadProgressKey\_$manufacturer\_$model',
      jsonEncode(progress),
    );
  }
  
  /// Save package metadata
  Future<void> _savePackageMetadata(OfflinePackage package) async {
    final prefs = await SharedPreferences.getInstance();
    final packages = await getDownloadedPackages();
    
    // Remove existing package with same ID
    packages.removeWhere((p) => p.id == package.id);
    packages.add(package);
    
    await prefs.setString(
      _offlinePackagesKey,
      jsonEncode(packages.map((p) => p.toJson()).toList()),
    );
  }
  
  /// Calculate directory size
  Future<int> _calculateDirectorySize(Directory dir) async {
    int size = 0;
    try {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          size += await entity.length();
        }
      }
    } catch (e) {
      debugPrint('Error calculating directory size: $e');
    }
    return size;
  }
  
  /// Delete an offline package
  Future<void> deletePackage(String packageId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final packages = await getDownloadedPackages();
      
      final package = packages.firstWhere((p) => p.id == packageId);
      
      // Delete local files
      final localDir = await _localDirectory;
      final packageDir = Directory('${localDir.path}/$packageId');
      if (await packageDir.exists()) {
        await packageDir.delete(recursive: true);
      }
      
      // Remove from metadata
      packages.removeWhere((p) => p.id == packageId);
      await prefs.setString(
        _offlinePackagesKey,
        jsonEncode(packages.map((p) => p.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error deleting package: $e');
    }
  }
  
  /// Get local file path for an offline file
  Future<String?> getLocalFilePath(String manufacturer, String model, String fileName) async {
    final packageId = '${manufacturer}_$model'.toLowerCase().replaceAll(' ', '_');
    final localDir = await _localDirectory;
    final localPath = '${localDir.path}/$packageId/$fileName';
    
    if (await File(localPath).exists()) {
      return localPath;
    }
    return null;
  }
  
  /// Get total offline storage used
  Future<int> getTotalStorageUsed() async {
    final localDir = await _localDirectory;
    return _calculateDirectorySize(localDir);
  }
  
  /// Clear all offline packages
  Future<void> clearAllPackages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localDir = await _localDirectory;
      
      if (await localDir.exists()) {
        await localDir.delete(recursive: true);
      }
      
      await prefs.remove(_offlinePackagesKey);
    } catch (e) {
      debugPrint('Error clearing packages: $e');
    }
  }
}

/// Offline package metadata
class OfflinePackage {
  final String id;
  final String manufacturer;
  final String model;
  final DateTime downloadedAt;
  final List<String> files;
  final int schematicCount;
  final int solutionCount;
  final int sizeBytes;
  
  const OfflinePackage({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.downloadedAt,
    required this.files,
    required this.schematicCount,
    required this.solutionCount,
    required this.sizeBytes,
  });
  
  factory OfflinePackage.fromJson(Map<String, dynamic> json) {
    return OfflinePackage(
      id: json['id'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      model: json['model'] ?? '',
      downloadedAt: DateTime.parse(json['downloadedAt']),
      files: List<String>.from(json['files'] ?? []),
      schematicCount: json['schematicCount'] ?? 0,
      solutionCount: json['solutionCount'] ?? 0,
      sizeBytes: json['sizeBytes'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'manufacturer': manufacturer,
      'model': model,
      'downloadedAt': downloadedAt.toIso8601String(),
      'files': files,
      'schematicCount': schematicCount,
      'solutionCount': solutionCount,
      'sizeBytes': sizeBytes,
    };
  }
  
  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    if (sizeBytes < 1024 * 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Provider for offline download service
final offlineDownloadServiceProvider = Provider<OfflineDownloadService>((ref) {
  final githubService = ref.watch(githubServiceProvider);
  return OfflineDownloadService(githubService);
});
