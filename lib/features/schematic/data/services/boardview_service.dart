import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/boardview_model.dart';

/// Service for loading boardview data
class BoardViewService {
  final String baseUrl;
  final http.Client? httpClient;

  BoardViewService({
    this.baseUrl = 'https://raw.githubusercontent.com/YOUR_USERNAME/repairai-files/main',
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Load boardview data for a device
  Future<BoardViewData> loadBoardView({
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
          'Boardview not found for $manufacturer $model',
        );
      } else {
        throw BoardViewLoadException(
          'Failed to load boardview: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is BoardViewException) rethrow;
      throw BoardViewLoadException('Error loading boardview: $e');
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
