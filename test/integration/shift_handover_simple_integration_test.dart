import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/features/shift_handover/data/models/handover_note_model.dart';
import 'package:health/src/features/shift_handover/domain/entities/handover_note.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/empty_state_widget.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/error_widget.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/loading_widget.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/note_card.dart';

void main() {
  group('Simplified Shift Handover Integration Tests', () {
    group('Individual Widget Integration Tests', () {
      testWidgets('should display note cards with different types and styles', (tester) async {
        // Create notes of different types
        final notes = [
          HandoverNote.from(
            HandoverNoteModel(
              id: 'note-obs',
              text: 'Patient is comfortable and alert, responded well to treatment',
              type: 'observation',
              timestamp: DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
              authorId: 'caregiver-1',
              taggedResidentIds: [],
              isAcknowledged: false,
            ),
          ),
          HandoverNote.from(
            HandoverNoteModel(
              id: 'note-med',
              text: 'Administered prescribed pain medication as scheduled',
              type: 'medication',
              timestamp: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
              authorId: 'caregiver-1',
              taggedResidentIds: ['resident-1'],
              isAcknowledged: true,
            ),
          ),
          HandoverNote.from(
            HandoverNoteModel(
              id: 'note-inc',
              text: 'Minor spill in room cleaned immediately, no safety concerns',
              type: 'incident',
              timestamp: DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
              authorId: 'caregiver-1',
              taggedResidentIds: [],
              isAcknowledged: false,
            ),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Notes Integration Test')),
              body: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NoteCard(note: notes[index]),
                ),
              ),
            ),
          ),
        );

        // Verify all note contents are displayed
        expect(
          find.text('Patient is comfortable and alert, responded well to treatment'),
          findsOneWidget,
        );
        expect(find.text('Administered prescribed pain medication as scheduled'), findsOneWidget);
        expect(
          find.text('Minor spill in room cleaned immediately, no safety concerns'),
          findsOneWidget,
        );

        // Verify note type labels
        expect(find.text('OBSERVATION'), findsOneWidget);
        expect(find.text('MEDICATION'), findsOneWidget);
        expect(find.text('INCIDENT'), findsOneWidget);

        // Verify different note type icons are present
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
        expect(find.byIcon(Icons.medical_services_outlined), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

        // Verify all cards are displayed
        expect(find.byType(NoteCard), findsNWidgets(3));
      });

      testWidgets('should display loading widget correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Loading Test')),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Loading shift report...'),
                  const SizedBox(height: 20),
                  const LoadingWidget(),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Loading shift report...'), findsOneWidget);
        expect(find.byType(LoadingWidget), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should handle scrolling through multiple notes', (tester) async {
        // Create many notes for scrolling test
        final manyNotes = List.generate(
          15,
          (index) => HandoverNote.from(
            HandoverNoteModel(
              id: 'scroll-note-$index',
              text: 'Scroll test note #$index with content that describes patient care activities',
              type: ['observation', 'medication', 'task'][index % 3],
              timestamp: DateTime.now().subtract(Duration(minutes: index * 10)).toIso8601String(),
              authorId: 'test-caregiver',
              taggedResidentIds: [],
              isAcknowledged: index % 2 == 0,
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Scroll Test')),
              body: ListView.builder(
                itemCount: manyNotes.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: NoteCard(note: manyNotes[index]),
                ),
              ),
            ),
          ),
        );

        // Should show the first notes
        expect(
          find.text('Scroll test note #0 with content that describes patient care activities'),
          findsOneWidget,
        );
        expect(
          find.text('Scroll test note #1 with content that describes patient care activities'),
          findsOneWidget,
        );

        // Scroll down
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();

        // Should still have note cards visible after scrolling
        expect(find.byType(NoteCard), findsWidgets);

        // Scroll back up
        await tester.drag(find.byType(ListView), const Offset(0, 500));
        await tester.pumpAndSettle();

        // Should be able to scroll smoothly
        expect(find.byType(NoteCard), findsWidgets);
      });
    });

    group('Layout Integration Tests', () {
      testWidgets('should handle different screen orientations', (tester) async {
        final testNote = HandoverNote.from(
          HandoverNoteModel(
            id: 'orientation-test',
            text: 'Testing layout behavior across different screen orientations and sizes',
            type: 'observation',
            timestamp: DateTime.now().toIso8601String(),
            authorId: 'test',
            taggedResidentIds: [],
            isAcknowledged: false,
          ),
        );

        // Portrait
        await tester.binding.setSurfaceSize(const Size(375, 812));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Orientation Test')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: NoteCard(note: testNote),
              ),
            ),
          ),
        );

        expect(
          find.text('Testing layout behavior across different screen orientations and sizes'),
          findsOneWidget,
        );
        expect(find.text('OBSERVATION'), findsOneWidget);

        // Landscape
        await tester.binding.setSurfaceSize(const Size(812, 375));
        await tester.pumpAndSettle();

        // Should still display correctly
        expect(
          find.text('Testing layout behavior across different screen orientations and sizes'),
          findsOneWidget,
        );
        expect(find.text('OBSERVATION'), findsOneWidget);
      });

      testWidgets('should adapt to different screen sizes', (tester) async {
        final testNote = HandoverNote.from(
          HandoverNoteModel(
            id: 'screen-size-test',
            text: 'Responsive design test for various screen dimensions',
            type: 'task',
            timestamp: DateTime.now().toIso8601String(),
            authorId: 'test',
            taggedResidentIds: [],
            isAcknowledged: false,
          ),
        );

        final screenSizes = [
          const Size(320, 568), // Small phone
          const Size(375, 812), // iPhone
          const Size(768, 1024), // Tablet portrait
          const Size(1024, 768), // Tablet landscape
        ];

        for (final size in screenSizes) {
          await tester.binding.setSurfaceSize(size);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                appBar: AppBar(title: Text('Size Test ${size.width}x${size.height}')),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NoteCard(note: testNote),
                ),
              ),
            ),
          );

          expect(find.text('Responsive design test for various screen dimensions'), findsOneWidget);
          expect(find.text('TASK'), findsOneWidget);
          expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
        }
      });
    });

    group('State Widget Tests', () {
      testWidgets('should display empty state widget with retry button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Empty State Test')),
              body: const ShiftHandoverEmptyWidget(),
            ),
          ),
        );

        expect(find.text('No shift report found.'), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should display error widget with error message', (tester) async {
        const errorMessage = 'Network connection failed';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Error State Test')),
              body: const ShiftHandoverErrorWidget(errorMessage),
            ),
          ),
        );

        expect(find.text('Failed to load shift report.'), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('Content Stress Tests', () {
      testWidgets('should handle notes with very long text content', (tester) async {
        final longTextNote = HandoverNote.from(
          HandoverNoteModel(
            id: 'long-text',
            text:
                'This is an extremely long note that contains a lot of detailed information about the patient care situation. ' *
                10,
            type: 'observation',
            timestamp: DateTime.now().toIso8601String(),
            authorId: 'test',
            taggedResidentIds: [],
            isAcknowledged: false,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Long Text Test')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: NoteCard(note: longTextNote),
              ),
            ),
          ),
        );

        // Should handle long text without crashing
        expect(find.byType(NoteCard), findsOneWidget);
        expect(find.text('OBSERVATION'), findsOneWidget);
      });

      testWidgets('should handle notes with special characters', (tester) async {
        final specialCharNote = HandoverNote.from(
          HandoverNoteModel(
            id: 'special-chars',
            text: 'Special characters test: ñáéíóú @#\$%^&*()[]{}|\\:";\'<>?,./~`+=_-',
            type: 'incident',
            timestamp: DateTime.now().toIso8601String(),
            authorId: 'test',
            taggedResidentIds: [],
            isAcknowledged: false,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Special Characters Test')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: NoteCard(note: specialCharNote),
              ),
            ),
          ),
        );

        expect(
          find.text('Special characters test: ñáéíóú @#\$%^&*()[]{}|\\:";\'<>?,./~`+=_-'),
          findsOneWidget,
        );
        expect(find.text('INCIDENT'), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('should work with different themes', (tester) async {
        final testNote = HandoverNote.from(
          HandoverNoteModel(
            id: 'theme-test',
            text: 'Testing theme adaptation',
            type: 'medication',
            timestamp: DateTime.now().toIso8601String(),
            authorId: 'test',
            taggedResidentIds: [],
            isAcknowledged: false,
          ),
        );

        // Light theme
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              appBar: AppBar(title: const Text('Light Theme Test')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: NoteCard(note: testNote),
              ),
            ),
          ),
        );

        expect(find.text('Testing theme adaptation'), findsOneWidget);
        expect(find.text('MEDICATION'), findsOneWidget);

        // Dark theme
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              appBar: AppBar(title: const Text('Dark Theme Test')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: NoteCard(note: testNote),
              ),
            ),
          ),
        );

        expect(find.text('Testing theme adaptation'), findsOneWidget);
        expect(find.text('MEDICATION'), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should handle rapid widget rebuilds', (tester) async {
        final testNote = HandoverNote.from(
          HandoverNoteModel(
            id: 'rebuild-test',
            text: 'Widget rebuild performance test',
            type: 'task',
            timestamp: DateTime.now().toIso8601String(),
            authorId: 'test',
            taggedResidentIds: [],
            isAcknowledged: false,
          ),
        );

        // Rapidly rebuild the same widget
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(
            MaterialApp(
              key: ValueKey('rebuild-$i'),
              home: Scaffold(
                appBar: AppBar(title: Text('Rebuild Test #$i')),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NoteCard(note: testNote),
                ),
              ),
            ),
          );

          await tester.pump(const Duration(milliseconds: 50));
        }

        // Should still display correctly after rapid rebuilds
        expect(find.text('Widget rebuild performance test'), findsOneWidget);
        expect(find.text('TASK'), findsOneWidget);
        expect(find.byType(NoteCard), findsOneWidget);
      });
    });
  });
}
