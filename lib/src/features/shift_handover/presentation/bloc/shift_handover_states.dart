import 'package:equatable/equatable.dart';

import '../../domain/entities/shift_report.dart';

sealed class ShiftHandoverState extends Equatable {
  @override
  List<Object> get props => [];
}

final class Loading extends ShiftHandoverState {}

final class Empty extends ShiftHandoverState {}

final class Success extends ShiftHandoverState {
  final ShiftReport shiftReport;

  Success({required this.shiftReport});

  @override
  List<Object> get props => [shiftReport];
}

final class Submitting extends Success {
  Submitting({required super.shiftReport});

  @override
  List<Object> get props => [super.shiftReport];
}

final class Submitted extends Success {
  Submitted({required super.shiftReport});

  @override
  List<Object> get props => [super.shiftReport];
}

final class Error extends ShiftHandoverState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
