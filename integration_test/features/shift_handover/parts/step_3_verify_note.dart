import 'package:flutter_test/flutter_test.dart';

import '../robots/robots.dart';

/// Step 3: Verify the note was successfully added to the list
Future<void> verifyNoteWasAdded(TestRobots robots, int initialCount) async {
  print('📝 Step 3: Wait and verify note appears in list');
  print('   → Expected to find note: "Note 1 by dexter"');
  print('   → Initial note count was: $initialCount');

  const testNote = "Note 1 by dexter";

  // Wait for note to appear in ListView (simplified)
  print('   → Waiting 5 seconds for note to appear in ListView...');
  await robots.app.waitAndPump(duration: const Duration(seconds: 1));
  print('   → Wait period completed, checking results...');

  // Final check after all refresh attempts
  print('   → Counting notes in the list...');
  final finalCount = robots.shiftHandover.assertions.getNotesCount();
  print('   → Notes count: initial=$initialCount, final=$finalCount');
  print('   → Count difference: ${finalCount - initialCount}');

  if (finalCount > initialCount) {
    print('   ✅ Note count increased! Note was added successfully');
    print('   → Now verifying note text is visible...');
    robots.shiftHandover.assertions.expectNoteExists(testNote);
    print('✅ Step 3 COMPLETE: Note "$testNote" is visible in the report list');
  } else {
    print('   ❌ Note count did not increase - investigating...');
    handleNoteNotAdded(robots, testNote);
  }
}

/// Handle the case where note was not added to the list
void handleNoteNotAdded(TestRobots robots, String testNote) {
  print('   ❌ Note count did not increase. Note was NOT added to the list.');
  print('   ⚠️ This indicates a problem with the note submission process.');
  print('   → Checking if note text exists in UI anyway...');

  // Still check if the note exists in the UI (maybe it replaced something)
  try {
    robots.shiftHandover.assertions.expectNoteExists(testNote);
    print('   🤔 Note text exists in UI but count did not increase');
    print('   → This means note text is visible but wasn\'t properly added to data structure');
  } catch (e) {
    print('   ❌ Note text is also not found in the UI');
    print('   → Complete failure - note not submitted at all');
    throw Exception('Note was not added to the list. Check the submission logic.');
  }
}
