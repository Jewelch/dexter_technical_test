part of '../datasource/shift_handover_datasource_impl.dart';

final _mockShiftReport = {
  "id": "shift-123",
  "caregiverId": "current-user-id",
  "startTime": DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
  "endTime": null,
  "notes": [
    for (int index = 0; index < 5; index++)
      {
        "id": "note-$index",
        "text": "This is a sample note of type ${_getNoteType(index).name}.",
        "type": _getNoteType(index).name,
        "timestamp": DateTime.now().subtract(Duration(hours: index)).toIso8601String(),
        "authorId": "caregiver-A",
        "taggedResidentIds": [],
        "isAcknowledged": false,
      },
  ],
  "summary": "",
  "isSubmitted": false,
};

NoteType _getNoteType(int index) {
  final types = NoteType.values;
  return types[index % types.length];
}
