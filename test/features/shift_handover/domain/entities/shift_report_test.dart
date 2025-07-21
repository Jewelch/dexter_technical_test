import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/features/shift_handover/data/models/handover_note_model.dart';
import 'package:health/src/features/shift_handover/data/models/shift_report_model.dart';
import 'package:health/src/features/shift_handover/domain/entities/handover_note.dart';
import 'package:health/src/features/shift_handover/domain/entities/shift_report.dart';

void main() {
  group('ShiftReport', () {
    late ShiftReport baseReport;
    late List<HandoverNote> testNotes;

    setUp(() {
      testNotes = [
        HandoverNote.from(
          const HandoverNoteModel(
            id: "note-1",
            text: "Test note 1",
            type: "observation",
            timestamp: "2024-01-15T09:00:00.000Z",
            authorId: "caregiver-001",
            taggedResidentIds: ["resident-1"],
            isAcknowledged: false,
          ),
        ),
        HandoverNote.from(
          const HandoverNoteModel(
            id: "note-2",
            text: "Test note 2",
            type: "medication",
            timestamp: "2024-01-15T10:00:00.000Z",
            authorId: "nurse-002",
            taggedResidentIds: ["resident-2"],
            isAcknowledged: true,
          ),
        ),
      ];

      baseReport = ShiftReport.from(
        ShiftReportModel(
          id: "shift-123",
          caregiverId: "caregiver-001",
          startTime: "2024-01-15T08:00:00.000Z",
          endTime: "2024-01-15T16:00:00.000Z",
          notes: [
            {
              "id": "note-1",
              "text": "Test note 1",
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
    });

    test('should create ShiftReport from ShiftReportModel', () {
      // Act
      final report = ShiftReport.from(
        ShiftReportModel(
          id: "shift-456",
          caregiverId: "caregiver-002",
          startTime: "2024-01-15T06:00:00.000Z",
          endTime: null,
          notes: [],
          summary: "",
          isSubmitted: true,
        ),
      );

      // Assert
      expect(report.id, equals("shift-456"));
      expect(report.caregiverId, equals("caregiver-002"));
      expect(report.startTime, isA<DateTime>());
      expect(report.endTime, isNull);
      expect(report.notes, isEmpty);
      expect(report.summary, equals(""));
      expect(report.isSubmitted, equals(true));
    });

    test('should create copy with updated id', () {
      // Act
      final copiedReport = baseReport.copyWith(id: "new-shift-id");

      // Assert
      expect(copiedReport.id, equals("new-shift-id"));
      expect(copiedReport.caregiverId, equals(baseReport.caregiverId));
      expect(copiedReport.startTime, equals(baseReport.startTime));
      expect(copiedReport.endTime, equals(baseReport.endTime));
      expect(copiedReport.notes, equals(baseReport.notes));
      expect(copiedReport.summary, equals(baseReport.summary));
      expect(copiedReport.isSubmitted, equals(baseReport.isSubmitted));
    });

    test('should create copy with updated caregiverId', () {
      // Act
      final copiedReport = baseReport.copyWith(caregiverId: "new-caregiver");

      // Assert
      expect(copiedReport.caregiverId, equals("new-caregiver"));
      expect(copiedReport.id, equals(baseReport.id));
    });

    test('should create copy with updated startTime', () {
      // Arrange
      final newStartTime = DateTime.parse("2024-01-16T08:00:00.000Z");

      // Act
      final copiedReport = baseReport.copyWith(startTime: newStartTime);

      // Assert
      expect(copiedReport.startTime, equals(newStartTime));
      expect(copiedReport.id, equals(baseReport.id));
    });

    test('should create copy with updated endTime', () {
      // Arrange
      final newEndTime = DateTime.parse("2024-01-15T18:00:00.000Z");

      // Act
      final copiedReport = baseReport.copyWith(endTime: newEndTime);

      // Assert
      expect(copiedReport.endTime, equals(newEndTime));
      expect(copiedReport.id, equals(baseReport.id));
    });

    test('should create copy with updated notes', () {
      // Act
      final copiedReport = baseReport.copyWith(notes: testNotes);

      // Assert
      expect(copiedReport.notes, equals(testNotes));
      expect(copiedReport.notes.length, equals(2));
      expect(copiedReport.id, equals(baseReport.id));
    });

    test('should create copy with updated summary', () {
      // Act
      final copiedReport = baseReport.copyWith(summary: "Updated summary");

      // Assert
      expect(copiedReport.summary, equals("Updated summary"));
      expect(copiedReport.id, equals(baseReport.id));
    });

    test('should create copy with updated isSubmitted', () {
      // Act
      final copiedReport = baseReport.copyWith(isSubmitted: true);

      // Assert
      expect(copiedReport.isSubmitted, equals(true));
      expect(copiedReport.id, equals(baseReport.id));
    });

    test('should create copy with multiple updated fields', () {
      // Arrange
      final newEndTime = DateTime.parse("2024-01-15T20:00:00.000Z");

      // Act
      final copiedReport = baseReport.copyWith(
        caregiverId: "multi-caregiver",
        endTime: newEndTime,
        summary: "Multi-field summary",
        isSubmitted: true,
      );

      // Assert
      expect(copiedReport.caregiverId, equals("multi-caregiver"));
      expect(copiedReport.endTime, equals(newEndTime));
      expect(copiedReport.summary, equals("Multi-field summary"));
      expect(copiedReport.isSubmitted, equals(true));
      expect(copiedReport.id, equals(baseReport.id));
      expect(copiedReport.startTime, equals(baseReport.startTime));
      expect(copiedReport.notes, equals(baseReport.notes));
    });

    test('should convert to ShiftReportModel using toModel', () {
      // Act
      final model = baseReport.toModel();

      // Assert
      expect(model.id, equals(baseReport.id));
      expect(model.caregiverId, equals(baseReport.caregiverId));
      expect(model.startTime, equals(baseReport.startTime.toIso8601String()));
      expect(model.endTime, equals(baseReport.endTime?.toIso8601String()));
      expect(model.summary, equals(baseReport.summary));
      expect(model.isSubmitted, equals(baseReport.isSubmitted));
      expect(model.notes, isNotNull);
      expect(model.notes?.length, equals(baseReport.notes.length));
    });

    test('should convert to ShiftReportModel with custom parameters', () {
      // Arrange
      final customEndTime = DateTime.parse("2024-01-15T22:00:00.000Z");
      const customSummary = "Custom summary for conversion";

      // Act
      final model = baseReport.toModel(
        summary: customSummary,
        endTime: customEndTime,
        isSubmitted: true,
      );

      // Assert
      expect(model.summary, equals(customSummary));
      expect(model.endTime, equals(customEndTime.toIso8601String()));
      expect(model.isSubmitted, equals(true));
      expect(model.id, equals(baseReport.id));
      expect(model.caregiverId, equals(baseReport.caregiverId));
    });

    test('should convert to ShiftReportModel with default endTime when null', () {
      // Arrange
      final reportWithoutEndTime = baseReport.copyWith(endTime: null);

      // Act
      final model = reportWithoutEndTime.toModel();

      // Assert
      expect(model.endTime, isNotNull);
      expect(DateTime.parse(model.endTime!), isA<DateTime>());
    });

    test('should have correct Equatable props', () {
      // Act
      final props = baseReport.props;

      // Assert
      expect(props.length, equals(7));
      expect(props, contains(baseReport.id));
      expect(props, contains(baseReport.caregiverId));
      expect(props, contains(baseReport.startTime));
      expect(props, contains(baseReport.endTime));
      expect(props, contains(baseReport.notes));
      expect(props, contains(baseReport.summary));
      expect(props, contains(baseReport.isSubmitted));
    });

    test('should be equal when all props are equal', () {
      // Arrange
      final report1 = ShiftReport.from(
        ShiftReportModel(
          id: "equal-shift",
          caregiverId: "equal-caregiver",
          startTime: "2024-01-15T08:00:00.000Z",
          endTime: "2024-01-15T16:00:00.000Z",
          notes: [],
          summary: "Equal summary",
          isSubmitted: false,
        ),
      );

      final report2 = ShiftReport.from(
        ShiftReportModel(
          id: "equal-shift",
          caregiverId: "equal-caregiver",
          startTime: "2024-01-15T08:00:00.000Z",
          endTime: "2024-01-15T16:00:00.000Z",
          notes: [],
          summary: "Equal summary",
          isSubmitted: false,
        ),
      );

      // Assert
      expect(report1, equals(report2));
      expect(report1.hashCode, equals(report2.hashCode));
    });
  });
}
