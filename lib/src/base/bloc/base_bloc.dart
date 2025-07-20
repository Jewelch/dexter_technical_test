import 'package:cg_core_defs/helpers/debugging_printer.dart';
import 'package:flutter/widgets.dart'
    show WidgetsBinding, WidgetsBindingObserver, AppLifecycleState, mustCallSuper, protected, immutable;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../base/extensions/function_ext.dart';

@immutable
abstract class BaseBloc<E, S> extends Bloc<E, S> with WidgetsBindingObserver {
  bool debugginEnabled = true;

  bool _isPaused = false;

  BaseBloc(super.initialState) {
    onInit();
  }

  @mustCallSuper
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
    Debugger.yellow.execute(() => "$runtimeType initialized", when: debugginEnabled);
    _observeLifecycle();
  }

  @mustCallSuper
  @protected
  void onReady() {
    Debugger.green.execute(() => "$runtimeType ready", when: debugginEnabled);
  }

  @mustCallSuper
  void onDispose() async {
    _removeLifecycleObserver();
    await close();
    Debugger.red.execute(() => "$runtimeType closed", when: debugginEnabled);
  }

  @protected
  @mustCallSuper
  void onPause() {
    if (_isPaused) return;
    _isPaused = true;
    Debugger.black.execute(() => "$runtimeType paused at $time", when: debugginEnabled);
  }

  @protected
  @mustCallSuper
  void onResume() {
    if (!_isPaused) return;
    _isPaused = false;
    Debugger.white.execute(() => "$runtimeType resumed at $time", when: debugginEnabled);
  }

  @protected
  void _observeLifecycle() => WidgetsBinding.instance.addObserver(this);

  @protected
  void _removeLifecycleObserver() => WidgetsBinding.instance.removeObserver(this);

  @override
  @protected
  void didChangeAppLifecycleState(AppLifecycleState state) => switch (state) {
        AppLifecycleState.resumed => onResume(),
        AppLifecycleState.paused || AppLifecycleState.inactive => onPause(),
        _ => null,
      };

  String get time => DateTime.now().toLocal().toString().split(' ')[1].substring(0, 8);
}
