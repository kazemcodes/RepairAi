// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'boardview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BoardViewData _$BoardViewDataFromJson(Map<String, dynamic> json) {
  return _BoardViewData.fromJson(json);
}

/// @nodoc
mixin _$BoardViewData {
  String get version => throw _privateConstructorUsedError;
  BoardInfo get board => throw _privateConstructorUsedError;
  List<Component> get components => throw _privateConstructorUsedError;
  List<Net> get nets => throw _privateConstructorUsedError;
  List<Pin> get pins => throw _privateConstructorUsedError;
  DeviceInfo? get device => throw _privateConstructorUsedError;

  /// Serializes this BoardViewData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoardViewData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoardViewDataCopyWith<BoardViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardViewDataCopyWith<$Res> {
  factory $BoardViewDataCopyWith(
    BoardViewData value,
    $Res Function(BoardViewData) then,
  ) = _$BoardViewDataCopyWithImpl<$Res, BoardViewData>;
  @useResult
  $Res call({
    String version,
    BoardInfo board,
    List<Component> components,
    List<Net> nets,
    List<Pin> pins,
    DeviceInfo? device,
  });

  $BoardInfoCopyWith<$Res> get board;
  $DeviceInfoCopyWith<$Res>? get device;
}

/// @nodoc
class _$BoardViewDataCopyWithImpl<$Res, $Val extends BoardViewData>
    implements $BoardViewDataCopyWith<$Res> {
  _$BoardViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoardViewData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? board = null,
    Object? components = null,
    Object? nets = null,
    Object? pins = null,
    Object? device = freezed,
  }) {
    return _then(
      _value.copyWith(
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            board: null == board
                ? _value.board
                : board // ignore: cast_nullable_to_non_nullable
                      as BoardInfo,
            components: null == components
                ? _value.components
                : components // ignore: cast_nullable_to_non_nullable
                      as List<Component>,
            nets: null == nets
                ? _value.nets
                : nets // ignore: cast_nullable_to_non_nullable
                      as List<Net>,
            pins: null == pins
                ? _value.pins
                : pins // ignore: cast_nullable_to_non_nullable
                      as List<Pin>,
            device: freezed == device
                ? _value.device
                : device // ignore: cast_nullable_to_non_nullable
                      as DeviceInfo?,
          )
          as $Val,
    );
  }

  /// Create a copy of BoardViewData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoardInfoCopyWith<$Res> get board {
    return $BoardInfoCopyWith<$Res>(_value.board, (value) {
      return _then(_value.copyWith(board: value) as $Val);
    });
  }

  /// Create a copy of BoardViewData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeviceInfoCopyWith<$Res>? get device {
    if (_value.device == null) {
      return null;
    }

    return $DeviceInfoCopyWith<$Res>(_value.device!, (value) {
      return _then(_value.copyWith(device: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BoardViewDataImplCopyWith<$Res>
    implements $BoardViewDataCopyWith<$Res> {
  factory _$$BoardViewDataImplCopyWith(
    _$BoardViewDataImpl value,
    $Res Function(_$BoardViewDataImpl) then,
  ) = __$$BoardViewDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String version,
    BoardInfo board,
    List<Component> components,
    List<Net> nets,
    List<Pin> pins,
    DeviceInfo? device,
  });

  @override
  $BoardInfoCopyWith<$Res> get board;
  @override
  $DeviceInfoCopyWith<$Res>? get device;
}

/// @nodoc
class __$$BoardViewDataImplCopyWithImpl<$Res>
    extends _$BoardViewDataCopyWithImpl<$Res, _$BoardViewDataImpl>
    implements _$$BoardViewDataImplCopyWith<$Res> {
  __$$BoardViewDataImplCopyWithImpl(
    _$BoardViewDataImpl _value,
    $Res Function(_$BoardViewDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoardViewData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? board = null,
    Object? components = null,
    Object? nets = null,
    Object? pins = null,
    Object? device = freezed,
  }) {
    return _then(
      _$BoardViewDataImpl(
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        board: null == board
            ? _value.board
            : board // ignore: cast_nullable_to_non_nullable
                  as BoardInfo,
        components: null == components
            ? _value._components
            : components // ignore: cast_nullable_to_non_nullable
                  as List<Component>,
        nets: null == nets
            ? _value._nets
            : nets // ignore: cast_nullable_to_non_nullable
                  as List<Net>,
        pins: null == pins
            ? _value._pins
            : pins // ignore: cast_nullable_to_non_nullable
                  as List<Pin>,
        device: freezed == device
            ? _value.device
            : device // ignore: cast_nullable_to_non_nullable
                  as DeviceInfo?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BoardViewDataImpl implements _BoardViewData {
  const _$BoardViewDataImpl({
    required this.version,
    required this.board,
    required final List<Component> components,
    required final List<Net> nets,
    required final List<Pin> pins,
    this.device,
  }) : _components = components,
       _nets = nets,
       _pins = pins;

  factory _$BoardViewDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoardViewDataImplFromJson(json);

  @override
  final String version;
  @override
  final BoardInfo board;
  final List<Component> _components;
  @override
  List<Component> get components {
    if (_components is EqualUnmodifiableListView) return _components;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_components);
  }

  final List<Net> _nets;
  @override
  List<Net> get nets {
    if (_nets is EqualUnmodifiableListView) return _nets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nets);
  }

  final List<Pin> _pins;
  @override
  List<Pin> get pins {
    if (_pins is EqualUnmodifiableListView) return _pins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pins);
  }

  @override
  final DeviceInfo? device;

  @override
  String toString() {
    return 'BoardViewData(version: $version, board: $board, components: $components, nets: $nets, pins: $pins, device: $device)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardViewDataImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.board, board) || other.board == board) &&
            const DeepCollectionEquality().equals(
              other._components,
              _components,
            ) &&
            const DeepCollectionEquality().equals(other._nets, _nets) &&
            const DeepCollectionEquality().equals(other._pins, _pins) &&
            (identical(other.device, device) || other.device == device));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    version,
    board,
    const DeepCollectionEquality().hash(_components),
    const DeepCollectionEquality().hash(_nets),
    const DeepCollectionEquality().hash(_pins),
    device,
  );

  /// Create a copy of BoardViewData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardViewDataImplCopyWith<_$BoardViewDataImpl> get copyWith =>
      __$$BoardViewDataImplCopyWithImpl<_$BoardViewDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoardViewDataImplToJson(this);
  }
}

abstract class _BoardViewData implements BoardViewData {
  const factory _BoardViewData({
    required final String version,
    required final BoardInfo board,
    required final List<Component> components,
    required final List<Net> nets,
    required final List<Pin> pins,
    final DeviceInfo? device,
  }) = _$BoardViewDataImpl;

  factory _BoardViewData.fromJson(Map<String, dynamic> json) =
      _$BoardViewDataImpl.fromJson;

  @override
  String get version;
  @override
  BoardInfo get board;
  @override
  List<Component> get components;
  @override
  List<Net> get nets;
  @override
  List<Pin> get pins;
  @override
  DeviceInfo? get device;

  /// Create a copy of BoardViewData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoardViewDataImplCopyWith<_$BoardViewDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) {
  return _DeviceInfo.fromJson(json);
}

/// @nodoc
mixin _$DeviceInfo {
  String get manufacturer => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String? get boardNumber => throw _privateConstructorUsedError;
  String? get revision => throw _privateConstructorUsedError;

  /// Serializes this DeviceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceInfoCopyWith<DeviceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoCopyWith<$Res> {
  factory $DeviceInfoCopyWith(
    DeviceInfo value,
    $Res Function(DeviceInfo) then,
  ) = _$DeviceInfoCopyWithImpl<$Res, DeviceInfo>;
  @useResult
  $Res call({
    String manufacturer,
    String model,
    String? boardNumber,
    String? revision,
  });
}

/// @nodoc
class _$DeviceInfoCopyWithImpl<$Res, $Val extends DeviceInfo>
    implements $DeviceInfoCopyWith<$Res> {
  _$DeviceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? manufacturer = null,
    Object? model = null,
    Object? boardNumber = freezed,
    Object? revision = freezed,
  }) {
    return _then(
      _value.copyWith(
            manufacturer: null == manufacturer
                ? _value.manufacturer
                : manufacturer // ignore: cast_nullable_to_non_nullable
                      as String,
            model: null == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                      as String,
            boardNumber: freezed == boardNumber
                ? _value.boardNumber
                : boardNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            revision: freezed == revision
                ? _value.revision
                : revision // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeviceInfoImplCopyWith<$Res>
    implements $DeviceInfoCopyWith<$Res> {
  factory _$$DeviceInfoImplCopyWith(
    _$DeviceInfoImpl value,
    $Res Function(_$DeviceInfoImpl) then,
  ) = __$$DeviceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String manufacturer,
    String model,
    String? boardNumber,
    String? revision,
  });
}

/// @nodoc
class __$$DeviceInfoImplCopyWithImpl<$Res>
    extends _$DeviceInfoCopyWithImpl<$Res, _$DeviceInfoImpl>
    implements _$$DeviceInfoImplCopyWith<$Res> {
  __$$DeviceInfoImplCopyWithImpl(
    _$DeviceInfoImpl _value,
    $Res Function(_$DeviceInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? manufacturer = null,
    Object? model = null,
    Object? boardNumber = freezed,
    Object? revision = freezed,
  }) {
    return _then(
      _$DeviceInfoImpl(
        manufacturer: null == manufacturer
            ? _value.manufacturer
            : manufacturer // ignore: cast_nullable_to_non_nullable
                  as String,
        model: null == model
            ? _value.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String,
        boardNumber: freezed == boardNumber
            ? _value.boardNumber
            : boardNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        revision: freezed == revision
            ? _value.revision
            : revision // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceInfoImpl implements _DeviceInfo {
  const _$DeviceInfoImpl({
    required this.manufacturer,
    required this.model,
    this.boardNumber,
    this.revision,
  });

  factory _$DeviceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceInfoImplFromJson(json);

  @override
  final String manufacturer;
  @override
  final String model;
  @override
  final String? boardNumber;
  @override
  final String? revision;

  @override
  String toString() {
    return 'DeviceInfo(manufacturer: $manufacturer, model: $model, boardNumber: $boardNumber, revision: $revision)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoImpl &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.boardNumber, boardNumber) ||
                other.boardNumber == boardNumber) &&
            (identical(other.revision, revision) ||
                other.revision == revision));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, manufacturer, model, boardNumber, revision);

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      __$$DeviceInfoImplCopyWithImpl<_$DeviceInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceInfoImplToJson(this);
  }
}

abstract class _DeviceInfo implements DeviceInfo {
  const factory _DeviceInfo({
    required final String manufacturer,
    required final String model,
    final String? boardNumber,
    final String? revision,
  }) = _$DeviceInfoImpl;

  factory _DeviceInfo.fromJson(Map<String, dynamic> json) =
      _$DeviceInfoImpl.fromJson;

  @override
  String get manufacturer;
  @override
  String get model;
  @override
  String? get boardNumber;
  @override
  String? get revision;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BoardInfo _$BoardInfoFromJson(Map<String, dynamic> json) {
  return _BoardInfo.fromJson(json);
}

/// @nodoc
mixin _$BoardInfo {
  double get width => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;
  List<List<double>> get outline => throw _privateConstructorUsedError;
  String get units => throw _privateConstructorUsedError;
  int get layers => throw _privateConstructorUsedError;

  /// Serializes this BoardInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoardInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoardInfoCopyWith<BoardInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardInfoCopyWith<$Res> {
  factory $BoardInfoCopyWith(BoardInfo value, $Res Function(BoardInfo) then) =
      _$BoardInfoCopyWithImpl<$Res, BoardInfo>;
  @useResult
  $Res call({
    double width,
    double height,
    List<List<double>> outline,
    String units,
    int layers,
  });
}

/// @nodoc
class _$BoardInfoCopyWithImpl<$Res, $Val extends BoardInfo>
    implements $BoardInfoCopyWith<$Res> {
  _$BoardInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoardInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? outline = null,
    Object? units = null,
    Object? layers = null,
  }) {
    return _then(
      _value.copyWith(
            width: null == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as double,
            height: null == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as double,
            outline: null == outline
                ? _value.outline
                : outline // ignore: cast_nullable_to_non_nullable
                      as List<List<double>>,
            units: null == units
                ? _value.units
                : units // ignore: cast_nullable_to_non_nullable
                      as String,
            layers: null == layers
                ? _value.layers
                : layers // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BoardInfoImplCopyWith<$Res>
    implements $BoardInfoCopyWith<$Res> {
  factory _$$BoardInfoImplCopyWith(
    _$BoardInfoImpl value,
    $Res Function(_$BoardInfoImpl) then,
  ) = __$$BoardInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double width,
    double height,
    List<List<double>> outline,
    String units,
    int layers,
  });
}

/// @nodoc
class __$$BoardInfoImplCopyWithImpl<$Res>
    extends _$BoardInfoCopyWithImpl<$Res, _$BoardInfoImpl>
    implements _$$BoardInfoImplCopyWith<$Res> {
  __$$BoardInfoImplCopyWithImpl(
    _$BoardInfoImpl _value,
    $Res Function(_$BoardInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoardInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? outline = null,
    Object? units = null,
    Object? layers = null,
  }) {
    return _then(
      _$BoardInfoImpl(
        width: null == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as double,
        height: null == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as double,
        outline: null == outline
            ? _value._outline
            : outline // ignore: cast_nullable_to_non_nullable
                  as List<List<double>>,
        units: null == units
            ? _value.units
            : units // ignore: cast_nullable_to_non_nullable
                  as String,
        layers: null == layers
            ? _value.layers
            : layers // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BoardInfoImpl implements _BoardInfo {
  const _$BoardInfoImpl({
    required this.width,
    required this.height,
    required final List<List<double>> outline,
    this.units = 'mm',
    this.layers = 2,
  }) : _outline = outline;

  factory _$BoardInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoardInfoImplFromJson(json);

  @override
  final double width;
  @override
  final double height;
  final List<List<double>> _outline;
  @override
  List<List<double>> get outline {
    if (_outline is EqualUnmodifiableListView) return _outline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outline);
  }

  @override
  @JsonKey()
  final String units;
  @override
  @JsonKey()
  final int layers;

  @override
  String toString() {
    return 'BoardInfo(width: $width, height: $height, outline: $outline, units: $units, layers: $layers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardInfoImpl &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            const DeepCollectionEquality().equals(other._outline, _outline) &&
            (identical(other.units, units) || other.units == units) &&
            (identical(other.layers, layers) || other.layers == layers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    width,
    height,
    const DeepCollectionEquality().hash(_outline),
    units,
    layers,
  );

  /// Create a copy of BoardInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardInfoImplCopyWith<_$BoardInfoImpl> get copyWith =>
      __$$BoardInfoImplCopyWithImpl<_$BoardInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoardInfoImplToJson(this);
  }
}

abstract class _BoardInfo implements BoardInfo {
  const factory _BoardInfo({
    required final double width,
    required final double height,
    required final List<List<double>> outline,
    final String units,
    final int layers,
  }) = _$BoardInfoImpl;

  factory _BoardInfo.fromJson(Map<String, dynamic> json) =
      _$BoardInfoImpl.fromJson;

  @override
  double get width;
  @override
  double get height;
  @override
  List<List<double>> get outline;
  @override
  String get units;
  @override
  int get layers;

  /// Create a copy of BoardInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoardInfoImplCopyWith<_$BoardInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Component _$ComponentFromJson(Map<String, dynamic> json) {
  return _Component.fromJson(json);
}

/// @nodoc
mixin _$Component {
  String get ref => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  String? get package => throw _privateConstructorUsedError;
  double get rotation => throw _privateConstructorUsedError;
  String get side => throw _privateConstructorUsedError;
  List<String>? get pins => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get datasheet => throw _privateConstructorUsedError;
  List<String>? get replacements => throw _privateConstructorUsedError;

  /// Serializes this Component to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Component
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComponentCopyWith<Component> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComponentCopyWith<$Res> {
  factory $ComponentCopyWith(Component value, $Res Function(Component) then) =
      _$ComponentCopyWithImpl<$Res, Component>;
  @useResult
  $Res call({
    String ref,
    String type,
    double x,
    double y,
    String? value,
    String? package,
    double rotation,
    String side,
    List<String>? pins,
    String? description,
    String? datasheet,
    List<String>? replacements,
  });
}

/// @nodoc
class _$ComponentCopyWithImpl<$Res, $Val extends Component>
    implements $ComponentCopyWith<$Res> {
  _$ComponentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Component
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ref = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? value = freezed,
    Object? package = freezed,
    Object? rotation = null,
    Object? side = null,
    Object? pins = freezed,
    Object? description = freezed,
    Object? datasheet = freezed,
    Object? replacements = freezed,
  }) {
    return _then(
      _value.copyWith(
            ref: null == ref
                ? _value.ref
                : ref // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as double,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as double,
            value: freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String?,
            package: freezed == package
                ? _value.package
                : package // ignore: cast_nullable_to_non_nullable
                      as String?,
            rotation: null == rotation
                ? _value.rotation
                : rotation // ignore: cast_nullable_to_non_nullable
                      as double,
            side: null == side
                ? _value.side
                : side // ignore: cast_nullable_to_non_nullable
                      as String,
            pins: freezed == pins
                ? _value.pins
                : pins // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            datasheet: freezed == datasheet
                ? _value.datasheet
                : datasheet // ignore: cast_nullable_to_non_nullable
                      as String?,
            replacements: freezed == replacements
                ? _value.replacements
                : replacements // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ComponentImplCopyWith<$Res>
    implements $ComponentCopyWith<$Res> {
  factory _$$ComponentImplCopyWith(
    _$ComponentImpl value,
    $Res Function(_$ComponentImpl) then,
  ) = __$$ComponentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String ref,
    String type,
    double x,
    double y,
    String? value,
    String? package,
    double rotation,
    String side,
    List<String>? pins,
    String? description,
    String? datasheet,
    List<String>? replacements,
  });
}

/// @nodoc
class __$$ComponentImplCopyWithImpl<$Res>
    extends _$ComponentCopyWithImpl<$Res, _$ComponentImpl>
    implements _$$ComponentImplCopyWith<$Res> {
  __$$ComponentImplCopyWithImpl(
    _$ComponentImpl _value,
    $Res Function(_$ComponentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Component
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ref = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? value = freezed,
    Object? package = freezed,
    Object? rotation = null,
    Object? side = null,
    Object? pins = freezed,
    Object? description = freezed,
    Object? datasheet = freezed,
    Object? replacements = freezed,
  }) {
    return _then(
      _$ComponentImpl(
        ref: null == ref
            ? _value.ref
            : ref // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as double,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as double,
        value: freezed == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String?,
        package: freezed == package
            ? _value.package
            : package // ignore: cast_nullable_to_non_nullable
                  as String?,
        rotation: null == rotation
            ? _value.rotation
            : rotation // ignore: cast_nullable_to_non_nullable
                  as double,
        side: null == side
            ? _value.side
            : side // ignore: cast_nullable_to_non_nullable
                  as String,
        pins: freezed == pins
            ? _value._pins
            : pins // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        datasheet: freezed == datasheet
            ? _value.datasheet
            : datasheet // ignore: cast_nullable_to_non_nullable
                  as String?,
        replacements: freezed == replacements
            ? _value._replacements
            : replacements // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ComponentImpl implements _Component {
  const _$ComponentImpl({
    required this.ref,
    required this.type,
    required this.x,
    required this.y,
    this.value,
    this.package,
    this.rotation = 0,
    this.side = 'top',
    final List<String>? pins,
    this.description,
    this.datasheet,
    final List<String>? replacements,
  }) : _pins = pins,
       _replacements = replacements;

  factory _$ComponentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComponentImplFromJson(json);

  @override
  final String ref;
  @override
  final String type;
  @override
  final double x;
  @override
  final double y;
  @override
  final String? value;
  @override
  final String? package;
  @override
  @JsonKey()
  final double rotation;
  @override
  @JsonKey()
  final String side;
  final List<String>? _pins;
  @override
  List<String>? get pins {
    final value = _pins;
    if (value == null) return null;
    if (_pins is EqualUnmodifiableListView) return _pins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? description;
  @override
  final String? datasheet;
  final List<String>? _replacements;
  @override
  List<String>? get replacements {
    final value = _replacements;
    if (value == null) return null;
    if (_replacements is EqualUnmodifiableListView) return _replacements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Component(ref: $ref, type: $type, x: $x, y: $y, value: $value, package: $package, rotation: $rotation, side: $side, pins: $pins, description: $description, datasheet: $datasheet, replacements: $replacements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComponentImpl &&
            (identical(other.ref, ref) || other.ref == ref) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.package, package) || other.package == package) &&
            (identical(other.rotation, rotation) ||
                other.rotation == rotation) &&
            (identical(other.side, side) || other.side == side) &&
            const DeepCollectionEquality().equals(other._pins, _pins) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.datasheet, datasheet) ||
                other.datasheet == datasheet) &&
            const DeepCollectionEquality().equals(
              other._replacements,
              _replacements,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    ref,
    type,
    x,
    y,
    value,
    package,
    rotation,
    side,
    const DeepCollectionEquality().hash(_pins),
    description,
    datasheet,
    const DeepCollectionEquality().hash(_replacements),
  );

  /// Create a copy of Component
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComponentImplCopyWith<_$ComponentImpl> get copyWith =>
      __$$ComponentImplCopyWithImpl<_$ComponentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComponentImplToJson(this);
  }
}

abstract class _Component implements Component {
  const factory _Component({
    required final String ref,
    required final String type,
    required final double x,
    required final double y,
    final String? value,
    final String? package,
    final double rotation,
    final String side,
    final List<String>? pins,
    final String? description,
    final String? datasheet,
    final List<String>? replacements,
  }) = _$ComponentImpl;

  factory _Component.fromJson(Map<String, dynamic> json) =
      _$ComponentImpl.fromJson;

  @override
  String get ref;
  @override
  String get type;
  @override
  double get x;
  @override
  double get y;
  @override
  String? get value;
  @override
  String? get package;
  @override
  double get rotation;
  @override
  String get side;
  @override
  List<String>? get pins;
  @override
  String? get description;
  @override
  String? get datasheet;
  @override
  List<String>? get replacements;

  /// Create a copy of Component
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComponentImplCopyWith<_$ComponentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Net _$NetFromJson(Map<String, dynamic> json) {
  return _Net.fromJson(json);
}

/// @nodoc
mixin _$Net {
  String get name => throw _privateConstructorUsedError;
  List<String> get pins => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this Net to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Net
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetCopyWith<Net> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetCopyWith<$Res> {
  factory $NetCopyWith(Net value, $Res Function(Net) then) =
      _$NetCopyWithImpl<$Res, Net>;
  @useResult
  $Res call({String name, List<String> pins, String? id});
}

/// @nodoc
class _$NetCopyWithImpl<$Res, $Val extends Net> implements $NetCopyWith<$Res> {
  _$NetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Net
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? pins = null, Object? id = freezed}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            pins: null == pins
                ? _value.pins
                : pins // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NetImplCopyWith<$Res> implements $NetCopyWith<$Res> {
  factory _$$NetImplCopyWith(_$NetImpl value, $Res Function(_$NetImpl) then) =
      __$$NetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<String> pins, String? id});
}

/// @nodoc
class __$$NetImplCopyWithImpl<$Res> extends _$NetCopyWithImpl<$Res, _$NetImpl>
    implements _$$NetImplCopyWith<$Res> {
  __$$NetImplCopyWithImpl(_$NetImpl _value, $Res Function(_$NetImpl) _then)
    : super(_value, _then);

  /// Create a copy of Net
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? pins = null, Object? id = freezed}) {
    return _then(
      _$NetImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        pins: null == pins
            ? _value._pins
            : pins // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NetImpl implements _Net {
  const _$NetImpl({
    required this.name,
    required final List<String> pins,
    this.id,
  }) : _pins = pins;

  factory _$NetImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetImplFromJson(json);

  @override
  final String name;
  final List<String> _pins;
  @override
  List<String> get pins {
    if (_pins is EqualUnmodifiableListView) return _pins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pins);
  }

  @override
  final String? id;

  @override
  String toString() {
    return 'Net(name: $name, pins: $pins, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._pins, _pins) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    const DeepCollectionEquality().hash(_pins),
    id,
  );

  /// Create a copy of Net
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetImplCopyWith<_$NetImpl> get copyWith =>
      __$$NetImplCopyWithImpl<_$NetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetImplToJson(this);
  }
}

abstract class _Net implements Net {
  const factory _Net({
    required final String name,
    required final List<String> pins,
    final String? id,
  }) = _$NetImpl;

  factory _Net.fromJson(Map<String, dynamic> json) = _$NetImpl.fromJson;

  @override
  String get name;
  @override
  List<String> get pins;
  @override
  String? get id;

  /// Create a copy of Net
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetImplCopyWith<_$NetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Pin _$PinFromJson(Map<String, dynamic> json) {
  return _Pin.fromJson(json);
}

/// @nodoc
mixin _$Pin {
  String get component => throw _privateConstructorUsedError;
  String get number => throw _privateConstructorUsedError;
  String get net => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  /// Serializes this Pin to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Pin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PinCopyWith<Pin> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PinCopyWith<$Res> {
  factory $PinCopyWith(Pin value, $Res Function(Pin) then) =
      _$PinCopyWithImpl<$Res, Pin>;
  @useResult
  $Res call({String component, String number, String net, double x, double y});
}

/// @nodoc
class _$PinCopyWithImpl<$Res, $Val extends Pin> implements $PinCopyWith<$Res> {
  _$PinCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? component = null,
    Object? number = null,
    Object? net = null,
    Object? x = null,
    Object? y = null,
  }) {
    return _then(
      _value.copyWith(
            component: null == component
                ? _value.component
                : component // ignore: cast_nullable_to_non_nullable
                      as String,
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as String,
            net: null == net
                ? _value.net
                : net // ignore: cast_nullable_to_non_nullable
                      as String,
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as double,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PinImplCopyWith<$Res> implements $PinCopyWith<$Res> {
  factory _$$PinImplCopyWith(_$PinImpl value, $Res Function(_$PinImpl) then) =
      __$$PinImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String component, String number, String net, double x, double y});
}

/// @nodoc
class __$$PinImplCopyWithImpl<$Res> extends _$PinCopyWithImpl<$Res, _$PinImpl>
    implements _$$PinImplCopyWith<$Res> {
  __$$PinImplCopyWithImpl(_$PinImpl _value, $Res Function(_$PinImpl) _then)
    : super(_value, _then);

  /// Create a copy of Pin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? component = null,
    Object? number = null,
    Object? net = null,
    Object? x = null,
    Object? y = null,
  }) {
    return _then(
      _$PinImpl(
        component: null == component
            ? _value.component
            : component // ignore: cast_nullable_to_non_nullable
                  as String,
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as String,
        net: null == net
            ? _value.net
            : net // ignore: cast_nullable_to_non_nullable
                  as String,
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as double,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PinImpl implements _Pin {
  const _$PinImpl({
    required this.component,
    required this.number,
    required this.net,
    required this.x,
    required this.y,
  });

  factory _$PinImpl.fromJson(Map<String, dynamic> json) =>
      _$$PinImplFromJson(json);

  @override
  final String component;
  @override
  final String number;
  @override
  final String net;
  @override
  final double x;
  @override
  final double y;

  @override
  String toString() {
    return 'Pin(component: $component, number: $number, net: $net, x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PinImpl &&
            (identical(other.component, component) ||
                other.component == component) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.net, net) || other.net == net) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, component, number, net, x, y);

  /// Create a copy of Pin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PinImplCopyWith<_$PinImpl> get copyWith =>
      __$$PinImplCopyWithImpl<_$PinImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PinImplToJson(this);
  }
}

abstract class _Pin implements Pin {
  const factory _Pin({
    required final String component,
    required final String number,
    required final String net,
    required final double x,
    required final double y,
  }) = _$PinImpl;

  factory _Pin.fromJson(Map<String, dynamic> json) = _$PinImpl.fromJson;

  @override
  String get component;
  @override
  String get number;
  @override
  String get net;
  @override
  double get x;
  @override
  double get y;

  /// Create a copy of Pin
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PinImplCopyWith<_$PinImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LayerInfo _$LayerInfoFromJson(Map<String, dynamic> json) {
  return _LayerInfo.fromJson(json);
}

/// @nodoc
mixin _$LayerInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  bool get visible => throw _privateConstructorUsedError;
  double get opacity => throw _privateConstructorUsedError;

  /// Serializes this LayerInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LayerInfoCopyWith<LayerInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LayerInfoCopyWith<$Res> {
  factory $LayerInfoCopyWith(LayerInfo value, $Res Function(LayerInfo) then) =
      _$LayerInfoCopyWithImpl<$Res, LayerInfo>;
  @useResult
  $Res call({
    String id,
    String name,
    String type,
    String image,
    bool visible,
    double opacity,
  });
}

/// @nodoc
class _$LayerInfoCopyWithImpl<$Res, $Val extends LayerInfo>
    implements $LayerInfoCopyWith<$Res> {
  _$LayerInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? image = null,
    Object? visible = null,
    Object? opacity = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            image: null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String,
            visible: null == visible
                ? _value.visible
                : visible // ignore: cast_nullable_to_non_nullable
                      as bool,
            opacity: null == opacity
                ? _value.opacity
                : opacity // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LayerInfoImplCopyWith<$Res>
    implements $LayerInfoCopyWith<$Res> {
  factory _$$LayerInfoImplCopyWith(
    _$LayerInfoImpl value,
    $Res Function(_$LayerInfoImpl) then,
  ) = __$$LayerInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String type,
    String image,
    bool visible,
    double opacity,
  });
}

/// @nodoc
class __$$LayerInfoImplCopyWithImpl<$Res>
    extends _$LayerInfoCopyWithImpl<$Res, _$LayerInfoImpl>
    implements _$$LayerInfoImplCopyWith<$Res> {
  __$$LayerInfoImplCopyWithImpl(
    _$LayerInfoImpl _value,
    $Res Function(_$LayerInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? image = null,
    Object? visible = null,
    Object? opacity = null,
  }) {
    return _then(
      _$LayerInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        image: null == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String,
        visible: null == visible
            ? _value.visible
            : visible // ignore: cast_nullable_to_non_nullable
                  as bool,
        opacity: null == opacity
            ? _value.opacity
            : opacity // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LayerInfoImpl implements _LayerInfo {
  const _$LayerInfoImpl({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    this.visible = true,
    this.opacity = 1.0,
  });

  factory _$LayerInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LayerInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final String image;
  @override
  @JsonKey()
  final bool visible;
  @override
  @JsonKey()
  final double opacity;

  @override
  String toString() {
    return 'LayerInfo(id: $id, name: $name, type: $type, image: $image, visible: $visible, opacity: $opacity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LayerInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.visible, visible) || other.visible == visible) &&
            (identical(other.opacity, opacity) || other.opacity == opacity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, type, image, visible, opacity);

  /// Create a copy of LayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LayerInfoImplCopyWith<_$LayerInfoImpl> get copyWith =>
      __$$LayerInfoImplCopyWithImpl<_$LayerInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LayerInfoImplToJson(this);
  }
}

abstract class _LayerInfo implements LayerInfo {
  const factory _LayerInfo({
    required final String id,
    required final String name,
    required final String type,
    required final String image,
    final bool visible,
    final double opacity,
  }) = _$LayerInfoImpl;

  factory _LayerInfo.fromJson(Map<String, dynamic> json) =
      _$LayerInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  String get image;
  @override
  bool get visible;
  @override
  double get opacity;

  /// Create a copy of LayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LayerInfoImplCopyWith<_$LayerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
