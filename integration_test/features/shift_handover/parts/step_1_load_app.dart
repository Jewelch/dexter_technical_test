import 'package:flutter_test/flutter_test.dart';

import '../robots/robots.dart';

/// Step 1: Load the app and verify we start with the expected initial state
Future<int> loadAppAndVerifyInitialState(TestRobots robots) async {
  print('🚀 Step 1: App loaded with initial mock note');
  print('   → Checking if shift handover screen is loaded...');
  robots.shiftHandover.assertions.expectScreenLoaded();
  print('   ✅ Screen components found (note input + submit button)');

  print('   → Waiting 2 seconds for UI to stabilize...');
  await robots.app.waitAndPump(duration: const Duration(seconds: 1));
  print('   ✅ UI stabilization complete');

  // Verify we start with 1 mock note
  print('   → Counting initial notes in the list...');
  final initialCount = robots.shiftHandover.assertions.getNotesCount();
  print('   → Found $initialCount notes in the list');
  expect(initialCount, equals(1), reason: 'Should start with 1 mock note');
  print('✅ Step 1 COMPLETE: Found $initialCount initial mock note');

  return initialCount;
}
