import 'dart:async';

import 'package:cg_core_defs/cg_core_defs.dart';
import 'package:get_it/get_it.dart';

class GetItContainer extends DependecyInjectionContainer {
  @override
  GetIt get actor => GetIt.instance;

  //* Instance
  @override
  void registerInstance<T extends Object>(T instance, {String? name}) {
    if (isRegistered<T>(name: name)) return;
    actor.registerSingleton(instance, instanceName: name);
  }

  @override
  void registerInstanceAsync<T extends Object>(Future<T> Function() factoryFunc, {String? name}) {
    if (isRegistered<T>(name: name)) return;
    actor.registerSingletonAsync(() => factoryFunc.call(), instanceName: name);
  }

  //? Factory
  @override
  void registerFactory<T extends Object>(T Function() factoryFunc, {String? name}) {
    if (isRegistered<T>(name: name)) return;
    actor.registerFactory(() => factoryFunc(), instanceName: name);
  }

  @override
  void registerFactoryAsync<T extends Object>(Future<T> Function() factoryFunc, {String? name}) {
    if (GetIt.instance.isRegistered<T>()) return;
    GetIt.instance.registerFactoryAsync(() => factoryFunc.call(), instanceName: name);
  }

  //= Singleton
  @override
  void registerSingleton<T extends Object>(
    T instance, {
    String? name,
    bool? signalsReady,
    FutureOr<dynamic> Function(T)? dispose,
  }) {
    if (isRegistered<T>(name: name)) return;
    actor.registerSingleton(
      instance,
      instanceName: name,
      signalsReady: signalsReady,
      dispose: dispose,
    );
  }

  @override
  void registerSingletonAsync<T extends Object>(
    Future<T> Function() factoryFunc, {
    String? name,
    Iterable<Type>? dependsOn,
    bool? signalsReady,
    FutureOr<dynamic> Function(T)? dispose,
  }) {
    if (isRegistered<T>(name: name)) return;
    actor.registerSingletonAsync(
      () => factoryFunc(),
      instanceName: name,
      dependsOn: dependsOn,
      signalsReady: signalsReady,
      dispose: dispose,
    );
  }

  //= Lazy Singleton
  @override
  void registerLazySingleton<T extends Object>(
    T Function() factoryFunc, {
    String? name,
    FutureOr<dynamic> Function(T)? dispose,
  }) {
    if (isRegistered<T>(name: name)) return;
    actor.registerLazySingleton(() => factoryFunc(), instanceName: name, dispose: dispose);
  }

  @override
  void registerLazySingletonAsync<T extends Object>(
    Future<T> Function() factoryFunc, {
    String? instanceName,
    FutureOr Function(T param)? dispose,
  }) {
    if (actor.isRegistered<T>()) return;
    GetIt.instance.registerLazySingletonAsync(
      () => factoryFunc.call(),
      instanceName: instanceName,
      dispose: dispose,
    );
  }

  @override
  T get<T extends Object>() => actor.get<T>();

  @override
  T getNamed<T extends Object>(String name) => actor<T>(instanceName: name);

  @override
  bool isRegistered<T extends Object>({String? name}) => actor.isRegistered<T>(instanceName: name);

  @override
  void unregister<T extends Object>({String? name}) {
    if (isRegistered<T>(name: name)) actor.unregister<T>(instanceName: name);
  }

  @override
  void clear() => actor.reset();
}
