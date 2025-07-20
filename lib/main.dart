import 'dart:async';

import 'package:cg_core_defs/cg_core_defs.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';

import 'src/app/app_widget.dart';
import 'src/app/binding/dependencies_injection.dart';

part 'error_handling.dart';

void main() => runZonedGuarded(() async {
  await AppBinding().all();

  runApp(const AppWidget());
}, _recordError);
