// =============================================================================
// ROUTE NAMES - Centralized route constants
// =============================================================================

abstract class AppRoutes {
  // Authentication Routes
  static const splash = '/';
  static const login = '/login';

  // Main App Routes
  static const dashboard = '/dashboard';
  static const mainLayout = '/main';

  // Finance Routes
  static const withdrawals = '/withdrawals';
  static const transactions = '/transactions';
  static const transactionDetails = '/transactionDetails';

  // Users Routes
  static const driversList = '/driversList';
  static const driverDetails = '/driverDetails';
  static const studentsList = '/studentsList';
  static const studentDetails = '/studentDetails';
  static const addDuePayment = '/addDuePayment';

  // Admin Panel Routes
  static const adminDashboard = '/admin';
  static const userManagement = '/admin/users';
  static const analytics = '/admin/analytics';
  static const settings = '/admin/settings';
  static const reports = '/admin/reports';

  // Content Management Routes
  static const content = '/content';
  static const contentList = '/content/list';
  static const createContent = '/content/create';
  static const mediaLibrary = '/content/media';

  // Error Routes
  static const notFound = '/404';
  static const unauthorized = '/401';
  static const serverError = '/500';
}
