// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boardview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoardViewDataImpl _$$BoardViewDataImplFromJson(Map<String, dynamic> json) =>
    _$BoardViewDataImpl(
      version: json['version'] as String,
      board: BoardInfo.fromJson(json['board'] as Map<String, dynamic>),
      components: (json['components'] as List<dynamic>)
          .map((e) => Component.fromJson(e as Map<String, dynamic>))
          .toList(),
      nets: (json['nets'] as List<dynamic>)
          .map((e) => Net.fromJson(e as Map<String, dynamic>))
          .toList(),
      pins: (json['pins'] as List<dynamic>)
          .map((e) => Pin.fromJson(e as Map<String, dynamic>))
          .toList(),
      device: json['device'] == null
          ? null
          : DeviceInfo.fromJson(json['device'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BoardViewDataImplToJson(_$BoardViewDataImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'board': instance.board,
      'components': instance.components,
      'nets': instance.nets,
      'pins': instance.pins,
      'device': instance.device,
    };

_$DeviceInfoImpl _$$DeviceInfoImplFromJson(Map<String, dynamic> json) =>
    _$DeviceInfoImpl(
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      boardNumber: json['boardNumber'] as String?,
      revision: json['revision'] as String?,
    );

Map<String, dynamic> _$$DeviceInfoImplToJson(_$DeviceInfoImpl instance) =>
    <String, dynamic>{
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'boardNumber': instance.boardNumber,
      'revision': instance.revision,
    };

_$BoardInfoImpl _$$BoardInfoImplFromJson(Map<String, dynamic> json) =>
    _$BoardInfoImpl(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      outline: (json['outline'] as List<dynamic>)
          .map(
            (e) =>
                (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
      units: json['units'] as String? ?? 'mm',
      layers: (json['layers'] as num?)?.toInt() ?? 2,
    );

Map<String, dynamic> _$$BoardInfoImplToJson(_$BoardInfoImpl instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'outline': instance.outline,
      'units': instance.units,
      'layers': instance.layers,
    };

_$ComponentImpl _$$ComponentImplFromJson(Map<String, dynamic> json) =>
    _$ComponentImpl(
      ref: json['ref'] as String,
      type: json['type'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      value: json['value'] as String?,
      package: json['package'] as String?,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
      side: json['side'] as String? ?? 'top',
      pins: (json['pins'] as List<dynamic>?)?.map((e) => e as String).toList(),
      description: json['description'] as String?,
      datasheet: json['datasheet'] as String?,
      replacements: (json['replacements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ComponentImplToJson(_$ComponentImpl instance) =>
    <String, dynamic>{
      'ref': instance.ref,
      'type': instance.type,
      'x': instance.x,
      'y': instance.y,
      'value': instance.value,
      'package': instance.package,
      'rotation': instance.rotation,
      'side': instance.side,
      'pins': instance.pins,
      'description': instance.description,
      'datasheet': instance.datasheet,
      'replacements': instance.replacements,
    };

_$NetImpl _$$NetImplFromJson(Map<String, dynamic> json) => _$NetImpl(
  name: json['name'] as String,
  pins: (json['pins'] as List<dynamic>).map((e) => e as String).toList(),
  id: json['id'] as String?,
);

Map<String, dynamic> _$$NetImplToJson(_$NetImpl instance) => <String, dynamic>{
  'name': instance.name,
  'pins': instance.pins,
  'id': instance.id,
};

_$PinImpl _$$PinImplFromJson(Map<String, dynamic> json) => _$PinImpl(
  component: json['component'] as String,
  number: json['number'] as String,
  net: json['net'] as String,
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
);

Map<String, dynamic> _$$PinImplToJson(_$PinImpl instance) => <String, dynamic>{
  'component': instance.component,
  'number': instance.number,
  'net': instance.net,
  'x': instance.x,
  'y': instance.y,
};

_$LayerInfoImpl _$$LayerInfoImplFromJson(Map<String, dynamic> json) =>
    _$LayerInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      image: json['image'] as String,
      visible: json['visible'] as bool? ?? true,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$LayerInfoImplToJson(_$LayerInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'image': instance.image,
      'visible': instance.visible,
      'opacity': instance.opacity,
    };
