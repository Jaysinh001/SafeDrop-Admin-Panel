import 'package:equatable/equatable.dart';
import '../model/student_details_response.dart';

class StudentDetailState extends Equatable {
  final int studentId;
  final StudentDetails? studentDetails;
  final bool isLoading;
  final int selectedTab;
  final String transactionFilter;
  final String? errorMessage;

  const StudentDetailState({
    this.studentId = 0,
    this.studentDetails,
    this.isLoading = false,
    this.selectedTab = 0,
    this.transactionFilter = 'all',
    this.errorMessage,
  });

  StudentDetailState copyWith({
    int? studentId,
    StudentDetails? studentDetails,
    bool? isLoading,
    int? selectedTab,
    String? transactionFilter,
    String? errorMessage,
  }) {
    return StudentDetailState(
      studentId: studentId ?? this.studentId,
      studentDetails: studentDetails ?? this.studentDetails,
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      transactionFilter: transactionFilter ?? this.transactionFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    studentId,
    studentDetails,
    isLoading,
    selectedTab,
    transactionFilter,
    errorMessage,
  ];
}
