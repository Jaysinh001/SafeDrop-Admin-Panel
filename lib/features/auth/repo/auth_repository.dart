import '../../../../core/data/network/api_client.dart';
import '../../../../core/data/network/api_response.dart';
import '../../../../core/data/network/endpoints.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<ApiResponse<dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _apiClient.post(
      ApiEndpoints.loginApi,
      body: {
        "email": email,
        "password": password,
      },
    );
  }

  // Future<ApiResponse<dynamic>> refreshToken({
  //   required String refreshToken,
  // }) async {
  //   return await _apiClient.post(
  //     ApiEndpoints.refreshToken,
  //     body: {
  //       "refresh_token": refreshToken,
  //     },
  //   );
  // }

  // Future<ApiResponse<dynamic>> logout() async {
  //   return await _apiClient.post(
  //     ApiEndpoints.logoutApi,
  //   );
  // }
}