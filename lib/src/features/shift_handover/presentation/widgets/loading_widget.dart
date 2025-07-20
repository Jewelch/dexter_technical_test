import '../../../../base/screens/exports.dart';

final class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(strokeWidth: 1.5, backgroundColor: AppColors.warning),
  ).squared(30).center();
}
