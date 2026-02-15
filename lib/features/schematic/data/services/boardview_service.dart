import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../models/boardview_model.dart';

/// Device index entry
class DeviceIndexEntry {
  final String manufacturer;
  final String model;
  final String status;
  final String? path;

  DeviceIndexEntry({
    required this.manufacturer,
    required this.model,
    required this.status,
    this.path,
  });

  factory DeviceIndexEntry.fromJson(Map<String, dynamic> json) {
    return DeviceIndexEntry(
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      status: json['status'] as String,
      path: json['path'] as String?,
    );
  }

  bool get isAvailable => status == 'available';
  bool get isAwaiting => status == 'awaiting';
}

/// Device index
class DeviceIndex {
  final DateTime generated;
  final int totalDevices;
  final int devicesWithData;
  final int devicesAwaitingData;
  final Map<String, ManufacturerStats> manufacturers;
  final List<DeviceIndexEntry> devices;

  DeviceIndex({
    required this.generated,
    required this.totalDevices,
    required this.devicesWithData,
    required this.devicesAwaitingData,
    required this.manufacturers,
    required this.devices,
  });

  factory DeviceIndex.fromJson(Map<String, dynamic> json) {
    return DeviceIndex(
      generated: DateTime.parse(json['generated'] as String),
      totalDevices: json['total_devices'] as int,
      devicesWithData: json['devices_with_data'] as int,
      devicesAwaitingData: json['devices_awaiting_data'] as int,
      manufacturers: (json['manufacturers'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          ManufacturerStats.fromJson(value as Map<String, dynamic>),
        ),
      ),
      devices: (json['devices'] as List)
          .map((e) => DeviceIndexEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<String> get manufacturerNames => manufacturers.keys.toList()..sort();
  
  List<DeviceIndexEntry> getDevicesByManufacturer(String manufacturer) {
    return devices.where((d) => d.manufacturer == manufacturer).toList();
  }
  
  List<DeviceIndexEntry> get availableDevices {
    return devices.where((d) => d.isAvailable).toList();
  }
}

/// Manufacturer statistics
class ManufacturerStats {
  final int total;
  final int withData;
  final int awaitingData;

  ManufacturerStats({
    required this.total,
    required this.withData,
    required this.awaitingData,
  });

  factory ManufacturerStats.fromJson(Map<String, dynamic> json) {
    return ManufacturerStats(
      total: json['total'] as int,
      withData: json['with_data'] as int,
      awaitingData: json['awaiting_data'] as int,
    );
  }
}

/// Service for loading boardview data
class BoardViewService {
  final String baseUrl;
  final http.Client? httpClient;
  DeviceIndex? _cachedIndex;

  BoardViewService({
    this.baseUrl = AppConstants.githubRawBase,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Load device index
  Future<DeviceIndex> loadDeviceIndex({bool forceRefresh = false}) async {
    if (_cachedIndex != null && !forceRefresh) {
      return _cachedIndex!;
    }

    final url = '$baseUrl/DEVICES_INDEX.json';
    
    try {
      final response = await httpClient!.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        _cachedIndex = DeviceIndex.fromJson(json);
        return _cachedIndex!;
      } else {
        throw BoardViewLoadException(
          'Failed to load device index: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is BoardViewException) rethrow;
      throw BoardViewLoadException('Error loading device index: $e');
    }
  }

  /// Load boardview data for a device
  Future<BoardViewData> loadBoardView({
    required String manufacturer,
    required String model,
  }) async {
    // First try loading from GitHub
    try {
      final data = await _loadFromGitHub(manufacturer: manufacturer, model: model);
      return data;
    } catch (e) {
      // Fallback to local assets
      try {
        final data = await _loadFromAssets(manufacturer: manufacturer, model: model);
        return data;
      } catch (e2) {
        // Re-throw the original error if both fail
        throw BoardViewLoadException('Failed to load boardview from both GitHub and local: $e');
      }
    }
  }

  /// Load boardview from GitHub
  Future<BoardViewData> _loadFromGitHub({
    required String manufacturer,
    required String model,
  }) async {
    final url = '$baseUrl/${manufacturer.toLowerCase()}/${model.toLowerCase()}/boardview/boardview.json';
    
    try {
      final response = await httpClient!.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return BoardViewData.fromJson(json);
      } else if (response.statusCode == 404) {
        throw BoardViewNotFoundException(
          'Boardview not found for $manufacturer $model on GitHub',
        );
      } else {
        throw BoardViewLoadException(
          'Failed to load boardview from GitHub: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is BoardViewException) rethrow;
      throw BoardViewLoadException('Error loading boardview from GitHub: $e');
    }
  }

  /// Load boardview from local assets
  Future<BoardViewData> _loadFromAssets({
    required String manufacturer,
    required String model,
  }) async {
    try {
      final assetPath = '${manufacturer.toLowerCase()}/$model/boardview/boardview.json';
      final jsonString = await rootBundle.loadString(assetPath);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return BoardViewData.fromJson(json);
    } catch (e) {
      throw BoardViewNotFoundException(
        'Boardview not found in assets for $manufacturer $model',
      );
    }
  }

  /// Check if boardview exists for a device
  Future<bool> hasBoardView({
    required String manufacturer,
    required String model,
  }) async {
    try {
      await loadBoardView(manufacturer: manufacturer, model: model);
      return true;
    } on BoardViewNotFoundException {
      return false;
    }
  }

  /// Get SVG layer URL
  String getLayerUrl({
    required String manufacturer,
    required String model,
    required String layer,
  }) {
    return '$baseUrl/${manufacturer.toLowerCase()}/${model.toLowerCase()}/boardview/layers/$layer.svg';
  }

  /// Get preview image URL
  String getPreviewUrl({
    required String manufacturer,
    required String model,
  }) {
    return '$baseUrl/${manufacturer.toLowerCase()}/${model.toLowerCase()}/boardview/preview.png';
  }

  /// Search for components
  List<Component> searchComponents(
    BoardViewData boardData,
    String query,
  ) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return boardData.components.where((component) {
      return component.ref.toLowerCase().contains(lowerQuery) ||
             (component.value?.toLowerCase().contains(lowerQuery) ?? false) ||
             (component.description?.toLowerCase().contains(lowerQuery) ?? false) ||
             component.type.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get nets connected to a component
  List<Net> getComponentNets(
    BoardViewData boardData,
    Component component,
  ) {
    return boardData.nets.where((net) {
      return net.pins.any((pin) => pin.startsWith('${component.ref}.'));
    }).toList();
  }

  /// Get pins for a component
  List<Pin> getComponentPins(
    BoardViewData boardData,
    Component component,
  ) {
    return boardData.pins.where((pin) {
      return pin.component == component.ref;
    }).toList();
  }

  void dispose() {
    httpClient?.close();
  }
}

/// Base exception for boardview operations
abstract class BoardViewException implements Exception {
  final String message;
  BoardViewException(this.message);

  @override
  String toString() => message;
}

/// Exception when boardview is not found
class BoardViewNotFoundException extends BoardViewException {
  BoardViewNotFoundException(super.message);
}

/// Exception when loading fails
class BoardViewLoadException extends BoardViewException {
  BoardViewLoadException(super.message);
}
