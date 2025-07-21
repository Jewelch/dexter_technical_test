import '../base/screens/exports.dart';
import '../core/router/app_router.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowMaterialGrid: false,
    theme: AppThemes.light,
    routerConfig: router,
  );
}
