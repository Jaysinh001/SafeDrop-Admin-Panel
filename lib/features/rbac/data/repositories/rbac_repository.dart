import 'package:dio/dio.dart';
import '../models/permission_model.dart';
import '../models/permission_group_model.dart';
import '../models/role_model.dart';
import '../models/org_member_model.dart';

class PolicyInput {
  final int permissionId;
  final bool allowed;

  PolicyInput({required this.permissionId, required this.allowed});

  Map<String, dynamic> toJson() => {
    'permission_id': permissionId,
    'allowed': allowed,
  };
}

class RbacRepository {
  final Dio dio;
  static const String baseUrl =
      'https://safe-drop-backend-3nwm.onrender.com/api/v1/protected/admin/rbac/';

  RbacRepository(this.dio) {
    // Basic configuration
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    // Auth Interceptor (Placeholder for real token retrieval)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // TODO: Get real JWE token from secure storage
          const token = 'YOUR_BEARER_TOKEN';
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
      ),
    );
  }

  // PERMISSIONS
  Future<List<PermissionModel>> getAllPermissions() async {
    try {
      final response = await dio.get('permissions');
      final List data = response.data['permissions'] ?? response.data;
      return data.map((json) => PermissionModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // PERMISSION GROUPS
  Future<List<PermissionGroupModel>> getPermissionGroups() async {
    try {
      final response = await dio.get('permission-groups');
      final List data = response.data['groups'] ?? response.data;
      return data.map((json) => PermissionGroupModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<PermissionGroupModel> getGroupDetail(int groupId) async {
    try {
      final response = await dio.get('permission-groups/$groupId');
      return PermissionGroupModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPermissionGroup(String name, String desc) async {
    try {
      await dio.post(
        'permission-groups',
        data: {'name': name, 'description': desc},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePermissionGroup(int id, String name, String desc) async {
    try {
      await dio.put(
        'permission-groups/$id',
        data: {'name': name, 'description': desc},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePermissionGroup(int id) async {
    try {
      await dio.delete('permission-groups/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveGroupPolicies(
    int groupId,
    List<PolicyInput> policies,
  ) async {
    try {
      await dio.post(
        'permission-groups/$groupId/policies',
        data: {'policies': policies.map((p) => p.toJson()).toList()},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> assignGroupToMember(int groupId, int orgUserId) async {
    try {
      await dio.post(
        'permission-groups/$groupId/assign',
        data: {'organization_user_id': orgUserId},
      );
    } catch (e) {
      rethrow;
    }
  }

  // ROLES
  Future<List<RoleModel>> getRoles() async {
    try {
      final response = await dio.get('roles');
      final List data = response.data['roles'] ?? response.data;
      return data.map((json) => RoleModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<RoleModel> getRoleDetail(int roleId) async {
    try {
      final response = await dio.get('roles/$roleId');
      return RoleModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createRole(String name) async {
    try {
      await dio.post('roles', data: {'name': name});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRole(int id, String name) async {
    try {
      await dio.put('roles/$id', data: {'name': name});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRole(int id) async {
    try {
      await dio.delete('roles/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveRolePermissions(int roleId, List<int> permissionIds) async {
    try {
      await dio.post(
        'roles/$roleId/permissions',
        data: {'permission_ids': permissionIds},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> assignRoleToMember(int roleId, int orgUserId) async {
    try {
      await dio.post(
        'roles/$roleId/assign',
        data: {
          'organization_user_id': orgUserId,
          // assigned_by should be handles by backend or passed here if needed
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // MEMBERS
  Future<List<OrgMemberModel>> getMembers() async {
    try {
      final response = await dio.get('members');
      final List data = response.data['members'] ?? response.data;
      return data.map((json) => OrgMemberModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ResolvedPermission>> getMemberPermissions(int orgUserId) async {
    try {
      final response = await dio.get('members/$orgUserId/permissions');
      final List data = response.data['permissions'] ?? response.data;
      return data.map((json) => ResolvedPermission.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUserOverride(int orgUserId, int permId, bool allowed) async {
    try {
      await dio.post(
        'members/$orgUserId/overrides',
        data: {'permission_id': permId, 'allowed': allowed},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeUserOverride(int orgUserId, int permId) async {
    try {
      await dio.delete('members/$orgUserId/overrides/$permId');
    } catch (e) {
      rethrow;
    }
  }
}
