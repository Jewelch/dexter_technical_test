import 'package:cg_core_defs/cg_core_defs.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityPlus extends ConnectivityMonitor {
  final Connectivity _connectivity;

  ConnectivityPlus(this._connectivity);

  @visibleForTesting
  ConnectivityPlus.mock(this._connectivity);

  @override
  void startMonitoring() {
    super.startMonitoring();
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      isConnectedObs.value = !connectivityResult.contains(ConnectivityResult.none);
    });
  }
}
