// Base robot for common functionality
// Test utilities for robot initialization
import 'package:flutter_test/flutter_test.dart';

import '../../../common/app_robot.dart';
import 'shift_handover_robot.dart';

export '../../../base/base_robot.dart';
export '../../../common/app_robot.dart';
export 'shift_handover_actions_robot.dart';
export 'shift_handover_assertions_robot.dart';
export 'shift_handover_robot.dart';

/// Simplified robot factory for easy test setup
class TestRobots {
  final WidgetTester tester;

  TestRobots({required this.tester});

  // Lazy-loaded robots
  AppRobot? _appRobot;
  ShiftHandoverRobot? _shiftHandoverRobot;

  /// Access to general app operations
  AppRobot get app => _appRobot ??= AppRobot(tester: tester);

  /// Access to shift handover operations (simplified)
  ShiftHandoverRobot get shiftHandover =>
      _shiftHandoverRobot ??= ShiftHandoverRobot(tester: tester);

  /// Initialize the app and return robots for testing
  static Future<TestRobots> initialize(WidgetTester tester) async {
    final robots = TestRobots(tester: tester);
    await robots.app.startApp();
    return robots;
  }

  /// Quick setup for shift handover tests
  static Future<TestRobots> forShiftHandover(WidgetTester tester) async {
    final robots = await initialize(tester);
    await robots.app.waitForAppToLoad();
    return robots;
  }
}
