import 'package:assignmenttask/features/PendingTasks/presentation/bloc/tasks_bloc.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/screens/pending_tasks.dart';
import 'package:assignmenttask/task_injection.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late TaskBloc _taskBloc;

  @override
  void initState() {
    super.initState();
    _taskBloc = serviceLocator<TaskBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Task App"),
      ),
      body: const SizedBox(
        child: PendingTasks(),
      ),
    );
  }

  @override
  void dispose() {
    _taskBloc.close();
    super.dispose();
  }

 
}
