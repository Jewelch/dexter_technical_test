import 'package:lean_requester/models_exp.dart';

final class SubmissionResultModel implements DAO {
  final bool? success;
  final String? message;

  const SubmissionResultModel({this.success, this.message});

  @override
  SubmissionResultModel fromJson(json) =>
      SubmissionResultModel(success: json?['success'], message: json?['message']);

  @override
  Map<String, dynamic> toJson() => {"success": success, "message": message};
}
