import 'package:lean_requester/models_exp.dart';

import '../../../../base/helpers/timestamp_helper.dart';
import '../../data/models/handover_note_model.dart';
import 'note_type.dart';

base class HandoverNote extends DTO {
  final String id;
  final String text;
  final NoteType type;
  final DateTime timestamp;
  final String authorId;
  final List<String> taggedResidentIds;
  final bool isAcknowledged;

  factory HandoverNote.acknowledged(HandoverNote note) => note.copyWith(isAcknowledged: true);

  bool get isEmpty => text.isEmpty;

  const HandoverNote._({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
    required this.authorId,
    required this.taggedResidentIds,
    required this.isAcknowledged,
  });

  factory HandoverNote.from(HandoverNoteModel model) {
    NoteType parseType(String? typeString) => switch (typeString) {
      'observation' => NoteType.observation,
      'incident' => NoteType.incident,
      'medication' => NoteType.medication,
      'task' => NoteType.task,
      'supplyRequest' => NoteType.supplyRequest,
      _ => NoteType.observation,
    };

    return HandoverNote._(
      id: model.id ?? '',
      text: model.text ?? '',
      type: parseType(model.type),
      timestamp: TimestampHelper.parseTimestamp(model.timestamp),
      authorId: model.authorId ?? '',
      taggedResidentIds: model.taggedResidentIds ?? [],
      isAcknowledged: model.isAcknowledged ?? false,
    );
  }

  HandoverNote copyWith({
    String? id,
    String? text,
    NoteType? type,
    DateTime? timestamp,
    String? authorId,
    List<String>? taggedResidentIds,
    bool? isAcknowledged,
  }) => HandoverNote._(
    id: id ?? this.id,
    text: text ?? this.text,
    type: type ?? this.type,
    timestamp: timestamp ?? this.timestamp,
    authorId: authorId ?? this.authorId,
    taggedResidentIds: taggedResidentIds ?? this.taggedResidentIds,
    isAcknowledged: isAcknowledged ?? this.isAcknowledged,
  );

  @override
  List<Object?> get props => [
    id,
    text,
    type,
    timestamp,
    authorId,
    taggedResidentIds,
    isAcknowledged,
  ];
}
