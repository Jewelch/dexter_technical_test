import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color.fromRGBO(32, 70, 155, 1);
  static const Color secondary = Color.fromRGBO(32, 70, 155, .7);
  static const Color accent = Color(0xFFFFB800);

  static const Color greyDark = Color(0xFF405052);
  static const Color greyMedium = Color(0xFF555555);
  static const Color greyRegular = Color(0xFF6D7475);
  static const Color greyLight = Color(0xFFE1E2E5);
  static const Color greyBackground = Color(0xFFF3F5F7);
  static const Color divider = Color(0xFFD9D9D9);
  static const Color inputBorder = Color(0xFF98C4DE);

  static const Color toolTip = Color(0xFFF8F3E6);

  static const Color bottomBarColor = greyBackground;
  static const Color bottomBarDarkColor = Color.fromRGBO(6, 48, 72, 1);

  static const Color scaffold = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  static const Color splashColor = Color(0x1A6DADF0);
  static const Color focusColor = Color(0x1AFC5656);
  static const Color overlayColor = Color(0x0D063048);
  static const Color inactiveColor = Color(0xA7003A76);
  static const Color disabledColor = greyBackground;
  static const Color hint = greyRegular;
  static const Color shadow = greyLight;

  static const Color error = Color(0xFFF20000);
  static const Color warning = Color(0xFFD3A02A);
  static const Color success = Colors.green;
}
