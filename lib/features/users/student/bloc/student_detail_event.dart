import 'package:equatable/equatable.dart';

abstract class StudentDetailEvent extends Equatable {
  const StudentDetailEvent();

  @override
  List<Object?> get props => [];
}

class StudentDetailLoaded extends StudentDetailEvent {
  final int studentId;
  const StudentDetailLoaded(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class StudentDetailTabChanged extends StudentDetailEvent {
  final int index;
  const StudentDetailTabChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class StudentDetailTransactionFilterChanged extends StudentDetailEvent {
  final String filter;
  const StudentDetailTransactionFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class StudentDetailRefreshRequested extends StudentDetailEvent {}

class StudentDetailGenerateNextPaymentRequested extends StudentDetailEvent {}
