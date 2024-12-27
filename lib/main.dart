import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_management/models/user_preference.dart';
import 'package:task_management/models/userpreferenceg.dart';
import 'package:task_management/services/database_helper.dart';
import 'package:task_management/views/home_view.dart';
import 'view_models/user_preference_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserPreferencesAdapter());
  await Hive.openBox<UserPreferences>('userPreferences');
  runApp(
    ProviderScope(
      child: TaskManagerApp(),
    ),
  );
}

class TaskManagerApp extends ConsumerWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferences = ref.watch(userPreferencesProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      theme: userPreferences.isDarkMode ? ThemeData.dark() : ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, 
          ),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
      home: HomeView(),
    );
  }
}

