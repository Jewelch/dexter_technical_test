part of '../app_constants.dart';

class _Drawer {
  const _Drawer._();

  final double width = 0;
  final double radius = 10;
}

class _Cards {
  const _Cards._();

  final double elevation = AppConstants.defaultElevation;
  final double radius = 8;
  final double iconSize = 36;
}

class _ListTiles {
  const _ListTiles._();

  final double radius = AppConstants.defaultRadius;
}

class _ProgressIndicators {
  const _ProgressIndicators._();

  final double circularStrokeWidth = 2;
  final double linearMinHeight = 4;
  final double downloadCircularColorSize = 45;
}

class _FilePicking {
  _FilePicking._();

  static const int sizeLimit = 5;
  final int sizeLimitInBytes = sizeLimit * 1024 * 1024;
  final int imageQuality = 60;
  final List<String> extensions = ['jpeg', 'jpg', 'png', 'pdf'];
}
