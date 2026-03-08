import 'package:equatable/equatable.dart';

import '../../widgets/screen_container.dart';

class AdminLayoutState extends Equatable {
  final bool isSidebarExpanded;
  final bool isSidebarVisible;
  final int currentPageIndex;
  final String currentPageTitle;
  final List<String> breadcrumbs;
  final ScreenSize screenSize;

  const AdminLayoutState({
    this.isSidebarExpanded = true,
    this.isSidebarVisible = true,
    this.currentPageIndex = 0,
    this.currentPageTitle = 'Dashboard',
    this.breadcrumbs = const ['Home', 'Dashboard'],
    this.screenSize = ScreenSize.desktop,
  });

  AdminLayoutState copyWith({
    bool? isSidebarExpanded,
    bool? isSidebarVisible,
    int? currentPageIndex,
    String? currentPageTitle,
    List<String>? breadcrumbs,
    ScreenSize? screenSize,
  }) {
    return AdminLayoutState(
      isSidebarExpanded: isSidebarExpanded ?? this.isSidebarExpanded,
      isSidebarVisible: isSidebarVisible ?? this.isSidebarVisible,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      currentPageTitle: currentPageTitle ?? this.currentPageTitle,
      breadcrumbs: breadcrumbs ?? this.breadcrumbs,
      screenSize: screenSize ?? this.screenSize,
    );
  }

  @override
  List<Object> get props => [
    isSidebarExpanded,
    isSidebarVisible,
    currentPageIndex,
    currentPageTitle,
    breadcrumbs,
    screenSize,
  ];
}
