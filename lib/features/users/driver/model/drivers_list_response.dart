// To parse this JSON data, do
//
//     final driversListResponse = driversListResponseFromJson(jsonString);

import 'dart:convert';

DriversListResponse driversListResponseFromJson(String str) => DriversListResponse.fromJson(json.decode(str));

String driversListResponseToJson(DriversListResponse data) => json.encode(data.toJson());

class DriversListResponse {
    final List<Driver>? drivers;
    final String? message;
    final bool? success;

    DriversListResponse({
        this.drivers,
        this.message,
        this.success,
    });

    DriversListResponse copyWith({
        List<Driver>? drivers,
        String? message,
        bool? success,
    }) => 
        DriversListResponse(
            drivers: drivers ?? this.drivers,
            message: message ?? this.message,
            success: success ?? this.success,
        );

    factory DriversListResponse.fromJson(Map<String, dynamic> json) => DriversListResponse(
        drivers: json["drivers"] == null ? [] : List<Driver>.from(json["drivers"]!.map((x) => Driver.fromJson(x))),
        message: json["message"],
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "drivers": drivers == null ? [] : List<dynamic>.from(drivers!.map((x) => x.toJson())),
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
    final String? uniqueCode;
    final String? profilePicture;
    final bool? hasBankDetails;
    final bool? mpinSet;
    final DateTime? createdAt;

    Driver({
        this.id,
        this.driverName,
        this.email,
        this.phoneNumber,
        this.uniqueCodeId,
        this.uniqueCode,
        this.profilePicture,
        this.hasBankDetails,
        this.mpinSet,
        this.createdAt,
    });

    Driver copyWith({
        int? id,
        String? driverName,
        String? email,
        String? phoneNumber,
        int? uniqueCodeId,
        String? uniqueCode,
        String? profilePicture,
        bool? hasBankDetails,
        bool? mpinSet,
        DateTime? createdAt,
    }) => 
        Driver(
            id: id ?? this.id,
            driverName: driverName ?? this.driverName,
            email: email ?? this.email,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            uniqueCodeId: uniqueCodeId ?? this.uniqueCodeId,
            uniqueCode: uniqueCode ?? this.uniqueCode,
            profilePicture: profilePicture ?? this.profilePicture,
            hasBankDetails: hasBankDetails ?? this.hasBankDetails,
            mpinSet: mpinSet ?? this.mpinSet,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        driverName: json["driverName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        uniqueCodeId: json["uniqueCodeID"],
        uniqueCode: json["uniqueCode"],
        profilePicture: json["profilePicture"],
        hasBankDetails: json["hasBankDetails"],
        mpinSet: json["mpinSet"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "driverName": driverName,
        "email": email,
        "phoneNumber": phoneNumber,
        "uniqueCodeID": uniqueCodeId,
        "uniqueCode": uniqueCode,
        "profilePicture": profilePicture,
        "hasBankDetails": hasBankDetails,
        "mpinSet": mpinSet,
        "createdAt": createdAt?.toIso8601String(),
    };
}
