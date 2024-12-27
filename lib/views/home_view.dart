import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/view_models/task_view_model.dart';
import 'package:task_management/view_models/user_preference_view_model.dart';
import 'package:task_management/views/task_detail_view.dart';
import 'package:task_management/views/task_list_view.dart';
import 'package:task_management/views/add_task_view.dart';

class HomeView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskViewModelProvider);
    final userPreferences = ref.watch(userPreferencesProvider);
    final userPreferencesViewModel = ref.read(userPreferencesProvider.notifier);

    void showSettingsBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: Text('Dark Mode'),
                  value: userPreferences.isDarkMode,
                  onChanged: (value) => userPreferencesViewModel.toggleTheme(),
                ),
                ListTile(
                  title: Text('Default Sort Order'),
                  subtitle: Text(userPreferences.defaultSortOrder),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Select Default Sort Order'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('Date'),
                                onTap: () {
                                  userPreferencesViewModel.setDefaultSortOrder('date');
                                  Navigator.pop(context); 
                                },
                              ),
                              ListTile(
                                title: Text('Priority'),
                                onTap: () {
                                  userPreferencesViewModel.setDefaultSortOrder('priority');
                                  Navigator.pop(context); 
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Task Management',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: showSettingsBottomSheet, 
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return TaskListView();
          } else {
            // Tablet layout
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TaskListView(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: tasks.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TaskDetailView(task: tasks.first),
                        )
                      : Center(
                          child: Text(
                            'Select a task to view details',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskView()),
          );
        },
        backgroundColor: Theme.of(context).brightness==Brightness.dark?Colors.white:Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Theme.of(context).brightness==Brightness.dark?Colors.black:Colors.white),
      ),
    );
  }
}


