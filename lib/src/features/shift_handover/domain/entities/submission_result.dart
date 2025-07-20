import 'package:lean_requester/models_exp.dart';

import '../../data/models/submission_result_model.dart';

base class SubmissionResult extends DTO {
  final bool success;
  final String message;

  const SubmissionResult._({required this.success, required this.message});

  factory SubmissionResult.from(SubmissionResultModel model) => SubmissionResult._(
    success: model.success ?? false,
    message: model.message ?? 'Unknown result',
  );

  @override
  List<Object?> get props => [success, message];
}
