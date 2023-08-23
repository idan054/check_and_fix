import 'package:freezed_annotation/freezed_annotation.dart';

part 'calls_model.freezed.dart';
part 'calls_model.g.dart';

@Freezed(toJson: true, fromJson: true)
class CallsModel with _$CallsModel {
  @JsonSerializable(explicitToJson: true) // This needed for sub classes only
  const factory CallsModel({
    @JsonKey(name: 'date') @Default('') String date,
    DateTime? datetime,
    @Default('') String duration,
    @Default('') String mobileNumber,
    @Default('') String name,
    @Default('') String type,
  }) = _CallsModel;
  factory CallsModel.fromJson(Map<String, dynamic> json) => _$CallsModelFromJson(json);
}

//$ dart run build_runner build --delete-conflicting-outputs
// freezed_annotation: ^2.4.1
// json_annotation: ^4.8.1
// build_runner: ^2.4.6
// json_serializable: ^6.7.1
// freezed: ^2.4.2
