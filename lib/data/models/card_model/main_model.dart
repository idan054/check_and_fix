import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_model.freezed.dart';

@freezed
class MainModel with _$MainModel {
  const factory MainModel({
    @Default(0) int currentTabIndex,
  }) = _MainModel;
}
