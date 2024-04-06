import 'package:assignmenttask/features/PendingTasks/presentation/bloc/formsubmissionstatus.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/task_States.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/task_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvents, TaskState> {
  TaskBloc() : super(TaskState()) {
    //event to handle task name input
    on<TaskNameInput>((event, emit) =>
        emit(state.copyWith(taskName: event.taskName, errorMessage: "")));

    //event to handle start date.
    on<TaskStartDate>((event, emit) => emit(
        state.copyWith(errorMessage: "", taskStartDate: event.taskStartDate)));

    //event to handle task end date.
    on<TaskEndDate>((event, emit) =>
        emit(state.copyWith(errorMessage: "", taskEndDate: event.taskEndDate)));

    on<TaskSubmit>((event, emit) => emit(state.copyWith(
            formSubmissionStatus: SubmissionSuccess(),
            taskEndDate: '',
            taskName: '',
            taskStartDate: '',
            successMessage:
                'Task ${event.taskName} has been saved successfully',
            tasksData: [
              ...state.tasksData ?? [],
              {
                'taskName': event.taskName,
                'taskStartDate': event.taskstartDate,
                'taskEndDate': event.taskendDate,
                'taskType': event.taskType,
              }
            ])));

    on<TaskDelete>((event, emit) {
      List<Map<String, dynamic>> updatedList =
          List.from(state.tasksData!.toList());
      final deletedTaskName = updatedList[event.elementIndex]['taskName'];
      updatedList.removeAt(event.elementIndex);
      emit(state.copyWith(
        successMessage: "Task $deletedTaskName has been deleted Successfully.",
        formSubmissionStatus: SubmissionSuccess(),
        tasksData: updatedList,
      ));
    });

    on<FormStatusReset>((event, emit) {
      emit(state.copyWith(
          formSubmissionStatus: const InitialFormSubmissionStatus()));
    });

    on<TaskTypeUpdate>((event, emit) {
      List<Map<String, dynamic>> updatedList =
          List.from(state.tasksData!.toList());
      final taskData = updatedList[event.index];
      taskData['taskType'] =
          taskData['taskType'] == 'pending' ? 'completed' : 'pending';

      emit(state.copyWith(
          successMessage:
              "Task ${taskData['taskName']} ${taskData['taskType'] == 'pending' ? 'is in' : 'has been'} ${taskData['taskType']}  ${taskData['taskType'] == 'pending' ? 'State' : ''}.",
          tasksData: updatedList.toList(),
          formSubmissionStatus: SubmissionSuccess()));
    });

    on<clearState>((event, emit) => emit(state.copyWith(
        formSubmissionStatus: const InitialFormSubmissionStatus(),
        errorMessage: '',
        taskEndDate: '',
        taskName: '',
        taskStartDate: '',
        taskType: 'pending',
        successMessage: '')));
  }
}
