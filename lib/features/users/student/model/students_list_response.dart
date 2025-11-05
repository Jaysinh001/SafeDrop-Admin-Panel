// To parse this JSON data, do
//
//     final studentsListResponse = studentsListResponseFromJson(jsonString);

import 'dart:convert';

StudentsListResponse studentsListResponseFromJson(String str) => StudentsListResponse.fromJson(json.decode(str));

String studentsListResponseToJson(StudentsListResponse data) => json.encode(data.toJson());

class StudentsListResponse {
    final String? message;
    final List<Student>? students;
    final bool? success;

    StudentsListResponse({
        this.message,
        this.students,
        this.success,
    });

    StudentsListResponse copyWith({
        String? message,
        List<Student>? students,
        bool? success,
    }) => 
        StudentsListResponse(
            message: message ?? this.message,
            students: students ?? this.students,
            success: success ?? this.success,
        );

    factory StudentsListResponse.fromJson(Map<String, dynamic> json) => StudentsListResponse(
        message: json["message"],
        students: json["students"] == null ? [] : List<Student>.from(json["students"]!.map((x) => Student.fromJson(x))),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "students": students == null ? [] : List<dynamic>.from(students!.map((x) => x.toJson())),
        "success": success,
    };
}

class Student {
    final int? studentId;
    final String? phoneNumber;
    final String? email;
    final String? studentName;
    final int? proposedFee;
    final bool? accountActive;
    final int? driverId;
    final String? driverName;
    final String? driverCode;

    Student({
        this.studentId,
        this.phoneNumber,
        this.email,
        this.studentName,
        this.proposedFee,
        this.accountActive,
        this.driverId,
        this.driverName,
        this.driverCode,
    });

    Student copyWith({
        int? studentId,
        String? phoneNumber,
        String? email,
        String? studentName,
        int? proposedFee,
        bool? accountActive,
        int? driverId,
        String? driverName,
        String? driverCode,
    }) => 
        Student(
            studentId: studentId ?? this.studentId,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            email: email ?? this.email,
            studentName: studentName ?? this.studentName,
            proposedFee: proposedFee ?? this.proposedFee,
            accountActive: accountActive ?? this.accountActive,
            driverId: driverId ?? this.driverId,
            driverName: driverName ?? this.driverName,
            driverCode: driverCode ?? this.driverCode,
        );

    factory Student.fromJson(Map<String, dynamic> json) => Student(
        studentId: json["student_id"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        studentName: json["student_name"],
        proposedFee: json["proposed_fee"],
        accountActive: json["account_active"],
        driverId: json["driver_id"],
        driverName: json["driver_name"],
        driverCode: json["driver_code"],
    );

    Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "phone_number": phoneNumber,
        "email": email,
        "student_name": studentName,
        "proposed_fee": proposedFee,
        "account_active": accountActive,
        "driver_id": driverId,
        "driver_name": driverName,
        "driver_code": driverCode,
    };
}
