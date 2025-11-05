// To parse this JSON data, do
//
//     final transactionsListResponse = transactionsListResponseFromJson(jsonString);

import 'dart:convert';

TransactionsListResponse transactionsListResponseFromJson(String str) => TransactionsListResponse.fromJson(json.decode(str));

String transactionsListResponseToJson(TransactionsListResponse data) => json.encode(data.toJson());

class TransactionsListResponse {
    final String? message;
    final bool? success;
    final List<Transaction>? transactions;

    TransactionsListResponse({
        this.message,
        this.success,
        this.transactions,
    });

    TransactionsListResponse copyWith({
        String? message,
        bool? success,
        List<Transaction>? transactions,
    }) => 
        TransactionsListResponse(
            message: message ?? this.message,
            success: success ?? this.success,
            transactions: transactions ?? this.transactions,
        );

    factory TransactionsListResponse.fromJson(Map<String, dynamic> json) => TransactionsListResponse(
        message: json["message"],
        success: json["success"],
        transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
        "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    };
}

class Transaction {
    final int? id;
    final int? studentId;
    final String? studentName;
    final int? amount;
    final String? status;
    final String? transactionMode;
    final DateTime? updatedAt;

    Transaction({
        this.id,
        this.studentId,
        this.studentName,
        this.amount,
        this.status,
        this.transactionMode,
        this.updatedAt,
    });

    Transaction copyWith({
        int? id,
        int? studentId,
        String? studentName,
        int? amount,
        String? status,
        String? transactionMode,
        DateTime? updatedAt,
    }) => 
        Transaction(
            id: id ?? this.id,
            studentId: studentId ?? this.studentId,
            studentName: studentName ?? this.studentName,
            amount: amount ?? this.amount,
            status: status ?? this.status,
            transactionMode: transactionMode ?? this.transactionMode,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        studentId: json["student_id"],
        studentName: json["student_name"],
        amount: json["amount"],
        status: json["status"],
        transactionMode: json["transaction_mode"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "student_name": studentName,
        "amount": amount,
        "status": status,
        "transaction_mode": transactionMode,
        "updated_at": updatedAt?.toIso8601String(),
    };
}
