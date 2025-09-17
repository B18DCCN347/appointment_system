import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository repository;

  AppointmentBloc(this.repository) : super(AppointmentInitial(DateTime.now())) {
    on<ChangeDateEvent>((event, emit) async {
      emit(AppointmentLoading(event.selectedDate));
      final appointments = await repository.getAppointmentsForDay(event.selectedDate);
      emit(AppointmentLoaded(event.selectedDate, appointments));
    });

    on<BookAppointmentEvent>((event, emit) async {
      if (repository.isSlotAvailable(event.startTime) &&
          event.startTime.isAfter(DateTime.now())) {
        await repository.bookAppointment(event.startTime, event.userName);
        final appointments = await repository.getAppointmentsForDay(state.selectedDate);
        emit(AppointmentLoaded(state.selectedDate, appointments));
      } else {
        emit(AppointmentError(state.selectedDate, 'Khung giờ không khả dụng'));
      }
    });

    on<CancelAppointmentEvent>((event, emit) async {
      final now = DateTime.now();
      final minCancelTime = event.startTime.subtract(const Duration(minutes: 30));
      if (now.isBefore(minCancelTime)) {
        await repository.cancelAppointment(event.startTime);
        final appointments = await repository.getAppointmentsForDay(state.selectedDate);
        emit(AppointmentLoaded(state.selectedDate, appointments));
      } else {
        emit(AppointmentError(state.selectedDate, 'Không thể hủy lịch trước 30 phút'));
      }
    });
  }
}