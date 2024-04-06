import 'package:assignmenttask/core/Resources/color_manager.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/task_events.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/tasks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CustomListView extends StatelessWidget {

  final double screenDimensions;

  const CustomListView({required this.screenDimensions, super.key});

  @override
  Widget build(BuildContext context) {
    

    return _buildTaskList(context, screenDimensions);
  }

  Widget _buildTaskList(BuildContext context, double screenDimensions) {
    var taskBloc = context.read<TaskBloc>();
    if (taskBloc.state.tasksData == null || taskBloc.state.tasksData!.isEmpty) {
      return Center(
        child: Text(
          "No Tasks Added Yet",
          style: TextStyle(fontSize: screenDimensions * 0.02),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: context.read<TaskBloc>().state.tasksData!.length,
          itemBuilder: (context, index) {
            final taskData = taskBloc.state.tasksData![index];
            return GestureDetector(
              onTap: () =>
                  {context.read<TaskBloc>().add(TaskTypeUpdate(index: index))},
              child: Dismissible(
                key: Key('${taskData["taskName"]}$index'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  //event to delete the item from list.
                  context.read<TaskBloc>().add(TaskDelete(elementIndex: index));
                },
                child: Card(
                  color: ColorManager.white,
                  margin: EdgeInsets.symmetric(
                    horizontal: screenDimensions * 0.01,
                    vertical: screenDimensions * 0.02,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenDimensions * 0.02,
                      horizontal: screenDimensions * 0.009,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              taskData['taskName'] ?? '',
                              style: TextStyle(
                                color: context
                                            .read<TaskBloc>()
                                            .state
                                            .tasksData![index]['taskType'] ==
                                        'completed'
                                    ? Colors.blueGrey
                                    : Colors.black,
                                fontSize: screenDimensions * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            taskBloc.state.tasksData?[index]['taskType'] ==
                                    'pending'
                                ? Icon(
                                    Icons.pending_actions_sharp,
                                    color: ColorManager.error,
                                  )
                                : const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Start Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(taskData['taskStartDate']))}',
                              style: TextStyle(
                                  color: context
                                              .read<TaskBloc>()
                                              .state
                                              .tasksData![index]['taskType'] ==
                                          'completed'
                                      ? Colors.blueGrey
                                      : Colors.black,
                                  fontSize: screenDimensions * 0.02),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.01),
                            Text(
                              'End Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(taskData['taskEndDate']))}',
                              style: TextStyle(
                                  color: context
                                              .read<TaskBloc>()
                                              .state
                                              .tasksData![index]['taskType'] ==
                                          'completed'
                                      ? Colors.blueGrey
                                      : Colors.black,
                                  fontSize: screenDimensions * 0.02),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
