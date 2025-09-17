part of 'appointment_bloc.dart';

abstract class AppointmentState extends Equatable {
  final DateTime selectedDate;

  const AppointmentState(this.selectedDate);

  @override
  List<Object> get props => [selectedDate];
}

class AppointmentInitial extends AppointmentState {
  const AppointmentInitial(super.selectedDate);
}

class AppointmentLoading extends AppointmentState {
  const AppointmentLoading(super.selectedDate);
}

class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;

  const AppointmentLoaded(super.selectedDate, this.appointments);

  @override
  List<Object> get props => [selectedDate, appointments];
}

class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(super.selectedDate, this.message);

  @override
  List<Object> get props => [selectedDate, message];
}