import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/shift_handover/presentation/screen/shift_handover_screen.dart';

final router = GoRouter(
  navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'root'),
  initialLocation: ShiftHandoverScreen.path,
  debugLogDiagnostics: true,
  routes: [GoRoute(path: ShiftHandoverScreen.path, builder: (_, _) => ShiftHandoverScreen())],
);

BuildContext globalContext = router.routerDelegate.navigatorKey.currentContext!;
