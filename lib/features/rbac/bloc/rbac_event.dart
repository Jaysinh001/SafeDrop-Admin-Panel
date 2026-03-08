import 'package:equatable/equatable.dart';
import '../data/repositories/rbac_repository.dart';

abstract class RbacEvent extends Equatable {
  const RbacEvent();

  @override
  List<Object?> get props => [];
}

class LoadRbacDashboard extends RbacEvent {}

class LoadAllPermissions extends RbacEvent {}

class CreatePermissionGroup extends RbacEvent {
  final String name;
  final String description;
  const CreatePermissionGroup(this.name, this.description);
  @override
  List<Object?> get props => [name, description];
}

class UpdatePermissionGroup extends RbacEvent {
  final int id;
  final String name;
  final String description;
  const UpdatePermissionGroup(this.id, this.name, this.description);
  @override
  List<Object?> get props => [id, name, description];
}

class DeletePermissionGroup extends RbacEvent {
  final int id;
  const DeletePermissionGroup(this.id);
  @override
  List<Object?> get props => [id];
}

class SaveGroupPolicies extends RbacEvent {
  final int groupId;
  final List<PolicyInput> policies;
  const SaveGroupPolicies(this.groupId, this.policies);
  @override
  List<Object?> get props => [groupId, policies];
}

class AssignGroupToMember extends RbacEvent {
  final int groupId;
  final int orgUserId;
  const AssignGroupToMember(this.groupId, this.orgUserId);
  @override
  List<Object?> get props => [groupId, orgUserId];
}

class CreateRole extends RbacEvent {
  final String name;
  const CreateRole(this.name);
  @override
  List<Object?> get props => [name];
}

class UpdateRole extends RbacEvent {
  final int id;
  final String name;
  const UpdateRole(this.id, this.name);
  @override
  List<Object?> get props => [id, name];
}

class DeleteRole extends RbacEvent {
  final int id;
  const DeleteRole(this.id);
  @override
  List<Object?> get props => [id];
}

class SaveRolePermissions extends RbacEvent {
  final int roleId;
  final List<int> permissionIds;
  const SaveRolePermissions(this.roleId, this.permissionIds);
  @override
  List<Object?> get props => [roleId, permissionIds];
}

class AssignRoleToMember extends RbacEvent {
  final int roleId;
  final int orgUserId;
  const AssignRoleToMember(this.roleId, this.orgUserId);
  @override
  List<Object?> get props => [roleId, orgUserId];
}

class SelectGroup extends RbacEvent {
  final int groupId;
  const SelectGroup(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class SelectRole extends RbacEvent {
  final int roleId;
  const SelectRole(this.roleId);
  @override
  List<Object?> get props => [roleId];
}

class SelectMember extends RbacEvent {
  final int orgUserId;
  const SelectMember(this.orgUserId);
  @override
  List<Object?> get props => [orgUserId];
}

class AddUserPermissionOverride extends RbacEvent {
  final int orgUserId;
  final int permissionId;
  final bool allowed;
  const AddUserPermissionOverride(
    this.orgUserId,
    this.permissionId,
    this.allowed,
  );
  @override
  List<Object?> get props => [orgUserId, permissionId, allowed];
}

class RemoveUserPermissionOverride extends RbacEvent {
  final int orgUserId;
  final int permissionId;
  const RemoveUserPermissionOverride(this.orgUserId, this.permissionId);
  @override
  List<Object?> get props => [orgUserId, permissionId];
}

class SearchMembers extends RbacEvent {
  final String query;
  const SearchMembers(this.query);
  @override
  List<Object?> get props => [query];
}

class FilterByModule extends RbacEvent {
  final String? module;
  const FilterByModule(this.module);
  @override
  List<Object?> get props => [module];
}

class ClearMessages extends RbacEvent {}
