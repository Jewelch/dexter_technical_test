import 'package:flutter/services.dart';
import 'package:health/src/base/extensions/enum_key_ext.dart';

import '../../test/tools/exports.dart';

/// Base class for all test robots providing common functionality
abstract class BaseRobot {
  final WidgetTester tester;

  BaseRobot({required this.tester});

  // Common finder methods
  Finder findByKey(Key key) => find.byKey(Key(key.alphabeticValue));

  Finder findByText(String text) => find.text(text);

  Finder findByType<T extends Widget>() => find.byType(T);

  // Common waiting methods
  Future<void> waitForAppToLoad({Duration? duration}) async {
    await tester.pumpAndSettle(duration ?? const Duration(seconds: 2));
  }

  Future<void> waitAndPump({Duration? duration}) async {
    await tester.pumpAndSettle(duration ?? const Duration(milliseconds: 500));
  }

  // Common input methods
  Future<void> enterText(Finder finder, String text) async {
    await tester.enterText(finder, text);
    await waitAndPump();
  }

  Future<void> submitTextWithKeyboard() async {
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await waitAndPump();
  }

  // Common tap methods
  Future<void> tap(Finder finder, {bool warnIfMissed = false}) async {
    await tester.tap(finder, warnIfMissed: warnIfMissed);
    await waitAndPump();
  }

  Future<void> tapWithScroll(Finder finder, {bool warnIfMissed = false}) async {
    try {
      await tester.ensureVisible(finder);
      await waitAndPump();
      await tester.tap(finder, warnIfMissed: warnIfMissed);
      await waitAndPump();
    } catch (e) {
      // Fallback: scroll down and try again
      await tester.drag(find.byType(Scaffold), const Offset(0, -200));
      await waitAndPump();
      await tester.tap(finder, warnIfMissed: warnIfMissed);
      await waitAndPump();
    }
  }

  // Common verification methods
  void expectWidgetExists(Finder finder) {
    expect(finder, findsOneWidget);
  }

  void expectWidgetNotExists(Finder finder) {
    expect(finder, findsNothing);
  }

  void expectTextExists(String text, {int? count}) {
    if (count != null) {
      expect(find.text(text), findsNWidgets(count));
    } else {
      expect(find.text(text), findsAtLeastNWidgets(1));
    }
  }

  void expectWidgetCount(Finder finder, int count) {
    expect(finder, findsNWidgets(count));
  }

  // Helper methods
  bool hasWidget(Finder finder) {
    return finder.evaluate().isNotEmpty;
  }

  int getWidgetCount(Finder finder) {
    return finder.evaluate().length;
  }

  // Common dialog methods
  Future<void> waitForDialog() async {
    await tester.pumpAndSettle(const Duration(seconds: 1));
  }

  Future<void> dismissDialog() async {
    await tester.tap(find.byType(Scaffold).first);
    await waitAndPump();
  }
}
