class PermissionModel {
  final int id;
  final String name;
  final String module;
  final String scope;
  final String description;

  PermissionModel({
    required this.id,
    required this.name,
    required this.module,
    required this.scope,
    required this.description,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      module: json['module'] as String,
      scope: json['scope'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'module': module,
      'scope': scope,
      'description': description,
    };
  }
}
