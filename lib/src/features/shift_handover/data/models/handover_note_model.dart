import 'package:lean_requester/models_exp.dart';

final class HandoverNoteModel implements DAO {
  final String? id;
  final String? text;
  final String? type;
  final String? timestamp;
  final String? authorId;
  final List<String>? taggedResidentIds;
  final bool? isAcknowledged;

  const HandoverNoteModel({
    this.id,
    this.text,
    this.type,
    this.timestamp,
    this.authorId,
    this.taggedResidentIds,
    this.isAcknowledged,
  });

  @override
  HandoverNoteModel fromJson(json) => HandoverNoteModel(
    id: json?['id'],
    text: json?['text'],
    type: json?['type'],
    timestamp: json?['timestamp'],
    authorId: json?['authorId'],
    taggedResidentIds: json?['taggedResidentIds'] != null
        ? List<String>.from(json?['taggedResidentIds'])
        : null,
    isAcknowledged: json?['isAcknowledged'],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "type": type,
    "timestamp": timestamp,
    "authorId": authorId,
    "taggedResidentIds": taggedResidentIds,
    "isAcknowledged": isAcknowledged,
  };
}
