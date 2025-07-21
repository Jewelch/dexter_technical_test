import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/features/shift_handover/data/models/handover_note_model.dart';

void main() {
  group('HandoverNoteModel', () {
    test('should create HandoverNoteModel from JSON', () {
      // Arrange
      final jsonData = {
        "id": "note-123",
        "text": "Patient needs attention",
        "type": "observation",
        "timestamp": "2024-01-15T09:00:00.000Z",
        "authorId": "caregiver-001",
        "taggedResidentIds": ["resident-1", "resident-2"],
        "isAcknowledged": false,
      };

      // Act
      final model = HandoverNoteModel().fromJson(jsonData);

      // Assert
      expect(model.id, equals("note-123"));
      expect(model.text, equals("Patient needs attention"));
      expect(model.type, equals("observation"));
      expect(model.timestamp, equals("2024-01-15T09:00:00.000Z"));
      expect(model.authorId, equals("caregiver-001"));
      expect(model.taggedResidentIds, equals(["resident-1", "resident-2"]));
      expect(model.isAcknowledged, equals(false));
    });

    test('should convert HandoverNoteModel to JSON', () {
      // Arrange
      const model = HandoverNoteModel(
        id: "note-456",
        text: "Medication administered",
        type: "medication",
        timestamp: "2024-01-15T10:30:00.000Z",
        authorId: "nurse-002",
        taggedResidentIds: ["resident-3"],
        isAcknowledged: true,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(
        json,
        equals({
          "id": "note-456",
          "text": "Medication administered",
          "type": "medication",
          "timestamp": "2024-01-15T10:30:00.000Z",
          "authorId": "nurse-002",
          "taggedResidentIds": ["resident-3"],
          "isAcknowledged": true,
        }),
      );
    });

    test('should handle null values in toJson', () {
      // Arrange
      const model = HandoverNoteModel(
        id: null,
        text: null,
        type: null,
        timestamp: null,
        authorId: null,
        taggedResidentIds: null,
        isAcknowledged: null,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(
        json,
        equals({
          "id": null,
          "text": null,
          "type": null,
          "timestamp": null,
          "authorId": null,
          "taggedResidentIds": null,
          "isAcknowledged": null,
        }),
      );
    });

    test('should handle empty taggedResidentIds list', () {
      // Arrange
      const model = HandoverNoteModel(
        id: "note-789",
        text: "Regular check",
        type: "observation",
        timestamp: "2024-01-15T14:00:00.000Z",
        authorId: "caregiver-003",
        taggedResidentIds: [],
        isAcknowledged: false,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json["taggedResidentIds"], equals([]));
      expect(json["id"], equals("note-789"));
      expect(json["text"], equals("Regular check"));
    });
  });
}
