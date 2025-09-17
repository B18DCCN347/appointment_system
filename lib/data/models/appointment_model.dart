import 'package:hive/hive.dart';

part 'appointment_model.g.dart';

@HiveType(typeId: 0)
class AppointmentModel extends HiveObject {
  @HiveField(0)
  DateTime startTime;

  @HiveField(1)
  String userName;

  AppointmentModel({required this.startTime, required this.userName});
}