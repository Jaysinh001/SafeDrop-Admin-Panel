class RoleModel {
  final int id;
  final int organizationId;
  final String name;
  final int memberCount;
  final List<int> permissionIds;
  final List<String>? permissionNames;

  RoleModel({
    required this.id,
    required this.organizationId,
    required this.name,
    this.memberCount = 0,
    this.permissionIds = const [],
    this.permissionNames,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as int,
      organizationId: json['organization_id'] as int,
      name: json['name'] as String,
      memberCount: json['member_count'] ?? 0,
      permissionIds: List<int>.from(json['permission_ids'] ?? []),
      permissionNames: (json['permission_names'] as List?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'member_count': memberCount,
      'permission_ids': permissionIds,
      if (permissionNames != null) 'permission_names': permissionNames,
    };
  }

  RoleModel copyWith({
    int? id,
    int? organizationId,
    String? name,
    int? memberCount,
    List<int>? permissionIds,
    List<String>? permissionNames,
  }) {
    return RoleModel(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      memberCount: memberCount ?? this.memberCount,
      permissionIds: permissionIds ?? this.permissionIds,
      permissionNames: permissionNames ?? this.permissionNames,
    );
  }
}
