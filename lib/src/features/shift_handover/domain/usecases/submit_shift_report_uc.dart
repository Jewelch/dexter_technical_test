import '../../../../api/data_source.dart';
import '../../data/datasource/shift_handover_datasource_impl.dart';
import '../../data/models/submission_result_model.dart';
import '../entities/submission_result.dart';

class SubmitShiftReportUC
    extends UseCase<SubmissionResult, SubmissionResultModel, SubmissionResult> {
  SubmitShiftReportUC(ShiftHandoverDataSource dataSource)
    : super(
        dataSourceFetcher: (report) => dataSource.submitShiftReport(report),
        modelToEntityMapper: SubmissionResult.from,
      );
}
