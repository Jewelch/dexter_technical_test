import '../../../../base/screens/exports.dart';
import '../bloc/shift_handover_bloc.dart';
import '../bloc/shift_handover_events.dart';

final class ShiftHandoverEmptyWidget extends StatelessWidget {
  const ShiftHandoverEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'No shift report found.',
        style: AppStyles.headline3.bold().withColor(AppColors.greyDark),
      ),
      const VerticalSpacing(16),
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
        icon: const Icon(Icons.refresh, size: 30),
        label: Text('Try Again', style: AppStyles.title),
        onPressed: () => context.read<ShiftHandoverBloc>().add(GetShiftReport('current-user-id')),
      ),
    ],
  ).symmetricPadding(horizontal: AppConstants.scaffold.horizontalBodyPadding);
}
