import 'package:equatable/equatable.dart';
import '../data/models/permission_model.dart';
import '../data/models/permission_group_model.dart';
import '../data/models/role_model.dart';
import '../data/models/org_member_model.dart';

class RbacState extends Equatable {
  final bool isLoadingGroups;
  final bool isLoadingRoles;
  final bool isLoadingMembers;
  final bool isLoadingPermissions;
  final bool isSaving;

  final List<PermissionGroupModel> groups;
  final List<RoleModel> roles;
  final List<OrgMemberModel> members;
  final List<PermissionModel> allPermissions;

  final PermissionGroupModel? selectedGroup;
  final RoleModel? selectedRole;
  final OrgMemberModel? selectedMember;
  final List<ResolvedPermission> selectedMemberPermissions;

  final String? error;
  final String? successMessage;

  final String memberSearchQuery;
  final String? selectedModuleFilter;

  const RbacState({
    this.isLoadingGroups = false,
    this.isLoadingRoles = false,
    this.isLoadingMembers = false,
    this.isLoadingPermissions = false,
    this.isSaving = false,
    this.groups = const [],
    this.roles = const [],
    this.members = const [],
    this.allPermissions = const [],
    this.selectedGroup,
    this.selectedRole,
    this.selectedMember,
    this.selectedMemberPermissions = const [],
    this.error,
    this.successMessage,
    this.memberSearchQuery = '',
    this.selectedModuleFilter,
  });

  RbacState copyWith({
    bool? isLoadingGroups,
    bool? isLoadingRoles,
    bool? isLoadingMembers,
    bool? isLoadingPermissions,
    bool? isSaving,
    List<PermissionGroupModel>? groups,
    List<RoleModel>? roles,
    List<OrgMemberModel>? members,
    List<PermissionModel>? allPermissions,
    PermissionGroupModel? selectedGroup,
    RoleModel? selectedRole,
    OrgMemberModel? selectedMember,
    List<ResolvedPermission>? selectedMemberPermissions,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
    String? memberSearchQuery,
    String? selectedModuleFilter,
    bool clearModuleFilter = false,
  }) {
    return RbacState(
      isLoadingGroups: isLoadingGroups ?? this.isLoadingGroups,
      isLoadingRoles: isLoadingRoles ?? this.isLoadingRoles,
      isLoadingMembers: isLoadingMembers ?? this.isLoadingMembers,
      isLoadingPermissions: isLoadingPermissions ?? this.isLoadingPermissions,
      isSaving: isSaving ?? this.isSaving,
      groups: groups ?? this.groups,
      roles: roles ?? this.roles,
      members: members ?? this.members,
      allPermissions: allPermissions ?? this.allPermissions,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      selectedRole: selectedRole ?? this.selectedRole,
      selectedMember: selectedMember ?? this.selectedMember,
      selectedMemberPermissions:
          selectedMemberPermissions ?? this.selectedMemberPermissions,
      error: clearError ? null : (error ?? this.error),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      memberSearchQuery: memberSearchQuery ?? this.memberSearchQuery,
      selectedModuleFilter:
          clearModuleFilter
              ? null
              : (selectedModuleFilter ?? this.selectedModuleFilter),
    );
  }

  List<OrgMemberModel> get filteredMembers {
    if (memberSearchQuery.isEmpty) return members;
    return members
        .where(
          (m) =>
              m.name.toLowerCase().contains(memberSearchQuery.toLowerCase()) ||
              m.email.toLowerCase().contains(memberSearchQuery.toLowerCase()),
        )
        .toList();
  }

  List<PermissionModel> get filteredPermissions {
    if (selectedModuleFilter == null || selectedModuleFilter == 'All') {
      return allPermissions;
    }
    return allPermissions
        .where((p) => p.module == selectedModuleFilter)
        .toList();
  }

  List<String> get modules {
    final set = allPermissions.map((p) => p.module).toSet();
    return ['All', ...set.toList()..sort()];
  }

  @override
  List<Object?> get props => [
    isLoadingGroups,
    isLoadingRoles,
    isLoadingMembers,
    isLoadingPermissions,
    isSaving,
    groups,
    roles,
    members,
    allPermissions,
    selectedGroup,
    selectedRole,
    selectedMember,
    selectedMemberPermissions,
    error,
    successMessage,
    memberSearchQuery,
    selectedModuleFilter,
  ];
}
