// lib/presentation/screens/home_screen.dart
import 'package:appointment_sys/presentation/bloc/appointment_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({super.key, required this.toggleTheme, required this.isDarkMode});

   List<DateTime> _generateSlots(DateTime day) {
    final slots = <DateTime>[];
    DateTime start = DateTime(day.year, day.month, day.day, 7, 0);
    DateTime end = DateTime(day.year, day.month, day.day, 19, 0);
    while (start.isBefore(end)) {
      slots.add(start);
      start = start.add(const Duration(minutes: 30));
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hệ Thống Đặt Lịch'),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.yellow : Colors.blue,
            ),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          final bloc = context.read<AppointmentBloc>();
          final now = DateTime.now();
          final selectedDay = state.selectedDate;
          final slots = _generateSlots(selectedDay);
          final appointments = state is AppointmentLoaded ? state.appointments : [];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CalendarDatePicker(
                    initialDate: selectedDay,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    onDateChanged: (date) => bloc.add(ChangeDateEvent(DateTime(date.year, date.month, date.day))),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: state is AppointmentLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: slots.length,
                          itemBuilder: (context, index) {
                            final slot = slots[index];
                            final appointment = appointments.firstWhereOrNull((a) =>
                                DateTime(a.startTime.year, a.startTime.month, a.startTime.day, a.startTime.hour, a.startTime.minute) ==
                                DateTime(slot.year, slot.month, slot.day, slot.hour, slot.minute));
                            final isPast = slot.isBefore(now);
                            final isAvailable = appointment == null && !isPast;

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                title: Text(
                                  DateFormat('HH:mm').format(slot),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: appointment != null
                                    ? Text(
                                        'Đã đặt bởi: ${appointment.userName}',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      )
                                    : const Text(
                                        'Trống',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                trailing: isAvailable
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              final controller = TextEditingController();
                                              return AlertDialog(
                                                title: const Text('Đặt lịch'),
                                                content: TextField(
                                                  controller: controller,
                                                  decoration: const InputDecoration(hintText: 'Tên người đặt'),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      if (controller.text.isNotEmpty) {
                                                        bloc.add(BookAppointmentEvent(slot, controller.text));
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: const Text('Đặt'),
                                                  ),
                                                ],
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('Đặt'),
                                      )
                                    : appointment != null && now.isBefore(slot.subtract(const Duration(minutes: 30)))
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            onPressed: () => bloc.add(CancelAppointmentEvent(slot)),
                                            child: const Text('Hủy'),
                                          )
                                        : null,
                              ),
                            );
                          },
                        ),
                ),
                if (state is AppointmentError)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.message, style: const TextStyle(color: Colors.red, fontSize: 16)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}