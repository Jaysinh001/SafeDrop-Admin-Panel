// To parse this JSON data, do
//
//     final studentDetailsResponse = studentDetailsResponseFromJson(jsonString);

import 'dart:convert';

StudentDetailsResponse studentDetailsResponseFromJson(String str) => StudentDetailsResponse.fromJson(json.decode(str));

String studentDetailsResponseToJson(StudentDetailsResponse data) => json.encode(data.toJson());

class StudentDetailsResponse {
    final String? message;
    final StudentDetails? studentDetails;
    final bool? success;

    StudentDetailsResponse({
        this.message,
        this.studentDetails,
        this.success,
    });

    StudentDetailsResponse copyWith({
        String? message,
        StudentDetails? studentDetails,
        bool? success,
    }) => 
        StudentDetailsResponse(
            message: message ?? this.message,
            studentDetails: studentDetails ?? this.studentDetails,
            success: success ?? this.success,
        );

    factory StudentDetailsResponse.fromJson(Map<String, dynamic> json) => StudentDetailsResponse(
        message: json["message"],
        studentDetails: json["student_details"] == null ? null : StudentDetails.fromJson(json["student_details"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "student_details": studentDetails?.toJson(),
        "success": success,
    };
}

class StudentDetails {
    final Student? student;
    final Driver? driver;
    final List<Transaction>? transactions;
    final StudentCreditBalance? studentCreditBalance;
    final UniqueCode? uniqueCode;
    final FcmToken? fcmToken;
    final List<DuePayment>? duePayments;

    StudentDetails({
        this.student,
        this.driver,
        this.transactions,
        this.studentCreditBalance,
        this.uniqueCode,
        this.fcmToken,
        this.duePayments,
    });

    StudentDetails copyWith({
        Student? student,
        Driver? driver,
        List<Transaction>? transactions,
        StudentCreditBalance? studentCreditBalance,
        UniqueCode? uniqueCode,
        FcmToken? fcmToken,
        List<DuePayment>? duePayments,
    }) => 
        StudentDetails(
            student: student ?? this.student,
            driver: driver ?? this.driver,
            transactions: transactions ?? this.transactions,
            studentCreditBalance: studentCreditBalance ?? this.studentCreditBalance,
            uniqueCode: uniqueCode ?? this.uniqueCode,
            fcmToken: fcmToken ?? this.fcmToken,
            duePayments: duePayments ?? this.duePayments,
        );

    factory StudentDetails.fromJson(Map<String, dynamic> json) => StudentDetails(
        student: json["student"] == null ? null : Student.fromJson(json["student"]),
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
        transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
        studentCreditBalance: json["student_credit_balance"] == null ? null : StudentCreditBalance.fromJson(json["student_credit_balance"]),
        uniqueCode: json["unique_code"] == null ? null : UniqueCode.fromJson(json["unique_code"]),
        fcmToken: json["fcm_token"] == null ? null : FcmToken.fromJson(json["fcm_token"]),
        duePayments: json["due_payments"] == null ? [] : List<DuePayment>.from(json["due_payments"]!.map((x) => DuePayment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "student": student?.toJson(),
        "driver": driver?.toJson(),
        "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
        "student_credit_balance": studentCreditBalance?.toJson(),
        "unique_code": uniqueCode?.toJson(),
        "fcm_token": fcmToken?.toJson(),
        "due_payments": duePayments == null ? [] : List<dynamic>.from(duePayments!.map((x) => x.toJson())),
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
    }) => 
        Driver(
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
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
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

class DuePayment {
    final int? id;
    final int? studentId;
    final int? driverId;
    final int? amount;
    final int? dueMonth;
    final int? dueYear;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    DuePayment({
        this.id,
        this.studentId,
        this.driverId,
        this.amount,
        this.dueMonth,
        this.dueYear,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    DuePayment copyWith({
        int? id,
        int? studentId,
        int? driverId,
        int? amount,
        int? dueMonth,
        int? dueYear,
        String? status,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        DuePayment(
            id: id ?? this.id,
            studentId: studentId ?? this.studentId,
            driverId: driverId ?? this.driverId,
            amount: amount ?? this.amount,
            dueMonth: dueMonth ?? this.dueMonth,
            dueYear: dueYear ?? this.dueYear,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory DuePayment.fromJson(Map<String, dynamic> json) => DuePayment(
        id: json["id"],
        studentId: json["student_id"],
        driverId: json["driver_id"],
        amount: json["amount"],
        dueMonth: json["due_month"],
        dueYear: json["due_year"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "driver_id": driverId,
        "amount": amount,
        "due_month": dueMonth,
        "due_year": dueYear,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
    }) => 
        FcmToken(
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
        lastUsedAt: json["last_used_at"] == null ? null : DateTime.parse(json["last_used_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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

class Student {
    final int? id;
    final String? phoneNumber;
    final String? email;
    final String? studentName;
    final String? address;
    final int? uniqueCodeId;
    final int? proposedFee;
    final bool? accountActive;
    final String? profilePicture;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Student({
        this.id,
        this.phoneNumber,
        this.email,
        this.studentName,
        this.address,
        this.uniqueCodeId,
        this.proposedFee,
        this.accountActive,
        this.profilePicture,
        this.createdAt,
        this.updatedAt,
    });

    Student copyWith({
        int? id,
        String? phoneNumber,
        String? email,
        String? studentName,
        String? address,
        int? uniqueCodeId,
        int? proposedFee,
        bool? accountActive,
        String? profilePicture,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Student(
            id: id ?? this.id,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            email: email ?? this.email,
            studentName: studentName ?? this.studentName,
            address: address ?? this.address,
            uniqueCodeId: uniqueCodeId ?? this.uniqueCodeId,
            proposedFee: proposedFee ?? this.proposedFee,
            accountActive: accountActive ?? this.accountActive,
            profilePicture: profilePicture ?? this.profilePicture,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        studentName: json["student_name"],
        address: json["address"],
        uniqueCodeId: json["unique_code_id"],
        proposedFee: json["proposed_fee"],
        accountActive: json["account_active"],
        profilePicture: json["profile_picture"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "phone_number": phoneNumber,
        "email": email,
        "student_name": studentName,
        "address": address,
        "unique_code_id": uniqueCodeId,
        "proposed_fee": proposedFee,
        "account_active": accountActive,
        "profile_picture": profilePicture,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class StudentCreditBalance {
    final int? id;
    final int? studentId;
    final int? credit;
    final DateTime? updatedAt;

    StudentCreditBalance({
        this.id,
        this.studentId,
        this.credit,
        this.updatedAt,
    });

    StudentCreditBalance copyWith({
        int? id,
        int? studentId,
        int? credit,
        DateTime? updatedAt,
    }) => 
        StudentCreditBalance(
            id: id ?? this.id,
            studentId: studentId ?? this.studentId,
            credit: credit ?? this.credit,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory StudentCreditBalance.fromJson(Map<String, dynamic> json) => StudentCreditBalance(
        id: json["ID"],
        studentId: json["StudentID"],
        credit: json["Credit"],
        updatedAt: json["UpdatedAt"] == null ? null : DateTime.parse(json["UpdatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "StudentID": studentId,
        "Credit": credit,
        "UpdatedAt": updatedAt?.toIso8601String(),
    };
}

class Transaction {
    final int? id;
    final int? studentId;
    final int? driverId;
    final int? amount;
    final String? transactionRef;
    final String? status;
    final String? transactionMode;
    final DateTime? timestamp;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Transaction({
        this.id,
        this.studentId,
        this.driverId,
        this.amount,
        this.transactionRef,
        this.status,
        this.transactionMode,
        this.timestamp,
        this.createdAt,
        this.updatedAt,
    });

    Transaction copyWith({
        int? id,
        int? studentId,
        int? driverId,
        int? amount,
        String? transactionRef,
        String? status,
        String? transactionMode,
        DateTime? timestamp,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Transaction(
            id: id ?? this.id,
            studentId: studentId ?? this.studentId,
            driverId: driverId ?? this.driverId,
            amount: amount ?? this.amount,
            transactionRef: transactionRef ?? this.transactionRef,
            status: status ?? this.status,
            transactionMode: transactionMode ?? this.transactionMode,
            timestamp: timestamp ?? this.timestamp,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        studentId: json["student_id"],
        driverId: json["driver_id"],
        amount: json["amount"],
        transactionRef: json["transaction_ref"],
        status: json["status"],
        transactionMode: json["transaction_mode"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "driver_id": driverId,
        "amount": amount,
        "transaction_ref": transactionRef,
        "status": status,
        "transaction_mode": transactionMode,
        "timestamp": timestamp?.toIso8601String(),
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
    }) => 
        UniqueCode(
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
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "driver_id": driverId,
        "uniqueCode": uniqueCode,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
