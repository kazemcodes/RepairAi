import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

/// GitHub index entry model
class IndexEntry {
  final String path;
  final String type;
  final String? hash;
  final String? index;
  final List<String>? images;

  IndexEntry({
    required this.path,
    required this.type,
    this.hash,
    this.index,
    this.images,
  });

  factory IndexEntry.fromJson(Map<String, dynamic> json) {
    return IndexEntry(
      path: json['path'] ?? '',
      type: json['type'] ?? 'unknown',
      hash: json['hash'],
      index: json['index'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'type': type,
      if (hash != null) 'hash': hash,
      if (index != null) 'index': index,
      if (images != null) 'images': images,
    };
  }
}

/// GitHub index model
class GitHubIndex {
  final String version;
  final DateTime updatedAt;
  final List<IndexEntry> schematics;
  final List<IndexEntry> solutions;

  GitHubIndex({
    required this.version,
    required this.updatedAt,
    required this.schematics,
    required this.solutions,
  });

  factory GitHubIndex.fromJson(Map<String, dynamic> json) {
    return GitHubIndex(
      version: json['version'] ?? '1.0.0',
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
      schematics: json['schematics'] != null
          ? (json['schematics'] as List).map((e) => IndexEntry.fromJson(e)).toList()
          : [],
      solutions: json['solutions'] != null
          ? (json['solutions'] as List).map((e) => IndexEntry.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'updated_at': updatedAt.toIso8601String(),
      'schematics': schematics.map((e) => e.toJson()).toList(),
      'solutions': solutions.map((e) => e.toJson()).toList(),
    };
  }
}

/// GitHub service for interacting with GitHub API
class GitHubService {
  final http.Client _httpClient;

  GitHubService(this._httpClient);

  /// Fetch the main index.json from GitHub
  Future<GitHubIndex> fetchIndex() async {
    final response = await _httpClient.get(
      Uri.parse(AppConstants.indexJsonUrl),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return GitHubIndex.fromJson(json);
    } else {
      throw Exception('Failed to fetch index: ${response.statusCode}');
    }
  }

  /// Fetch a schematic file from GitHub
  Future<List<int>> fetchSchematic(String path) async {
    final url = '${AppConstants.githubRawBase}/$path';
    final response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to fetch schematic: ${response.statusCode}');
    }
  }

  /// Fetch a solution file from GitHub
  Future<Map<String, dynamic>> fetchSolution(String path) async {
    final url = '${AppConstants.githubRawBase}/$path';
    final response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch solution: ${response.statusCode}');
    }
  }

  /// Search schematics by model or manufacturer
  Future<List<IndexEntry>> searchSchematics(String query) async {
    final index = await fetchIndex();
    final lowerQuery = query.toLowerCase();
    
    return index.schematics.where((entry) {
      return entry.path.toLowerCase().contains(lowerQuery) ||
             (entry.index?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Search solutions by problem or index
  Future<List<IndexEntry>> searchSolutions(String query) async {
    final index = await fetchIndex();
    final lowerQuery = query.toLowerCase();
    
    return index.solutions.where((entry) {
      return entry.path.toLowerCase().contains(lowerQuery) ||
             (entry.index?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Get raw file URL
  String getRawFileUrl(String path) {
    return '${AppConstants.githubRawBase}/$path';
  }
}

/// GitHub service provider
final githubServiceProvider = Provider<GitHubService>((ref) {
  return GitHubService(http.Client());
});

/// Cached index provider
final githubIndexProvider = FutureProvider<GitHubIndex>((ref) async {
  final service = ref.watch(githubServiceProvider);
  return service.fetchIndex();
});
