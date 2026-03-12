class ApiEndpoints {
  static const String baseUrl = "https://inner-lexi-jcdev-21a99e33.koyeb.app/api/v1";

  static const String loginApi = "$baseUrl/auth/login/password";
  static const String refreshTokenApi = "$baseUrl/auth/refresh";

  static const String studentsList = "/org/allStudents";
  static String studentDetails(String studentId) => "/org/studentDetails/$studentId";
  static const String generateNextPayment = "/org/generateNextPayment";

  static const String driversList = "/org/allDrivers";
  static String driverDetails(String driverId) => "/org/driverDetails/$driverId";




  // static const String withdrawals = "/admin/withdrawals";
  // static const String settings = "/admin/settings";
}