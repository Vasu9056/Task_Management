import 'package:hive/hive.dart';
@HiveType(typeId: 0)
class UserPreferences extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  String defaultSortOrder;

  UserPreferences({
    this.isDarkMode = false,
    this.defaultSortOrder = 'date',
  });
}

