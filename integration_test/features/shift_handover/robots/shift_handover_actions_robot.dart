import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/base/extensions/enum_key_ext.dart';
import 'package:health/src/features/shift_handover/presentation/widgets/input_section.dart';

import '../../../base/base_robot.dart';

/// Simple robot for all shift handover actions (notes + reports)
class ShiftHandoverActionsRobot extends BaseRobot {
  ShiftHandoverActionsRobot({required super.tester});

  // ========================================
  // NOTE ACTIONS
  // ========================================

  /// Type text in the note input field
  Future<void> enterNoteText(String noteText) async {
    await enterText(findByKey(InputSectionKeys.noteInput.key), noteText);
  }

  /// Select note type from dropdown (opens only once)
  Future<void> selectNoteType(String noteType) async {
    // Check if dropdown is already open, if not, open it
    final noteTypeText = noteType.toUpperCase();
    final dropdownItem = find.text(noteTypeText);

    if (dropdownItem.evaluate().isEmpty) {
      // Dropdown is not open, tap to open it
      await tap(findByKey(InputSectionKeys.noteTypeDropdown.key));
      await waitAndPump(duration: const Duration(milliseconds: 300));
    }

    // Find and tap the note type text (displayed in uppercase in the dropdown)
    final dropdownItemAfterOpen = find.text(noteTypeText);

    if (dropdownItemAfterOpen.evaluate().isNotEmpty) {
      await tap(dropdownItemAfterOpen);
      await waitAndPump(duration: const Duration(milliseconds: 500));
    } else {
      // Fallback: close dropdown if item not found
      await tap(find.byType(Scaffold).first);
      throw Exception('Could not find dropdown item with text: $noteTypeText');
    }
  }

  /// Submit note using keyboard action button (onSubmitted)
  Future<void> submitNote() async {
    // First ensure the text field is focused
    final noteInputField = findByKey(InputSectionKeys.noteInput.key);
    await tester.tap(noteInputField);
    await waitAndPump(duration: const Duration(milliseconds: 300));

    // Now trigger the onSubmitted callback by simulating the done action
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await waitAndPump(duration: const Duration(seconds: 1));
  }

  /// Add a complete note (text + type + submit)
  Future<void> addNote(String noteText, {String noteType = 'OBSERVATION'}) async {
    await enterNoteText(noteText);
    if (noteType != 'OBSERVATION') {
      await selectNoteType(noteType);
    }
    await submitNote();
  }

  // ========================================
  // REPORT ACTIONS
  // ========================================

  /// Tap the submit button to open dialog
  Future<void> tapSubmitButton() async =>
      await tapWithScroll(findByKey(InputSectionKeys.submitButton.key), warnIfMissed: false);

  /// Enter summary text in the submit dialog
  Future<void> enterSummaryInDialog(String summary) async =>
      await enterText(findByKey(InputSectionKeys.submitAlertDialogSummaryInput.key), summary);

  /// Confirm submission in the dialog (target ElevatedButton specifically)
  Future<void> confirmSubmissionInDialog() async =>
      await tap(findByKey(InputSectionKeys.submitAlertDialogSubmitButton.key));

  /// Cancel the submit dialog
  Future<void> cancelSubmitDialog() async =>
      await tap(findByKey(InputSectionKeys.submitAlertDialogCancelButton.key));

  /// Submit complete report with summary
  Future<void> submitReport(String summary) async {
    await tapSubmitButton();
    await waitAndPump(duration: const Duration(seconds: 1));

    if (hasWidget(findByKey(InputSectionKeys.submitAlertDialog.key))) {
      await enterSummaryInDialog(summary);
      await confirmSubmissionInDialog();
    }
  }
}
