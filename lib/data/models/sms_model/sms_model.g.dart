// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SmsModel _$$_SmsModelFromJson(Map<String, dynamic> json) => _$_SmsModel(
      phoneNumber: json['phone_number'] as String? ?? '',
      message: json['message'] as String? ?? '',
      date: json['date'] as String? ?? '',
      datetime: json['datetime'] == null
          ? null
          : DateTime.parse(json['datetime'] as String),
      sender: json['sender'] as bool? ?? false,
    );

Map<String, dynamic> _$$_SmsModelToJson(_$_SmsModel instance) =>
    <String, dynamic>{
      'phone_number': instance.phoneNumber,
      'message': instance.message,
      'date': instance.date,
      'datetime': instance.datetime?.toIso8601String(),
      'sender': instance.sender,
    };
