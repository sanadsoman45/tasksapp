import 'package:assignmenttask/features/PendingTasks/presentation/Widgets/custom_listview.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/formsubmissionstatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:assignmenttask/core/Resources/color_manager.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/task_States.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/task_events.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/tasks_bloc.dart';
import 'package:assignmenttask/features/quotes/presentation/bloc/quotes_bloc.dart';
import 'package:assignmenttask/features/quotes/presentation/screens/quotes_screen.dart';
import 'package:assignmenttask/task_injection.dart';

class PendingTasks extends StatefulWidget {
  const PendingTasks({Key? key}) : super(key: key);

  @override
  State<PendingTasks> createState() => _PendingTasksState();
}

class _PendingTasksState extends State<PendingTasks> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late QuotesBloc _quotesBloc;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _quotesBloc = serviceLocator<QuotesBloc>();
  }

  @override
  Widget build(BuildContext context) {
    var screenDimensions =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => serviceLocator<TaskBloc>(),
      child: Scaffold(
          body: BlocConsumer<TaskBloc, TaskState>(listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).clearSnackBars();
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
        if (state.formSubmissionStatus is SubmissionSuccess) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.successMessage),
            backgroundColor: Colors.green.shade500,
          ));
          context.read<TaskBloc>().add(FormStatusReset());
        }
        debugPrint(state.tasksData.toString());
      }, buildWhen: (prevState, curState) {
        return prevState.tasksData != curState.tasksData;
      }, builder: (context, state) {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.all(screenDimensions * 0.01),
              height: screenDimensions * 0.5,
              width: screenDimensions * 0.5,
              child: QuotesScreen(quotesBloc: _quotesBloc),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius:
                            BorderRadius.circular(screenDimensions * 0.01)),
                    padding: EdgeInsets.only(
                      bottom: screenDimensions * 0.15,
                    ),
                    child: Column(children: [
                      Text("Tasks List:",
                          style: TextStyle(
                              fontSize: screenDimensions * 0.04,
                              fontWeight: FontWeight.bold)),
                      CustomListView(screenDimensions: screenDimensions)
                    ]),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FloatingActionButton.extended(
                        backgroundColor: Colors.amberAccent,
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
        );
      })),
    );
  }

  void _showTaskDialog(BuildContext context, double screenDimensions) {
    //clearing the controllers for textfields and also state variables to avoid previous values.
    _startDateController.clear();
    _endDateController.clear();
    context.read<TaskBloc>().add(clearState());
    showDialog(
      context: context,
      builder: (buildContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Dialog(
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
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            SizedBox(
              child: TextFormField(
                onChanged: (value) {
                  context.read<TaskBloc>().add(TaskNameInput(taskName: value));
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
                  labelStyle: const TextStyle(color: Colors.grey),
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
                  labelStyle: const TextStyle(color: Colors.grey),
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
                      if (context
                          .read<TaskBloc>()
                          .state
                          .taskStartDate
                          .isNotEmpty) {
                        _showDatePicker(
                            context, 'endDate', GoRouter.of(context));
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("Please Enter Start Date First"),
                          backgroundColor: ColorManager.error,
                        ));
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
                  labelStyle: const TextStyle(color: Colors.grey),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final state = context.read<TaskBloc>().state;
                    if (_isRequiredFieldsEmpty(context, state)) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text("All Fields are Required"),
                        backgroundColor: ColorManager.error,
                      ));
                    } else if (state.errorMessage.isNotEmpty) {
                      ScaffoldMessenger.of(context).clearSnackBars();
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
                  child: const Text(
                    "Add Task",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.error,
                  ),
                  child: Text("Close",
                      style: TextStyle(color: ColorManager.white)),
                )
              ],
            )
          ],
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
    final taskBlocState = context.read<TaskBloc>().state;
    DateTime? initialDate;

    if (datePickerType == 'startDate' &&
        taskBlocState.taskStartDate.isNotEmpty) {
      initialDate = DateTime.parse(taskBlocState.taskStartDate);
    }
    if (datePickerType == 'endDate' &&
        taskBlocState.taskEndDate.isNotEmpty &&
        (DateTime.parse(taskBlocState.taskStartDate)
                .compareTo(DateTime.parse(taskBlocState.taskEndDate))) >
            0) {
      initialDate = DateTime.parse(taskBlocState.taskStartDate);
    } else if (datePickerType == 'endDate' &&
        taskBlocState.taskEndDate.isNotEmpty) {
      initialDate = DateTime.parse(taskBlocState.taskEndDate);
    }

    showDialog(
      context: context,
      builder: (buildContext) {
        return Dialog(
          child: Material(
            child: DatePicker(
              selectedDate: initialDate,
              selectedCellDecoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              highlightColor: Colors.blueAccent,
              maxDate: DateTime(2100, 12, 31),
              minDate: (datePickerType == 'startDate')
                  ? DateTime.now()
                  : DateTime.tryParse(taskBlocState.taskStartDate) ??
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
                  if ((taskBlocState.taskEndDate.isNotEmpty) &&
                      (DateTime.parse(value.toString()).compareTo(
                              DateTime.parse(taskBlocState.taskEndDate))) >
                          0) {
                    context
                        .read<TaskBloc>()
                        .add(TaskEndDate(taskEndDate: value.toString()));
                  }
                }

                debugPrint(context.read<TaskBloc>().state.taskEndDate);
                debugPrint(value.toString());
                goRouter.pop();
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
    super.dispose();
  }
}
