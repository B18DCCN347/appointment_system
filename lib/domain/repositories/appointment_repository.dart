import '../entities/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointmentsForDay(DateTime day);
  Future<void> bookAppointment(DateTime startTime, String userName);
  Future<void> cancelAppointment(DateTime startTime);
  bool isSlotAvailable(DateTime startTime);
}