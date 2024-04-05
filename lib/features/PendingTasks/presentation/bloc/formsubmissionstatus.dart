abstract class FormSubmissionStatus{
  const FormSubmissionStatus();
}

class InitialFormSubmissionStatus extends FormSubmissionStatus{
  const InitialFormSubmissionStatus();
}

class FormSubmitting extends FormSubmissionStatus{}

class SubmissionSuccess extends FormSubmissionStatus{}

class SubmissionFailed extends FormSubmissionStatus{
   final String exception;

    SubmissionFailed(this.exception);
}