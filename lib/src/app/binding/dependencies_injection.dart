import 'package:cg_core_defs/cg_core_defs.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:lean_requester/lean_requester.dart' show Dio;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/dependency/get_it_container.dart';
import '../../core/managers/cache/shared_preferences.dart';
import '../../core/managers/connectivity/connectivity_plus.dart';

//= Use this to inject dependencies
final DependecyInjectionContainer di = GetItContainer();

//= Use this to get dependencies
T get<T extends Object>([_]) => di.get<T>();

final class AppBinding extends AppBindings {
  @override
  Future<void> asynchronous() async {
    WidgetsFlutterBinding.ensureInitialized();

    di.registerLazySingletonAsync(() => SharedPreferences.getInstance());
  }

  @override
  void synchronous() {
    //& Managers
    di.registerLazySingleton<CacheManager>(() => SharedPrefs());

    //& Packages
    di.registerLazySingleton(() => Dio());
    di.registerLazySingleton<ConnectivityMonitor>(() => ConnectivityPlus(Connectivity()));
  }
}
