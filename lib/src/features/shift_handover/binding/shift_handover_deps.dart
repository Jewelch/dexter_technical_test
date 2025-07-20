import '../../../app/binding/dependencies_injection.dart';
import '../../../base/dependencies/dependencies.dart';
import '../data/datasource/shift_handover_datasource_impl.dart';
import '../domain/usecases/get_shift_report_uc.dart';
import '../domain/usecases/submit_shift_report_uc.dart';
import '../presentation/bloc/shift_handover_bloc.dart';

class ShiftHandoverDependencies implements Dependencies {
  @override
  void inject() {
    //? Bloc
    di.registerFactory(() => ShiftHandoverBloc(get(), get()));

    //@ Use cases
    di.registerLazySingleton(() => GetShiftReportUC(get()));
    di.registerLazySingleton(() => SubmitShiftReportUC(get()));

    //$ Data sources
    di.registerLazySingleton<ShiftHandoverDataSource>(
      () => ShiftHandoverDataSourceImpl(
        client: get(),
        cacheManager: get(),
        connectivityMonitor: get(),
      ),
    );
  }
}
