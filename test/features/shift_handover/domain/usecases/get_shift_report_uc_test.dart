import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/features/shift_handover/data/models/handover_note_model.dart';
import 'package:health/src/features/shift_handover/data/models/shift_report_model.dart';
import 'package:health/src/features/shift_handover/domain/entities/handover_note.dart';
import 'package:health/src/features/shift_handover/domain/entities/note_type.dart';
import 'package:health/src/features/shift_handover/domain/entities/shift_report.dart';

void main() {
  group('GetShiftReportUC Tests', () {
    group('ShiftReport Entity Creation', () {
      test('should create ShiftReport entity from ShiftReportModel', () {
        // Arrange
        final model = ShiftReportModel(
          id: "shift-123",
          caregiverId: "caregiver-001",
          startTime: "2024-01-15T08:00:00.000Z",
          endTime: "2024-01-15T16:00:00.000Z",
          notes: [
            {
              "id": "note-1",
              "text": "Patient vitals checked",
              "type": "observation",
              "timestamp": "2024-01-15T09:00:00.000Z",
              "authorId": "caregiver-001",
              "taggedResidentIds": ["resident-1"],
              "isAcknowledged": false,
            },
            {
              "id": "note-2",
              "text": "Medication administered",
              "type": "medication",
              "timestamp": "2024-01-15T14:00:00.000Z",
              "authorId": "caregiver-001",
              "taggedResidentIds": [],
              "isAcknowledged": true,
            },
          ],
          summary: "Patient had a good day",
          isSubmitted: false,
        );

        // Act
        final entity = ShiftReport.from(model);

        // Assert
        expect(entity.id, equals("shift-123"));
        expect(entity.caregiverId, equals("caregiver-001"));
        expect(entity.startTime, isA<DateTime>());
        expect(entity.endTime, isA<DateTime>());
        expect(entity.notes.length, equals(2));
        expect(entity.summary, equals("Patient had a good day"));
        expect(entity.isSubmitted, equals(false));
      });

      test('should handle null endTime in ShiftReportModel', () {
        // Arrange
        final model = ShiftReportModel(
          id: "shift-456",
          caregiverId: "caregiver-002",
          startTime: "2024-01-15T08:00:00.000Z",
          endTime: null,
          notes: [],
          summary: "",
          isSubmitted: false,
        );

        // Act
        final entity = ShiftReport.from(model);

        // Assert
        expect(entity.id, equals("shift-456"));
        expect(entity.caregiverId, equals("caregiver-002"));
        expect(entity.startTime, isA<DateTime>());
        expect(entity.endTime, isNull);
        expect(entity.notes.length, equals(0));
        expect(entity.summary, equals(""));
        expect(entity.isSubmitted, equals(false));
      });

      test('should handle missing or null values gracefully', () {
        // Arrange
        final model = ShiftReportModel(
          id: null,
          caregiverId: null,
          startTime: null,
          endTime: null,
          notes: null,
          summary: null,
          isSubmitted: null,
        );

        // Act
        final entity = ShiftReport.from(model);

        // Assert
        expect(entity.id, equals(''));
        expect(entity.caregiverId, equals(''));
        expect(entity.startTime, isA<DateTime>()); // Should default to current time
        expect(entity.endTime, isNull);
        expect(entity.notes.length, equals(0));
        expect(entity.summary, equals(''));
        expect(entity.isSubmitted, equals(false));
      });

      test('should convert notes correctly with different types', () {
        // Arrange
        final model = ShiftReportModel(
          id: "shift-789",
          caregiverId: "caregiver-003",
          startTime: "2024-01-15T08:00:00.000Z",
          notes: [
            {
              "id": "note-1",
              "text": "Regular observation",
              "type": "observation",
              "timestamp": "2024-01-15T09:00:00.000Z",
              "authorId": "caregiver-003",
              "taggedResidentIds": [],
              "isAcknowledged": false,
            },
            {
              "id": "note-2",
              "text": "Safety incident",
              "type": "incident",
              "timestamp": "2024-01-15T10:00:00.000Z",
              "authorId": "caregiver-003",
              "taggedResidentIds": ["resident-1"],
              "isAcknowledged": true,
            },
            {
              "id": "note-3",
              "text": "Pain medication given",
              "type": "medication",
              "timestamp": "2024-01-15T11:00:00.000Z",
              "authorId": "caregiver-003",
              "taggedResidentIds": ["resident-1"],
              "isAcknowledged": false,
            },
            {
              "id": "note-4",
              "text": "Complete cleaning task",
              "type": "task",
              "timestamp": "2024-01-15T12:00:00.000Z",
              "authorId": "caregiver-003",
              "taggedResidentIds": [],
              "isAcknowledged": true,
            },
            {
              "id": "note-5",
              "text": "Request more supplies",
              "type": "supplyRequest",
              "timestamp": "2024-01-15T13:00:00.000Z",
              "authorId": "caregiver-003",
              "taggedResidentIds": [],
              "isAcknowledged": false,
            },
          ],
        );

        // Act
        final entity = ShiftReport.from(model);

        // Assert
        expect(entity.notes.length, equals(5));
        expect(entity.notes[0].type, equals(NoteType.observation));
        expect(entity.notes[1].type, equals(NoteType.incident));
        expect(entity.notes[2].type, equals(NoteType.medication));
        expect(entity.notes[3].type, equals(NoteType.task));
        expect(entity.notes[4].type, equals(NoteType.supplyRequest));
      });
    });

    group('ShiftReport Entity Methods', () {
      test('should correctly identify empty shift report', () {
        // Arrange
        final emptyReport = ShiftReport.from(
          ShiftReportModel(
            id: "empty-shift",
            caregiverId: "caregiver-001",
            startTime: "2024-01-15T08:00:00.000Z",
            notes: [],
            summary: "",
            isSubmitted: false,
          ),
        );

        final nonEmptyReport = ShiftReport.from(
          ShiftReportModel(
            id: "non-empty-shift",
            caregiverId: "caregiver-001",
            startTime: "2024-01-15T08:00:00.000Z",
            notes: [
              {
                "id": "note-1",
                "text": "Patient checked",
                "type": "observation",
                "timestamp": "2024-01-15T09:00:00.000Z",
                "authorId": "caregiver-001",
                "taggedResidentIds": [],
                "isAcknowledged": false,
              },
            ],
            summary: "Good day",
            isSubmitted: false,
          ),
        );

        // Act & Assert
        expect(emptyReport.isEmpty, isTrue);
        expect(nonEmptyReport.isEmpty, isFalse);
      });

      test('should create copyWith correctly', () {
        // Arrange
        final originalReport = ShiftReport.from(
          ShiftReportModel(
            id: "original-shift",
            caregiverId: "caregiver-001",
            startTime: "2024-01-15T08:00:00.000Z",
            notes: [],
            summary: "Original summary",
            isSubmitted: false,
          ),
        );

        // Act
        final copiedReport = originalReport.copyWith(summary: "Updated summary", isSubmitted: true);

        // Assert
        expect(copiedReport.id, equals("original-shift"));
        expect(copiedReport.caregiverId, equals("caregiver-001"));
        expect(copiedReport.summary, equals("Updated summary"));
        expect(copiedReport.isSubmitted, isTrue);
        expect(copiedReport.startTime, equals(originalReport.startTime));
        expect(copiedReport.notes, equals(originalReport.notes));
      });

      test('should convert back to model correctly', () {
        // Arrange
        final entity = ShiftReport.from(
          ShiftReportModel(
            id: "test-shift",
            caregiverId: "caregiver-001",
            startTime: "2024-01-15T08:00:00.000Z",
            endTime: "2024-01-15T16:00:00.000Z",
            notes: [
              {
                "id": "note-1",
                "text": "Test note",
                "type": "observation",
                "timestamp": "2024-01-15T09:00:00.000Z",
                "authorId": "caregiver-001",
                "taggedResidentIds": ["resident-1"],
                "isAcknowledged": false,
              },
            ],
            summary: "Test summary",
            isSubmitted: false,
          ),
        );

        // Act
        final model = entity.toModel(summary: "Updated summary", isSubmitted: true);

        // Assert
        expect(model.id, equals("test-shift"));
        expect(model.caregiverId, equals("caregiver-001"));
        expect(model.startTime, isNotNull);
        expect(model.endTime, isNotNull);
        expect(model.notes?.length, equals(1));
        expect(model.summary, equals("Updated summary"));
        expect(model.isSubmitted, isTrue);
      });
    });

    group('HandoverNote Entity Tests', () {
      test('should create HandoverNote from model correctly', () {
        // Arrange
        final noteData = {
          "id": "note-123",
          "text": "Patient needs attention",
          "type": "observation",
          "timestamp": "2024-01-15T09:00:00.000Z",
          "authorId": "caregiver-001",
          "taggedResidentIds": ["resident-1", "resident-2"],
          "isAcknowledged": false,
        };
        final noteModel = HandoverNoteModel().fromJson(noteData);

        // Act
        final note = HandoverNote.from(noteModel);

        // Assert
        expect(note.id, equals("note-123"));
        expect(note.text, equals("Patient needs attention"));
        expect(note.type, equals(NoteType.observation));
        expect(note.authorId, equals("caregiver-001"));
        expect(note.taggedResidentIds.length, equals(2));
        expect(note.isAcknowledged, isFalse);
        expect(note.timestamp, isA<DateTime>());
      });

      test('should handle unknown note types gracefully', () {
        // Arrange
        final noteData = {
          "id": "note-456",
          "text": "Unknown type note",
          "type": "unknown_type",
          "timestamp": "2024-01-15T09:00:00.000Z",
          "authorId": "caregiver-001",
          "taggedResidentIds": [],
          "isAcknowledged": false,
        };
        final noteModel = HandoverNoteModel().fromJson(noteData);

        // Act
        final note = HandoverNote.from(noteModel);

        // Assert
        expect(note.type, equals(NoteType.observation)); // Should default to observation
      });

      test('should create acknowledged note correctly', () {
        // Arrange
        final noteData = {
          "id": "note-789",
          "text": "Original note",
          "type": "medication",
          "timestamp": "2024-01-15T09:00:00.000Z",
          "authorId": "caregiver-001",
          "taggedResidentIds": [],
          "isAcknowledged": false,
        };
        final noteModel = HandoverNoteModel().fromJson(noteData);
        final originalNote = HandoverNote.from(noteModel);

        // Act
        final acknowledgedNote = HandoverNote.acknowledged(originalNote);

        // Assert
        expect(acknowledgedNote.id, equals("note-789"));
        expect(acknowledgedNote.text, equals("Original note"));
        expect(acknowledgedNote.type, equals(NoteType.medication));
        expect(acknowledgedNote.isAcknowledged, isTrue);
      });

      test('should identify empty notes correctly', () {
        // Arrange
        final emptyNoteData = {
          "id": "empty-note",
          "text": "",
          "type": "observation",
          "timestamp": "2024-01-15T09:00:00.000Z",
          "authorId": "caregiver-001",
          "taggedResidentIds": [],
          "isAcknowledged": false,
        };
        final emptyNoteModel = HandoverNoteModel().fromJson(emptyNoteData);
        final emptyNote = HandoverNote.from(emptyNoteModel);

        final nonEmptyNoteData = {
          "id": "non-empty-note",
          "text": "Has content",
          "type": "observation",
          "timestamp": "2024-01-15T09:00:00.000Z",
          "authorId": "caregiver-001",
          "taggedResidentIds": [],
          "isAcknowledged": false,
        };
        final nonEmptyNoteModel = HandoverNoteModel().fromJson(nonEmptyNoteData);
        final nonEmptyNote = HandoverNote.from(nonEmptyNoteModel);

        // Act & Assert
        expect(emptyNote.isEmpty, isTrue);
        expect(nonEmptyNote.isEmpty, isFalse);
      });
    });
  });
}
