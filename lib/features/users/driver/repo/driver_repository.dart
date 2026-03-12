import '../../../../core/data/network/api_client.dart';
import '../../../../core/data/network/api_response.dart';
import '../../../../core/data/network/endpoints.dart';
import '../model/driver_details_response.dart';
import '../model/drivers_list_response.dart';

class DriverRepository {

  final ApiClient _apiClient;

  DriverRepository({required ApiClient apiClient}) : _apiClient = apiClient;



    Future<ApiResponse<DriversListResponse>> getDriversList() async {
    return await _apiClient.get(
      ApiEndpoints.driversList,
      parser: (json) => DriversListResponse.fromJson(json),
    );
  }

  Future<ApiResponse<DriversDetailsResponse>> getDriverDetails(String driverId) async {
    return await _apiClient.get(
      ApiEndpoints.driverDetails(driverId),
      parser: (json) => DriversDetailsResponse.fromJson(json),
    );
  }

}