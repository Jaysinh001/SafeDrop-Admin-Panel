// To parse this JSON data, do
//
//     final driversDetailsResponse = driversDetailsResponseFromJson(jsonString);

import 'dart:convert';

DriversDetailsResponse driversDetailsResponseFromJson(String str) =>
    DriversDetailsResponse.fromJson(json.decode(str));

String driversDetailsResponseToJson(DriversDetailsResponse data) =>
    json.encode(data.toJson());

class DriversDetailsResponse {
  final Data? data;
  final String? message;
  final bool? success;

  DriversDetailsResponse({this.data, this.message, this.success});

  DriversDetailsResponse copyWith({
    Data? data,
    String? message,
    bool? success,
  }) => DriversDetailsResponse(
    data: data ?? this.data,
    message: message ?? this.message,
    success: success ?? this.success,
  );

  factory DriversDetailsResponse.fromJson(Map<String, dynamic> json) =>
      DriversDetailsResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "message": message,
    "success": success,
  };
}

class Data {
  final Driver? driver;
  final Wallet? wallet;
  final List<BankDetail>? bankDetails;
  final List<Vehicle>? vehicles;
  final UniqueCode? uniqueCode;
  final FcmToken? fcmToken;

  Data({
    this.driver,
    this.wallet,
    this.bankDetails,
    this.vehicles,
    this.uniqueCode,
    this.fcmToken,
  });

  Data copyWith({
    Driver? driver,
    Wallet? wallet,
    List<BankDetail>? bankDetails,
    List<Vehicle>? vehicles,
    UniqueCode? uniqueCode,
    FcmToken? fcmToken,
  }) => Data(
    driver: driver ?? this.driver,
    wallet: wallet ?? this.wallet,
    bankDetails: bankDetails ?? this.bankDetails,
    vehicles: vehicles ?? this.vehicles,
    uniqueCode: uniqueCode ?? this.uniqueCode,
    fcmToken: fcmToken ?? this.fcmToken,
  );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
    wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
    bankDetails:
        json["bank_details"] == null
            ? []
            : List<BankDetail>.from(
              json["bank_details"]!.map((x) => BankDetail.fromJson(x)),
            ),
    vehicles:
        json["vehicles"] == null
            ? []
            : List<Vehicle>.from(
              json["vehicles"]!.map((x) => Vehicle.fromJson(x)),
            ),
    uniqueCode:
        json["unique_code"] == null
            ? null
            : UniqueCode.fromJson(json["unique_code"]),
    fcmToken:
        json["fcm_token"] == null ? null : FcmToken.fromJson(json["fcm_token"]),
  );

  Map<String, dynamic> toJson() => {
    "driver": driver?.toJson(),
    "wallet": wallet?.toJson(),
    "bank_details":
        bankDetails == null
            ? []
            : List<dynamic>.from(bankDetails!.map((x) => x.toJson())),
    "vehicles":
        vehicles == null
            ? []
            : List<dynamic>.from(vehicles!.map((x) => x.toJson())),
    "unique_code": uniqueCode?.toJson(),
    "fcm_token": fcmToken?.toJson(),
  };
}

class BankDetail {
  final int? id;
  final int? driverId;
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;
  final String? accountHolder;
  final bool? isPrimary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BankDetail({
    this.id,
    this.driverId,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.accountHolder,
    this.isPrimary,
    this.createdAt,
    this.updatedAt,
  });

  BankDetail copyWith({
    int? id,
    int? driverId,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? accountHolder,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BankDetail(
    id: id ?? this.id,
    driverId: driverId ?? this.driverId,
    bankName: bankName ?? this.bankName,
    accountNumber: accountNumber ?? this.accountNumber,
    ifscCode: ifscCode ?? this.ifscCode,
    accountHolder: accountHolder ?? this.accountHolder,
    isPrimary: isPrimary ?? this.isPrimary,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
    id: json["id"],
    driverId: json["driver_id"],
    bankName: json["bank_name"],
    accountNumber: json["account_number"],
    ifscCode: json["ifsc_code"],
    accountHolder: json["account_holder"],
    isPrimary: json["is_primary"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_id": driverId,
    "bank_name": bankName,
    "account_number": accountNumber,
    "ifsc_code": ifscCode,
    "account_holder": accountHolder,
    "is_primary": isPrimary,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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

class FcmToken {
  final int? id;
  final int? userId;
  final String? role;
  final String? token;
  final String? platform;
  final bool? isActive;
  final DateTime? lastUsedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FcmToken({
    this.id,
    this.userId,
    this.role,
    this.token,
    this.platform,
    this.isActive,
    this.lastUsedAt,
    this.createdAt,
    this.updatedAt,
  });

  FcmToken copyWith({
    int? id,
    int? userId,
    String? role,
    String? token,
    String? platform,
    bool? isActive,
    DateTime? lastUsedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FcmToken(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    token: token ?? this.token,
    platform: platform ?? this.platform,
    isActive: isActive ?? this.isActive,
    lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory FcmToken.fromJson(Map<String, dynamic> json) => FcmToken(
    id: json["id"],
    userId: json["user_id"],
    role: json["role"],
    token: json["token"],
    platform: json["platform"],
    isActive: json["is_active"],
    lastUsedAt:
        json["last_used_at"] == null
            ? null
            : DateTime.parse(json["last_used_at"]),
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "role": role,
    "token": token,
    "platform": platform,
    "is_active": isActive,
    "last_used_at": lastUsedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class UniqueCode {
  final int? id;
  final int? driverId;
  final String? uniqueCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UniqueCode({
    this.id,
    this.driverId,
    this.uniqueCode,
    this.createdAt,
    this.updatedAt,
  });

  UniqueCode copyWith({
    int? id,
    int? driverId,
    String? uniqueCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UniqueCode(
    id: id ?? this.id,
    driverId: driverId ?? this.driverId,
    uniqueCode: uniqueCode ?? this.uniqueCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory UniqueCode.fromJson(Map<String, dynamic> json) => UniqueCode(
    id: json["id"],
    driverId: json["driver_id"],
    uniqueCode: json["uniqueCode"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_id": driverId,
    "uniqueCode": uniqueCode,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Vehicle {
  final int? id;
  final int? ownerId;
  final int? assignedDriverId;
  final String? vehicleNumber;
  final String? vehicleType;
  final String? model;
  final String? color;
  final bool? isAssigned;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Vehicle({
    this.id,
    this.ownerId,
    this.assignedDriverId,
    this.vehicleNumber,
    this.vehicleType,
    this.model,
    this.color,
    this.isAssigned,
    this.createdAt,
    this.updatedAt,
  });

  Vehicle copyWith({
    int? id,
    int? ownerId,
    int? assignedDriverId,
    String? vehicleNumber,
    String? vehicleType,
    String? model,
    String? color,
    bool? isAssigned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Vehicle(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    assignedDriverId: assignedDriverId ?? this.assignedDriverId,
    vehicleNumber: vehicleNumber ?? this.vehicleNumber,
    vehicleType: vehicleType ?? this.vehicleType,
    model: model ?? this.model,
    color: color ?? this.color,
    isAssigned: isAssigned ?? this.isAssigned,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["id"],
    ownerId: json["owner_id"],
    assignedDriverId: json["assigned_driver_id"],
    vehicleNumber: json["vehicle_number"],
    vehicleType: json["vehicle_type"],
    model: json["model"],
    color: json["color"],
    isAssigned: json["is_assigned"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_id": ownerId,
    "assigned_driver_id": assignedDriverId,
    "vehicle_number": vehicleNumber,
    "vehicle_type": vehicleType,
    "model": model,
    "color": color,
    "is_assigned": isAssigned,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Wallet {
  final int? id;
  final int? driverId;
  final int? availableBalance;
  final int? pendingBalance;
  final DateTime? updatedAt;

  Wallet({
    this.id,
    this.driverId,
    this.availableBalance,
    this.pendingBalance,
    this.updatedAt,
  });

  Wallet copyWith({
    int? id,
    int? driverId,
    int? availableBalance,
    int? pendingBalance,
    DateTime? updatedAt,
  }) => Wallet(
    id: id ?? this.id,
    driverId: driverId ?? this.driverId,
    availableBalance: availableBalance ?? this.availableBalance,
    pendingBalance: pendingBalance ?? this.pendingBalance,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json["id"],
    driverId: json["driver_id"],
    availableBalance: json["available_balance"],
    pendingBalance: json["pending_balance"],
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_id": driverId,
    "available_balance": availableBalance,
    "pending_balance": pendingBalance,
    "updated_at": updatedAt?.toIso8601String(),
  };
}
