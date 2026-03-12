import '../../../../core/data/network/api_client.dart';
import '../../../../core/data/network/api_response.dart';
import '../../../../core/data/network/endpoints.dart';
import '../model/drivers_list_response.dart';

class DriverRepository {

  final ApiClient _apiClient;

  DriverRepository({required ApiClient apiClient}) : _apiClient = apiClient;



    Future<ApiResponse<Data>> getDriversList() async {
    return await _apiClient.get(
      ApiEndpoints.driversList,
      parser: (json) => Data.fromJson(json),
    );
  }

  Future<ApiResponse<dynamic>> getDriverDetails(String driverId) async {
    return await _apiClient.get(
      ApiEndpoints.driverDetails(driverId),
      parser: (json) => Data.fromJson(json),
    );
  }

}