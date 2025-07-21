import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/app/environment/app_environment.dart';
import 'package:integration_test/integration_test.dart';

import '../parts/parts.dart';
import '../robots/robots.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Shift Handover E2E Tests - Simplified', () {
    setUpAll(() {
      // Set test environment to enable test mode (1 note in mock)
      AppEnvironment.setupEnvironment(Environment.test);
    });

    testWidgets('Simple workflow: load app, add one note, submit report', (tester) async {
      final robots = await TestRobots.forShiftHandover(tester);

      // Step 1: Load app and verify initial state
      final initialCount = await loadAppAndVerifyInitialState(robots);

      // Step 2: Add a note to the list
      await addNoteToList(robots);

      // Step 3: Verify note was added successfully
      await verifyNoteWasAdded(robots, initialCount);

      // Step 4: Submit the final report
      await submitFinalReport(robots);

      print('🎉🎉🎉 WORKFLOW COMPLETED SUCCESSFULLY! 🎉🎉🎉');
      print('   → All 4 steps executed without errors');
      print('   → Note was added and verified in the list');
      print('   → Final report was submitted');
      print('🎯 Test mission accomplished!');
    });
  });
}
