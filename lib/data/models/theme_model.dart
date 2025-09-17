import 'package:hive/hive.dart';

part 'theme_model.g.dart';

@HiveType(typeId: 1) // Sử dụng typeId khác với AppointmentModel
class ThemeModel extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  ThemeModel({required this.isDarkMode});
}