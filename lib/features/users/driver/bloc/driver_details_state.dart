import 'package:equatable/equatable.dart';
import '../model/driver_details_response.dart';

class DriverDetailsState extends Equatable {
  final Data? driverDetails;
  final bool isLoading;
  final int selectedTab;
  final int driverId;

  const DriverDetailsState({
    this.driverDetails,
    this.isLoading = false,
    this.selectedTab = 0,
    this.driverId = 0,
  });

  DriverDetailsState copyWith({
    Data? driverDetails,
    bool? isLoading,
    int? selectedTab,
    int? driverId,
  }) {
    return DriverDetailsState(
      driverDetails: driverDetails ?? this.driverDetails,
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      driverId: driverId ?? this.driverId,
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
  List<Object?> get props => [driverDetails, isLoading, selectedTab, driverId];
}
