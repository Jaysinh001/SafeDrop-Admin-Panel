import '../../../../core/data/network/api_client.dart';
import '../../../../core/data/network/api_response.dart';
import '../../../../core/data/network/endpoints.dart';
import '../model/student_details_response.dart';
import '../model/students_list_response.dart';

class StudentRepository {
  final ApiClient _apiClient;

  StudentRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<ApiResponse<Data>> getStudentsList() async {
    return await _apiClient.get(
      ApiEndpoints.studentsList,
      parser: (json) => Data.fromJson(json),
    );
  }

  Future<ApiResponse<StudentDetailsResponse>> getStudentDetails(
    String studentId,
  ) async {
    return await _apiClient.get(
      ApiEndpoints.studentDetails(studentId),
      parser: (json) => StudentDetailsResponse.fromJson(json),
    );
  }

  Future<ApiResponse<dynamic>> generateNextPayment(
    Map<String, int?> payload,
  ) async {
    return await _apiClient.post(
      ApiEndpoints.generateNextPayment,
      body: payload,
    );
  }
}
