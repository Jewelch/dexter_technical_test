import 'package:lean_requester/models_exp.dart';

final class ShiftReportModel implements DAO {
  final String? id;
  final String? caregiverId;
  final String? startTime;
  final String? endTime;
  final List<Map<String, dynamic>>? notes;
  final String? summary;
  final bool? isSubmitted;

  const ShiftReportModel({
    this.id,
    this.caregiverId,
    this.startTime,
    this.endTime,
    this.notes,
    this.summary,
    this.isSubmitted,
  });

  @override
  ShiftReportModel fromJson(json) => ShiftReportModel(
    id: json?['id'],
    caregiverId: json?['caregiverId'],
    startTime: json?['startTime'],
    endTime: json?['endTime'],
    notes: json?['notes'] != null ? List<Map<String, dynamic>>.from(json?['notes']) : null,
    summary: json?['summary'],
    isSubmitted: json?['isSubmitted'],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "caregiverId": caregiverId,
    "startTime": startTime,
    "endTime": endTime,
    "notes": notes,
    "summary": summary,
    "isSubmitted": isSubmitted,
  };
}
