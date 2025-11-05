// To parse this JSON data, do
//
//     final transactionDetailsResponse = transactionDetailsResponseFromJson(jsonString);

import 'dart:convert';

TransactionDetailsResponse transactionDetailsResponseFromJson(String str) => TransactionDetailsResponse.fromJson(json.decode(str));

String transactionDetailsResponseToJson(TransactionDetailsResponse data) => json.encode(data.toJson());

class TransactionDetailsResponse {
    final String? message;
    final List<PaymentLog>? paymentLogs;
    final bool? success;
    final Transaction? transaction;

    TransactionDetailsResponse({
        this.message,
        this.paymentLogs,
        this.success,
        this.transaction,
    });

    TransactionDetailsResponse copyWith({
        String? message,
        List<PaymentLog>? paymentLogs,
        bool? success,
        Transaction? transaction,
    }) => 
        TransactionDetailsResponse(
            message: message ?? this.message,
            paymentLogs: paymentLogs ?? this.paymentLogs,
            success: success ?? this.success,
            transaction: transaction ?? this.transaction,
        );

    factory TransactionDetailsResponse.fromJson(Map<String, dynamic> json) => TransactionDetailsResponse(
        message: json["message"],
        paymentLogs: json["payment_logs"] == null ? [] : List<PaymentLog>.from(json["payment_logs"]!.map((x) => PaymentLog.fromJson(x))),
        success: json["success"],
        transaction: json["transaction"] == null ? null : Transaction.fromJson(json["transaction"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "payment_logs": paymentLogs == null ? [] : List<dynamic>.from(paymentLogs!.map((x) => x.toJson())),
        "success": success,
        "transaction": transaction?.toJson(),
    };
}

class PaymentLog {
    final int? id;
    final int? transactionId;
    final String? logMessage;
    final DateTime? createdAt;

    PaymentLog({
        this.id,
        this.transactionId,
        this.logMessage,
        this.createdAt,
    });

    PaymentLog copyWith({
        int? id,
        int? transactionId,
        String? logMessage,
        DateTime? createdAt,
    }) => 
        PaymentLog(
            id: id ?? this.id,
            transactionId: transactionId ?? this.transactionId,
            logMessage: logMessage ?? this.logMessage,
            createdAt: createdAt ?? this.createdAt,
        );

    factory PaymentLog.fromJson(Map<String, dynamic> json) => PaymentLog(
        id: json["id"],
        transactionId: json["transaction_id"],
        logMessage: json["log_message"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "transaction_id": transactionId,
        "log_message": logMessage,
        "created_at": createdAt?.toIso8601String(),
    };
}

class Transaction {
    final int? id;
    final int? studentId;
    final String? studentName;
    final int? driverId;
    final String? driverName;
    final String? referenceId;
    final int? amount;
    final String? status;
    final String? transactionMode;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Transaction({
        this.id,
        this.studentId,
        this.studentName,
        this.driverId,
        this.driverName,
        this.referenceId,
        this.amount,
        this.status,
        this.transactionMode,
        this.createdAt,
        this.updatedAt,
    });

    Transaction copyWith({
        int? id,
        int? studentId,
        String? studentName,
        int? driverId,
        String? driverName,
        String? referenceId,
        int? amount,
        String? status,
        String? transactionMode,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Transaction(
            id: id ?? this.id,
            studentId: studentId ?? this.studentId,
            studentName: studentName ?? this.studentName,
            driverId: driverId ?? this.driverId,
            driverName: driverName ?? this.driverName,
            referenceId: referenceId ?? this.referenceId,
            amount: amount ?? this.amount,
            status: status ?? this.status,
            transactionMode: transactionMode ?? this.transactionMode,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        studentId: json["student_id"],
        studentName: json["student_name"],
        driverId: json["driver_id"],
        driverName: json["driver_name"],
        referenceId: json["reference_id"],
        amount: json["amount"],
        status: json["status"],
        transactionMode: json["transaction_mode"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "student_name": studentName,
        "driver_id": driverId,
        "driver_name": driverName,
        "reference_id": referenceId,
        "amount": amount,
        "status": status,
        "transaction_mode": transactionMode,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
