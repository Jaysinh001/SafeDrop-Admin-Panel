import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/colors.dart';
import '../../widgets/screen_container.dart';
import '../bloc/admin_layout_bloc.dart';
import '../bloc/admin_layout_event.dart';
import '../bloc/admin_layout_state.dart';
import 'admin_layout_appbar_view.dart';
import 'admin_sidebar_view.dart';
import '../../../core/dependencies/injection_container.dart';

// =============================================================================
// MAIN ADMIN PANEL LAYOUT
// =============================================================================

class AdminPanelLayout extends StatelessWidget {
  final Widget child;

  const AdminPanelLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AdminLayoutBloc>(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Update bloc with current screen size
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final width = MediaQuery.of(context).size.width;
            sl<AdminLayoutBloc>().add(AdminLayoutScreenSizeUpdated(width));
          });

          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  // Sidebar Navigation
                  BlocBuilder<AdminLayoutBloc, AdminLayoutState>(
                    buildWhen:
                        (previous, current) =>
                            previous.isSidebarVisible !=
                                current.isSidebarVisible ||
                            previous.isSidebarExpanded !=
                                current.isSidebarExpanded ||
                            previous.currentPageIndex !=
                                current.currentPageIndex ||
                            previous.screenSize != current.screenSize,
                    builder: (context, state) {
                      return state.isSidebarVisible
                          ? AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width: state.isSidebarExpanded ? 280 : 90,
                            child: AdminSideBar(
                              isExpanded: state.isSidebarExpanded,
                              onToggleExpansion:
                                  () => context.read<AdminLayoutBloc>().add(
                                    AdminLayoutSidebarExpansionToggled(),
                                  ),
                              onNavigate:
                                  (index, title, route, {breadcrumbs}) =>
                                      context.read<AdminLayoutBloc>().add(
                                        AdminLayoutPageNavigated(
                                          index: index,
                                          title: title,
                                          route: route,
                                          breadcrumbs: breadcrumbs,
                                        ),
                                      ),
                              currentPageIndex: state.currentPageIndex,
                              screenSize: state.screenSize,
                            ),
                          )
                          : const SizedBox.shrink();
                    },
                  ),

                  // Main Content Area
                  Expanded(
                    child: Column(
                      children: [
                        // Top App Bar
                        const AdminAppBar(),

                        // Main Content
                        Expanded(
                          child: Container(
                            color: AppColors.background,
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
