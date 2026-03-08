import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:safedrop_panel/core/services/network_services_api.dart';

import '../model/driver_details_response.dart';
import 'driver_details_event.dart';
import 'driver_details_state.dart';

class DriverDetailsBloc extends Bloc<DriverDetailsEvent, DriverDetailsState> {
  final List<String> tabTitles = [
    'Overview',
    'Wallet',
    'Bank Details',
    'Vehicles',
    'Activity',
  ];

  DriverDetailsBloc() : super(const DriverDetailsState()) {
    on<DriverDetailsLoaded>(_onLoaded);
    on<DriverDetailsRefreshed>(_onRefreshed);
    on<DriverDetailsTabChanged>(_onTabChanged);
    on<DriverDetailsSuspendRequested>(_onSuspendRequested);
    on<DriverDetailsContactRequested>(_onContactRequested);
    on<DriverDetailsNotificationRequested>(_onNotificationRequested);
  }

  Future<void> _onLoaded(
    DriverDetailsLoaded event,
    Emitter<DriverDetailsState> emit,
  ) async {
    if (event.driverId != null) {
      emit(state.copyWith(driverId: event.driverId));
    }
    await _fetchData(emit);
  }

  Future<void> _onRefreshed(
    DriverDetailsRefreshed event,
    Emitter<DriverDetailsState> emit,
  ) async {
    await _fetchData(emit);
  }

  Future<void> _fetchData(Emitter<DriverDetailsState> emit) async {
    if (state.driverId == 0) return;

    emit(state.copyWith(isLoading: true));

    try {
      final res = await NetworkServicesApi().getApi(
        path: 'driver/details/${state.driverId}',
      );

      final response = driversDetailsResponseFromJson(res);
      emit(state.copyWith(driverDetails: response.data, isLoading: false));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load driver details: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onTabChanged(
    DriverDetailsTabChanged event,
    Emitter<DriverDetailsState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.index));
  }

  void _onSuspendRequested(
    DriverDetailsSuspendRequested event,
    Emitter<DriverDetailsState> emit,
  ) {
    Get.defaultDialog(
      title: 'Suspend Driver',
      middleText: 'Are you sure you want to suspend this driver?',
      textConfirm: 'Suspend',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        Get.snackbar('Success', 'Driver suspended successfully');
      },
    );
  }

  void _onContactRequested(
    DriverDetailsContactRequested event,
    Emitter<DriverDetailsState> emit,
  ) {
    final phoneNumber = state.driver?.phoneNumber;
    if (phoneNumber != null) {
      // GetPlatform.isWeb ? Get.snackbar('Contact', 'Calling $phoneNumber...') : null;
    }
  }

  void _onNotificationRequested(
    DriverDetailsNotificationRequested event,
    Emitter<DriverDetailsState> emit,
  ) {
    Get.snackbar('Notification', 'Notification sent to driver');
  }
}
