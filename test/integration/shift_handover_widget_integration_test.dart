import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/features/shift_handover/data/models/handover_note_model.dart';
import 'package:health/src/features/shift_handover/domain/entities/handover_note.dart';
import 'package:health/src/features/shift_handover/domain/entities/note_type.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/input_section.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/note_card.dart';

void main() {
  group('Shift Handover Widget Integration Tests', () {
    group('NoteCard Widget Integration', () {
      testWidgets('should display note card with all information correctly', (tester) async {
        // Create a test note
        final noteModel = HandoverNoteModel(
          id: 'test-note-1',
          text: 'Patient showed improvement in mobility',
          type: 'observation',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
          authorId: 'caregiver-123',
          taggedResidentIds: ['resident-1', 'resident-2'],
          isAcknowledged: false,
        );

        final note = HandoverNote.from(noteModel);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: NoteCard(note: note)),
          ),
        );

        // Verify note content is displayed
        expect(find.text('Patient showed improvement in mobility'), findsOneWidget);
        expect(find.text('OBSERVATION'), findsOneWidget);

        // Verify icon is displayed for observation type
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });

      testWidgets('should display different note types with correct styling', (tester) async {
        final noteTypes = [
          ('observation', Icons.visibility_outlined),
          ('medication', Icons.medical_services_outlined),
          ('incident', Icons.warning_amber_rounded),
          ('task', Icons.check_circle_outline),
          ('supplyRequest', Icons.shopping_cart_checkout_outlined),
        ];

        for (final (typeString, expectedIcon) in noteTypes) {
          final noteModel = HandoverNoteModel(
            id: 'test-note-$typeString',
            text: 'Test note for $typeString',
            type: typeString,
            timestamp: DateTime.now().toIso8601String(),
            authorId: 'caregiver-123',
            taggedResidentIds: [],
            isAcknowledged: false,
          );

          final note = HandoverNote.from(noteModel);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: NoteCard(note: note)),
            ),
          );

          // Verify correct content and styling for each type
          expect(find.text('Test note for $typeString'), findsOneWidget);
          expect(find.text(typeString.toUpperCase()), findsOneWidget);
          expect(find.byIcon(expectedIcon), findsOneWidget);

          await tester.pumpWidget(Container()); // Clear widget tree
        }
      });

      testWidgets('should handle acknowledged vs unacknowledged notes', (tester) async {
        final unacknowledgedModel = HandoverNoteModel(
          id: 'unack-note',
          text: 'Unacknowledged note',
          type: 'incident',
          timestamp: DateTime.now().toIso8601String(),
          authorId: 'caregiver-123',
          taggedResidentIds: [],
          isAcknowledged: false,
        );

        final acknowledgedModel = HandoverNoteModel(
          id: 'ack-note',
          text: 'Acknowledged note',
          type: 'incident',
          timestamp: DateTime.now().toIso8601String(),
          authorId: 'caregiver-123',
          taggedResidentIds: [],
          isAcknowledged: true,
        );

        final unacknowledgedNote = HandoverNote.from(unacknowledgedModel);
        final acknowledgedNote = HandoverNote.from(acknowledgedModel);

        // Test unacknowledged note
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: NoteCard(note: unacknowledgedNote)),
          ),
        );

        expect(find.text('Unacknowledged note'), findsOneWidget);

        // Test acknowledged note
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: NoteCard(note: acknowledgedNote)),
          ),
        );

        expect(find.text('Acknowledged note'), findsOneWidget);
      });
    });

    group('InputSection Widget Integration', () {
      testWidgets('should render input section with all components', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        // Verify input components are present
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(DropdownButton<NoteType>), findsOneWidget);
        expect(find.text('Add Note'), findsOneWidget);
      });

      testWidgets('should handle text input correctly', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        final textField = find.byType(TextField);

        // Enter text into the field
        await tester.enterText(textField, 'Test note content');
        await tester.pump();

        // Verify the text appears in the field
        expect(find.text('Test note content'), findsOneWidget);
      });

      testWidgets('should show all note types in dropdown', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        final dropdown = find.byType(DropdownButton<NoteType>);

        // Tap dropdown to open it
        await tester.tap(dropdown);
        await tester.pumpAndSettle();

        // Verify all note types are available
        expect(find.text('observation'), findsWidgets);
        expect(find.text('medication'), findsWidgets);
        expect(find.text('incident'), findsWidgets);
        expect(find.text('task'), findsWidgets);
        expect(find.text('supplyRequest'), findsWidgets);
      });

      testWidgets('should allow selecting different note types', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        final dropdown = find.byType(DropdownButton<NoteType>);

        // Open dropdown and select medication
        await tester.tap(dropdown);
        await tester.pumpAndSettle();

        await tester.tap(find.text('medication').last);
        await tester.pumpAndSettle();

        // Verify selection changed (dropdown should show medication as selected)
        expect(find.text('medication'), findsOneWidget);
      });
    });

    group('Widget Interaction Integration', () {
      testWidgets('should handle form submission workflow', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        final textField = find.byType(TextField);
        final addButton = find.text('Add Note');

        // Enter text
        await tester.enterText(textField, 'Integration test note');
        await tester.pump();

        // Verify text is entered
        expect(find.text('Integration test note'), findsOneWidget);

        // The actual button functionality would require BLoC integration
        // Here we just verify the button is tappable
        expect(addButton, findsOneWidget);

        // Tap the button (won't do anything without BLoC, but verifies UI)
        await tester.tap(addButton);
        await tester.pump();
      });

      testWidgets('should handle dropdown and text input together', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        final textField = find.byType(TextField);
        final dropdown = find.byType(DropdownButton<NoteType>);

        // Select incident type
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text('incident').last);
        await tester.pumpAndSettle();

        // Enter incident description
        await tester.enterText(textField, 'Safety incident in hallway');
        await tester.pump();

        // Verify both selections
        expect(find.text('incident'), findsOneWidget);
        expect(find.text('Safety incident in hallway'), findsOneWidget);
      });
    });

    group('Multiple Widget Integration', () {
      testWidgets('should display multiple note cards in a list', (tester) async {
        final notes = [
          HandoverNote.from(
            HandoverNoteModel(
              id: 'note-1',
              text: 'First test note',
              type: 'observation',
              timestamp: DateTime.now().toIso8601String(),
              authorId: 'caregiver-1',
              taggedResidentIds: [],
              isAcknowledged: false,
            ),
          ),
          HandoverNote.from(
            HandoverNoteModel(
              id: 'note-2',
              text: 'Second test note',
              type: 'medication',
              timestamp: DateTime.now().toIso8601String(),
              authorId: 'caregiver-1',
              taggedResidentIds: [],
              isAcknowledged: true,
            ),
          ),
          HandoverNote.from(
            HandoverNoteModel(
              id: 'note-3',
              text: 'Third test note',
              type: 'incident',
              timestamp: DateTime.now().toIso8601String(),
              authorId: 'caregiver-1',
              taggedResidentIds: ['resident-1'],
              isAcknowledged: false,
            ),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) => NoteCard(note: notes[index]),
              ),
            ),
          ),
        );

        // Verify all notes are displayed
        expect(find.text('First test note'), findsOneWidget);
        expect(find.text('Second test note'), findsOneWidget);
        expect(find.text('Third test note'), findsOneWidget);

        // Verify different note type styles
        expect(find.text('OBSERVATION'), findsOneWidget);
        expect(find.text('MEDICATION'), findsOneWidget);
        expect(find.text('INCIDENT'), findsOneWidget);

        // Verify different icons
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
        expect(find.byIcon(Icons.medical_services_outlined), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      });

      testWidgets('should handle scrolling with many notes', (tester) async {
        final manyNotes = List.generate(
          20,
          (index) => HandoverNote.from(
            HandoverNoteModel(
              id: 'note-$index',
              text: 'Test note number $index',
              type: index % 2 == 0 ? 'observation' : 'medication',
              timestamp: DateTime.now().toIso8601String(),
              authorId: 'caregiver-1',
              taggedResidentIds: [],
              isAcknowledged: index % 3 == 0,
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: manyNotes.length,
                itemBuilder: (context, index) => NoteCard(note: manyNotes[index]),
              ),
            ),
          ),
        );

        // Verify first few notes are visible
        expect(find.text('Test note number 0'), findsOneWidget);
        expect(find.text('Test note number 1'), findsOneWidget);

        // Scroll down to see more notes
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();

        // Should still have note cards visible
        expect(find.byType(NoteCard), findsWidgets);
      });
    });

    group('Responsive Design Widget Tests', () {
      testWidgets('should adapt to different screen sizes', (tester) async {
        final testNote = HandoverNote.from(
          HandoverNoteModel(
            id: 'responsive-note',
            text: 'Responsive design test note with longer content to see how it wraps',
            type: 'observation',
            timestamp: DateTime.now().toIso8601String(),
            authorId: 'caregiver-1',
            taggedResidentIds: [],
            isAcknowledged: false,
          ),
        );

        // Test on phone size
        await tester.binding.setSurfaceSize(const Size(375, 812));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  NoteCard(note: testNote),
                  const InputSection(),
                ],
              ),
            ),
          ),
        );

        expect(
          find.text('Responsive design test note with longer content to see how it wraps'),
          findsOneWidget,
        );
        expect(find.byType(TextField), findsOneWidget);

        // Test on tablet size
        await tester.binding.setSurfaceSize(const Size(768, 1024));
        await tester.pumpAndSettle();

        // Should still display correctly
        expect(
          find.text('Responsive design test note with longer content to see how it wraps'),
          findsOneWidget,
        );
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('Accessibility Widget Tests', () {
      testWidgets('should have accessible widgets', (tester) async {
        final testNote = HandoverNote.from(
          HandoverNoteModel(
            id: 'accessible-note',
            text: 'Accessibility test note',
            type: 'observation',
            timestamp: DateTime.now().toIso8601String(),
            authorId: 'caregiver-1',
            taggedResidentIds: [],
            isAcknowledged: false,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  NoteCard(note: testNote),
                  const InputSection(),
                ],
              ),
            ),
          ),
        );

        // Verify widgets are accessible
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(DropdownButton<NoteType>), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);

        // Text should be readable
        expect(find.text('Accessibility test note'), findsOneWidget);
        expect(find.text('Add Note'), findsOneWidget);
      });
    });
  });
}
