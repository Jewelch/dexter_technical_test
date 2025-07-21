import 'environments.dart';

export 'environments.dart';

abstract final class AppEnvironment {
  static Environment current = Environment.dev;

  static void setupEnvironment(Environment environment) => current = environment;

  static bool get mocking => current == Environment.mock;
  static bool get developping => current == Environment.dev;
  static bool get testing => current == Environment.test;
}
