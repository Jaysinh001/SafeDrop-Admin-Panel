import 'package:equatable/equatable.dart';
import '../../model/student_details_response.dart';


enum StudentDetailStatus { initial, loading, success, error }

class StudentDetailState extends Equatable {
  final int studentId;
  final StudentDetails? studentDetails;
  final StudentDetailStatus status;
  final int selectedTab;
  final String transactionFilter;
  final String? errorMessage;

  const StudentDetailState({
    this.studentId = 0,
    this.studentDetails,
    this.status = StudentDetailStatus.initial,
    this.selectedTab = 0,
    this.transactionFilter = 'all',
    this.errorMessage,
  });

  StudentDetailState copyWith({
    int? studentId,
    StudentDetails? studentDetails,
    StudentDetailStatus? status,
    int? selectedTab,
    String? transactionFilter,
    String? errorMessage,
  }) {
    return StudentDetailState(
      studentId: studentId ?? this.studentId,
      studentDetails: studentDetails ?? this.studentDetails,
      status: status ?? this.status,
      selectedTab: selectedTab ?? this.selectedTab,
      transactionFilter: transactionFilter ?? this.transactionFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    studentId,
    studentDetails,
    status,
    selectedTab,
    transactionFilter,
    errorMessage,
  ];
}
