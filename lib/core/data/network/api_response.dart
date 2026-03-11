class ApiResponse<T> {
  final bool success;
  final String code;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse(
      success: json["success"],
      code: json["code"],
      message: json["message"],
      data: fromJsonT != null ? fromJsonT(json["data"]) : json["data"],
    );
  }
}