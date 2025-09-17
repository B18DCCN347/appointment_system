part of 'appointment_bloc.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object> get props => [];
}

class ChangeDateEvent extends AppointmentEvent {
  final DateTime selectedDate;

  const ChangeDateEvent(this.selectedDate);

  @override
  List<Object> get props => [selectedDate];
}

class BookAppointmentEvent extends AppointmentEvent {
  final DateTime startTime;
  final String userName;

  const BookAppointmentEvent(this.startTime, this.userName);

  @override
  List<Object> get props => [startTime, userName];
}

class CancelAppointmentEvent extends AppointmentEvent {
  final DateTime startTime;

  const CancelAppointmentEvent(this.startTime);

  @override
  List<Object> get props => [startTime];
}