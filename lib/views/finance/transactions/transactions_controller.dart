import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safedropadminpanel/data/network/network_service_api.dart';
import 'dart:convert';

class TransactionsController extends GetxController {
  Rx<String> noOfEntries = '0'.obs;

  ///return all transaction history
  Future<List<Transaction>?> getTransectionHistory() async {
    try {
      // final res = await NetworkServicesApi().getApi(path: "");
      final res = test;

      // final transactionHistoryModel = transactionHistoryModelFromJson(
      //   jsonDecode(res),
      // );
      final transactionHistoryModel = transactionHistoryModelFromJson(
        jsonEncode(res),
      );

      final transactionHistoryList = transactionHistoryModel.transactions;

      noOfEntries.value = transactionHistoryList!.length.toString();

      return transactionHistoryList;
    } catch (e) {
      debugPrint("Error fetching transactions: $e");
      return [];
    }
  }

  final test = {
    "message": "All Transactions has been fetched",
    "success": true,
    "transactions": [
      {
        "id": 10,
        "student_id": 2,
        "driver_id": 1,
        "bank_details_id": 0,
        "amount": 1000,
        "transaction_ref": "pay_QeJmsj5dsxC4lu",
        "status": "Success",
        "timestamp": "2025-06-07T18:42:07.65468+05:30",
        "created_at": "2025-06-07T18:42:07.65468+05:30",
        "updated_at": "2025-06-07T18:42:36.523725+05:30",
      },
      {
        "id": 11,
        "student_id": 2,
        "driver_id": 1,
        "bank_details_id": 0,
        "amount": 2000,
        "transaction_ref": "pay_QeKAy5ZeFl24bN",
        "status": "Success",
        "timestamp": "2025-06-07T19:04:52.486706+05:30",
        "created_at": "2025-06-07T19:04:52.486706+05:30",
        "updated_at": "2025-06-07T19:05:24.596839+05:30",
      },
      {
        "id": 12,
        "student_id": 2,
        "driver_id": 1,
        "bank_details_id": 0,
        "amount": 500,
        "transaction_ref": "pay_QeKChJSP1fo3lK",
        "status": "Success",
        "timestamp": "2025-06-07T19:06:37.346668+05:30",
        "created_at": "2025-06-07T19:06:37.346668+05:30",
        "updated_at": "2025-06-07T19:07:02.883617+05:30",
      },
      {
        "id": 13,
        "student_id": 2,
        "driver_id": 1,
        "bank_details_id": 0,
        "amount": 200,
        "transaction_ref": "pay_QeKbQX0tE4geqe",
        "status": "Success",
        "timestamp": "2025-06-07T19:29:46.915283+05:30",
        "created_at": "2025-06-07T19:29:46.915283+05:30",
        "updated_at": "2025-06-07T19:30:27.823217+05:30",
      },
      {
        "id": 14,
        "student_id": 2,
        "driver_id": 1,
        "bank_details_id": 0,
        "amount": 300,
        "transaction_ref": "pay_QeKcjtvsMtAvZl",
        "status": "Success",
        "timestamp": "2025-06-07T19:31:06.584304+05:30",
        "created_at": "2025-06-07T19:31:06.584304+05:30",
        "updated_at": "2025-06-07T19:31:42.963795+05:30",
      },
      {
        "id": 15,
        "student_id": 2,
        "driver_id": 1,
        "bank_details_id": 0,
        "amount": 300,
        "transaction_ref": "pay_QeMj5e8BQzgWhM",
        "status": "Success",
        "timestamp": "2025-06-07T21:34:26.070861+05:30",
        "created_at": "2025-06-07T21:34:26.070861+05:30",
        "updated_at": "2025-06-07T21:35:07.161442+05:30",
      },
    ],
  };
}

// To parse this JSON data, do
//
//     final transactionHistoryModel = transactionHistoryModelFromJson(jsonString);

TransactionHistoryModel transactionHistoryModelFromJson(String str) =>
    TransactionHistoryModel.fromJson(json.decode(str));

String transactionHistoryModelToJson(TransactionHistoryModel data) =>
    json.encode(data.toJson());

class TransactionHistoryModel {
  String? message;
  bool? success;
  List<Transaction>? transactions;

  TransactionHistoryModel({this.message, this.success, this.transactions});

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryModel(
        message: json["message"],
        success: json["success"],
        transactions:
            json["transactions"] == null
                ? []
                : List<Transaction>.from(
                  json["transactions"]!.map((x) => Transaction.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "success": success,
    "transactions":
        transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
  };
}

class Transaction {
  int? id;
  int? studentId;
  int? driverId;
  int? bankDetailsId;
  int? amount;
  String? transactionRef;
  String? status;
  DateTime? timestamp;
  DateTime? createdAt;
  DateTime? updatedAt;

  Transaction({
    this.id,
    this.studentId,
    this.driverId,
    this.bankDetailsId,
    this.amount,
    this.transactionRef,
    this.status,
    this.timestamp,
    this.createdAt,
    this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    studentId: json["student_id"],
    driverId: json["driver_id"],
    bankDetailsId: json["bank_details_id"],
    amount: json["amount"],
    transactionRef: json["transaction_ref"],
    status: json["status"],
    timestamp:
        json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "student_id": studentId,
    "driver_id": driverId,
    "bank_details_id": bankDetailsId,
    "amount": amount,
    "transaction_ref": transactionRef,
    "status": status,
    "timestamp": timestamp?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
