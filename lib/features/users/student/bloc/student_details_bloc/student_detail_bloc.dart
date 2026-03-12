import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/data/local_storage/local_storage_service.dart';
import '../../repo/student_repository.dart';
import 'student_detail_event.dart';
import 'student_detail_state.dart';

class StudentDetailBloc extends Bloc<StudentDetailEvent, StudentDetailState> {
  final StudentRepository studentRepository;
  final LocalStorageService storage;

  StudentDetailBloc({required this.studentRepository, required this.storage})
    : super(const StudentDetailState()) {
    on<StudentDetailLoaded>(_onStudentDetailLoaded);
    on<StudentDetailTabChanged>(_onTabChanged);
    on<StudentDetailTransactionFilterChanged>(_onTransactionFilterChanged);
    on<StudentDetailRefreshRequested>(_onRefreshRequested);
    on<StudentDetailGenerateNextPaymentRequested>(
      _onGenerateNextPaymentRequested,
    );
  }

  Future<void> _onStudentDetailLoaded(
    StudentDetailLoaded event,
    Emitter<StudentDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: StudentDetailStatus.loading,
        studentId: event.studentId,
        errorMessage: null,
      ),
    );

    try {
      final response = await studentRepository.getStudentDetails(
        event.studentId.toString(),
      );

      if (response.success == true) {
        emit(
          state.copyWith(
            studentDetails: response.data?.studentDetails,
            status: StudentDetailStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: StudentDetailStatus.error,
            errorMessage: response.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: StudentDetailStatus.error,
          errorMessage: 'Failed to load student details: $e',
        ),
      );
    }
  }

  void _onTabChanged(
    StudentDetailTabChanged event,
    Emitter<StudentDetailState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.index));
  }

  void _onTransactionFilterChanged(
    StudentDetailTransactionFilterChanged event,
    Emitter<StudentDetailState> emit,
  ) {
    emit(state.copyWith(transactionFilter: event.filter));
  }

  Future<void> _onRefreshRequested(
    StudentDetailRefreshRequested event,
    Emitter<StudentDetailState> emit,
  ) async {
    add(StudentDetailLoaded(state.studentId));
  }

  Future<void> _onGenerateNextPaymentRequested(
    StudentDetailGenerateNextPaymentRequested event,
    Emitter<StudentDetailState> emit,
  ) async {
    if (state.studentDetails?.student == null) return;

    emit(
      state.copyWith(status: StudentDetailStatus.loading, errorMessage: null),
    );

    try {
      final payload = {
        'student_id': state.studentDetails!.student!.id,
        'driver_id': state.studentDetails!.driver?.id,
      };

      final response = await studentRepository.generateNextPayment(payload);

      if (response.success == true) {
        add(StudentDetailRefreshRequested());
      } else {
        emit(
          state.copyWith(
            status: StudentDetailStatus.error,
            errorMessage: response.message,
          ),
        );
        return;
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: StudentDetailStatus.error,
          errorMessage: 'Failed to generate payment: $e',
        ),
      );
    }
  }
}
