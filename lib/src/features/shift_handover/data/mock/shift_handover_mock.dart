part of '../datasource/shift_handover_datasource_impl.dart';

/// Creates mock shift report data with specific number of notes
/// [notesCount] - Number of mock notes to generate
///
Map<String, dynamic> _mockShiftReport({int notesCount = 5}) => {
  "id": "shift-123",
  "caregiverId": "current-user-id",
  "startTime": DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
  "endTime": null,
  "summary": "",
  "isSubmitted": false,
  "notes": [
    for (int index = 0; index < notesCount; index++)
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
};

NoteType _getNoteType(int index) {
  final types = NoteType.values;
  return types[index % types.length];
}
