import 'package:assignmenttask/features/PendingTasks/presentation/bloc/formsubmissionstatus.dart';

class TaskState {
  final String taskName;
  final String taskStartDate;
  final String taskEndDate;
  final FormSubmissionStatus formSubmissionStatus;
  final String errorMessage;
  final List<Map<String, dynamic>>? tasksData;
  final String taskType;

  TaskState(
      {this.taskName = "",
      this.taskType = "pending",
      this.tasksData,
      this.taskStartDate = "",
      this.taskEndDate = "",
      this.errorMessage = "",
      this.formSubmissionStatus = const InitialFormSubmissionStatus()});

  TaskState copyWith(
      {String? taskName,
      String? taskStartDate,
      String? taskEndDate,
      String? errorMessage,
      String? taskType,
      List<Map<String, dynamic>>? tasksData,
      FormSubmissionStatus? formSubmissionStatus}) {
    return TaskState(
        errorMessage: errorMessage ?? this.errorMessage,
        taskName: taskName ?? this.taskName,
        taskEndDate: taskEndDate ?? this.taskEndDate,
        taskStartDate: taskStartDate ?? this.taskStartDate,
        tasksData: tasksData ?? this.tasksData,
        taskType: taskType ?? this.taskType,
        formSubmissionStatus:
            formSubmissionStatus ?? this.formSubmissionStatus);
  }
}
