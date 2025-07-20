import 'package:equatable/equatable.dart';

import '../../domain/entities/note_type.dart';

sealed class ShiftHandoverEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class GetShiftReport extends ShiftHandoverEvent {
  final String caregiverId;

  GetShiftReport(this.caregiverId);

  @override
  List<Object> get props => [caregiverId];
}

final class AddNewNote extends ShiftHandoverEvent {
  final String text;
  final NoteType type;

  AddNewNote(this.text, this.type);

  @override
  List<Object> get props => [text, type];
}

final class SubmitReport extends ShiftHandoverEvent {
  final String summary;

  SubmitReport(this.summary);

  @override
  List<Object> get props => [summary];
}
