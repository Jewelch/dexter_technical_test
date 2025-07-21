import '../robots/robots.dart';

/// Step 4: Submit the final report with summary
Future<void> submitFinalReport(TestRobots robots) async {
  print('📤 Step 4: Submit the report');
  print('   → Summary text: "Test summary by dexter"');

  const summaryText = "Test summary by dexter";

  print('   → Tapping submit button to open dialog...');
  print('   → Entering summary text in dialog...');
  print('   → Confirming submission...');
  await robots.shiftHandover.actions.submitReport(summaryText);

  print('   → Waiting 1 second for final processing...');
  await robots.app.waitAndPump(duration: const Duration(seconds: 1));

  print('✅ Step 4 COMPLETE: Report submitted successfully');
}
