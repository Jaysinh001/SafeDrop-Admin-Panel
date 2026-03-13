import 'dart:convert';

class EmployeeListResponse {
    final bool? success;
    final String? message;
    final List<Datum>? data;
    final Pagination? pagination;

    EmployeeListResponse({
        this.success,
        this.message,
        this.data,
        this.pagination,
    });

    EmployeeListResponse copyWith({
        bool? success,
        String? message,
        List<Datum>? data,
        Pagination? pagination,
    }) => 
        EmployeeListResponse(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
            pagination: pagination ?? this.pagination,
        );

    factory EmployeeListResponse.fromRawJson(String str) => EmployeeListResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EmployeeListResponse.fromJson(Map<String, dynamic> json) => EmployeeListResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class Datum {
    final int? id;
    final String? firstName;
    final String? lastName;
    final String? email;
    final String? phoneNumber;
    final String? departmentName;
    final String? designation;
    final String? employmentType;
    final String? status;
    final DateTime? joinDate;
    final DateTime? dateOfBirth;
    final String? gender;
    final String? address;
    final String? city;
    final String? state;
    final String? pinCode;
    final String? profilePicture;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Datum({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phoneNumber,
        this.departmentName,
        this.designation,
        this.employmentType,
        this.status,
        this.joinDate,
        this.dateOfBirth,
        this.gender,
        this.address,
        this.city,
        this.state,
        this.pinCode,
        this.profilePicture,
        this.createdAt,
        this.updatedAt,
    });

    Datum copyWith({
        int? id,
        String? firstName,
        String? lastName,
        String? email,
        String? phoneNumber,
        String? departmentName,
        String? designation,
        String? employmentType,
        String? status,
        DateTime? joinDate,
        DateTime? dateOfBirth,
        String? gender,
        String? address,
        String? city,
        String? state,
        String? pinCode,
        String? profilePicture,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            email: email ?? this.email,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            departmentName: departmentName ?? this.departmentName,
            designation: designation ?? this.designation,
            employmentType: employmentType ?? this.employmentType,
            status: status ?? this.status,
            joinDate: joinDate ?? this.joinDate,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            gender: gender ?? this.gender,
            address: address ?? this.address,
            city: city ?? this.city,
            state: state ?? this.state,
            pinCode: pinCode ?? this.pinCode,
            profilePicture: profilePicture ?? this.profilePicture,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        departmentName: json["departmentName"],
        designation: json["designation"],
        employmentType: json["employmentType"],
        status: json["status"],
        joinDate: json["joinDate"] == null ? null : DateTime.parse(json["joinDate"]),
        dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
        gender: json["gender"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        pinCode: json["pinCode"],
        profilePicture: json["profilePicture"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "departmentName": departmentName,
        "designation": designation,
        "employmentType": employmentType,
        "status": status,
        "joinDate": joinDate?.toIso8601String(),
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "gender": gender,
        "address": address,
        "city": city,
        "state": state,
        "pinCode": pinCode,
        "profilePicture": profilePicture,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}

class Pagination {
    final int? currentPage;
    final int? pageSize;
    final int? totalPages;
    final int? totalRecords;
    final bool? hasNextPage;
    final bool? hasPreviousPage;

    Pagination({
        this.currentPage,
        this.pageSize,
        this.totalPages,
        this.totalRecords,
        this.hasNextPage,
        this.hasPreviousPage,
    });

    Pagination copyWith({
        int? currentPage,
        int? pageSize,
        int? totalPages,
        int? totalRecords,
        bool? hasNextPage,
        bool? hasPreviousPage,
    }) => 
        Pagination(
            currentPage: currentPage ?? this.currentPage,
            pageSize: pageSize ?? this.pageSize,
            totalPages: totalPages ?? this.totalPages,
            totalRecords: totalRecords ?? this.totalRecords,
            hasNextPage: hasNextPage ?? this.hasNextPage,
            hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
        );

    factory Pagination.fromRawJson(String str) => Pagination.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["currentPage"],
        pageSize: json["pageSize"],
        totalPages: json["totalPages"],
        totalRecords: json["totalRecords"],
        hasNextPage: json["hasNextPage"],
        hasPreviousPage: json["hasPreviousPage"],
    );

    Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "pageSize": pageSize,
        "totalPages": totalPages,
        "totalRecords": totalRecords,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
    };
}
