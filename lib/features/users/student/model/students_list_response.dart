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
