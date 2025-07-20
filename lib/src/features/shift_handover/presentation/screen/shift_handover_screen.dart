import '../../../../base/screens/exports.dart';
import '../../binding/shift_handover_deps.dart';
import '../bloc/shift_handover_bloc.dart';
import '../bloc/shift_handover_states.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/report_view_widget.dart';
import '../widgets/shift_handover_app_bar.dart';

final class ShiftHandoverScreen extends BlocProviderWidget<ShiftHandoverBloc> {
  ShiftHandoverScreen({super.key}) : super(dependencies: ShiftHandoverDependencies());

  static final path = "/shift-handover";

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const ShiftHandoverAppBar(),
    body: BlocBuilder<ShiftHandoverBloc, ShiftHandoverState>(
      builder: (context, state) => switch (state) {
        Loading() => const LoadingWidget(),
        Error() => ShiftHandoverErrorWidget(state.message),
        Empty() => const ShiftHandoverEmptyWidget(),
        _ => ReportViewWidget((state as Success).shiftReport),
      },
    ),
  );
}
