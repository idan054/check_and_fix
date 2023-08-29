// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calls_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CallsModel _$$_CallsModelFromJson( json) =>
    _$_CallsModel(
      date: json['date'] as String? ?? '',
      datetime: json['datetime'] == null
          ? null
          : DateTime.parse(json['datetime'] as String),
      duration: json['duration'] as String? ?? '',
      mobileNumber: json['mobileNumber'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      isHide: json['isHide'] as bool? ?? false,
    );

Map<String, dynamic> _$$_CallsModelToJson(_$_CallsModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'datetime': instance.datetime?.toIso8601String(),
      'duration': instance.duration,
      'mobileNumber': instance.mobileNumber,
      'name': instance.name,
      'type': instance.type,
      'isHide': instance.isHide,
    };
