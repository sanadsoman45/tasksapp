import 'package:assignmenttask/features/PendingTasks/presentation/bloc/formsubmissionstatus.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/task_States.dart';
import 'package:assignmenttask/features/PendingTasks/presentation/bloc/task_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvents, TaskState> {
  TaskBloc() : super(TaskState()) {
    //event to handle task name input
    on<TaskNameInput>((event, emit) => {
          if (event.taskName.isEmpty)
            {emit(state.copyWith(errorMessage: "Task Name Cannot be Empty."))}
          else
            {emit(state.copyWith(taskName: event.taskName, errorMessage: ""))}
        });

    //event to handle start date.
    on<TaskStartDate>((event, emit) => {
          if (event.taskStartDate.isEmpty)
            {emit(state.copyWith(errorMessage: "Start Date is Mandatory"))}
          else
            {
              emit(state.copyWith(
                  errorMessage: "", taskStartDate: event.taskStartDate))
            }
        });

    //event to handle task end date.
    on<TaskEndDate>((event, emit) => {
          if (event.taskEndDate.isEmpty)
            {emit(state.copyWith(errorMessage: "End Date cannot be Empty"))}
          else
            {
              emit(state.copyWith(
                  errorMessage: "", taskEndDate: event.taskEndDate))
            }
        });

    on<TaskSubmit>((event, emit) => emit(state.copyWith(
            formSubmissionStatus: SubmissionSuccess(),
            taskEndDate: '',
            taskName: '',
            taskStartDate: '',
            tasksData: [
              ...state.tasksData ?? [],
              {
                'taskName': event.taskName,
                'taskStartDate': event.taskstartDate,
                'taskEndDate': event.taskendDate,
                'taskType': event.taskType
              }
            ])));
  }
}
