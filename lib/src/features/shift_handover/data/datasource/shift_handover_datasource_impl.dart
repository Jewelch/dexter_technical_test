import '../../../../api/data_source.dart';
import '../../../../app/environment/app_environment.dart';
import '../../domain/entities/note_type.dart';
import '../models/shift_report_model.dart';
import '../models/submission_result_model.dart';

part '../mock/shift_handover_mock.dart';

abstract interface class ShiftHandoverDataSource {
  static const String endpoint = "shift-handover";

  /// Calls the shift handover API endpoints.
  Future<ShiftReportModel> getShiftReport(String caregiverId);
  Future<SubmissionResultModel> submitShiftReport(ShiftReportModel report);
}

final class ShiftHandoverDataSourceImpl extends RestfulConsumerImpl
    implements ShiftHandoverDataSource {
  ShiftHandoverDataSourceImpl({
    required Dio client,
    required CacheManager cacheManager,
    required ConnectivityMonitor connectivityMonitor,
  }) : super(client, cacheManager, connectivityMonitor);

  @override
  Future<ShiftReportModel> getShiftReport(String caregiverId) async => await request(
    requirement: ShiftReportModel(),
    method: RestfulMethods.get,
    path: "${ShiftHandoverDataSource.endpoint}/$caregiverId",
    cachingKey: 'shiftReport_$caregiverId',
    mockIt: true,
    mockingData: _mockShiftReport(notesCount: AppEnvironment.testing ? 1 : 5),
  );

  @override
  Future<SubmissionResultModel> submitShiftReport(ShiftReportModel report) async => await request(
    requirement: SubmissionResultModel(),
    method: RestfulMethods.post,
    path: "${ShiftHandoverDataSource.endpoint}/submit",
    cachingKey: 'submitShiftReport_${report.id}',
    mockIt: true,
    mockingData: {"success": true, "message": "Report submitted successfully"},
  );
}
