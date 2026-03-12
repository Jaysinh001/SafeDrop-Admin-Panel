import 'package:equatable/equatable.dart';
import '../../model/driver_details_response.dart';

enum DriverDetailStatus { initial, loading, error, success }

class DriverDetailsState extends Equatable {
  final DriverDetailStatus status;
  final Data? driverDetails;
  final int selectedTab;
  final int driverId;
  final bool showSuspendConfirmation;
  final bool showNotificationSent;
  final String? contactPhoneNumber;
  final String? errorMessage;

  const DriverDetailsState({
    this.status = DriverDetailStatus.initial,
    this.driverDetails,
    this.selectedTab = 0,
    this.driverId = 0,
    this.showSuspendConfirmation = false,
    this.showNotificationSent = false,
    this.contactPhoneNumber,
    this.errorMessage,
  });

  DriverDetailsState copyWith({
    Data? driverDetails,
    DriverDetailStatus? status,
    int? selectedTab,
    int? driverId,
    bool? showSuspendConfirmation,
    bool? showNotificationSent,
    String? contactPhoneNumber,
    String? errorMessage,
  }) {
    return DriverDetailsState(
      driverDetails: driverDetails ?? this.driverDetails,
      status: status ?? this.status,
      selectedTab: selectedTab ?? this.selectedTab,
      driverId: driverId ?? this.driverId,
      showSuspendConfirmation: showSuspendConfirmation ?? this.showSuspendConfirmation,
      showNotificationSent: showNotificationSent ?? this.showNotificationSent,
      contactPhoneNumber: contactPhoneNumber ?? this.contactPhoneNumber,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Driver? get driver => driverDetails?.driver;
  Wallet? get wallet => driverDetails?.wallet;
  List<BankDetail> get bankDetails => driverDetails?.bankDetails ?? [];
  List<Vehicle> get vehicles => driverDetails?.vehicles ?? [];
  UniqueCode? get uniqueCode => driverDetails?.uniqueCode;
  FcmToken? get fcmToken => driverDetails?.fcmToken;

  String get driverStatus {
    if (driver?.hasBankDetails == true && driver?.mpinSet == true) {
      return 'Active';
    } else if (driver?.hasBankDetails == true || driver?.mpinSet == true) {
      return 'Incomplete Setup';
    } else {
      return 'Inactive';
    }
  }

  @override
  List<Object?> get props => [
    driverDetails,
    status,
    selectedTab,
    driverId,
    showSuspendConfirmation,
    showNotificationSent,
    contactPhoneNumber,
    errorMessage,
  ];
}