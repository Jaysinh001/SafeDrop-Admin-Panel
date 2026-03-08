import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/org_member_model.dart';
import '../data/models/permission_group_model.dart';
import '../data/models/role_model.dart';
import '../data/repositories/rbac_repository.dart';
import 'rbac_event.dart';
import 'rbac_state.dart';

class RbacBloc extends Bloc<RbacEvent, RbacState> {
  final RbacRepository repository;

  RbacBloc({required this.repository}) : super(const RbacState()) {
    on<LoadRbacDashboard>(_onLoadRbacDashboard);
    on<LoadAllPermissions>(_onLoadAllPermissions);
    on<CreatePermissionGroup>(_onCreatePermissionGroup);
    on<UpdatePermissionGroup>(_onUpdatePermissionGroup);
    on<DeletePermissionGroup>(_onDeletePermissionGroup);
    on<SaveGroupPolicies>(_onSaveGroupPolicies);
    on<AssignGroupToMember>(_onAssignGroupToMember);
    on<CreateRole>(_onCreateRole);
    on<UpdateRole>(_onUpdateRole);
    on<DeleteRole>(_onDeleteRole);
    on<SaveRolePermissions>(_onSaveRolePermissions);
    on<AssignRoleToMember>(_onAssignRoleToMember);
    on<SelectGroup>(_onSelectGroup);
    on<SelectRole>(_onSelectRole);
    on<SelectMember>(_onSelectMember);
    on<AddUserPermissionOverride>(_onAddUserPermissionOverride);
    on<RemoveUserPermissionOverride>(_onRemoveUserPermissionOverride);
    on<SearchMembers>(_onSearchMembers);
    on<FilterByModule>(_onFilterByModule);
    on<ClearMessages>(_onClearMessages);
  }

  Future<void> _onLoadRbacDashboard(
    LoadRbacDashboard event,
    Emitter<RbacState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoadingGroups: true,
        isLoadingRoles: true,
        isLoadingMembers: true,
        error: null,
      ),
    );

    try {
      final results = await Future.wait([
        repository.getPermissionGroups(),
        repository.getRoles(),
        repository.getMembers(),
      ]);

      emit(
        state.copyWith(
          isLoadingGroups: false,
          isLoadingRoles: false,
          isLoadingMembers: false,
          groups: results[0] as List<PermissionGroupModel>,
          roles: results[1] as List<RoleModel>,
          members: results[2] as List<OrgMemberModel>,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingGroups: false,
          isLoadingRoles: false,
          isLoadingMembers: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadAllPermissions(
    LoadAllPermissions event,
    Emitter<RbacState> emit,
  ) async {
    emit(state.copyWith(isLoadingPermissions: true, error: null));
    try {
      final permissions = await repository.getAllPermissions();
      emit(
        state.copyWith(
          isLoadingPermissions: false,
          allPermissions: permissions,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingPermissions: false, error: e.toString()));
    }
  }

  Future<void> _onCreatePermissionGroup(
    CreatePermissionGroup event,
    Emitter<RbacState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.createPermissionGroup(event.name, event.description);
      final groups = await repository.getPermissionGroups();
      emit(
        state.copyWith(
          isSaving: false,
          groups: groups,
          successMessage: 'Group created successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> _onUpdatePermissionGroup(
    UpdatePermissionGroup event,
    Emitter<RbacState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.updatePermissionGroup(
        event.id,
        event.name,
        event.description,
      );
      final groups = await repository.getPermissionGroups();
      emit(
        state.copyWith(
          isSaving: false,
          groups: groups,
          successMessage: 'Group updated successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> _onDeletePermissionGroup(
    DeletePermissionGroup event,
    Emitter<RbacState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.deletePermissionGroup(event.id);
      final groups = await repository.getPermissionGroups();
      emit(
        state.copyWith(
          isSaving: false,
          groups: groups,
          successMessage: 'Group deleted successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> _onSaveGroupPolicies(
    SaveGroupPolicies event,
    Emitter<RbacState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.saveGroupPolicies(event.groupId, event.policies);
      final group = await repository.getGroupDetail(event.groupId);
      final groups =
          state.groups.map((g) => g.id == event.groupId ? group : g).toList();
      emit(
        state.copyWith(
          isSaving: false,
          groups: groups,
          selectedGroup: group,
          successMessage: 'Policies saved successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> _onAssignGroupToMember(
    AssignGroupToMember event,
    Emitter<RbacState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.assignGroupToMember(event.groupId, event.orgUserId);
      final members = await repository.getMembers();
      emit(
        state.copyWith(
          isSaving: false,
          members: members,
          successMessage: 'Group assigned successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> _onCreateRole(CreateRole event, Emitter<RbacState> emit) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.createRole(event.name);
      final roles = await repository.getRoles();
      emit(
        state.copyWith(
          isSaving: false,
          roles: roles,
          successMessage: 'Role created successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateRole(UpdateRole event, Emitter<RbacState> emit) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.updateRole(event.id, event.name);
      final roles = await repository.getRoles();
      emit(
        state.copyWith(
          isSaving: false,
          roles: roles,
          successMessage: 'Role updated successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteRole(DeleteRole event, Emitter<RbacState> emit) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.deleteRole(event.id);
      final roles = await repository.getRoles();
      emit(
        state.copyWith(
          isSaving: false,
          roles: roles,
          successMessage: 'Role deleted successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> _onSaveRolePermissions(
    SaveRolePermissions event,
    Emitter<RbacState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.saveRolePermissions(event.roleId, event.permissionIds);
      final role = await repository.getRoleDetail(event.roleId);
      final roles =
          state.roles.map((r) => r.id == event.roleId ? role : r).toList();
      emit(
        state.copyWith(
          isSaving: false,
          roles: roles,
          selectedRole: role,
          successMessage: 'Permissions saved successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> _onAssignRoleToMember(
    AssignRoleToMember event,
    Emitter<RbacState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.assignRoleToMember(event.roleId, event.orgUserId);
      final members = await repository.getMembers();
      emit(
        state.copyWith(
          isSaving: false,
          members: members,
          successMessage: 'Role assigned successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  void _onSelectGroup(SelectGroup event, Emitter<RbacState> emit) {
    final group = state.groups.firstWhere((g) => g.id == event.groupId);
    emit(state.copyWith(selectedGroup: group));
  }

  void _onSelectRole(SelectRole event, Emitter<RbacState> emit) {
    final role = state.roles.firstWhere((r) => r.id == event.roleId);
    emit(state.copyWith(selectedRole: role));
  }

  Future<void> _onSelectMember(
    SelectMember event,
    Emitter<RbacState> emit,
  ) async {
    final member = state.members.firstWhere(
      (m) => m.organizationUserId == event.orgUserId,
    );
    emit(
      state.copyWith(
        selectedMember: member,
        isLoadingPermissions: true,
        error: null,
      ),
    );

    try {
      final permissions = await repository.getMemberPermissions(
        event.orgUserId,
      );
      emit(
        state.copyWith(
          isLoadingPermissions: false,
          selectedMemberPermissions: permissions,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingPermissions: false, error: e.toString()));
    }
  }

  Future<void> _onAddUserPermissionOverride(
    AddUserPermissionOverride event,
    Emitter<RbacState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.addUserOverride(
        event.orgUserId,
        event.permissionId,
        event.allowed,
      );
      final permissions = await repository.getMemberPermissions(
        event.orgUserId,
      );
      emit(
        state.copyWith(
          isSaving: false,
          selectedMemberPermissions: permissions,
          successMessage: 'Override added successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> _onRemoveUserPermissionOverride(
    RemoveUserPermissionOverride event,
    Emitter<RbacState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      await repository.removeUserOverride(event.orgUserId, event.permissionId);
      final permissions = await repository.getMemberPermissions(
        event.orgUserId,
      );
      emit(
        state.copyWith(
          isSaving: false,
          selectedMemberPermissions: permissions,
          successMessage: 'Override removed successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  void _onSearchMembers(SearchMembers event, Emitter<RbacState> emit) {
    emit(state.copyWith(memberSearchQuery: event.query));
  }

  void _onFilterByModule(FilterByModule event, Emitter<RbacState> emit) {
    if (event.module == null || event.module == 'All') {
      emit(state.copyWith(clearModuleFilter: true));
    } else {
      emit(state.copyWith(selectedModuleFilter: event.module));
    }
  }

  void _onClearMessages(ClearMessages event, Emitter<RbacState> emit) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
}
