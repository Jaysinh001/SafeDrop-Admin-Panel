// To parse this JSON data, do
//
//     final withdrawalRequestResponse = withdrawalRequestResponseFromJson(jsonString);

import 'dart:convert';

WithdrawalRequestResponse withdrawalRequestResponseFromJson(String str) =>
    WithdrawalRequestResponse.fromJson(json.decode(str));

String withdrawalRequestResponseToJson(WithdrawalRequestResponse data) =>
    json.encode(data.toJson());

class WithdrawalRequestResponse {
  final String? message;
  final List<Request>? requests;
  final bool? success;

  WithdrawalRequestResponse({this.message, this.requests, this.success});

  WithdrawalRequestResponse copyWith({
    String? message,
    List<Request>? requests,
    bool? success,
  }) => WithdrawalRequestResponse(
    message: message ?? this.message,
    requests: requests ?? this.requests,
    success: success ?? this.success,
  );

  factory WithdrawalRequestResponse.fromJson(Map<String, dynamic> json) =>
      WithdrawalRequestResponse(
        message: json["message"],
        requests:
            json["requests"] == null
                ? []
                : List<Request>.from(
                  json["requests"]!.map((x) => Request.fromJson(x)),
                ),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "requests":
        requests == null
            ? []
            : List<dynamic>.from(requests!.map((x) => x.toJson())),
    "success": success,
  };
}

class Request {
  final int? id;
  final int? driverId;
  final int? amount;
  final String? status;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Request({
    this.id,
    this.driverId,
    this.amount,
    this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  Request copyWith({
    int? id,
    int? driverId,
    int? amount,
    String? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Request(
    id: id ?? this.id,
    driverId: driverId ?? this.driverId,
    amount: amount ?? this.amount,
    status: status ?? this.status,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    id: json["id"],
    driverId: json["driver_id"],
    amount: json["amount"],
    status: json["status"],
    note: json["note"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_id": driverId,
    "amount": amount,
    "status": status,
    "note": note,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
