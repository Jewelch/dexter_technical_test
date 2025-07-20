import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/shift_handover/presentation/screen/shift_handover_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
BuildContext globalContext = _rootNavigatorKey.currentContext!;

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: ShiftHandoverScreen.path,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: ShiftHandoverScreen.path, builder: (context, state) => ShiftHandoverScreen()),
  ],
);
