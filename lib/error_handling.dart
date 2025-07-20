part of 'main.dart';

void _recordError(Object e, StackTrace s) {
  if (kReleaseMode) return;
  Debugger.red('Error: $e');
  Debugger.red('StackTrace: $s');
}
