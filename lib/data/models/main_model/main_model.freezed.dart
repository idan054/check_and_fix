// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MainModel {
  int get currentTabIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MainModelCopyWith<MainModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainModelCopyWith<$Res> {
  factory $MainModelCopyWith(MainModel value, $Res Function(MainModel) then) =
      _$MainModelCopyWithImpl<$Res, MainModel>;
  @useResult
  $Res call({int currentTabIndex});
}

/// @nodoc
class _$MainModelCopyWithImpl<$Res, $Val extends MainModel>
    implements $MainModelCopyWith<$Res> {
  _$MainModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTabIndex = null,
  }) {
    return _then(_value.copyWith(
      currentTabIndex: null == currentTabIndex
          ? _value.currentTabIndex
          : currentTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MainModelCopyWith<$Res> implements $MainModelCopyWith<$Res> {
  factory _$$_MainModelCopyWith(
          _$_MainModel value, $Res Function(_$_MainModel) then) =
      __$$_MainModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int currentTabIndex});
}

/// @nodoc
class __$$_MainModelCopyWithImpl<$Res>
    extends _$MainModelCopyWithImpl<$Res, _$_MainModel>
    implements _$$_MainModelCopyWith<$Res> {
  __$$_MainModelCopyWithImpl(
      _$_MainModel _value, $Res Function(_$_MainModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTabIndex = null,
  }) {
    return _then(_$_MainModel(
      currentTabIndex: null == currentTabIndex
          ? _value.currentTabIndex
          : currentTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_MainModel implements _MainModel {
  const _$_MainModel({this.currentTabIndex = 0});

  @override
  @JsonKey()
  final int currentTabIndex;

  @override
  String toString() {
    return 'MainModel(currentTabIndex: $currentTabIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MainModel &&
            (identical(other.currentTabIndex, currentTabIndex) ||
                other.currentTabIndex == currentTabIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentTabIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MainModelCopyWith<_$_MainModel> get copyWith =>
      __$$_MainModelCopyWithImpl<_$_MainModel>(this, _$identity);
}

abstract class _MainModel implements MainModel {
  const factory _MainModel({final int currentTabIndex}) = _$_MainModel;

  @override
  int get currentTabIndex;
  @override
  @JsonKey(ignore: true)
  _$$_MainModelCopyWith<_$_MainModel> get copyWith =>
      throw _privateConstructorUsedError;
}
