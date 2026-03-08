import 'permission_policy_model.dart';

class PermissionGroupModel {
  final int id;
  final int organizationId;
  final String name;
  final String? description;
  final int memberCount;
  final List<PermissionPolicyModel> policies;

  PermissionGroupModel({
    required this.id,
    required this.organizationId,
    required this.name,
    this.description,
    this.memberCount = 0,
    this.policies = const [],
  });

  factory PermissionGroupModel.fromJson(Map<String, dynamic> json) {
    return PermissionGroupModel(
      id: json['id'] as int,
      organizationId: json['organization_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      memberCount: json['member_count'] ?? 0,
      policies:
          (json['policies'] as List?)
              ?.map(
                (e) =>
                    PermissionPolicyModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'description': description,
      'member_count': memberCount,
      'policies': policies.map((e) => e.toJson()).toList(),
    };
  }

  PermissionGroupModel copyWith({
    int? id,
    int? organizationId,
    String? name,
    String? description,
    int? memberCount,
    List<PermissionPolicyModel>? policies,
  }) {
    return PermissionGroupModel(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      description: description ?? this.description,
      memberCount: memberCount ?? this.memberCount,
      policies: policies ?? this.policies,
    );
  }
}
