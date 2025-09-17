// lib/main.dart
import 'package:appointment_sys/data/models/theme_model.dart';
import 'package:appointment_sys/presentation/bloc/appointment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'presentation/screens/home_screen.dart';
import 'data/models/appointment_model.dart';
import 'data/repositories/appointment_repository_impl.dart';
import 'domain/repositories/appointment_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AppointmentModelAdapter());
  await Hive.openBox<AppointmentModel>('appointments');
  await Hive.openBox<ThemeModel>('theme_settings'); 
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;
  @override
  void initState() {
    super.initState();
    final themeBox = Hive.box<ThemeModel>('theme_settings');
    _isDarkMode = themeBox.get('theme')?.isDarkMode ?? false; 
  }
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      final themeBox = Hive.box<ThemeModel>('theme_settings');
      themeBox.put('theme', ThemeModel(isDarkMode: _isDarkMode));
    });
  }
  @override
  Widget build(BuildContext context) {
    final AppointmentRepository repository = AppointmentRepositoryImpl();
    return BlocProvider(
      create: (context) => AppointmentBloc(repository),
      child: MaterialApp(
        title: 'Hệ Thống Đặt Lịch',
        theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: HomeScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
      ),
    );
  }
}