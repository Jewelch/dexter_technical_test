part of '../app_constants.dart';

class _Inputs {
  const _Inputs._();

  final AutovalidateMode inputsAutovalidationMode = AutovalidateMode.disabled;
  static const _applyElevation = false;
  final double elevation = _applyElevation ? AppConstants.defaultElevation : 0;
  final double radius = 12;
  final double height = 56;
  final double horizontalContentPadding = 24;
  final double verticalContentPadding = 15;
  final double borderWidth = 1.5;
  final int passwordInputMaxLength = 12;
  final int maxLength = 50;
  final prefixIconConstraints = const BoxConstraints(
    minWidth: 60,
    maxWidth: 60,
    minHeight: 56,
    maxHeight: 56,
  );
  final suffixIconConstraints = const BoxConstraints(
    minWidth: 60,
    maxWidth: 60,
    minHeight: 56,
    maxHeight: 56,
  );
}
