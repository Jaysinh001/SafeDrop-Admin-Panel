import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/network_services_api.dart';
import '../model/student_details_response.dart';
import 'student_detail_event.dart';
import 'student_detail_state.dart';

class StudentDetailBloc extends Bloc<StudentDetailEvent, StudentDetailState> {
  final NetworkServicesApi _networkServicesApi = NetworkServicesApi();

  StudentDetailBloc() : super(const StudentDetailState()) {
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
        isLoading: true,
        studentId: event.studentId,
        errorMessage: null,
      ),
    );

    try {
      final res = await _networkServicesApi.getApi(
        path: 'student/details/${event.studentId}',
      );

      final response = studentDetailsResponseFromJson(res);
      emit(
        state.copyWith(
          studentDetails: response.studentDetails,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
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

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final payload = {
        'student_id': state.studentDetails!.student!.id,
        'driver_id': state.studentDetails!.driver?.id,
      };

      await _networkServicesApi.postApi(
        path: 'generateNextStudentDues',
        data: payload,
      );

      add(StudentDetailRefreshRequested());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to generate payment: $e',
        ),
      );
    }
  }
}
