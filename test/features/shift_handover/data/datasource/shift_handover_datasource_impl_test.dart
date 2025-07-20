import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/features/shift_handover/data/models/shift_report_model.dart';
import 'package:health/src/features/shift_handover/data/models/submission_result_model.dart';

void main() {
  group('ShiftHandoverDataSource Models Tests', () {
    group('ShiftReportModel', () {
      test('should create ShiftReportModel from JSON data', () {
        // Arrange
        final jsonData = {
          "id": "shift-123",
          "caregiverId": "caregiver-001",
          "startTime": DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
          "endTime": null,
          "notes": [
            {
              "id": "note-1",
              "text": "Patient showed signs of improvement",
              "type": "observation",
              "timestamp": DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
              "authorId": "caregiver-A",
              "taggedResidentIds": ["resident-1"],
              "isAcknowledged": false,
            },
          ],
          "summary": "",
          "isSubmitted": false,
        };

        // Act
        final model = ShiftReportModel().fromJson(jsonData);

        // Assert
        expect(model.id, equals("shift-123"));
        expect(model.caregiverId, equals("caregiver-001"));
        expect(model.startTime, isNotNull);
        expect(model.endTime, isNull);
        expect(model.notes, isNotNull);
        expect(model.notes?.length, equals(1));
        expect(model.summary, equals(""));
        expect(model.isSubmitted, equals(false));
      });

      test('should create ShiftReportModel with empty data', () {
        // Arrange
        final jsonData = <String, dynamic>{};

        // Act
        final model = ShiftReportModel().fromJson(jsonData);

        // Assert
        expect(model.id, isNull);
        expect(model.caregiverId, isNull);
        expect(model.startTime, isNull);
        expect(model.endTime, isNull);
        expect(model.notes, isNull);
        expect(model.summary, isNull);
        expect(model.isSubmitted, isNull);
      });

      test('should serialize ShiftReportModel to JSON', () {
        // Arrange
        final model = ShiftReportModel(
          id: "shift-456",
          caregiverId: "caregiver-002",
          startTime: "2024-01-15T08:00:00Z",
          endTime: "2024-01-15T16:00:00Z",
          notes: [
            {
              "id": "note-1",
              "text": "Medication administered",
              "type": "medication",
              "timestamp": "2024-01-15T14:00:00Z",
              "authorId": "caregiver-002",
              "taggedResidentIds": [],
              "isAcknowledged": false,
            },
          ],
          summary: "Patient is stable",
          isSubmitted: true,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json["id"], equals("shift-456"));
        expect(json["caregiverId"], equals("caregiver-002"));
        expect(json["startTime"], equals("2024-01-15T08:00:00Z"));
        expect(json["endTime"], equals("2024-01-15T16:00:00Z"));
        expect(json["notes"], isNotNull);
        expect(json["summary"], equals("Patient is stable"));
        expect(json["isSubmitted"], equals(true));
      });

      test('should handle complex notes structure', () {
        // Arrange
        final jsonData = {
          "id": "shift-789",
          "caregiverId": "caregiver-003",
          "startTime": "2024-01-15T08:00:00Z",
          "notes": [
            {
              "id": "note-1",
              "text": "Patient vitals checked",
              "type": "observation",
              "timestamp": "2024-01-15T09:00:00Z",
              "authorId": "caregiver-003",
              "taggedResidentIds": [],
              "isAcknowledged": false,
            },
            {
              "id": "note-2",
              "text": "Minor incident occurred",
              "type": "incident",
              "timestamp": "2024-01-15T11:00:00Z",
              "authorId": "caregiver-003",
              "taggedResidentIds": ["resident-1", "resident-2"],
              "isAcknowledged": true,
            },
          ],
          "summary": "Mixed day with incident",
          "isSubmitted": false,
        };

        // Act
        final model = ShiftReportModel().fromJson(jsonData);

        // Assert
        expect(model.id, equals("shift-789"));
        expect(model.notes?.length, equals(2));
        expect(model.summary, equals("Mixed day with incident"));
        expect(model.isSubmitted, equals(false));
      });
    });

    group('SubmissionResultModel', () {
      test('should create SubmissionResultModel from successful JSON', () {
        // Arrange
        final jsonData = {"success": true, "message": "Report submitted successfully"};

        // Act
        final model = SubmissionResultModel().fromJson(jsonData);

        // Assert
        expect(model.success, equals(true));
        expect(model.message, equals("Report submitted successfully"));
      });

      test('should create SubmissionResultModel from failure JSON', () {
        // Arrange
        final jsonData = {"success": false, "message": "Submission failed due to network error"};

        // Act
        final model = SubmissionResultModel().fromJson(jsonData);

        // Assert
        expect(model.success, equals(false));
        expect(model.message, equals("Submission failed due to network error"));
      });

      test('should handle null values in SubmissionResultModel', () {
        // Arrange
        final jsonData = <String, dynamic>{};

        // Act
        final model = SubmissionResultModel().fromJson(jsonData);

        // Assert
        expect(model.success, isNull);
        expect(model.message, isNull);
      });

      test('should serialize SubmissionResultModel to JSON', () {
        // Arrange
        final model = SubmissionResultModel(success: true, message: "Operation completed");

        // Act
        final json = model.toJson();

        // Assert
        expect(json["success"], equals(true));
        expect(json["message"], equals("Operation completed"));
      });
    });

    group('Model Validation', () {
      test('should handle edge cases for ShiftReportModel', () {
        // Test with partial data
        final partialData = {"id": "test-id", "caregiverId": null, "notes": []};

        final model = ShiftReportModel().fromJson(partialData);

        expect(model.id, equals("test-id"));
        expect(model.caregiverId, isNull);
        expect(model.notes, isNotNull);
        expect(model.notes?.length, equals(0));
      });

      test('should handle nested null values gracefully', () {
        final dataWithNulls = {"id": "test", "notes": null, "summary": null, "isSubmitted": null};

        final model = ShiftReportModel().fromJson(dataWithNulls);

        expect(model.id, equals("test"));
        expect(model.notes, isNull);
        expect(model.summary, isNull);
        expect(model.isSubmitted, isNull);
      });
    });
  });
}
