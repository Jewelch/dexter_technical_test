import '../../../base/base_robot.dart';
import 'shift_handover_actions_robot.dart';
import 'shift_handover_assertions_robot.dart';

/// Simplified shift handover robot with actions and assertions
class ShiftHandoverRobot extends BaseRobot {
  ShiftHandoverRobot({required super.tester});

  // Lazy-loaded specialized robots
  ShiftHandoverActionsRobot? _actionsRobot;
  ShiftHandoverAssertionsRobot? _assertionsRobot;

  /// Access to all actions (notes + reports)
  ShiftHandoverActionsRobot get actions =>
      _actionsRobot ??= ShiftHandoverActionsRobot(tester: tester);

  /// Access to all assertions (verifications)
  ShiftHandoverAssertionsRobot get assertions =>
      _assertionsRobot ??= ShiftHandoverAssertionsRobot(tester: tester);
}
