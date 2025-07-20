import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/features/shift_handover/domain/entities/note_type.dart';

void main() {
  group('NoteType Tests', () {
    group('Enum Values', () {
      test('should have all expected note types', () {
        // Act & Assert
        expect(NoteType.values.length, equals(5));
        expect(NoteType.values, contains(NoteType.medication));
        expect(NoteType.values, contains(NoteType.observation));
        expect(NoteType.values, contains(NoteType.incident));
        expect(NoteType.values, contains(NoteType.task));
        expect(NoteType.values, contains(NoteType.supplyRequest));
      });

      test('should have correct enum names', () {
        // Assert
        expect(NoteType.medication.name, equals('medication'));
        expect(NoteType.observation.name, equals('observation'));
        expect(NoteType.incident.name, equals('incident'));
        expect(NoteType.task.name, equals('task'));
        expect(NoteType.supplyRequest.name, equals('supplyRequest'));
      });

      test('should have correct enum indices', () {
        // Assert
        expect(NoteType.medication.index, equals(0));
        expect(NoteType.observation.index, equals(1));
        expect(NoteType.incident.index, equals(2));
        expect(NoteType.task.index, equals(3));
        expect(NoteType.supplyRequest.index, equals(4));
      });
    });

    group('Enum Usage in Context', () {
      test('should be usable in switch statements', () {
        // Test each enum value in a switch
        for (final noteType in NoteType.values) {
          String result;

          switch (noteType) {
            case NoteType.medication:
              result = 'Medical';
              break;
            case NoteType.observation:
              result = 'Observe';
              break;
            case NoteType.incident:
              result = 'Incident';
              break;
            case NoteType.task:
              result = 'Task';
              break;
            case NoteType.supplyRequest:
              result = 'Supply';
              break;
          }

          expect(result, isNotNull);
          expect(result, isNotEmpty);
        }
      });

      test('should be comparable', () {
        // Assert
        expect(NoteType.medication == NoteType.medication, isTrue);
        expect(NoteType.medication == NoteType.observation, isFalse);
        expect(NoteType.observation != NoteType.incident, isTrue);
      });

      test('should be usable in collections', () {
        // Arrange
        final noteTypeSet = <NoteType>{
          NoteType.medication,
          NoteType.observation,
          NoteType.medication, // Duplicate should be ignored
        };

        final noteTypeList = [NoteType.task, NoteType.supplyRequest, NoteType.incident];

        // Assert
        expect(noteTypeSet.length, equals(2)); // Set should ignore duplicate
        expect(noteTypeSet.contains(NoteType.medication), isTrue);
        expect(noteTypeSet.contains(NoteType.observation), isTrue);

        expect(noteTypeList.length, equals(3));
        expect(noteTypeList[0], equals(NoteType.task));
        expect(noteTypeList[1], equals(NoteType.supplyRequest));
        expect(noteTypeList[2], equals(NoteType.incident));
      });

      test('should maintain value integrity', () {
        // Test that enum values remain consistent
        final savedMedication = NoteType.medication;
        final savedObservation = NoteType.observation;

        expect(savedMedication, equals(NoteType.medication));
        expect(savedObservation, equals(NoteType.observation));
        expect(savedMedication.name, equals('medication'));
        expect(savedObservation.name, equals('observation'));
      });
    });

    group('String Conversion Integration', () {
      test('should work with string mapping for all types', () {
        // This tests the pattern used in HandoverNote.from()
        final stringToType = <String, NoteType>{
          'observation': NoteType.observation,
          'incident': NoteType.incident,
          'medication': NoteType.medication,
          'task': NoteType.task,
          'supplyRequest': NoteType.supplyRequest,
        };

        // Test conversion from string to enum
        for (final entry in stringToType.entries) {
          final typeFromString = stringToType[entry.key];
          expect(typeFromString, equals(entry.value));
          expect(typeFromString?.name, equals(entry.key));
        }
      });

      test('should handle unknown string types with default', () {
        // Simulate the parseType function from HandoverNote
        NoteType parseType(String? typeString) => switch (typeString) {
          'observation' => NoteType.observation,
          'incident' => NoteType.incident,
          'medication' => NoteType.medication,
          'task' => NoteType.task,
          'supplyRequest' => NoteType.supplyRequest,
          _ => NoteType.observation, // Default
        };

        // Test unknown types default to observation
        expect(parseType('unknown'), equals(NoteType.observation));
        expect(parseType(null), equals(NoteType.observation));
        expect(parseType(''), equals(NoteType.observation));
        expect(parseType('invalid_type'), equals(NoteType.observation));

        // Test known types work correctly
        expect(parseType('medication'), equals(NoteType.medication));
        expect(parseType('incident'), equals(NoteType.incident));
        expect(parseType('task'), equals(NoteType.task));
        expect(parseType('supplyRequest'), equals(NoteType.supplyRequest));
      });

      test('should be case sensitive in string mapping', () {
        // Test that the mapping is case-sensitive (as implemented)
        NoteType parseType(String? typeString) => switch (typeString) {
          'observation' => NoteType.observation,
          'incident' => NoteType.incident,
          'medication' => NoteType.medication,
          'task' => NoteType.task,
          'supplyRequest' => NoteType.supplyRequest,
          _ => NoteType.observation,
        };

        // These should default to observation due to case mismatch
        expect(parseType('MEDICATION'), equals(NoteType.observation));
        expect(parseType('Observation'), equals(NoteType.observation));
        expect(parseType('INCIDENT'), equals(NoteType.observation));
        expect(parseType('Task'), equals(NoteType.observation));
        expect(parseType('SupplyRequest'), equals(NoteType.observation));
      });
    });

    group('Practical Usage Scenarios', () {
      test('should support filtering by note type', () {
        // Simulate filtering notes by type
        final mixedNoteTypes = [
          NoteType.medication,
          NoteType.observation,
          NoteType.medication,
          NoteType.incident,
          NoteType.task,
          NoteType.observation,
          NoteType.supplyRequest,
        ];

        final medicationNotes = mixedNoteTypes
            .where((type) => type == NoteType.medication)
            .toList();
        final observationNotes = mixedNoteTypes
            .where((type) => type == NoteType.observation)
            .toList();
        final incidentNotes = mixedNoteTypes.where((type) => type == NoteType.incident).toList();

        expect(medicationNotes.length, equals(2));
        expect(observationNotes.length, equals(2));
        expect(incidentNotes.length, equals(1));
      });

      test('should support grouping by note type', () {
        // Simulate grouping notes by type
        final noteTypes = [
          NoteType.medication,
          NoteType.observation,
          NoteType.medication,
          NoteType.incident,
          NoteType.observation,
        ];

        final groupedByType = <NoteType, int>{};
        for (final type in noteTypes) {
          groupedByType[type] = (groupedByType[type] ?? 0) + 1;
        }

        expect(groupedByType[NoteType.medication], equals(2));
        expect(groupedByType[NoteType.observation], equals(2));
        expect(groupedByType[NoteType.incident], equals(1));
        expect(groupedByType[NoteType.task], isNull);
        expect(groupedByType[NoteType.supplyRequest], isNull);
      });

      test('should support sorting by priority (based on index)', () {
        // Simulate sorting where enum index represents priority
        final unorderedTypes = [
          NoteType.supplyRequest,
          NoteType.observation,
          NoteType.medication,
          NoteType.task,
          NoteType.incident,
        ];

        final sortedByIndex = [...unorderedTypes]..sort((a, b) => a.index.compareTo(b.index));

        expect(sortedByIndex[0], equals(NoteType.medication)); // index 0
        expect(sortedByIndex[1], equals(NoteType.observation)); // index 1
        expect(sortedByIndex[2], equals(NoteType.incident)); // index 2
        expect(sortedByIndex[3], equals(NoteType.task)); // index 3
        expect(sortedByIndex[4], equals(NoteType.supplyRequest)); // index 4
      });
    });
  });
}
