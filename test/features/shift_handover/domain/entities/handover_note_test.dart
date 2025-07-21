import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/features/shift_handover/data/models/handover_note_model.dart';
import 'package:health/src/features/shift_handover/domain/entities/handover_note.dart';
import 'package:health/src/features/shift_handover/domain/entities/note_type.dart';

void main() {
  group('HandoverNote', () {
    late HandoverNote baseNote;

    setUp(() {
      baseNote = HandoverNote.from(
        const HandoverNoteModel(
          id: "note-123",
          text: "Original text",
          type: "observation",
          timestamp: "2024-01-15T09:00:00.000Z",
          authorId: "caregiver-001",
          taggedResidentIds: ["resident-1"],
          isAcknowledged: false,
        ),
      );
    });

    test('should create HandoverNote from HandoverNoteModel', () {
      // Act
      final note = HandoverNote.from(
        const HandoverNoteModel(
          id: "note-456",
          text: "Test note",
          type: "medication",
          timestamp: "2024-01-15T10:00:00.000Z",
          authorId: "nurse-002",
          taggedResidentIds: ["resident-2", "resident-3"],
          isAcknowledged: true,
        ),
      );

      // Assert
      expect(note.id, equals("note-456"));
      expect(note.text, equals("Test note"));
      expect(note.type, equals(NoteType.medication));
      expect(note.authorId, equals("nurse-002"));
      expect(note.taggedResidentIds, equals(["resident-2", "resident-3"]));
      expect(note.isAcknowledged, equals(true));
      expect(note.timestamp, isA<DateTime>());
    });

    test('should create copy with updated id', () {
      // Act
      final copiedNote = baseNote.copyWith(id: "new-id");

      // Assert
      expect(copiedNote.id, equals("new-id"));
      expect(copiedNote.text, equals(baseNote.text));
      expect(copiedNote.type, equals(baseNote.type));
      expect(copiedNote.timestamp, equals(baseNote.timestamp));
      expect(copiedNote.authorId, equals(baseNote.authorId));
      expect(copiedNote.taggedResidentIds, equals(baseNote.taggedResidentIds));
      expect(copiedNote.isAcknowledged, equals(baseNote.isAcknowledged));
    });

    test('should create copy with updated text', () {
      // Act
      final copiedNote = baseNote.copyWith(text: "Updated text");

      // Assert
      expect(copiedNote.text, equals("Updated text"));
      expect(copiedNote.id, equals(baseNote.id));
    });

    test('should create copy with updated type', () {
      // Act
      final copiedNote = baseNote.copyWith(type: NoteType.incident);

      // Assert
      expect(copiedNote.type, equals(NoteType.incident));
      expect(copiedNote.id, equals(baseNote.id));
    });

    test('should create copy with updated timestamp', () {
      // Arrange
      final newTimestamp = DateTime.parse("2024-02-01T12:00:00.000Z");

      // Act
      final copiedNote = baseNote.copyWith(timestamp: newTimestamp);

      // Assert
      expect(copiedNote.timestamp, equals(newTimestamp));
      expect(copiedNote.id, equals(baseNote.id));
    });

    test('should create copy with updated authorId', () {
      // Act
      final copiedNote = baseNote.copyWith(authorId: "new-author");

      // Assert
      expect(copiedNote.authorId, equals("new-author"));
      expect(copiedNote.id, equals(baseNote.id));
    });

    test('should create copy with updated taggedResidentIds', () {
      // Act
      final copiedNote = baseNote.copyWith(taggedResidentIds: ["resident-4", "resident-5"]);

      // Assert
      expect(copiedNote.taggedResidentIds, equals(["resident-4", "resident-5"]));
      expect(copiedNote.id, equals(baseNote.id));
    });

    test('should create copy with updated isAcknowledged', () {
      // Act
      final copiedNote = baseNote.copyWith(isAcknowledged: true);

      // Assert
      expect(copiedNote.isAcknowledged, equals(true));
      expect(copiedNote.id, equals(baseNote.id));
    });

    test('should create copy with multiple updated fields', () {
      // Arrange
      final newTimestamp = DateTime.parse("2024-03-01T15:00:00.000Z");

      // Act
      final copiedNote = baseNote.copyWith(
        text: "Multi-update text",
        type: NoteType.task,
        timestamp: newTimestamp,
        isAcknowledged: true,
      );

      // Assert
      expect(copiedNote.text, equals("Multi-update text"));
      expect(copiedNote.type, equals(NoteType.task));
      expect(copiedNote.timestamp, equals(newTimestamp));
      expect(copiedNote.isAcknowledged, equals(true));
      expect(copiedNote.id, equals(baseNote.id));
      expect(copiedNote.authorId, equals(baseNote.authorId));
      expect(copiedNote.taggedResidentIds, equals(baseNote.taggedResidentIds));
    });

    test('should have correct Equatable props', () {
      // Act
      final props = baseNote.props;

      // Assert
      expect(props.length, equals(7));
      expect(props, contains(baseNote.id));
      expect(props, contains(baseNote.text));
      expect(props, contains(baseNote.type));
      expect(props, contains(baseNote.timestamp));
      expect(props, contains(baseNote.authorId));
      expect(props, contains(baseNote.taggedResidentIds));
      expect(props, contains(baseNote.isAcknowledged));
    });

    test('should be equal when all props are equal', () {
      // Arrange
      final note1 = HandoverNote.from(
        const HandoverNoteModel(
          id: "note-equal",
          text: "Equal text",
          type: "observation",
          timestamp: "2024-01-15T09:00:00.000Z",
          authorId: "caregiver-001",
          taggedResidentIds: ["resident-1"],
          isAcknowledged: false,
        ),
      );

      final note2 = HandoverNote.from(
        const HandoverNoteModel(
          id: "note-equal",
          text: "Equal text",
          type: "observation",
          timestamp: "2024-01-15T09:00:00.000Z",
          authorId: "caregiver-001",
          taggedResidentIds: ["resident-1"],
          isAcknowledged: false,
        ),
      );

      // Assert
      expect(note1, equals(note2));
      expect(note1.hashCode, equals(note2.hashCode));
    });
  });
}
