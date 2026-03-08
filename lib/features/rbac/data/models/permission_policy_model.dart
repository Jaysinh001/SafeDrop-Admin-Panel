class PermissionPolicyModel {
  final int permissionGroupId;
  final int permissionId;
  final bool allowed;
  final String? permissionName;
  final String? module;

  PermissionPolicyModel({
    required this.permissionGroupId,
    required this.permissionId,
    required this.allowed,
    this.permissionName,
    this.module,
  });

  factory PermissionPolicyModel.fromJson(Map<String, dynamic> json) {
    return PermissionPolicyModel(
      permissionGroupId: json['permission_group_id'] as int,
      permissionId: json['permission_id'] as int,
      allowed: json['allowed'] as bool,
      permissionName: json['permission_name'] as String?,
      module: json['module'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permission_group_id': permissionGroupId,
      'permission_id': permissionId,
      'allowed': allowed,
      if (permissionName != null) 'permission_name': permissionName,
      if (module != null) 'module': module,
    };
  }
}
