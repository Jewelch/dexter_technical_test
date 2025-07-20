import 'environments.dart';

abstract final class AppEnvironment {
  static Environment current = Environment.dev;
  static bool get mocking => current == Environment.mock;
  static bool get developping => current == Environment.dev;

  static const (String, String) testAccount = ("xx@yy.com", "xxxxxx");

  static void setupEnvironment(Environment environment) => current = environment;
}
