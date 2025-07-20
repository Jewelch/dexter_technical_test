import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/features/shift_handover/data/models/handover_note_model.dart';
import 'package:health/src/features/shift_handover/domain/entities/handover_note.dart';
import 'package:health/src/features/shift_handover/domain/entities/note_type.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/empty_state_widget.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/error_widget.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/input_section.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/loading_widget.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/note_card.dart';

void main() {
  group('Advanced Shift Handover Integration Tests', () {
    group('Advanced Widget State Tests', () {
      testWidgets('should handle complex widget interactions', (tester) async {
        // Create complex test scenario with multiple widgets
        final complexNotes = List.generate(
          10,
          (index) => HandoverNote.from(
            HandoverNoteModel(
              id: 'complex-note-$index',
              text:
                  'Complex test scenario note #$index with varying lengths of content that may wrap across multiple lines to test layout behavior',
              type: ['observation', 'medication', 'incident', 'task', 'supplyRequest'][index % 5],
              timestamp: DateTime.now().subtract(Duration(hours: index)).toIso8601String(),
              authorId: 'caregiver-complex-$index',
              taggedResidentIds: index % 2 == 0 ? ['resident-1', 'resident-2'] : [],
              isAcknowledged: index % 3 == 0,
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Advanced Integration Test'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {}, // Mock refresh action
                  ),
                ],
              ),
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('Shift Report Status: Active'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: complexNotes.length,
                      itemBuilder: (context, index) => NoteCard(note: complexNotes[index]),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: const Text('Add new note below:'),
                  ),
                  const InputSection(),
                ],
              ),
            ),
          ),
        );

        // Verify complex layout renders correctly
        expect(find.byType(NoteCard), findsNWidgets(10));
        expect(find.byType(InputSection), findsOneWidget);
        expect(find.text('Advanced Integration Test'), findsOneWidget);
        expect(find.text('Shift Report Status: Active'), findsOneWidget);

        // Test scrolling through all notes
        await tester.drag(find.byType(ListView), const Offset(0, -2000));
        await tester.pumpAndSettle();

        // Should still find note cards (some may be off-screen)
        expect(find.byType(NoteCard), findsWidgets);

        // Test input interaction while scrolled
        final textField = find.byType(TextField);
        await tester.enterText(textField, 'Note added while scrolled');
        await tester.pump();

        expect(find.text('Note added while scrolled'), findsOneWidget);
      });

      testWidgets('should handle rapid widget state changes', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        final textField = find.byType(TextField);
        final dropdown = find.byType(DropdownButton<NoteType>);

        // Rapidly switch between different states
        for (int cycle = 0; cycle < 3; cycle++) {
          // Enter text
          await tester.enterText(textField, 'Rapid change cycle #$cycle');
          await tester.pump(const Duration(milliseconds: 50));

          // Change dropdown
          await tester.tap(dropdown);
          await tester.pumpAndSettle();

          final types = ['observation', 'medication', 'incident'];
          await tester.tap(find.text(types[cycle % 3]).last);
          await tester.pumpAndSettle();

          // Clear text
          await tester.enterText(textField, '');
          await tester.pump(const Duration(milliseconds: 50));
        }

        // Should end up in a stable state
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(DropdownButton<NoteType>), findsOneWidget);
      });
    });

    group('Layout Stress Tests', () {
      testWidgets('should handle extreme content lengths', (tester) async {
        // Create notes with extreme content variations
        final extremeNotes = [
          // Very short note
          HandoverNote.from(
            HandoverNoteModel(
              id: 'short',
              text: 'OK',
              type: 'observation',
              timestamp: DateTime.now().toIso8601String(),
              authorId: 'test',
              taggedResidentIds: [],
              isAcknowledged: false,
            ),
          ),
          // Very long note
          HandoverNote.from(
            HandoverNoteModel(
              id: 'long',
              text:
                  'This is an extremely long note that contains a lot of detailed information about the patient\'s condition, treatment procedures, medication administration, vital signs monitoring, behavioral observations, family interactions, dietary requirements, mobility assessments, pain management strategies, and various other clinical observations that need to be documented comprehensively for proper continuity of care during shift handover processes. ' *
                  3,
              type: 'observation',
              timestamp: DateTime.now().toIso8601String(),
              authorId: 'test',
              taggedResidentIds: [],
              isAcknowledged: false,
            ),
          ),
          // Note with special formatting
          HandoverNote.from(
            HandoverNoteModel(
              id: 'special',
              text:
                  'Note with\nmultiple\nlines\nand\tspecial\tcharacters: !@#\$%^&*()[]{}|\\:";\'<>?,./~`+=_-',
              type: 'incident',
              timestamp: DateTime.now().toIso8601String(),
              authorId: 'test',
              taggedResidentIds: [],
              isAcknowledged: false,
            ),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: extremeNotes.length,
                itemBuilder: (context, index) => NoteCard(note: extremeNotes[index]),
              ),
            ),
          ),
        );

        // All notes should render without crashing
        expect(find.text('OK'), findsOneWidget);
        expect(find.textContaining('This is an extremely long note'), findsOneWidget);
        expect(find.textContaining('Note with'), findsOneWidget);
        expect(find.byType(NoteCard), findsNWidgets(3));
      });

      testWidgets('should adapt to extreme screen sizes', (tester) async {
        final testNote = HandoverNote.from(
          HandoverNoteModel(
            id: 'adaptive',
            text: 'Testing adaptive layout behavior across different screen configurations',
            type: 'observation',
            timestamp: DateTime.now().toIso8601String(),
            authorId: 'test',
            taggedResidentIds: [],
            isAcknowledged: false,
          ),
        );

        // Very narrow screen (like a smartwatch)
        await tester.binding.setSurfaceSize(const Size(150, 300));

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
          find.text('Testing adaptive layout behavior across different screen configurations'),
          findsOneWidget,
        );

        // Very wide screen (like an ultrawide monitor)
        await tester.binding.setSurfaceSize(const Size(2000, 600));
        await tester.pumpAndSettle();

        expect(
          find.text('Testing adaptive layout behavior across different screen configurations'),
          findsOneWidget,
        );
        expect(find.byType(InputSection), findsOneWidget);

        // Square screen
        await tester.binding.setSurfaceSize(const Size(500, 500));
        await tester.pumpAndSettle();

        expect(find.byType(NoteCard), findsOneWidget);
        expect(find.byType(InputSection), findsOneWidget);
      });
    });

    group('Error Boundary Widget Tests', () {
      testWidgets('should display error widget correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: ShiftHandoverErrorWidget('Network connection failed'))),
        );

        expect(find.text('Network connection failed'), findsOneWidget);
        expect(find.byType(ShiftHandoverErrorWidget), findsOneWidget);
      });

      testWidgets('should display empty state widget correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: const ShiftHandoverEmptyWidget())),
        );

        expect(find.text('No shift report found.'), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
        expect(find.byType(ShiftHandoverEmptyWidget), findsOneWidget);
      });

      testWidgets('should display loading widget correctly', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const LoadingWidget())));

        expect(find.byType(LoadingWidget), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Accessibility Advanced Tests', () {
      testWidgets('should support semantic navigation', (tester) async {
        final accessibilityNotes = List.generate(
          3,
          (index) => HandoverNote.from(
            HandoverNoteModel(
              id: 'a11y-note-$index',
              text: 'Accessibility test note number $index',
              type: ['observation', 'medication', 'incident'][index],
              timestamp: DateTime.now().toIso8601String(),
              authorId: 'test',
              taggedResidentIds: [],
              isAcknowledged: false,
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Accessibility Test')),
              body: Column(
                children: [
                  ...accessibilityNotes.map((note) => NoteCard(note: note)),
                  const InputSection(),
                ],
              ),
            ),
          ),
        );

        // Verify semantic structure
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(NoteCard), findsNWidgets(3));
        expect(find.byType(InputSection), findsOneWidget);

        // Verify interactive elements are present
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(DropdownButton<NoteType>), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should handle focus management', (tester) async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: const InputSection())));

        final textField = find.byType(TextField);
        final dropdown = find.byType(DropdownButton<NoteType>);
        final button = find.byType(ElevatedButton);

        // Test focus transitions
        await tester.tap(textField);
        await tester.pump();

        await tester.tap(dropdown);
        await tester.pumpAndSettle();

        await tester.tap(find.text('observation').last);
        await tester.pumpAndSettle();

        await tester.tap(button);
        await tester.pump();

        // All elements should remain accessible
        expect(textField, findsOneWidget);
        expect(dropdown, findsOneWidget);
        expect(button, findsOneWidget);
      });
    });

    group('Performance Edge Cases', () {
      testWidgets('should handle memory-intensive scenarios', (tester) async {
        // Create a large number of notes to test memory handling
        final memoryTestNotes = List.generate(
          100,
          (index) => HandoverNote.from(
            HandoverNoteModel(
              id: 'memory-note-$index',
              text: 'Memory stress test note #$index ' * 10, // Repeated content
              type: ['observation', 'medication', 'incident', 'task', 'supplyRequest'][index % 5],
              timestamp: DateTime.now().subtract(Duration(seconds: index)).toIso8601String(),
              authorId: 'memory-tester',
              taggedResidentIds: List.generate(index % 5, (i) => 'resident-$i'),
              isAcknowledged: index % 7 == 0,
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: memoryTestNotes.length,
                itemBuilder: (context, index) => NoteCard(note: memoryTestNotes[index]),
              ),
            ),
          ),
        );

        // Should handle large dataset without issues
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(NoteCard), findsWidgets);

        // Test scrolling through large dataset
        for (int scroll = 0; scroll < 5; scroll++) {
          await tester.drag(find.byType(ListView), const Offset(0, -500));
          await tester.pump(const Duration(milliseconds: 100));
        }

        // Should still be responsive
        expect(find.byType(NoteCard), findsWidgets);
      });

      testWidgets('should handle rapid widget creation and disposal', (tester) async {
        // Test rapid widget lifecycle changes
        for (int cycle = 0; cycle < 5; cycle++) {
          final cycleNote = HandoverNote.from(
            HandoverNoteModel(
              id: 'cycle-note-$cycle',
              text: 'Rapid lifecycle test note #$cycle',
              type: 'observation',
              timestamp: DateTime.now().toIso8601String(),
              authorId: 'test',
              taggedResidentIds: [],
              isAcknowledged: false,
            ),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: NoteCard(note: cycleNote)),
            ),
          );

          expect(find.text('Rapid lifecycle test note #$cycle'), findsOneWidget);

          // Clear the widget
          await tester.pumpWidget(Container());
        }

        // Should handle rapid creation/disposal without memory leaks
        expect(find.byType(Container), findsOneWidget);
      });
    });

    group('Complex Integration Scenarios', () {
      testWidgets('should handle mixed widget state scenarios', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              appBar: AppBar(title: const Text('Mixed State Test')),
              body: Column(
                children: [
                  const LoadingWidget(),
                  const Divider(),
                  NoteCard(
                    note: HandoverNote.from(
                      HandoverNoteModel(
                        id: 'mixed-note',
                        text: 'Note in mixed widget state',
                        type: 'observation',
                        timestamp: DateTime.now().toIso8601String(),
                        authorId: 'test',
                        taggedResidentIds: [],
                        isAcknowledged: false,
                      ),
                    ),
                  ),
                  const Divider(),
                  const InputSection(),
                ],
              ),
            ),
          ),
        );

        // All widgets should coexist
        expect(find.byType(LoadingWidget), findsOneWidget);
        expect(find.byType(NoteCard), findsOneWidget);
        expect(find.byType(InputSection), findsOneWidget);
        expect(find.text('Note in mixed widget state'), findsOneWidget);

        // Switch theme to test theme changes
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              appBar: AppBar(title: const Text('Mixed State Test')),
              body: Column(
                children: [
                  const LoadingWidget(),
                  const Divider(),
                  NoteCard(
                    note: HandoverNote.from(
                      HandoverNoteModel(
                        id: 'mixed-note',
                        text: 'Note in mixed widget state',
                        type: 'observation',
                        timestamp: DateTime.now().toIso8601String(),
                        authorId: 'test',
                        taggedResidentIds: [],
                        isAcknowledged: false,
                      ),
                    ),
                  ),
                  const Divider(),
                  const InputSection(),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Widgets should adapt to theme changes
        expect(find.byType(LoadingWidget), findsOneWidget);
        expect(find.byType(NoteCard), findsOneWidget);
        expect(find.byType(InputSection), findsOneWidget);
      });
    });
  });
}
