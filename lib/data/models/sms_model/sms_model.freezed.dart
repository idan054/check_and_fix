// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SmsModel _$SmsModelFromJson(Map<String, dynamic> json) {
  return _SmsModel.fromJson(json);
}

/// @nodoc
mixin _$SmsModel {
  @JsonKey(name: 'phone_number')
  String get phoneNumber => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'date')
  String get date => throw _privateConstructorUsedError;
  DateTime? get datetime => throw _privateConstructorUsedError;
  bool get sender => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SmsModelCopyWith<SmsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmsModelCopyWith<$Res> {
  factory $SmsModelCopyWith(SmsModel value, $Res Function(SmsModel) then) =
      _$SmsModelCopyWithImpl<$Res, SmsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'phone_number') String phoneNumber,
      String message,
      @JsonKey(name: 'date') String date,
      DateTime? datetime,
      bool sender});
}

/// @nodoc
class _$SmsModelCopyWithImpl<$Res, $Val extends SmsModel>
    implements $SmsModelCopyWith<$Res> {
  _$SmsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? message = null,
    Object? date = null,
    Object? datetime = freezed,
    Object? sender = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      datetime: freezed == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SmsModelCopyWith<$Res> implements $SmsModelCopyWith<$Res> {
  factory _$$_SmsModelCopyWith(
          _$_SmsModel value, $Res Function(_$_SmsModel) then) =
      __$$_SmsModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'phone_number') String phoneNumber,
      String message,
      @JsonKey(name: 'date') String date,
      DateTime? datetime,
      bool sender});
}

/// @nodoc
class __$$_SmsModelCopyWithImpl<$Res>
    extends _$SmsModelCopyWithImpl<$Res, _$_SmsModel>
    implements _$$_SmsModelCopyWith<$Res> {
  __$$_SmsModelCopyWithImpl(
      _$_SmsModel _value, $Res Function(_$_SmsModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? message = null,
    Object? date = null,
    Object? datetime = freezed,
    Object? sender = null,
  }) {
    return _then(_$_SmsModel(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      datetime: freezed == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_SmsModel implements _SmsModel {
  const _$_SmsModel(
      {@JsonKey(name: 'phone_number') this.phoneNumber = '',
      this.message = '',
      @JsonKey(name: 'date') this.date = '',
      this.datetime,
      this.sender = false});

  factory _$_SmsModel.fromJson(Map<String, dynamic> json) =>
      _$$_SmsModelFromJson(json);

  @override
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey(name: 'date')
  final String date;
  @override
  final DateTime? datetime;
  @override
  @JsonKey()
  final bool sender;

  @override
  String toString() {
    return 'SmsModel(phoneNumber: $phoneNumber, message: $message, date: $date, datetime: $datetime, sender: $sender)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SmsModel &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.sender, sender) || other.sender == sender));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, phoneNumber, message, date, datetime, sender);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SmsModelCopyWith<_$_SmsModel> get copyWith =>
      __$$_SmsModelCopyWithImpl<_$_SmsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SmsModelToJson(
      this,
    );
  }
}

abstract class _SmsModel implements SmsModel {
  const factory _SmsModel(
      {@JsonKey(name: 'phone_number') final String phoneNumber,
      final String message,
      @JsonKey(name: 'date') final String date,
      final DateTime? datetime,
      final bool sender}) = _$_SmsModel;

  factory _SmsModel.fromJson(Map<String, dynamic> json) = _$_SmsModel.fromJson;

  @override
  @JsonKey(name: 'phone_number')
  String get phoneNumber;
  @override
  String get message;
  @override
  @JsonKey(name: 'date')
  String get date;
  @override
  DateTime? get datetime;
  @override
  bool get sender;
  @override
  @JsonKey(ignore: true)
  _$$_SmsModelCopyWith<_$_SmsModel> get copyWith =>
      throw _privateConstructorUsedError;
}
