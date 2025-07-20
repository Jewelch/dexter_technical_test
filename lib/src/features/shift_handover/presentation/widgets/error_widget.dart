import '../../../../base/screens/exports.dart';
import '../bloc/shift_handover_bloc.dart';
import '../bloc/shift_handover_events.dart';

final class ShiftHandoverErrorWidget extends StatelessWidget {
  const ShiftHandoverErrorWidget(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Failed to load shift report.', style: AppStyles.title),
      const VerticalSpacing(16),
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
        icon: const Icon(Icons.refresh, size: 30),
        label: Text('Try Again', style: AppStyles.title),
        onPressed: () => context.read<ShiftHandoverBloc>().add(GetShiftReport('current-user-id')),
      ),
    ],
  ).symmetricPadding(horizontal: AppConstants.scaffold.horizontalBodyPadding);
}
