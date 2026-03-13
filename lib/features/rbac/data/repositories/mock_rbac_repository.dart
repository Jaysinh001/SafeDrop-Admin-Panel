import 'rbac_repository.dart';
import '../models/permission_model.dart';
import '../models/permission_group_model.dart';
import '../models/permission_policy_model.dart';
import '../models/role_model.dart';
import '../models/org_member_model.dart';

class MockRbacRepository extends RbacRepository {
  MockRbacRepository(super.dio);

  final List<PermissionModel> _mockPermissions = [
    // Dashboard & Analytics
    PermissionModel(
      id: 1,
      name: 'view_dashboard',
      module: 'Dashboard',
      scope: 'read',
      description: 'Access the main overview dashboard',
    ),
    PermissionModel(
      id: 2,
      name: 'view_analytics',
      module: 'Dashboard',
      scope: 'read',
      description: 'View detailed usage analytics',
    ),
    PermissionModel(
      id: 3,
      name: 'export_reports',
      module: 'Dashboard',
      scope: 'write',
      description: 'Export analytical data to CSV/PDF',
    ),

    // User management
    PermissionModel(
      id: 4,
      name: 'list_users',
      module: 'Users',
      scope: 'read',
      description: 'List all registered users',
    ),
    PermissionModel(
      id: 5,
      name: 'create_user',
      module: 'Users',
      scope: 'write',
      description: 'Create new system users',
    ),
    PermissionModel(
      id: 6,
      name: 'edit_user',
      module: 'Users',
      scope: 'write',
      description: 'Edit existing user profiles',
    ),
    PermissionModel(
      id: 7,
      name: 'delete_user',
      module: 'Users',
      scope: 'delete',
      description: 'Permanently remove users',
    ),
    PermissionModel(
      id: 8,
      name: 'reset_passwords',
      module: 'Users',
      scope: 'admin',
      description: 'Force reset user passwords',
    ),
    PermissionModel(
      id: 9,
      name: 'manage_system_roles',
      module: 'Users',
      scope: 'admin',
      description: 'Change system-level roles of users',
    ),

    // RBAC Management
    PermissionModel(
      id: 10,
      name: 'view_rbac',
      module: 'RBAC',
      scope: 'read',
      description: 'View roles and groups',
    ),
    PermissionModel(
      id: 11,
      name: 'manage_groups',
      module: 'RBAC',
      scope: 'admin',
      description: 'Create and edit permission groups',
    ),
    PermissionModel(
      id: 12,
      name: 'manage_roles',
      module: 'RBAC',
      scope: 'admin',
      description: 'Create and edit custom roles',
    ),
    PermissionModel(
      id: 13,
      name: 'assign_permissions',
      module: 'RBAC',
      scope: 'admin',
      description: 'Assign permissions to roles/groups',
    ),

    // Finance & Transactions
    PermissionModel(
      id: 14,
      name: 'view_balance',
      module: 'Finance',
      scope: 'read',
      description: 'View organization balance',
    ),
    PermissionModel(
      id: 15,
      name: 'view_transactions',
      module: 'Finance',
      scope: 'read',
      description: 'View all transaction logs',
    ),
    PermissionModel(
      id: 16,
      name: 'approve_withdrawal',
      module: 'Finance',
      scope: 'write',
      description: 'Approve pending withdrawals',
    ),
    PermissionModel(
      id: 17,
      name: 'refund_payment',
      module: 'Finance',
      scope: 'write',
      description: 'Initiate refunds for transactions',
    ),
    PermissionModel(
      id: 18,
      name: 'low_balance_alert',
      module: 'Finance',
      scope: 'read',
      description: 'Receive organization balance alerts',
    ),

    // Inventory & Products
    PermissionModel(
      id: 19,
      name: 'view_inventory',
      module: 'Inventory',
      scope: 'read',
      description: 'View current product stock',
    ),
    PermissionModel(
      id: 20,
      name: 'add_inventory',
      module: 'Inventory',
      scope: 'write',
      description: 'Add new items to stock',
    ),
    PermissionModel(
      id: 21,
      name: 'update_stock',
      module: 'Inventory',
      scope: 'write',
      description: 'Adjust stock quantities',
    ),
    PermissionModel(
      id: 22,
      name: 'delete_inventory',
      module: 'Inventory',
      scope: 'delete',
      description: 'Remove items from inventory',
    ),
    PermissionModel(
      id: 23,
      name: 'view_suppliers',
      module: 'Inventory',
      scope: 'read',
      description: 'View supplier information',
    ),
    PermissionModel(
      id: 24,
      name: 'manage_suppliers',
      module: 'Inventory',
      scope: 'write',
      description: 'Add or edit suppliers',
    ),

    // Orders & Shipments
    PermissionModel(
      id: 25,
      name: 'view_orders',
      module: 'Orders',
      scope: 'read',
      description: 'List all customer orders',
    ),
    PermissionModel(
      id: 26,
      name: 'process_orders',
      module: 'Orders',
      scope: 'write',
      description: 'Change order status',
    ),
    PermissionModel(
      id: 27,
      name: 'cancel_orders',
      module: 'Orders',
      scope: 'write',
      description: 'Cancel pending orders',
    ),
    PermissionModel(
      id: 28,
      name: 'create_shipment',
      module: 'Orders',
      scope: 'write',
      description: 'Generate shipping labels',
    ),
    PermissionModel(
      id: 29,
      name: 'track_shipment',
      module: 'Orders',
      scope: 'read',
      description: 'View real-time delivery status',
    ),

    // System Configuration
    PermissionModel(
      id: 30,
      name: 'view_settings',
      module: 'Settings',
      scope: 'read',
      description: 'View system configuration',
    ),
    PermissionModel(
      id: 31,
      name: 'edit_app_settings',
      module: 'Settings',
      scope: 'write',
      description: 'Modify global app settings',
    ),
    PermissionModel(
      id: 32,
      name: 'manage_api_keys',
      module: 'Settings',
      scope: 'admin',
      description: 'Generate and revoke API keys',
    ),
    PermissionModel(
      id: 33,
      name: 'view_audit_logs',
      module: 'Settings',
      scope: 'read',
      description: 'View system audit logs',
    ),
    PermissionModel(
      id: 34,
      name: 'clear_cache',
      module: 'Settings',
      scope: 'admin',
      description: 'Manually clear server-side cache',
    ),

    // Content Management
    PermissionModel(
      id: 35,
      name: 'view_content',
      module: 'CMS',
      scope: 'read',
      description: 'View CMS pages',
    ),
    PermissionModel(
      id: 36,
      name: 'edit_content',
      module: 'CMS',
      scope: 'write',
      description: 'Modify website content',
    ),
    PermissionModel(
      id: 37,
      name: 'publish_content',
      module: 'CMS',
      scope: 'write',
      description: 'Publish drafted content',
    ),
    PermissionModel(
      id: 38,
      name: 'upload_media',
      module: 'CMS',
      scope: 'write',
      description: 'Upload images and files',
    ),

    // Customer Support
    PermissionModel(
      id: 39,
      name: 'view_tickets',
      module: 'Support',
      scope: 'read',
      description: 'View support tickets',
    ),
    PermissionModel(
      id: 40,
      name: 'reply_tickets',
      module: 'Support',
      scope: 'write',
      description: 'Reply to customer queries',
    ),
    PermissionModel(
      id: 41,
      name: 'close_tickets',
      module: 'Support',
      scope: 'write',
      description: 'Resolve support issues',
    ),
    PermissionModel(
      id: 42,
      name: 'assign_tickets',
      module: 'Support',
      scope: 'write',
      description: 'Route tickets to specific agents',
    ),

    // Marketing & Promotions
    PermissionModel(
      id: 43,
      name: 'view_campaigns',
      module: 'Marketing',
      scope: 'read',
      description: 'View active marketing campaigns',
    ),
    PermissionModel(
      id: 44,
      name: 'create_coupons',
      module: 'Marketing',
      scope: 'write',
      description: 'Generate discount codes',
    ),
    PermissionModel(
      id: 45,
      name: 'send_newsletter',
      module: 'Marketing',
      scope: 'write',
      description: 'Blast emails to subscribers',
    ),

    // Compliance & Legal
    PermissionModel(
      id: 46,
      name: 'view_legal_docs',
      module: 'Compliance',
      scope: 'read',
      description: 'Access legal agreements',
    ),
    PermissionModel(
      id: 47,
      name: 'edit_privacy_policy',
      module: 'Compliance',
      scope: 'write',
      description: 'Update terms and policies',
    ),
    PermissionModel(
      id: 48,
      name: 'gdpr_tools',
      module: 'Compliance',
      scope: 'admin',
      description: 'Access user data deletion tools',
    ),

    // Notifications
    PermissionModel(
      id: 49,
      name: 'view_notifications',
      module: 'System',
      scope: 'read',
      description: 'Access system-wide notifications',
    ),
    PermissionModel(
      id: 50,
      name: 'broadcast_message',
      module: 'System',
      scope: 'admin',
      description: 'Send emergency alerts to all users',
    ),
  ];

  final List<PermissionGroupModel> _mockGroups = [
    PermissionGroupModel(
      id: 1,
      organizationId: 101,
      name: 'Super Admins',
      description: 'Full access to everything',
      memberCount: 2,
      policies: [
        PermissionPolicyModel(
          permissionGroupId: 1,
          permissionId: 1,
          allowed: true,
          permissionName: 'view_dashboard',
          module: 'Dashboard',
        ),
        PermissionPolicyModel(
          permissionGroupId: 1,
          permissionId: 3,
          allowed: true,
          permissionName: 'manage_users',
          module: 'Users',
        ),
      ],
    ),
    PermissionGroupModel(
      id: 2,
      organizationId: 101,
      name: 'Managers',
      description: 'Management access for daily operations',
      memberCount: 5,
      policies: [
        PermissionPolicyModel(
          permissionGroupId: 2,
          permissionId: 1,
          allowed: true,
          permissionName: 'view_dashboard',
          module: 'Dashboard',
        ),
        PermissionPolicyModel(
          permissionGroupId: 2,
          permissionId: 4,
          allowed: true,
          permissionName: 'view_reports',
          module: 'Reports',
        ),
      ],
    ),
  ];

  final List<RoleModel> _mockRoles = [
    RoleModel(
      id: 1,
      organizationId: 101,
      name: 'Organization Admin',
      memberCount: 3,
      permissionIds: [1, 2, 3],
      permissionNames: ['view_dashboard', 'edit_settings', 'manage_users'],
    ),
    RoleModel(
      id: 2,
      organizationId: 101,
      name: 'Standard User',
      memberCount: 15,
      permissionIds: [1],
      permissionNames: ['view_dashboard'],
    ),
  ];

  final List<OrgMemberModel> _mockMembers = [
    OrgMemberModel(
      organizationUserId: 1,
      userId: 10,
      name: 'John Doe',
      email: 'john@example.com',
      systemRole: 'admin',
      permissionGroupName: 'Super Admins',
      permissionGroupId: 1,
      customRoleName: 'Organization Admin',
      customRoleId: 1,
    ),
    OrgMemberModel(
      organizationUserId: 2,
      userId: 11,
      name: 'Jane Smith',
      email: 'jane@example.com',
      systemRole: 'user',
      permissionGroupName: 'Managers',
      permissionGroupId: 2,
      customRoleName: 'Standard User',
      customRoleId: 2,
    ),
  ];

  @override
  Future<List<PermissionModel>> getAllPermissions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPermissions;
  }

  @override
  Future<List<PermissionGroupModel>> getPermissionGroups() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockGroups;
  }

  @override
  Future<PermissionGroupModel> getGroupDetail(int groupId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockGroups.firstWhere((g) => g.id == groupId);
  }

  @override
  Future<List<RoleModel>> getRoles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRoles;
  }

  @override
  Future<RoleModel> getRoleDetail(int roleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockRoles.firstWhere((r) => r.id == roleId);
  }

  @override
  Future<List<OrgMemberModel>> getMembers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMembers;
  }

  @override
  Future<List<ResolvedPermission>> getMemberPermissions(int orgUserId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ResolvedPermission(
        permissionName: 'view_dashboard',
        module: 'Dashboard',
        scope: 'read',
        source: 'group',
        allowed: true,
      ),
      ResolvedPermission(
        permissionName: 'manage_users',
        module: 'Users',
        scope: 'admin',
        source: 'role',
        allowed: true,
      ),
    ];
  }

  @override
  Future<void> createPermissionGroup(String name, String desc) async =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> updatePermissionGroup(int id, String name, String desc) async =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> deletePermissionGroup(int id) async =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> saveGroupPolicies(
    int groupId,
    List<PolicyInput> policies,
  ) async => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> assignGroupToMember(int groupId, int orgUserId) async =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> createRole(String name) async =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> updateRole(int id, String name) async =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> deleteRole(int id) async =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> saveRolePermissions(int roleId, List<int> permissionIds) async =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> assignRoleToMember(int roleId, int orgUserId) async =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> addUserOverride(int orgUserId, int permId, bool allowed) async =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> removeUserOverride(int orgUserId, int permId) async =>
      Future.delayed(const Duration(milliseconds: 500));
}
