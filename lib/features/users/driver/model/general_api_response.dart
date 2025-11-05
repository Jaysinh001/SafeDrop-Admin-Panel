// To parse this JSON data, do
//
//     final generalApiResponse = generalApiResponseFromJson(jsonString);

import 'dart:convert';

GeneralApiResponse generalApiResponseFromJson(String str) =>
    GeneralApiResponse.fromJson(json.decode(str));

String generalApiResponseToJson(GeneralApiResponse data) =>
    json.encode(data.toJson());

class GeneralApiResponse {
  final String? message;
  final bool? success;

  GeneralApiResponse({
    this.message,
    this.success,
  });

  factory GeneralApiResponse.fromJson(Map<String, dynamic> json) =>
      GeneralApiResponse(
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
      };
}
