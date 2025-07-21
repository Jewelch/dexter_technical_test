import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/base/extensions/enum_key_ext.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/input_section.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/note_card.dart';

import '../../../base/base_robot.dart';

/// Simple robot for shift handover assertions and verifications
class ShiftHandoverAssertionsRobot extends BaseRobot {
  ShiftHandoverAssertionsRobot({required super.tester});

  // ========================================
  // BASIC ASSERTIONS
  // ========================================

  /// Verify the shift handover screen is loaded
  void expectScreenLoaded() {
    expectWidgetExists(findByKey(InputSectionKeys.noteInput.key));
    expectWidgetExists(findByKey(InputSectionKeys.submitButton.key));
  }

  /// Get the current number of notes displayed
  int getNotesCount() => getWidgetCount(findByType<NoteCard>());

  /// Verify expected number of notes
  void expectNotesCount(int expectedCount) {
    final actualCount = getNotesCount();
    expect(
      actualCount,
      equals(expectedCount),
      reason: 'Expected $expectedCount notes, but found $actualCount',
    );
  }

  /// Verify a specific note exists
  void expectNoteExists(String noteText) => expectTextExists(noteText);

  /// Verify submit dialog is open
  void expectSubmitDialogIsOpen() =>
      expectWidgetExists(findByKey(InputSectionKeys.submitAlertDialog.key));

  /// Verify submit dialog is closed
  void expectSubmitDialogIsClosed() =>
      expectWidgetNotExists(findByKey(InputSectionKeys.submitAlertDialog.key));

  /// Check if submit dialog is currently open
  bool hasSubmitDialog() => hasWidget(findByKey(InputSectionKeys.submitAlertDialog.key));
}
