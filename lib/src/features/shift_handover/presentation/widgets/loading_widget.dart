import '../../../../base/screens/exports.dart';

@visibleForTesting
enum LoadingWidgetKeys { loadingIndicator }

final class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(
      key: LoadingWidgetKeys.loadingIndicator.key,
      strokeWidth: 1.5,
      backgroundColor: AppColors.warning,
    ),
  ).squared(30).center();
}
