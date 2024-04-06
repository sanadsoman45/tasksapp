abstract class TaskEvents{}

class TaskNameInput extends TaskEvents{

  final String taskName;

  TaskNameInput({required this.taskName});
}

class TaskStartDate extends TaskEvents{

  final String taskStartDate;

  TaskStartDate({required this.taskStartDate});
}

class TaskEndDate extends TaskEvents{

  final String taskEndDate;

  TaskEndDate({required this.taskEndDate});
}

class TaskSubmit extends TaskEvents{

  final String taskName;
  final String taskstartDate;
  final String taskendDate;
  final String taskType;

  TaskSubmit({required this.taskName, required this.taskstartDate, required this.taskendDate,required this.taskType});
}

class TaskDelete extends TaskEvents{

  final int elementIndex;

  TaskDelete({required this.elementIndex});
}

class FormStatusReset extends TaskEvents{

}

class TaskTypeUpdate extends TaskEvents{
  final int index;

  TaskTypeUpdate({required this.index});
}

class clearState extends TaskEvents{
}