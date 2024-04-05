import 'package:assignmenttask/core/Resources/color_manager.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/task_States.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/task_events.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/tasks_bloc.dart';
import 'package:assignmenttask/features/quotes/presentation/bloc/quotes_bloc.dart';
import 'package:assignmenttask/features/quotes/presentation/screens/quotes_screen.dart';
import 'package:assignmenttask/task_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:intl/intl.dart';

class PendingTasks extends StatefulWidget {
  const PendingTasks({Key? key}) : super(key: key);

  @override
  State<PendingTasks> createState() => _PendingTasksState();
}

class _PendingTasksState extends State<PendingTasks> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TaskBloc _taskBloc;
  late QuotesBloc _quotesBloc;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _taskBloc = serviceLocator<TaskBloc>();
    _quotesBloc = serviceLocator<QuotesBloc>();
  }

  @override
  Widget build(BuildContext context) {
    var screenDimensions =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
             margin: EdgeInsets.all(screenDimensions*0.01),
             
            height: screenDimensions * 0.5,
            width: screenDimensions * 0.5,
            child: QuotesScreen(quotesBloc: _quotesBloc),
          ),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: screenDimensions * 0.15,
                    ),
                    child: ListView.builder(
                      itemCount: _taskBloc.state.tasksData?.length ?? 0,
                      itemBuilder: (context, index) {
                        final taskData = _taskBloc.state.tasksData?[index];
                        return ListTile(
                          title: Text(taskData?['taskName'] ?? ''),
                          subtitle: Row(
                            children: [
                              Text('Start Date: ${taskData?['taskStartDate']}'),
                              SizedBox(width: screenDimensions * 0.01),
                              Text('End Date: ${taskData?['taskEndDate']}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton.extended(
                      icon: const Icon(Icons.add_circle_outline_outlined),
                      onPressed: () {
                        _showTaskDialog(context, screenDimensions);
                      },
                      label: const Text("Add tasks"),
                      tooltip: "Add Tasks",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskDialog(BuildContext context, double screenDimensions) {
    _startDateController.clear();
    _endDateController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          // Use BlocProvider.value to provide an existing bloc
          value: _taskBloc,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 16,
            child: Container(
              height: screenDimensions * 0.4,
              padding: const EdgeInsets.all(20),
              child: _getForm(context, screenDimensions),
            ),
          ),
        );
      },
    );
  }

  Widget _getForm(BuildContext context, double screenDimensions) {
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage),
          ));
        }
        if (state.taskStartDate.isNotEmpty) {
          _startDateController.text = DateFormat('dd-MM-yyyy')
              .format(DateTime.parse(state.taskStartDate));
        }
        if (state.taskEndDate.isNotEmpty) {
          _endDateController.text = DateFormat('dd-MM-yyyy')
              .format(DateTime.parse(state.taskEndDate));
        }
        debugPrint(state.tasksData.toString());
      },
      builder: (context, state) => SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              SizedBox(
                child: TextFormField(
                  onChanged: (value) {
                    context
                        .read<TaskBloc>()
                        .add(TaskNameInput(taskName: value));
                    _startDateController.clear();
                    _endDateController.clear();
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.task),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenDimensions * 0.01,
                      vertical: screenDimensions * 0.01,
                    ),
                    border: InputBorder.none,
                    labelText: "Task Name",
                    labelStyle: const TextStyle(color: Colors.blue),
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: screenDimensions * 0.001,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenDimensions * 0.02,
              ),
              SizedBox(
                child: TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {
                        _showDatePicker(
                            context, 'startDate', GoRouter.of(context));
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenDimensions * 0.01,
                      vertical: screenDimensions * 0.01,
                    ),
                    border: InputBorder.none,
                    labelText: "Task Start Date",
                    labelStyle: const TextStyle(color: Colors.blue),
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: screenDimensions * 0.001,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenDimensions * 0.02,
              ),
              SizedBox(
                child: TextFormField(
                  readOnly: true,
                  controller: _endDateController,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {
                        if (state.taskStartDate.isNotEmpty) {
                          _showDatePicker(
                              context, 'endDate', GoRouter.of(context));
                        }
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenDimensions * 0.01,
                      vertical: screenDimensions * 0.01,
                    ),
                    border: InputBorder.none,
                    labelText: "Task End Date",
                    labelStyle: const TextStyle(color: Colors.blue),
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: screenDimensions * 0.001,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenDimensions * 0.02,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_isRequiredFieldsEmpty(context, state)) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("All Fields are Required"),
                      backgroundColor: ColorManager.error,
                    ));
                  } else if (state.errorMessage.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)));
                  } else {
                    context.read<TaskBloc>().add(TaskSubmit(
                        taskName: state.taskName,
                        taskType: state.taskType,
                        taskendDate: state.taskEndDate,
                        taskstartDate: state.taskStartDate));
                    GoRouter.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                ),
                child: const Text("Add Task"),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _isRequiredFieldsEmpty(BuildContext context, TaskState state) {
    return state.taskName.isEmpty ||
        state.taskStartDate.isEmpty ||
        state.taskEndDate.isEmpty;
  }

  void _showDatePicker(
      BuildContext context, String datePickerType, GoRouter goRouter) {
    showDialog(
      context: context,
      builder: (buildContext) {
        return Dialog(
          child: Material(
            child: DatePicker(
              maxDate: DateTime(2100, 12, 31),
              minDate: (datePickerType == 'startDate')
                  ? DateTime.now()
                  : DateTime.tryParse(
                          context.read<TaskBloc>().state.taskStartDate) ??
                      DateTime.now(),
              onDateSelected: (value) {
                if (datePickerType == 'endDate') {
                  context
                      .read<TaskBloc>()
                      .add(TaskEndDate(taskEndDate: value.toString()));
                } else {
                  context
                      .read<TaskBloc>()
                      .add(TaskStartDate(taskStartDate: value.toString()));
                }

                debugPrint(context.read<TaskBloc>().state.taskEndDate);

                debugPrint(value.toString());
                goRouter.pop(); // Use goRouter to pop the dialog
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _taskBloc.close(); // Close the bloc when disposing
    super.dispose();
  }
}
