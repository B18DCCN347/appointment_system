// lib/data/repositories/appointment_repository_impl.dart
import 'package:hive/hive.dart';
import '../../domain/entities/appointment.dart';
import '../models/appointment_model.dart';
import '../../domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final Box<AppointmentModel> _box = Hive.box<AppointmentModel>('appointments'); // Lấy box đã mở

  @override
  Future<List<Appointment>> getAppointmentsForDay(DateTime day) async {
    final appointments = _box.values.where((model) {
      final modelDay = DateTime(model.startTime.year, model.startTime.month, model.startTime.day);
      return modelDay == DateTime(day.year, day.month, day.day); // So sánh chính xác
    }).map((model) => Appointment(
          startTime: model.startTime,
          userName: model.userName,
        )).toList();
    return appointments;
  }

  @override
  Future<void> bookAppointment(DateTime startTime, String userName) async {
    final model = AppointmentModel(startTime: startTime, userName: userName);
    await _box.add(model);
  }

  @override
  Future<void> cancelAppointment(DateTime startTime) async {
    final keyToDelete = _box.values.firstWhere((model) => model.startTime == startTime).key;
    await _box.delete(keyToDelete);
  }

  @override
  bool isSlotAvailable(DateTime startTime) {
    return !_box.values.any((model) => model.startTime == startTime);
  }
}