import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/services/database_helper.dart';

final taskViewModelProvider = StateNotifierProvider<TaskViewModel, List<Task>>((ref) {
  return TaskViewModel(ref.read(databaseHelperProvider));
});

class TaskViewModel extends StateNotifier<List<Task>> {
  final DatabaseHelper _databaseHelper;

  TaskViewModel(this._databaseHelper) : super([]) {
    _loadTasks();
  }
  Future<void> _loadTasks() async {
    final tasks = await _databaseHelper.getTasks();
    state = tasks;
  }

  Future<void> addTask(Task task) async {
    await _databaseHelper.insertTask(task);
    _loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _databaseHelper.updateTask(task);
    state = state.map((t) => t.id == task.id ? task : t).toList();
  }

  Future<void> deleteTask(int id) async {
    await _databaseHelper.deleteTask(id);
    _loadTasks();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }

  Future<void> searchTasks(String query) async {
    if (query.isEmpty) {
      _loadTasks();
    } else {
      final tasks = await _databaseHelper.searchTasks(query);
      state = tasks;
    }
  }

  Future<void> sortTasksByPriority() async {
    final tasks = await _databaseHelper.getTasksByPriority();
    state = tasks;
  }
}

