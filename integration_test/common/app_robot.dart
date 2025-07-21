import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/src/app/app_widget.dart';
import 'package:health/src/app/binding/dependencies_injection.dart';

import '../base/base_robot.dart';

class AppRobot extends BaseRobot {
  AppRobot({required super.tester});

  // App initialization
  Future<void> startApp() async {
    await _initializeDependencies();
    await _launchApp();
    await waitForAppToLoad();
  }

  Future<void> restartApp() async {
    await _launchApp();
    await waitForAppToLoad();
  }

  // Private helper methods
  Future<void> _initializeDependencies() async => await AppBinding().all();

  Future<void> _launchApp() async {
    await tester.pumpWidget(const AppWidget());
    await waitAndPump(duration: const Duration(seconds: 2));
  }

  // Navigation helpers
  Future<void> navigateBack() async => await tap(find.byTooltip('Back'));

  // Common app state verifications
  void expectAppLoaded() => expectWidgetExists(find.byType(AppWidget));

  void expectLoadingIndicator() => expectWidgetExists(find.byType(CircularProgressIndicator));

  void expectNoLoadingIndicator() => expectWidgetNotExists(find.byType(CircularProgressIndicator));

  // Scroll helpers
  Future<void> scrollDown({double distance = 300.0}) async {
    await tester.drag(find.byType(Scaffold), Offset(0, -distance));
    await waitAndPump();
  }

  Future<void> scrollUp({double distance = 300.0}) async {
    await tester.drag(find.byType(Scaffold), Offset(0, distance));
    await waitAndPump();
  }

  Future<void> scrollToTop() async {
    await scrollUp(distance: 1000.0);
  }

  Future<void> scrollToBottom() async {
    await scrollDown(distance: 1000.0);
  }

  // Snackbar helpers
  void expectSnackBarWithText(String text) {
    expectWidgetExists(find.byType(SnackBar));
    expectTextExists(text);
  }

  Future<void> dismissSnackBar() async {
    if (hasWidget(find.byType(SnackBar))) {
      await tap(find.byType(SnackBar));
    }
  }
}
