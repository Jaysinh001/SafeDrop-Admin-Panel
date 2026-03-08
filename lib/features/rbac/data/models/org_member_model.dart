class OrgMemberModel {
  final int organizationUserId;
  final int userId;
  final String name;
  final String email;
  final String? avatarUrl;
  final String systemRole;
  final String? permissionGroupName;
  final int? permissionGroupId;
  final String? customRoleName;
  final int? customRoleId;

  OrgMemberModel({
    required this.organizationUserId,
    required this.userId,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.systemRole,
    this.permissionGroupName,
    this.permissionGroupId,
    this.customRoleName,
    this.customRoleId,
  });

  factory OrgMemberModel.fromJson(Map<String, dynamic> json) {
    return OrgMemberModel(
      organizationUserId: json['organization_user_id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      systemRole: json['system_role'] as String,
      permissionGroupName: json['permission_group_name'] as String?,
      permissionGroupId: json['permission_group_id'] as int?,
      customRoleName: json['custom_role_name'] as String?,
      customRoleId: json['custom_role_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organization_user_id': organizationUserId,
      'user_id': userId,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'system_role': systemRole,
      'permission_group_name': permissionGroupName,
      'permission_group_id': permissionGroupId,
      'custom_role_name': customRoleName,
      'custom_role_id': customRoleId,
    };
  }
}

class ResolvedPermission {
  final String permissionName;
  final String module;
  final String scope;
  final String source; // admin_override | user_override | group | role
  final bool allowed;

  ResolvedPermission({
    required this.permissionName,
    required this.module,
    required this.scope,
    required this.source,
    required this.allowed,
  });

  factory ResolvedPermission.fromJson(Map<String, dynamic> json) {
    return ResolvedPermission(
      permissionName: json['permission_name'] as String,
      module: json['module'] as String,
      scope: json['scope'] as String,
      source: json['source'] as String,
      allowed: json['allowed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permission_name': permissionName,
      'module': module,
      'scope': scope,
      'source': source,
      'allowed': allowed,
    };
  }
}
