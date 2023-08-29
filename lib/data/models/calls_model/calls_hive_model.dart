


import 'package:hive/hive.dart';

part 'calls_hive_model.g.dart';

@HiveType(typeId: 0)
class Calls extends HiveObject {

  @HiveField(0)
  String? date;

  @HiveField(1)
  String? duration;

  @HiveField(2)
  String? mobileNumber;

  @HiveField(3)
  String? name;

  @HiveField(4)
  String? type;

  @HiveField(5)
  DateTime? dateTime;

  @HiveField(6)
  bool? isHide;

  Calls({this.type, this.duration, this.dateTime, this.date, this.mobileNumber, this.name, this.isHide});
}