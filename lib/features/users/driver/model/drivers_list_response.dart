// To parse this JSON data, do
//
//     final driversListResponse = driversListResponseFromJson(jsonString);

import 'dart:convert';

DriversListResponse driversListResponseFromJson(String str) => DriversListResponse.fromJson(json.decode(str));

String driversListResponseToJson(DriversListResponse data) => json.encode(data.toJson());

class DriversListResponse {
    final String? code;
    final Data? data;
    final String? message;
    final bool? success;

    DriversListResponse({
        this.code,
        this.data,
        this.message,
        this.success,
    });

    DriversListResponse copyWith({
        String? code,
        Data? data,
        String? message,
        bool? success,
    }) => 
        DriversListResponse(
            code: code ?? this.code,
            data: data ?? this.data,
            message: message ?? this.message,
            success: success ?? this.success,
        );

    factory DriversListResponse.fromJson(Map<String, dynamic> json) => DriversListResponse(
        code: json["code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "data": data?.toJson(),
        "message": message,
        "success": success,
    };
}

class Data {
    final List<Item>? items;
    final Pagination? pagination;

    Data({
        this.items,
        this.pagination,
    });

    Data copyWith({
        List<Item>? items,
        Pagination? pagination,
    }) => 
        Data(
            items: items ?? this.items,
            pagination: pagination ?? this.pagination,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class Item {
    final int? id;
    final int? userId;
    final String? name;
    final String? email;
    final String? phone;
    final bool? isIndependent;
    final String? employmentStatus;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Item({
        this.id,
        this.userId,
        this.name,
        this.email,
        this.phone,
        this.isIndependent,
        this.employmentStatus,
        this.createdAt,
        this.updatedAt,
    });

    Item copyWith({
        int? id,
        int? userId,
        String? name,
        String? email,
        String? phone,
        bool? isIndependent,
        String? employmentStatus,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Item(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            name: name ?? this.name,
            email: email ?? this.email,
            phone: phone ?? this.phone,
            isIndependent: isIndependent ?? this.isIndependent,
            employmentStatus: employmentStatus ?? this.employmentStatus,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        isIndependent: json["is_independent"],
        employmentStatus: json["employment_status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "email": email,
        "phone": phone,
        "is_independent": isIndependent,
        "employment_status": employmentStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Pagination {
    final int? page;
    final int? limit;
    final int? totalItems;
    final int? totalPages;
    final bool? hasNext;
    final bool? hasPrev;

    Pagination({
        this.page,
        this.limit,
        this.totalItems,
        this.totalPages,
        this.hasNext,
        this.hasPrev,
    });

    Pagination copyWith({
        int? page,
        int? limit,
        int? totalItems,
        int? totalPages,
        bool? hasNext,
        bool? hasPrev,
    }) => 
        Pagination(
            page: page ?? this.page,
            limit: limit ?? this.limit,
            totalItems: totalItems ?? this.totalItems,
            totalPages: totalPages ?? this.totalPages,
            hasNext: hasNext ?? this.hasNext,
            hasPrev: hasPrev ?? this.hasPrev,
        );

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        limit: json["limit"],
        totalItems: json["total_items"],
        totalPages: json["total_pages"],
        hasNext: json["has_next"],
        hasPrev: json["has_prev"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total_items": totalItems,
        "total_pages": totalPages,
        "has_next": hasNext,
        "has_prev": hasPrev,
    };
}
