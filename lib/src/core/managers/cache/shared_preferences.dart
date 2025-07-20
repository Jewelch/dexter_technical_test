import 'package:cg_core_defs/cg_core_defs.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/binding/dependencies_injection.dart';

@immutable
class SharedPrefs implements CacheManager<SharedPreferences> {
  @override
  SharedPreferences get actor => get<SharedPreferences>();

  @override
  String? getString(String key) => actor.getString(key);

  @override
  Future<bool> setString(String key, String value) => actor.setString(key, value);

  @override
  int? getInt(String key) => actor.getInt(key);

  @override
  Future<bool> setInt(String key, int value) => actor.setInt(key, value);

  @override
  bool? getBool(String key) => actor.getBool(key);

  @override
  Future<bool> setBool(String key, bool value) => actor.setBool(key, value);

  @override
  double? getDouble(String key) => actor.getDouble(key);

  @override
  Future<bool> setDouble(String key, double value) => actor.setDouble(key, value);

  @override
  List<String>? getStringList(String key) => actor.getStringList(key);

  @override
  Future<bool> setStringList(String key, List<String> value) => actor.setStringList(key, value);

  @override
  Future<bool> remove(String key) => actor.remove(key);

  @override
  Future<bool> clear() => actor.clear();

  @override
  bool containsKey(String key) => actor.containsKey(key);

  @override
  Set<String> getKeys() => actor.getKeys();
}
