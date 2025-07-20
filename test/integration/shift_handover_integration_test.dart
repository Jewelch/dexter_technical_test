import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/features/shift_handover/data/models/handover_note_model.dart';
import 'package:health/src/features/shift_handover/domain/entities/handover_note.dart';
import 'package:health/src/features/shift_handover/domain/entities/note_type.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/input_section.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/note_card.dart';

void main() {
  group('Shift Handover Integration Tests', () {
    group('Complete Widget Integration Tests', () {
      testWidgets('should display and interact with shift handover components', (tester) async {
        // Create test data
        final testNotes = [
          HandoverNote.from(
            HandoverNoteModel(
              id: 'note-1',
              text: 'Patient is comfortable and responsive',
              type: 'observation',
              timestamp: DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
              authorId: 'caregiver-001',
              taggedResidentIds: ['resident-1'],
              isAcknowledged: false,
            ),
          ),
          HandoverNote.from(
            HandoverNoteModel(
              id: 'note-2',
              text: 'Administered morning medication',
              type: 'medication',
              timestamp: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
              authorId: 'caregiver-001',
              taggedResidentIds: ['resident-1'],
              isAcknowledged: true,
            ),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Shift Handover Report')),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: testNotes.length,
                      itemBuilder: (context, index) => NoteCard(note: testNotes[index]),
                    ),
                  ),
                  const InputSection(),
                ],
              ),
            ),
          ),
        );

        // Verify existing notes are displayed
        expect(find.text('Patient is comfortable and responsive'), findsOneWidget);
        expect(find.text('Administered morning medication'), findsOneWidget);
        expect(find.text('OBSERVATION'), findsOneWidget);
        expect(find.text('MEDICATION'), findsOneWidget);

        // Verify input section is present
        expect(find.byType(InputSection), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(DropdownButton<NoteType>), findsOneWidget);
        expect(find.text('Add Note'), findsOneWidget);

        // Test adding a new note (UI interaction only)
        final textField = find.byType(TextField);
        await tester.enterText(textField, 'New integration test note');
        await tester.pump();

        expect(find.text('New integration test note'), findsOneWidget);

        // Test dropdown selection
        final dropdown = find.byType(DropdownButton<NoteType>);
        await tester.tap(dropdown);
        await tester.pumpAndSettle();

        expect(find.text('observation'), findsWidgets);
        expect(find.text('medication'), findsWidgets);
        expect(find.text('incident'), findsWidgets);

        await tester.tap(find.text('incident').last);
        await tester.pumpAndSettle();
      });

      testWidgets('should handle different screen orientations', (tester) async {
        final testNote = HandoverNote.from(
          HandoverNoteModel(
            id: 'orientation-note',
            text: 'Testing orientation changes',
            type: 'task',
            timestamp: DateTime.now().toIso8601String(),
            authorId: 'caregiver-002',
            taggedResidentIds: [],
            isAcknowledged: false,
          ),
        );

        // Portrait mode
        await tester.binding.setSurfaceSize(const Size(375, 812));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Shift Handover Report')),
              body: Column(
                children: [
                  NoteCard(note: testNote),
                  const InputSection(),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Testing orientation changes'), findsOneWidget);
        expect(find.byType(InputSection), findsOneWidget);

        // Landscape mode
        await tester.binding.setSurfaceSize(const Size(812, 375));
        await tester.pumpAndSettle();

        expect(find.text('Testing orientation changes'), findsOneWidget);
        expect(find.byType(InputSection), findsOneWidget);
      });
    });

    group('User Interaction Flow Tests', () {
      testWidgets('should handle complete note addition workflow', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Shift Handover Report')),
              body: const Column(
                children: [
                  Expanded(child: SizedBox()), // Space for notes list
                  InputSection(),
                ],
              ),
            ),
          ),
        );

        final textField = find.byType(TextField);
        final dropdown = find.byType(DropdownButton<NoteType>);
        final addButton = find.text('Add Note');

        // Step 1: Enter note text
        await tester.enterText(textField, 'Patient requires assistance with mobility');
        await tester.pump();

        expect(find.text('Patient requires assistance with mobility'), findsOneWidget);

        // Step 2: Select note type
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text('observation').last);
        await tester.pumpAndSettle();

        // Step 3: Verify button is tappable
        expect(addButton, findsOneWidget);
        await tester.tap(addButton);
        await tester.pump();

        // UI should remain functional after interaction
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(DropdownButton<NoteType>), findsOneWidget);
      });

      testWidgets('should handle rapid input changes', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        final textField = find.byType(TextField);
        final dropdown = find.byType(DropdownButton<NoteType>);

        // Rapidly change text
        for (int i = 0; i < 3; i++) {
          await tester.enterText(textField, 'Quick text change #$i');
          await tester.pump(const Duration(milliseconds: 100));
        }

        expect(find.text('Quick text change #2'), findsOneWidget);

        // Rapidly change dropdown selections
        final noteTypes = ['medication', 'incident', 'task'];
        for (final type in noteTypes) {
          await tester.tap(dropdown);
          await tester.pumpAndSettle();
          await tester.tap(find.text(type).last);
          await tester.pumpAndSettle();
        }

        // Should end up with the last selection
        expect(find.text('task'), findsOneWidget);
      });
    });

    group('Performance and Responsiveness Tests', () {
      testWidgets('should handle large number of notes efficiently', (tester) async {
        final manyNotes = List.generate(
          50,
          (index) => HandoverNote.from(
            HandoverNoteModel(
              id: 'perf-note-$index',
              text: 'Performance test note #$index with some detailed content',
              type: index % 5 == 0 ? 'incident' : 'observation',
              timestamp: DateTime.now().subtract(Duration(minutes: index)).toIso8601String(),
              authorId: 'caregiver-perf',
              taggedResidentIds: index % 3 == 0 ? ['resident-1'] : [],
              isAcknowledged: index % 4 == 0,
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Shift Handover Report')),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: manyNotes.length,
                      itemBuilder: (context, index) => NoteCard(note: manyNotes[index]),
                    ),
                  ),
                  const InputSection(),
                ],
              ),
            ),
          ),
        );

        // Should display the first notes
        expect(find.text('Performance test note #0 with some detailed content'), findsOneWidget);
        expect(find.byType(NoteCard), findsWidgets);

        // Should handle scrolling smoothly
        await tester.drag(find.byType(ListView), const Offset(0, -1000));
        await tester.pumpAndSettle();

        // Should still show note cards
        expect(find.byType(NoteCard), findsWidgets);

        // Input section should remain at bottom
        expect(find.byType(InputSection), findsOneWidget);
      });
    });

    group('Error Boundary and Edge Case Tests', () {
      testWidgets('should handle empty text gracefully', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        final textField = find.byType(TextField);
        final addButton = find.text('Add Note');

        // Try with empty text
        await tester.enterText(textField, '');
        await tester.pump();

        // Button should still be present and tappable
        expect(addButton, findsOneWidget);
        await tester.tap(addButton);
        await tester.pump();

        // UI should remain functional
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('should handle very long text input', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        final longText = 'A' * 500; // Very long text
        final textField = find.byType(TextField);

        await tester.enterText(textField, longText);
        await tester.pump();

        // Should handle long text without crashing
        expect(find.text(longText), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('should handle special characters in text', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        const specialText = 'Special chars: ñáéíóú @#\$%^&*()[]{}|\\:";\'<>?,./';
        final textField = find.byType(TextField);

        await tester.enterText(textField, specialText);
        await tester.pump();

        expect(find.text(specialText), findsOneWidget);
      });
    });

    group('Widget State Management Tests', () {
      testWidgets('should maintain form state during rebuilds', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        final textField = find.byType(TextField);
        await tester.enterText(textField, 'Persistent text');
        await tester.pump();

        expect(find.text('Persistent text'), findsOneWidget);

        // Trigger rebuild with theme change
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(body: const InputSection()),
          ),
        );

        await tester.pump();

        // Text should persist through rebuild
        expect(find.text('Persistent text'), findsOneWidget);
      });
    });
  });
}
