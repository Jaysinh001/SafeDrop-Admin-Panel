import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_layout_event.dart';
import 'admin_layout_state.dart';
import '../../widgets/screen_container.dart';
import '../../../core/routes/route.dart';

class AdminLayoutBloc extends Bloc<AdminLayoutEvent, AdminLayoutState> {
  AdminLayoutBloc() : super(const AdminLayoutState()) {
    on<AdminLayoutScreenSizeUpdated>(_onScreenSizeUpdated);
    on<AdminLayoutSidebarVisibilityToggled>(_onSidebarVisibilityToggled);
    on<AdminLayoutSidebarExpansionToggled>(_onSidebarExpansionToggled);
    on<AdminLayoutPageNavigated>(_onPageNavigated);
  }

  void _onScreenSizeUpdated(
    AdminLayoutScreenSizeUpdated event,
    Emitter<AdminLayoutState> emit,
  ) {
    ScreenSize newScreenSize;
    if (event.width < 768) {
      newScreenSize = ScreenSize.mobile;
    } else if (event.width < 1024) {
      newScreenSize = ScreenSize.tablet;
    } else {
      newScreenSize = ScreenSize.desktop;
    }

    if (newScreenSize == state.screenSize) return;

    switch (newScreenSize) {
      case ScreenSize.mobile:
        emit(
          state.copyWith(
            screenSize: newScreenSize,
            isSidebarVisible: false,
            isSidebarExpanded: false,
          ),
        );
        break;
      case ScreenSize.tablet:
        emit(
          state.copyWith(
            screenSize: newScreenSize,
            isSidebarVisible: true,
            isSidebarExpanded: false,
          ),
        );
        break;
      case ScreenSize.desktop:
        emit(
          state.copyWith(
            screenSize: newScreenSize,
            isSidebarVisible: true,
            isSidebarExpanded: true,
          ),
        );
        break;
    }
  }

  void _onSidebarVisibilityToggled(
    AdminLayoutSidebarVisibilityToggled event,
    Emitter<AdminLayoutState> emit,
  ) {
    emit(state.copyWith(isSidebarVisible: !state.isSidebarVisible));
  }

  void _onSidebarExpansionToggled(
    AdminLayoutSidebarExpansionToggled event,
    Emitter<AdminLayoutState> emit,
  ) {
    if (state.screenSize != ScreenSize.mobile) {
      emit(state.copyWith(isSidebarExpanded: !state.isSidebarExpanded));
    }
  }

  void _onPageNavigated(
    AdminLayoutPageNavigated event,
    Emitter<AdminLayoutState> emit,
  ) {
    emit(
      state.copyWith(
        currentPageIndex: event.index,
        currentPageTitle: event.title,
        breadcrumbs: event.breadcrumbs ?? ['Home', event.title],
        // Close sidebar on mobile after navigation
        isSidebarVisible:
            state.screenSize == ScreenSize.mobile
                ? false
                : state.isSidebarVisible,
      ),
    );

    AppPages.router.go(event.route);
  }
}
