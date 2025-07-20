import '../../../../api/data_source.dart';
import '../../data/datasource/shift_handover_datasource_impl.dart';
import '../../data/models/shift_report_model.dart';
import '../entities/shift_report.dart';

class GetShiftReportUC extends UseCase<ShiftReport, ShiftReportModel, ShiftReport> {
  GetShiftReportUC(ShiftHandoverDataSource dataSource)
    : super(
        dataSourceFetcher: (_) => dataSource.getShiftReport('current-user-id'),
        modelToEntityMapper: ShiftReport.from,
      );
}
