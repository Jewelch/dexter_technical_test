import 'package:flutter/widgets.dart' show Key;

extension KeyFromString on Enum {
  Key get key => Key(name);
}

extension KeyExtension on Key {
  String get alphabeticValue =>
      RegExp(r'[a-zA-Z]+').allMatches(toString()).map((match) => match.group(0)).join();
}
