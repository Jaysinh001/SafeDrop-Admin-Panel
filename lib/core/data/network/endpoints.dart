class ApiEndpoints {
  static const String baseUrl = "https://inner-lexi-jcdev-21a99e33.koyeb.app/api/v1";
  // static const String baseUrl = "http://127.0.0.1:8000/api/v1";

  static const String loginApi = "$baseUrl/auth/login/password";
  static const String refreshTokenApi = "$baseUrl/auth/refresh";

  static const String studentsList = "/protected/org/allStudents";
  static String studentDetails(String studentId) => "/protected/org/studentDetails/$studentId";
  static const String generateNextPayment = "/protected/org/generateNextPayment";

  static const String driversList = "/protected/org/allDrivers";
  static String driverDetails(String driverId) => "/protected/org/driverDetails/$driverId";




  // static const String withdrawals = "/admin/withdrawals";
  // static const String settings = "/admin/settings";
}