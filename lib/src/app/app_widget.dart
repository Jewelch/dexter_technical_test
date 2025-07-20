import '../base/screens/exports.dart';
import '../features/shift_handover/presentation/screen/shift_handover_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: ShiftHandoverScreen(),
    debugShowMaterialGrid: false,
    theme: AppThemes.light,
  );
}

// class AppWidget extends StatefulWidget {
//   const AppWidget({super.key});

//   @override
//   Widget build(BuildContext context) => MaterialApp.router(
//     debugShowMaterialGrid: false,
//     theme: AppThemes.light,
//     routerConfig: router,
//   );
// }
