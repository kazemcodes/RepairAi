import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/boardview_service.dart';
import '../models/boardview_model.dart';

/// Provider for BoardViewService
final boardViewServiceProvider = Provider<BoardViewService>((ref) {
  final service = BoardViewService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for loading boardview data
final boardViewDataProvider = FutureProvider.family<BoardViewData, BoardViewParams>(
  (ref, params) async {
    final service = ref.watch(boardViewServiceProvider);
    return service.loadBoardView(
      manufacturer: params.manufacturer,
      model: params.model,
    );
  },
);

/// Provider for checking if boardview exists
final hasBoardViewProvider = FutureProvider.family<bool, BoardViewParams>(
  (ref, params) async {
    final service = ref.watch(boardViewServiceProvider);
    return service.hasBoardView(
      manufacturer: params.manufacturer,
      model: params.model,
    );
  },
);

/// Parameters for boardview providers
class BoardViewParams {
  final String manufacturer;
  final String model;

  const BoardViewParams({
    required this.manufacturer,
    required this.model,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardViewParams &&
          runtimeType == other.runtimeType &&
          manufacturer == other.manufacturer &&
          model == other.model;

  @override
  int get hashCode => manufacturer.hashCode ^ model.hashCode;
}
