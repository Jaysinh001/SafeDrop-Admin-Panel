// To parse this JSON data, do
//
//     final driversListResponse = driversListResponseFromJson(jsonString);

import 'dart:convert';

DriversListResponse driversListResponseFromJson(String str) =>
    DriversListResponse.fromJson(json.decode(str));

String driversListResponseToJson(DriversListResponse data) =>
    json.encode(data.toJson());

class DriversListResponse {
  final List<Driver>? drivers;
  final String? message;
  final bool? success;

  DriversListResponse({this.drivers, this.message, this.success});

  DriversListResponse copyWith({
    List<Driver>? drivers,
    String? message,
    bool? success,
  }) => DriversListResponse(
    drivers: drivers ?? this.drivers,
    message: message ?? this.message,
    success: success ?? this.success,
  );

  factory DriversListResponse.fromJson(Map<String, dynamic> json) =>
      DriversListResponse(
        drivers:
            json["drivers"] == null
                ? []
                : List<Driver>.from(
                  json["drivers"]!.map((x) => Driver.fromJson(x)),
                ),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
    "drivers":
        drivers == null
            ? []
            : List<dynamic>.from(drivers!.map((x) => x.toJson())),
    "message": message,
    "success": success,
  };
}

class Driver {
  final int? id;
  final String? driverName;
  final String? email;
  final String? phoneNumber;
  final int? uniqueCodeId;
  final String? profilePicture;
  final bool? hasBankDetails;
  final bool? mpinSet;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Driver({
    this.id,
    this.driverName,
    this.email,
    this.phoneNumber,
    this.uniqueCodeId,
    this.profilePicture,
    this.hasBankDetails,
    this.mpinSet,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  Driver copyWith({
    int? id,
    String? driverName,
    String? email,
    String? phoneNumber,
    int? uniqueCodeId,
    String? profilePicture,
    bool? hasBankDetails,
    bool? mpinSet,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Driver(
    id: id ?? this.id,
    driverName: driverName ?? this.driverName,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    uniqueCodeId: uniqueCodeId ?? this.uniqueCodeId,
    profilePicture: profilePicture ?? this.profilePicture,
    hasBankDetails: hasBankDetails ?? this.hasBankDetails,
    mpinSet: mpinSet ?? this.mpinSet,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    driverName: json["driver_name"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    uniqueCodeId: json["unique_code_id"],
    profilePicture: json["profilePicture"],
    hasBankDetails: json["has_bank_details"],
    mpinSet: json["mpin_set"],
    role: json["role"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_name": driverName,
    "email": email,
    "phoneNumber": phoneNumber,
    "unique_code_id": uniqueCodeId,
    "profilePicture": profilePicture,
    "has_bank_details": hasBankDetails,
    "mpin_set": mpinSet,
    "role": role,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
