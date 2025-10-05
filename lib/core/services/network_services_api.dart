import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import '../local_storage/local_db.dart';
import '../exceptions/app_exceptions.dart';
import '../utility/utils.dart';
import 'base_api_services.dart';

class NetworkServicesApi implements BaseApiServices {
  NetworkServicesApi();

  /// For RestApi
  // static const String baseApi = "http://127.0.0.1:8080/api/admin/";
  // static const String baseApi = "http://10.0.2.2:5678/api/admin/";
  static const String baseApi =
      "https://roughly-valued-starling.ngrok-free.app/api/admin/";

  // >>>>>> Production Api <<<<<<<<
  // static const String baseApi =
  //     "https://safe-drop-backend-3nwm.onrender.com/api/admin/";

  @override
  Future<dynamic> getApi({
    required String path,
    String? token,
    Map<String, String>? params,
  }) async {
    debugPrint(token);

    try {
      final headers = {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': "true",
      };
      // if (token != null) {
      //   headers['Authorization'] = 'Bearer $token';
      // }

      if (params != null) {
        headers.addAll(params);
      }

      final response = await http
          .get(Uri.parse(baseApi + path), headers: headers)
          .timeout(const Duration(seconds: 180));

      Utils.showLog(
        '$baseApi$path : ${response.statusCode} : ${response.body}',
      );

      dynamic res = returnResponse(response);

      return res;
    } on SocketException {
      throw NoInternetConnection('Failed To Get Api Response Due to :');
    } on TimeoutException {
      throw RequestTimeOutException('Failed To Get Api Response Due to :');
    }
  }

  @override
  Future customPathGetApi({required String path}) async {
    try {
      // final headers = {'Accept': 'application/json'};

      final response = await http
          .get(Uri.parse(path))
          .timeout(const Duration(seconds: 180));

      return response.body;
    } on SocketException {
      throw NoInternetConnection('Failed To Get Api Response Due to :');
    } on TimeoutException {
      throw RequestTimeOutException('Failed To Get Api Response Due to :');
    }
  }

  @override
  Future<dynamic> postApi({
    required String path,
    var data,
    String? token,
  }) async {
    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .post(
            Uri.parse(baseApi + path),
            body: jsonEncode(data),
            headers: headers,
          )
          .timeout(const Duration(seconds: 180));

      Utils.showLog('$path : ${response.body}');

      dynamic jsonResponse = returnResponse(response);

      return jsonResponse;
    } on SocketException {
      throw NoInternetConnection('Failed To Get Api Response Due to :');
    } on TimeoutException {
      throw RequestTimeOutException('Failed To Get Api Response Due to :');
    }
  }

  Future<dynamic> postImageApi({
    required String path,
    required File imageFile,
    String? token,
  }) async {
    try {
      final uri = Uri.parse(baseApi + path);
      final request = http.MultipartRequest('POST', uri);

      // Add headers if necessary
      request.headers['Accept'] = 'application/json';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Attach the image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture', // Change this to match the expected field name
          imageFile.path,
        ),
      );

      // Send the request
      final streamedResponse = await request.send();

      // Convert the streamed response to a regular HTTP response
      final response = await http.Response.fromStream(streamedResponse);

      // Process the response
      return returnResponse(response);
    } on SocketException {
      throw NoInternetConnection(
        'Failed to get API response due to: No internet',
      );
    } on TimeoutException {
      throw RequestTimeOutException(
        'Failed to get API response due to: Timeout',
      );
    }
  }

  dynamic returnResponse(http.Response res) {
    // Utility.showLog("Response StatusCode :: ${res.statusCode} \nResponse body :: ${res.body} ");
    switch (res.statusCode) {
      case 200:
        // dynamic response = jsonDecode(res.body);
        dynamic response = res.body;
        return response;
      case 201:
        // dynamic response = jsonDecode(res.body);
        dynamic response = res.body;
        return response;
      case 400:
        // dynamic response = jsonDecode(res.body);
        dynamic response = res.body;
        return response;
      case 401:
        dynamic response = res.body;
        return response;
      case 422:
        dynamic response = res.body;
        return response;
      case 500:
        throw FetchDataException('FetchDataException with response : $res');
      default:
        // Utility.showLog(
        //   "api Error status code : ${res.statusCode} :: body : ${res.body}",
        // );

        throw FetchDataException('default statusCode with res : $res');
    }
  }
}
