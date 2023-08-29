// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calls_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CallsModel _$CallsModelFromJson( json) {
  return _CallsModel.fromJson(json);
}

/// @nodoc
mixin _$CallsModel {
  @JsonKey(name: 'date')
  String get date => throw _privateConstructorUsedError;
  DateTime? get datetime => throw _privateConstructorUsedError;
  String get duration => throw _privateConstructorUsedError;
  String get mobileNumber => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  bool get isHide => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CallsModelCopyWith<CallsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallsModelCopyWith<$Res> {
  factory $CallsModelCopyWith(
          CallsModel value, $Res Function(CallsModel) then) =
      _$CallsModelCopyWithImpl<$Res, CallsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'date') String date,
      DateTime? datetime,
      String duration,
      String mobileNumber,
      String name,
      String type,
      bool isHide});
}

/// @nodoc
class _$CallsModelCopyWithImpl<$Res, $Val extends CallsModel>
    implements $CallsModelCopyWith<$Res> {
  _$CallsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? datetime = freezed,
    Object? duration = null,
    Object? mobileNumber = null,
    Object? name = null,
    Object? type = null,
    Object? isHide = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      datetime: freezed == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
      mobileNumber: null == mobileNumber
          ? _value.mobileNumber
          : mobileNumber // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isHide: null == isHide
          ? _value.isHide
          : isHide // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CallsModelCopyWith<$Res>
    implements $CallsModelCopyWith<$Res> {
  factory _$$_CallsModelCopyWith(
          _$_CallsModel value, $Res Function(_$_CallsModel) then) =
      __$$_CallsModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'date') String date,
      DateTime? datetime,
      String duration,
      String mobileNumber,
      String name,
      String type,
      bool isHide});
}

/// @nodoc
class __$$_CallsModelCopyWithImpl<$Res>
    extends _$CallsModelCopyWithImpl<$Res, _$_CallsModel>
    implements _$$_CallsModelCopyWith<$Res> {
  __$$_CallsModelCopyWithImpl(
      _$_CallsModel _value, $Res Function(_$_CallsModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? datetime = freezed,
    Object? duration = null,
    Object? mobileNumber = null,
    Object? name = null,
    Object? type = null,
    Object? isHide = null,
  }) {
    return _then(_$_CallsModel(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      datetime: freezed == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
      mobileNumber: null == mobileNumber
          ? _value.mobileNumber
          : mobileNumber // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isHide: null == isHide
          ? _value.isHide
          : isHide // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_CallsModel implements _CallsModel {
  const _$_CallsModel(
      {@JsonKey(name: 'date') this.date = '',
      this.datetime,
      this.duration = '',
      this.mobileNumber = '',
      this.name = '',
      this.type = '',
      this.isHide = false});

  factory _$_CallsModel.fromJson( json) =>
      _$$_CallsModelFromJson(json);

  @override
  @JsonKey(name: 'date')
  final String date;
  @override
  final DateTime? datetime;
  @override
  @JsonKey()
  final String duration;
  @override
  @JsonKey()
  final String mobileNumber;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final bool isHide;

  @override
  String toString() {
    return 'CallsModel(date: $date, datetime: $datetime, duration: $duration, mobileNumber: $mobileNumber, name: $name, type: $type, isHide: $isHide)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CallsModel &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.mobileNumber, mobileNumber) ||
                other.mobileNumber == mobileNumber) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isHide, isHide) || other.isHide == isHide));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, datetime, duration, mobileNumber, name, type, isHide);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CallsModelCopyWith<_$_CallsModel> get copyWith =>
      __$$_CallsModelCopyWithImpl<_$_CallsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CallsModelToJson(
      this,
    );
  }
}

abstract class _CallsModel implements CallsModel {
  const factory _CallsModel(
      {@JsonKey(name: 'date') final String date,
      final DateTime? datetime,
      final String duration,
      final String mobileNumber,
      final String name,
      final String type,
      final bool isHide}) = _$_CallsModel;

  factory _CallsModel.fromJson( json) =
      _$_CallsModel.fromJson;

  @override
  @JsonKey(name: 'date')
  String get date;
  @override
  DateTime? get datetime;
  @override
  String get duration;
  @override
  String get mobileNumber;
  @override
  String get name;
  @override
  String get type;
  @override
  bool get isHide;
  @override
  @JsonKey(ignore: true)
  _$$_CallsModelCopyWith<_$_CallsModel> get copyWith =>
      throw _privateConstructorUsedError;
}
