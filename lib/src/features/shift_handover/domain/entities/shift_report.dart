import 'package:lean_requester/models_exp.dart';

import '../../../../base/helpers/timestamp_helper.dart';
import '../../data/models/handover_note_model.dart';
import '../../data/models/shift_report_model.dart';
import 'handover_note.dart';

base class ShiftReport extends DTO {
  final String id;
  final String caregiverId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<HandoverNote> notes;
  final String summary;
  final bool isSubmitted;

  bool get isEmpty => notes.isEmpty && summary.isEmpty;

  const ShiftReport._({
    required this.id,
    required this.caregiverId,
    required this.startTime,
    this.endTime,
    required this.notes,
    required this.summary,
    required this.isSubmitted,
  });

  factory ShiftReport.from(ShiftReportModel model) => ShiftReport._(
    id: model.id ?? '',
    caregiverId: model.caregiverId ?? '',
    startTime: TimestampHelper.parseTimestamp(model.startTime),
    endTime: model.endTime != null ? TimestampHelper.parseTimestamp(model.endTime) : null,
    notes: (model.notes ?? [])
        .map((noteMap) => HandoverNote.from(HandoverNoteModel().fromJson(noteMap)))
        .toList(),
    summary: model.summary ?? '',
    isSubmitted: model.isSubmitted ?? false,
  );

  ShiftReport copyWith({
    String? id,
    String? caregiverId,
    DateTime? startTime,
    DateTime? endTime,
    List<HandoverNote>? notes,
    String? summary,
    bool? isSubmitted,
  }) => ShiftReport._(
    id: id ?? this.id,
    caregiverId: caregiverId ?? this.caregiverId,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    notes: notes ?? this.notes,
    summary: summary ?? this.summary,
    isSubmitted: isSubmitted ?? this.isSubmitted,
  );

  ShiftReportModel toModel({String? summary, DateTime? endTime, bool? isSubmitted}) =>
      ShiftReportModel(
        id: id,
        caregiverId: caregiverId,
        startTime: startTime.toIso8601String(),
        endTime: (endTime ?? this.endTime ?? DateTime.now()).toIso8601String(),
        notes: notes
            .map(
              (note) => {
                'id': note.id,
                'text': note.text,
                'type': note.type.name,
                'timestamp': note.timestamp.toIso8601String(),
                'authorId': note.authorId,
                'taggedResidentIds': note.taggedResidentIds,
                'isAcknowledged': note.isAcknowledged,
              },
            )
            .toList(),
        summary: summary ?? this.summary,
        isSubmitted: isSubmitted ?? this.isSubmitted,
      );

  @override
  List<Object?> get props => [id, caregiverId, startTime, endTime, notes, summary, isSubmitted];
}
