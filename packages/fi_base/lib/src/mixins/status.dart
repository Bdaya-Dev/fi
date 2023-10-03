/// Enum representing the submission status of a form.
enum FiSubmissionStatus {
  /// The form has not yet been submitted.
  initial,

  /// The form is in the process of being submitted.
  inProgress,

  /// The form has been submitted successfully.
  success,

  /// The form submission failed.
  failure,

  /// The form submission has been canceled.
  canceled,
}

/// Useful extensions on [FiSubmissionStatus]
extension FiSubmissionStatusX on FiSubmissionStatus {
  /// Indicates whether the form has not yet been submitted.
  bool get isInitial => this == FiSubmissionStatus.initial;

  /// Indicates whether the form is in the process of being submitted.
  bool get isInProgress => this == FiSubmissionStatus.inProgress;

  /// Indicates whether the form has been submitted successfully.
  bool get isSuccess => this == FiSubmissionStatus.success;

  /// Indicates whether the form submission failed.
  bool get isFailure => this == FiSubmissionStatus.failure;

  /// Indicates whether the form submission has been canceled.
  bool get isCanceled => this == FiSubmissionStatus.canceled;

  /// Indicates whether the form is either in progress or has been submitted
  /// successfully.
  ///
  /// This is useful for showing a loading indicator or disabling the submit
  /// button to prevent duplicate submissions.
  bool get isInProgressOrSuccess => isInProgress || isSuccess;
}
