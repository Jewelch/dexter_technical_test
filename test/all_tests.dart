// Integration tests
import '../integration_test/features/shift_handover/main/e2e_shift_handover_test.dart'
    as e2e_shift_handover_test;
import './features/shift_handover/data/datasource/shift_handover_datasource_impl_test.dart'
    as shift_handover_datasource_test;
import './features/shift_handover/domain/entities/note_type_test.dart' as note_type_test;
import './features/shift_handover/domain/usecases/get_shift_report_uc_test.dart'
    as get_shift_report_uc_test;
import './features/shift_handover/domain/usecases/submit_shift_report_uc_test.dart'
    as submit_shift_report_uc_test;
import './features/shift_handover/helpers/timestamp_helper_test.dart' as timestamp_helper_test;

void main() async {
  // Unit tests
  unitTests();

  // Integration tests
  integrationTests();
}

/// Unit tests
void unitTests() async {
  // Domain layer tests
  note_type_test.main();
  get_shift_report_uc_test.main();
  submit_shift_report_uc_test.main();

  // Data layer tests
  shift_handover_datasource_test.main();

  // Helper tests
  timestamp_helper_test.main();
}

/// Integration tests
void integrationTests() async {
  e2e_shift_handover_test.main();
}
