import 'package:freezed_annotation/freezed_annotation.dart';

part 'boardview_model.freezed.dart';
part 'boardview_model.g.dart';

/// BoardView data model
@freezed
class BoardViewData with _$BoardViewData {
  const factory BoardViewData({
    required String version,
    required BoardInfo board,
    required List<Component> components,
    required List<Net> nets,
    required List<Pin> pins,
    DeviceInfo? device,
  }) = _BoardViewData;

  factory BoardViewData.fromJson(Map<String, dynamic> json) =>
      _$BoardViewDataFromJson(json);
}

/// Device information
@freezed
class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    required String manufacturer,
    required String model,
    String? boardNumber,
    String? revision,
  }) = _DeviceInfo;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}

/// Board information
@freezed
class BoardInfo with _$BoardInfo {
  const factory BoardInfo({
    required double width,
    required double height,
    required List<List<double>> outline,
    @Default('mm') String units,
    @Default(2) int layers,
  }) = _BoardInfo;

  factory BoardInfo.fromJson(Map<String, dynamic> json) =>
      _$BoardInfoFromJson(json);
}

/// Component on the board
@freezed
class Component with _$Component {
  const factory Component({
    required String ref,
    required String type,
    required double x,
    required double y,
    String? value,
    String? package,
    @Default(0) double rotation,
    @Default('top') String side,
    List<String>? pins,
    String? description,
    String? datasheet,
    List<String>? replacements,
  }) = _Component;

  factory Component.fromJson(Map<String, dynamic> json) =>
      _$ComponentFromJson(json);
}

/// Net (electrical connection)
@freezed
class Net with _$Net {
  const factory Net({
    required String name,
    required List<String> pins,
    String? id,
  }) = _Net;

  factory Net.fromJson(Map<String, dynamic> json) => _$NetFromJson(json);
}

/// Pin on a component
@freezed
class Pin with _$Pin {
  const factory Pin({
    required String component,
    required String number,
    required String net,
    required double x,
    required double y,
  }) = _Pin;

  factory Pin.fromJson(Map<String, dynamic> json) => _$PinFromJson(json);
}

/// Layer information
@freezed
class LayerInfo with _$LayerInfo {
  const factory LayerInfo({
    required String id,
    required String name,
    required String type,
    required String image,
    @Default(true) bool visible,
    @Default(1.0) double opacity,
  }) = _LayerInfo;

  factory LayerInfo.fromJson(Map<String, dynamic> json) =>
      _$LayerInfoFromJson(json);
}
