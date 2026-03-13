import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/data/local_storage/local_storage_service.dart';
import '../../repo/driver_repository.dart';
import 'driver_details_state.dart';
import 'driver_details_event.dart';

class DriverDetailsBloc extends Bloc<DriverDetailsEvent, DriverDetailsState> {
  final DriverRepository driverRepository;
  final LocalStorageService storage;

  final List<String> tabTitles = [
    'Overview',
    'Wallet',
    'Bank Details',
    'Vehicles',
    'Activity',
  ];

  DriverDetailsBloc({required this.driverRepository, required this.storage})
    : super(const DriverDetailsState()) {
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

    emit(state.copyWith(status: DriverDetailStatus.loading));

    try {
      final response = await driverRepository.getDriverDetails(
        state.driverId.toString(),
      );

      if (response.success == true) {
        emit(
          state.copyWith(
            driverDetails: response.data?.data,
            status: DriverDetailStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DriverDetailStatus.error,
            errorMessage: response.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: DriverDetailStatus.error,
          errorMessage: e.toString(),
        ),
      );
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
    emit(state.copyWith(showSuspendConfirmation: true));
  }

  void _onContactRequested(
    DriverDetailsContactRequested event,
    Emitter<DriverDetailsState> emit,
  ) {
    final phoneNumber = state.driver?.phoneNumber;
    if (phoneNumber != null) {
      emit(state.copyWith(contactPhoneNumber: phoneNumber));
    }
  }

  void _onNotificationRequested(
    DriverDetailsNotificationRequested event,
    Emitter<DriverDetailsState> emit,
  ) {
    emit(state.copyWith(showNotificationSent: true));
  }

  void clearMessages(Emitter<DriverDetailsState> emit) {
    emit(
      state.copyWith(
        showSuspendConfirmation: false,
        showNotificationSent: false,
        contactPhoneNumber: null,
        errorMessage: null,
      ),
    );
  }
}
