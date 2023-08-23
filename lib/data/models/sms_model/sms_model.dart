import 'package:freezed_annotation/freezed_annotation.dart';

part 'sms_model.freezed.dart';
part 'sms_model.g.dart';

@Freezed(toJson: true, fromJson: true)
class SmsModel with _$SmsModel {
  @JsonSerializable(explicitToJson: true) // This needed for sub classes only
  const factory SmsModel({
    @JsonKey(name: 'phone_number') @Default('') String phoneNumber,
    @Default('') String message,
    @JsonKey(name: 'date') @Default('') String date,
    DateTime? datetime,
    @Default(false) bool sender,
  }) = _SmsModel;
  factory SmsModel.fromJson(Map<String, dynamic> json) => _$SmsModelFromJson(json);
}
