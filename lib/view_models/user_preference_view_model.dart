import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:task_management/models/user_preference.dart';

final userPreferencesProvider = StateNotifierProvider<UserPreferencesViewModel, UserPreferences>((ref) {
  return UserPreferencesViewModel();
});

class UserPreferencesViewModel extends StateNotifier<UserPreferences> {
  UserPreferencesViewModel() : super(UserPreferences()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final box = Hive.box<UserPreferences>('userPreferences');
    state = box.get('preferences') ?? UserPreferences();
  }

  Future<void> toggleTheme() async {
    final updatedPreferences = UserPreferences(
      isDarkMode: !state.isDarkMode,
      defaultSortOrder: state.defaultSortOrder,
    );
    await _savePreferences(updatedPreferences);
  }

  Future<void> setDefaultSortOrder(String sortOrder) async {
    final updatedPreferences = UserPreferences(
      isDarkMode: state.isDarkMode,
      defaultSortOrder: sortOrder,
    );
    await _savePreferences(updatedPreferences);
  }

  Future<void> _savePreferences(UserPreferences preferences) async {
    final box = Hive.box<UserPreferences>('userPreferences');
    await box.put('preferences', preferences);
    state = preferences;
  }
}

