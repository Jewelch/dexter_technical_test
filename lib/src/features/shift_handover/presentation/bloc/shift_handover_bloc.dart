import 'dart:math';

import '../../../../base/bloc/exports.dart';
import '../../../../base/screens/exports.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/handover_note_model.dart';
import '../../domain/entities/handover_note.dart';
import '../../domain/entities/shift_report.dart';
import '../../domain/entities/submission_result.dart';
import '../../domain/usecases/get_shift_report_uc.dart';
import '../../domain/usecases/submit_shift_report_uc.dart';
import 'shift_handover_events.dart';
import 'shift_handover_states.dart';

class ShiftHandoverBloc extends BaseBloc<ShiftHandoverEvent, ShiftHandoverState> {
  final GetShiftReportUC getShiftReportUC;
  final SubmitShiftReportUC submitShiftReportUC;

  ShiftHandoverBloc(this.getShiftReportUC, this.submitShiftReportUC) : super(Loading()) {
    on<GetShiftReport>(_loadShiftReport);
    on<AddNewNote>(_addNewNote);
    on<SubmitReport>(_submitReport);
  }

  @override
  void onReady() {
    add(GetShiftReport('current-user-id'));
    super.onReady();
  }

  void _loadShiftReport(GetShiftReport event, Emitter<ShiftHandoverState> emit) async {
    emit(Loading());

    await getShiftReportUC
        .call(NoParams())
        .then(
          (result) => result.fold(
            (failure) => _handleFailure(failure.message, emit),
            (ShiftReport? shiftReport) => _handleLoadShiftReport(shiftReport, emit),
          ),
        );
  }

  void _handleFailure(String message, Emitter<ShiftHandoverState> emit) {
    ScaffoldMessenger.of(globalContext).showSnackBar(
      SnackBar(
        content: Text('An error occurred: $message'),
        backgroundColor: Theme.of(globalContext).colorScheme.error,
      ),
    );
    emit(Error(message: message));
  }

  void _handleLoadShiftReport(ShiftReport? shiftReport, Emitter<ShiftHandoverState> emit) =>
      (shiftReport == null) ? emit(Empty()) : emit(Submitted(shiftReport: shiftReport));

  void _addNewNote(AddNewNote event, Emitter<ShiftHandoverState> emit) {
    final currentState = state;
    if (currentState is! Success) return;

    final newNote = HandoverNote.from(
      HandoverNoteModel(
        id: 'note-${Random().nextInt(1000)}',
        text: event.text,
        type: event.type.name,
        timestamp: DateTime.now().toIso8601String(),
        authorId: currentState.shiftReport.caregiverId,
        taggedResidentIds: [],
        isAcknowledged: false,
      ),
    );

    final updatedNotes = [...currentState.shiftReport.notes, newNote];
    final updatedReport = currentState.shiftReport.copyWith(notes: updatedNotes);

    emit(Success(shiftReport: updatedReport));
  }

  void _submitReport(SubmitReport event, Emitter<ShiftHandoverState> emit) async {
    final currentState = state;
    if (currentState is! Success) return;

    emit(Submitting(shiftReport: currentState.shiftReport));

    final reportModel = currentState.shiftReport.toModel(
      summary: event.summary,
      endTime: DateTime.now(),
      isSubmitted: true,
    );

    await submitShiftReportUC
        .call(reportModel)
        .then(
          (result) => result.fold(
            (failure) => _handleFailure(failure.message, emit),
            (SubmissionResult? submissionResult) => _handleSubmissionResult(submissionResult, emit),
          ),
        );
  }

  void _handleSubmissionResult(
    SubmissionResult? submissionResult,
    Emitter<ShiftHandoverState> emit,
  ) {
    if (submissionResult == null) {
      emit(Error(message: 'Failed to submit report'));
      return;
    }

    ScaffoldMessenger.of(globalContext).showSnackBar(
      SnackBar(content: Text('Report submitted successfully!'), backgroundColor: AppColors.success),
    );
    emit(Submitted(shiftReport: (state as Success).shiftReport));
  }
}
