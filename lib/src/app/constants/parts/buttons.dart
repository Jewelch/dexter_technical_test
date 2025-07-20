part of '../app_constants.dart';

class _Buttons {
  const _Buttons._();

  final double radius = 50;

  final elevated = const _ElevatedButtons._();
  final text = const _TextButtons._();
  final icon = const _IconButtons._();
  final floating = const _FloatingActionButtons._();
}

class _ElevatedButtons {
  const _ElevatedButtons._();
  static const _applyElevation = false;
  final double elevation = _applyElevation ? AppConstants.defaultElevation : 0;
  final double height = 60;
}

class _TextButtons {
  const _TextButtons._();
  static const _applyElevation = false;
  final double elevation = _applyElevation ? AppConstants.defaultElevation : 0;
  final double height = 60;
}

class _IconButtons {
  const _IconButtons._();
  static const _applyElevation = false;
  final double elevation = _applyElevation ? AppConstants.defaultElevation : 0;
  final double side = 60;
  final double radius = 60 / 2;
}

class _FloatingActionButtons {
  const _FloatingActionButtons._();
  static const _applyElevation = true;
  final double elevation = _applyElevation ? AppConstants.defaultElevation : 0;
  final double height = 45;
  final double iconSize = 28;
  final double radius = 10;
}
