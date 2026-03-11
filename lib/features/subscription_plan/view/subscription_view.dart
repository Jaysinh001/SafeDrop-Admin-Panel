// =============================================================================
// SUBSCRIPTION SCREEN — BLoC-compatible, single-state pattern
//
// Schema tables used:
//   subscription_plan         — id, name, features (jsonb), price
//   organization_subscription — organization_id, subscription_plan_id,
//                               start_date, end_date, status
//
// ─── COLOR CONTRACT ──────────────────────────────────────────────────────────
// Every color in this file comes from AppColors. No hardcoded hex anywhere.
//
//  Scaffold bg            → AppColors.darkBackground        #020617
//  Card / deep surface    → AppColors.darkSurface           #0f172a
//  Card lighter surface   → AppColors.darkSurfaceContainer  #1e293b
//  Primary brand          → AppColors.primary               #667eea
//  Primary dark           → AppColors.primaryDark           #5a67d8
//  Primary light          → AppColors.primaryLight          #7c3aed
//  Secondary / Pro accent → AppColors.secondary             #764ba2
//  Sec. light             → AppColors.secondaryLight        #8b5cf6
//  Basic plan accent      → AppColors.textSecondary         #64748b
//  Enterprise accent      → AppColors.warning               #f59e0b
//  Success green          → AppColors.success               #10b981
//  Error red              → AppColors.error                 #ef4444
//  Info blue              → AppColors.info                  #3b82f6
//  White on dark          → AppColors.darkOnSurface         #f8fafc
//  Muted on dark          → AppColors.darkOnBackground      #e2e8f0
//  Tertiary text          → AppColors.textTertiary          #94a3b8
//  Dark border            → AppColors.darkOutline           #475569
//  Drop shadow base       → AppColors.shadow                #000000
//  onPrimary              → AppColors.onPrimary             #ffffff
//  onSuccess              → AppColors.onSuccess             #ffffff
//  onWarning              → AppColors.onWarning             #ffffff
//  Chart pink             → AppColors.chartColors[7]        #ec4899
// =============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';
// import 'package:your_app/core/theme/app_colors.dart'; // ← adjust to your path

// =============================================================================
// DOMAIN MODELS
// =============================================================================

class SubscriptionPlan {
  final int id;
  final String name;
  final double price;
  final String billingPeriod;
  final List<PlanFeature> features;
  final String badge;
  final Color accentColor;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.billingPeriod,
    required this.features,
    this.badge = '',
    required this.accentColor,
  });
}

class PlanFeature {
  final String name;
  final String? value;
  final bool included;
  final bool highlight;

  const PlanFeature({
    required this.name,
    this.value,
    this.included = true,
    this.highlight = false,
  });
}

class OrganizationSubscription {
  final int id;
  final int organizationId;
  final SubscriptionPlan plan;
  final DateTime startDate;
  final DateTime? endDate;
  final String status;
  final int daysRemaining;

  const OrganizationSubscription({
    required this.id,
    required this.organizationId,
    required this.plan,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.daysRemaining,
  });
}

class SubscriptionUsageStat {
  final String label;
  final String used;
  final String limit;
  final double percent;
  final IconData icon;
  final Color color;

  const SubscriptionUsageStat({
    required this.label,
    required this.used,
    required this.limit,
    required this.percent,
    required this.icon,
    required this.color,
  });
}

// =============================================================================
// MOCK DATA
// ─── Accent colours per plan ─────────────────────────────────────────────────
//   Basic      → AppColors.textSecondary   slate-500 neutral
//   Pro        → AppColors.primary         brand indigo-blue  ← current plan
//   Enterprise → AppColors.warning         amber / gold
// =============================================================================

final _planBasic = SubscriptionPlan(
  id: 1,
  name: 'Basic',
  price: 999,
  billingPeriod: 'monthly',
  accentColor: AppColors.textSecondary, // slate neutral
  features: const [
    PlanFeature(name: 'Routes',              value: 'Up to 3 routes'),
    PlanFeature(name: 'Vehicles',            value: 'Up to 5 vehicles'),
    PlanFeature(name: 'Students',            value: 'Up to 100 students'),
    PlanFeature(name: 'Live Tracking',       included: true),
    PlanFeature(name: 'Attendance',          included: true),
    PlanFeature(name: 'Basic Billing',       included: true),
    PlanFeature(name: 'Chat',                included: false),
    PlanFeature(name: 'Announcements',       included: false),
    PlanFeature(name: 'Advanced Analytics',  included: false),
    PlanFeature(name: 'Corporate Module',    included: false),
    PlanFeature(name: 'Priority Support',    included: false),
    PlanFeature(name: 'Custom Roles & RBAC', included: false),
  ],
);

final _planPro = SubscriptionPlan(
  id: 2,
  name: 'Pro',
  price: 2499,
  billingPeriod: 'monthly',
  badge: 'Popular',
  accentColor: AppColors.primary, // brand indigo-blue
  features: const [
    PlanFeature(name: 'Routes',              value: 'Up to 15 routes',   highlight: true),
    PlanFeature(name: 'Vehicles',            value: 'Up to 25 vehicles', highlight: true),
    PlanFeature(name: 'Students',            value: 'Up to 500 students', highlight: true),
    PlanFeature(name: 'Live Tracking',       included: true),
    PlanFeature(name: 'Attendance',          included: true),
    PlanFeature(name: 'Advanced Billing',    included: true,  highlight: true),
    PlanFeature(name: 'Chat',                included: true,  highlight: true),
    PlanFeature(name: 'Announcements',       included: true,  highlight: true),
    PlanFeature(name: 'Advanced Analytics',  included: true,  highlight: true),
    PlanFeature(name: 'Corporate Module',    included: false),
    PlanFeature(name: 'Priority Support',    included: true,  highlight: true),
    PlanFeature(name: 'Custom Roles & RBAC', included: true,  highlight: true),
  ],
);

final _planEnterprise = SubscriptionPlan(
  id: 3,
  name: 'Enterprise',
  price: 5999,
  billingPeriod: 'monthly',
  badge: 'Best Value',
  accentColor: AppColors.warning, // amber / gold
  features: const [
    PlanFeature(name: 'Routes',              value: 'Unlimited', highlight: true),
    PlanFeature(name: 'Vehicles',            value: 'Unlimited', highlight: true),
    PlanFeature(name: 'Students',            value: 'Unlimited', highlight: true),
    PlanFeature(name: 'Live Tracking',       included: true),
    PlanFeature(name: 'Attendance',          included: true),
    PlanFeature(name: 'Advanced Billing',    included: true),
    PlanFeature(name: 'Chat',                included: true),
    PlanFeature(name: 'Announcements',       included: true),
    PlanFeature(name: 'Advanced Analytics',  included: true),
    PlanFeature(name: 'Corporate Module',    included: true,  highlight: true),
    PlanFeature(name: 'Priority Support',    included: true),
    PlanFeature(name: 'Custom Roles & RBAC', included: true),
  ],
);

final _allPlans = [_planBasic, _planPro, _planEnterprise];

final _mockSubscription = OrganizationSubscription(
  id: 7,
  organizationId: 1,
  plan: _planPro, // currently on Pro
  startDate: DateTime(2026, 2, 1),
  endDate: DateTime(2026, 3, 31),
  status: 'active',
  daysRemaining: 20,
);

// ── Usage stat colours ── pulled from AppColors.chartColors by index
//   [0] primary  #667eea — Routes
//   [2] success  #10b981 — Vehicles
//   [3] warning  #f59e0b — Students
//   [7] pink     #ec4899 — Drivers
final _mockUsageStats = [
  SubscriptionUsageStat(
    label: 'Routes',   used: '9',   limit: '15',  percent: 0.60,
    icon: Icons.route_rounded,
    color: AppColors.chartColors[0], // primary indigo-blue
  ),
  SubscriptionUsageStat(
    label: 'Vehicles', used: '18',  limit: '25',  percent: 0.72,
    icon: Icons.directions_bus_rounded,
    color: AppColors.chartColors[2], // success green
  ),
  SubscriptionUsageStat(
    label: 'Students', used: '342', limit: '500', percent: 0.68,
    icon: Icons.school_rounded,
    color: AppColors.chartColors[3], // warning amber
  ),
  SubscriptionUsageStat(
    label: 'Drivers',  used: '11',  limit: '25',  percent: 0.44,
    icon: Icons.person_pin_rounded,
    color: AppColors.chartColors[7], // chart pink #ec4899
  ),
];

// =============================================================================
// BLOC — single state
// =============================================================================

abstract class SubscriptionEvent {}

class SubscriptionLoaded              extends SubscriptionEvent {}
class SubscriptionUpgradeConfirmed    extends SubscriptionEvent {}
class SubscriptionBillingCycleToggled extends SubscriptionEvent {}
class SubscriptionUpgradeDismissed    extends SubscriptionEvent {}

class SubscriptionPlanSelected extends SubscriptionEvent {
  final SubscriptionPlan plan;
  SubscriptionPlanSelected(this.plan);
}

// ── Status enums ──────────────────────────────────────────────────────────────

enum SubscriptionStatus { initial, loading, success, error }
enum UpgradeStatus      { idle, confirming, processing, done }

// ── Single state ──────────────────────────────────────────────────────────────

class SubscriptionState {
  final SubscriptionStatus          status;
  final OrganizationSubscription?   currentSubscription;
  final List<SubscriptionPlan>      availablePlans;
  final List<SubscriptionUsageStat> usageStats;
  final SubscriptionPlan?           selectedPlan;
  final UpgradeStatus               upgradeStatus;
  final bool                        isAnnualBilling;
  final String?                     error;

  const SubscriptionState({
    this.status              = SubscriptionStatus.initial,
    this.currentSubscription,
    this.availablePlans      = const [],
    this.usageStats          = const [],
    this.selectedPlan,
    this.upgradeStatus       = UpgradeStatus.idle,
    this.isAnnualBilling     = false,
    this.error,
  });

  SubscriptionState copyWith({
    SubscriptionStatus?          status,
    OrganizationSubscription?    currentSubscription,
    List<SubscriptionPlan>?      availablePlans,
    List<SubscriptionUsageStat>? usageStats,
    Object?                      selectedPlan  = _sentinel,
    UpgradeStatus?               upgradeStatus,
    bool?                        isAnnualBilling,
    Object?                      error         = _sentinel,
  }) =>
      SubscriptionState(
        status:              status              ?? this.status,
        currentSubscription: currentSubscription ?? this.currentSubscription,
        availablePlans:      availablePlans      ?? this.availablePlans,
        usageStats:          usageStats          ?? this.usageStats,
        selectedPlan: selectedPlan == _sentinel
            ? this.selectedPlan
            : selectedPlan as SubscriptionPlan?,
        upgradeStatus:   upgradeStatus   ?? this.upgradeStatus,
        isAnnualBilling: isAnnualBilling ?? this.isAnnualBilling,
        error: error == _sentinel ? this.error : error as String?,
      );

  /// Annual billing applies a 20 % discount on the 12-month total.
  double priceFor(SubscriptionPlan p) =>
      isAnnualBilling ? p.price * 12 * 0.80 : p.price;
}

const _sentinel = Object();

// ── Real BLoC stub ─────────────────────────────────────────────────────────────
// Uncomment + swap _emit/_add for emit/bloc.add when wiring flutter_bloc.
//
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
//   SubscriptionBloc() : super(const SubscriptionState()) {
//     on<SubscriptionLoaded>(_onLoaded);
//     on<SubscriptionPlanSelected>(_onPlanSelected);
//     on<SubscriptionUpgradeConfirmed>(_onUpgradeConfirmed);
//     on<SubscriptionBillingCycleToggled>(_onToggled);
//     on<SubscriptionUpgradeDismissed>(_onDismissed);
//   }
//
//   Future<void> _onLoaded(_, Emitter<SubscriptionState> e) async {
//     e(state.copyWith(status: SubscriptionStatus.loading));
//     // final sub = await _repo.getCurrentSubscription();
//     e(state.copyWith(
//       status: SubscriptionStatus.success,
//       currentSubscription: _mockSubscription,
//       availablePlans: _allPlans,
//       usageStats: _mockUsageStats,
//     ));
//   }
//
//   void _onPlanSelected(SubscriptionPlanSelected ev, Emitter<SubscriptionState> e) =>
//     e(state.copyWith(selectedPlan: ev.plan, upgradeStatus: UpgradeStatus.confirming));
//
//   Future<void> _onUpgradeConfirmed(_, Emitter<SubscriptionState> e) async {
//     e(state.copyWith(upgradeStatus: UpgradeStatus.processing));
//     await Future.delayed(const Duration(seconds: 2)); // API call here
//     e(state.copyWith(upgradeStatus: UpgradeStatus.done, selectedPlan: null));
//   }
//
//   void _onToggled(_, Emitter<SubscriptionState> e) =>
//     e(state.copyWith(isAnnualBilling: !state.isAnnualBilling));
//
//   void _onDismissed(_, Emitter<SubscriptionState> e) =>
//     e(state.copyWith(selectedPlan: null, upgradeStatus: UpgradeStatus.idle));
// }

// =============================================================================
// SUBSCRIPTION VIEW
// =============================================================================

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView>
    with TickerProviderStateMixin {
  SubscriptionState _state = const SubscriptionState();

  late final AnimationController _heroAnim = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800));
  late final AnimationController _cardAnim = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000));

  late final Animation<double> _heroFade = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(parent: _heroAnim, curve: Curves.easeOut));
  late final Animation<Offset> _heroSlide =
      Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _heroAnim, curve: Curves.easeOutCubic));

  // ── BLoC mirror helpers ───────────────────────────────────────────────────

  void _emit(SubscriptionState next) => setState(() => _state = next);

  void _add(SubscriptionEvent event) {
    if (event is SubscriptionLoaded) {
      _emit(_state.copyWith(status: SubscriptionStatus.loading));
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        _emit(_state.copyWith(
          status: SubscriptionStatus.success,
          currentSubscription: _mockSubscription,
          availablePlans: _allPlans,
          usageStats: _mockUsageStats,
        ));
        _heroAnim.forward();
        _cardAnim.forward();
      });
    } else if (event is SubscriptionPlanSelected) {
      _emit(_state.copyWith(
          selectedPlan: event.plan,
          upgradeStatus: UpgradeStatus.confirming));
    } else if (event is SubscriptionUpgradeConfirmed) {
      _emit(_state.copyWith(upgradeStatus: UpgradeStatus.processing));
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        _emit(_state.copyWith(
            upgradeStatus: UpgradeStatus.done, selectedPlan: null));
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          _emit(_state.copyWith(upgradeStatus: UpgradeStatus.idle));
        });
      });
    } else if (event is SubscriptionBillingCycleToggled) {
      _emit(_state.copyWith(isAnnualBilling: !_state.isAnnualBilling));
    } else if (event is SubscriptionUpgradeDismissed) {
      _emit(_state.copyWith(
          selectedPlan: null, upgradeStatus: UpgradeStatus.idle));
    }
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _add(SubscriptionLoaded());
  }

  @override
  void dispose() {
    _heroAnim.dispose();
    _cardAnim.dispose();
    super.dispose();
  }

  // ── Root build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isLoading = _state.status == SubscriptionStatus.initial ||
        _state.status == SubscriptionStatus.loading;

    if (isLoading) return _buildLoadingScaffold();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(children: [
        // Ambient glow blobs
        const _AmbientBackground(),
        // Scrollable body
        CustomScrollView(slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _heroFade,
              child: SlideTransition(
                position: _heroSlide,
                child: Column(children: [
                  _buildCurrentPlanHero(),
                  _buildUsageSection(),
                  _buildBillingToggle(),
                  _buildPlansSection(),
                  _buildBenefitsSection(),
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ),
        ]),
        // Upgrade overlay — shown when a plan is selected
        if (_state.selectedPlan != null &&
            _state.upgradeStatus != UpgradeStatus.idle)
          _UpgradeConfirmOverlay(
            state: _state,
            onConfirm: () => _add(SubscriptionUpgradeConfirmed()),
            onDismiss: () => _add(SubscriptionUpgradeDismissed()),
          ),
      ]),
    );
  }

  // ── Loading scaffold ──────────────────────────────────────────────────────

  Widget _buildLoadingScaffold() => Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Stack(children: [
          const _AmbientBackground(),
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                        color: AppColors.primary, strokeWidth: 2),
                  ),
                  const SizedBox(height: 20),
                  Text('Loading subscription\u2026',
                      style: TextStyle(
                          color: AppColors.textTertiary, fontSize: 14)),
                ]),
          ),
        ]),
      );

  // ── App bar ───────────────────────────────────────────────────────────────

  Widget _buildAppBar() => SliverAppBar(
        backgroundColor: Colors.transparent,
        expandedHeight: 0,
        floating: true,
        elevation: 0,
        title: Text('Subscription',
            style: TextStyle(
                color: AppColors.darkOnSurface,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        centerTitle: false,
        actions: [
          // Active status pill
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.success.withOpacity(0.40))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                      color: AppColors.success, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text('Active',
                  style: TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
        ],
      );

  // ── Current plan hero card ─────────────────────────────────────────────────

  Widget _buildCurrentPlanHero() {
    final sub         = _state.currentSubscription!;
    final plan        = sub.plan;
    final daysLeft    = sub.daysRemaining;
    final cycleTotal  = sub.endDate!.difference(sub.startDate).inDays + 1;
    final daysPassed  = cycleTotal - daysLeft;
    final progress    = daysPassed / cycleTotal;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: _GlassCard(
        borderColor: plan.accentColor.withOpacity(0.50),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            plan.accentColor.withOpacity(0.22),
            plan.accentColor.withOpacity(0.05),
            AppColors.darkSurface.withOpacity(0.90),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Plan name row + days ring
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Current Plan',
                  style: TextStyle(
                      color: AppColors.darkOnSurface.withOpacity(0.50),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2)),
              const SizedBox(height: 6),
              Row(children: [
                Text(plan.name,
                    style: TextStyle(
                        color: AppColors.darkOnSurface,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1)),
                const SizedBox(width: 10),
                // Plan tier badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: plan.accentColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(plan.name.toUpperCase(),
                      style: TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5)),
                ),
              ]),
              const SizedBox(height: 4),
              // Price line
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '\u20b9${plan.price.toStringAsFixed(0)}',
                      style: TextStyle(
                          color: AppColors.darkOnSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                      text: '/month',
                      style: TextStyle(
                          color:
                              AppColors.darkOnSurface.withOpacity(0.45),
                          fontSize: 13)),
                ]),
              ),
            ]),
            const Spacer(),
            // Days remaining ring
            _DaysRingWidget(
                daysLeft: daysLeft, total: 31, color: plan.accentColor),
          ]),

          const SizedBox(height: 24),
          Divider(
              color: AppColors.darkOutline.withOpacity(0.30), height: 1),
          const SizedBox(height: 20),

          // ── Billing period progress
          Row(children: [
            Text('Billing Period',
                style: TextStyle(
                    color: AppColors.darkOnSurface.withOpacity(0.50),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8)),
            const Spacer(),
            Text(_fmtDate(sub.startDate),
                style: TextStyle(
                    color: AppColors.darkOnBackground, fontSize: 11)),
            Text(' \u2192 ',
                style: TextStyle(
                    color: AppColors.darkOutline, fontSize: 11)),
            Text(_fmtDate(sub.endDate!),
                style: TextStyle(
                    color: AppColors.darkOnBackground, fontSize: 11)),
          ]),
          const SizedBox(height: 8),
          _ProgressBar(
              progress: progress, color: plan.accentColor, height: 5),
          const SizedBox(height: 6),
          Row(children: [
            Text('$daysPassed days used',
                style: TextStyle(
                    color: AppColors.textTertiary, fontSize: 11)),
            const Spacer(),
            Text('$daysLeft days left',
                style: TextStyle(
                    color: plan.accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ]),

          const SizedBox(height: 20),

          // ── Included feature pills (first 5)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: plan.features
                .where((f) => f.included)
                .take(5)
                .map((f) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color:
                              AppColors.darkOnSurface.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.darkOutline
                                  .withOpacity(0.30))),
                      child: Text(f.value ?? f.name,
                          style: TextStyle(
                              color: AppColors.darkOnBackground,
                              fontSize: 11,
                              fontWeight: FontWeight.w500)),
                    ))
                .toList(),
          ),
        ]),
      ),
    );
  }

  // ── Usage section ─────────────────────────────────────────────────────────

  Widget _buildUsageSection() {
    final cols = MediaQuery.of(context).size.width > 600 ? 4 : 2;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionLabel('Plan Usage'),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.08),
          itemCount: _state.usageStats.length,
          itemBuilder: (_, i) =>
              _UsageStatCard(stat: _state.usageStats[i]),
        ),
      ]),
    );
  }

  // ── Billing cycle toggle ──────────────────────────────────────────────────

  Widget _buildBillingToggle() {
    final isAnnual = _state.isAnnualBilling;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionLabel('Choose a Plan'),
        const SizedBox(height: 16),
        Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: AppColors.darkSurfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.darkOutline.withOpacity(0.30))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              _billingTab(
                  label: 'Monthly',
                  active: !isAnnual,
                  onTap: () => _add(SubscriptionBillingCycleToggled())),
              _billingTab(
                  label: 'Annual',
                  active: isAnnual,
                  badge: 'Save 20%',
                  onTap: () => _add(SubscriptionBillingCycleToggled())),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _billingTab({
    required String label,
    required bool active,
    required VoidCallback onTap,
    String? badge,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
              color: active ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label,
                style: TextStyle(
                    color: active
                        ? AppColors.onPrimary
                        : AppColors.textTertiary,
                    fontWeight:
                        active ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13)),
            if (badge != null && active) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(badge,
                    style: TextStyle(
                        color: AppColors.onSuccess,
                        fontSize: 9,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ]),
        ),
      );

  // ── Plans section ─────────────────────────────────────────────────────────

  Widget _buildPlansSection() {
    final isWide = MediaQuery.of(context).size.width > 900;
    final plans  = _state.availablePlans;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: plans.asMap().entries.map((e) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left:  e.key == 0             ? 0 : 8,
                        right: e.key == plans.length-1 ? 0 : 8),
                    child: _buildPlanCard(e.value),
                  ),
                );
              }).toList())
          : Column(
              children: plans
                  .map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildPlanCard(p)))
                  .toList()),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isCurrent = plan.id == _state.currentSubscription?.plan.id;
    final isUpgrade = plan.id > (_state.currentSubscription?.plan.id ?? 0);
    final price     = _state.priceFor(plan);
    final isAnnual  = _state.isAnnualBilling;

    return _GlassCard(
      borderColor: isCurrent
          ? plan.accentColor
          : AppColors.darkOutline.withOpacity(0.25),
      gradient: isCurrent
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                plan.accentColor.withOpacity(0.18),
                AppColors.darkSurfaceContainer,
              ])
          : LinearGradient(colors: [
              AppColors.darkSurfaceContainer,
              AppColors.darkSurfaceContainer,
            ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // Header: badge label + plan name + current pill
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              if (plan.badge.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        plan.accentColor,
                        plan.accentColor.withOpacity(0.60)
                      ]),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(plan.badge.toUpperCase(),
                      style: TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0)),
                ),
              Text(plan.name,
                  style: TextStyle(
                      color: plan.accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
            ]),
          ),
          if (isCurrent)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: plan.accentColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: plan.accentColor.withOpacity(0.50))),
              child: Text('Current',
                  style: TextStyle(
                      color: plan.accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
        ]),
        const SizedBox(height: 12),

        // Price
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: '\u20b9${price.toStringAsFixed(0)}',
                style: TextStyle(
                    color: AppColors.darkOnSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.w800)),
            TextSpan(
                text: isAnnual ? '/year' : '/month',
                style: TextStyle(
                    color: AppColors.textTertiary, fontSize: 13)),
          ]),
        ),
        if (isAnnual)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
                '\u20b9${(price / 12).toStringAsFixed(0)}/mo billed annually',
                style: TextStyle(
                    color: plan.accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),

        const SizedBox(height: 18),
        Divider(
            color: AppColors.darkOutline.withOpacity(0.20), height: 1),
        const SizedBox(height: 16),

        // Feature list
        ...plan.features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                // Check / close icon bubble
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                      color: f.included
                          ? plan.accentColor.withOpacity(0.18)
                          : AppColors.darkSurface,
                      shape: BoxShape.circle),
                  child: Icon(
                    f.included
                        ? Icons.check_rounded
                        : Icons.close_rounded,
                    size: 11,
                    color: f.included
                        ? plan.accentColor
                        : AppColors.darkOutline.withOpacity(0.50),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    f.value ?? f.name,
                    style: TextStyle(
                      color: f.included
                          ? (f.highlight
                              ? AppColors.darkOnSurface
                              : AppColors.darkOnBackground)
                          : AppColors.darkOutline,
                      fontSize: 12,
                      fontWeight: f.highlight
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ]),
            )),

        const SizedBox(height: 20),

        // CTA button
        SizedBox(
          width: double.infinity,
          child: isCurrent
              // Current plan — static outlined chip
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                      color: plan.accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: plan.accentColor.withOpacity(0.40))),
                  alignment: Alignment.center,
                  child: Text('Current Plan',
                      style: TextStyle(
                          color: plan.accentColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)))
              // Other plans — gradient upgrade/downgrade button
              : GestureDetector(
                  onTap: () => _add(SubscriptionPlanSelected(plan)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          plan.accentColor,
                          plan.accentColor.withOpacity(0.70),
                        ]),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: plan.accentColor.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 4))
                        ]),
                    alignment: Alignment.center,
                    child: Text(isUpgrade ? 'Upgrade' : 'Downgrade',
                        style: TextStyle(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                  ),
                ),
        ),
      ]),
    );
  }

  // ── Benefits section ──────────────────────────────────────────────────────

  Widget _buildBenefitsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionLabel('Why Upgrade?'),
        const SizedBox(height: 14),
        _GlassCard(
          borderColor: AppColors.darkOutline.withOpacity(0.20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkSurfaceContainer,
              AppColors.darkSurface,
            ],
          ),
          child: Column(children: [
            _BenefitRow(
              icon: Icons.route_rounded,
              color: AppColors.primary,           // brand indigo
              title: 'Scale Your Routes',
              subtitle:
                  'Add more routes as your institution grows without service interruption.',
            ),
            _BenefitRow(
              icon: Icons.analytics_rounded,
              color: AppColors.success,           // success green
              title: 'Advanced Analytics',
              subtitle:
                  'Deep insights on attendance trends, route efficiency, and billing health.',
            ),
            _BenefitRow(
              icon: Icons.business_center_rounded,
              color: AppColors.warning,           // warning amber
              title: 'Corporate Module',
              subtitle:
                  'Unlock B2B contracts and employee transport management on Enterprise.',
            ),
            _BenefitRow(
              icon: Icons.support_agent_rounded,
              color: AppColors.chartColors[7],    // chart pink #ec4899
              title: 'Priority Support',
              subtitle:
                  'Dedicated account manager with a guaranteed 4-hour response SLA.',
              isLast: true,
            ),
          ]),
        ),
      ]),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) => Text(text,
      style: TextStyle(
          color: AppColors.darkOnSurface,
          fontSize: 16,
          fontWeight: FontWeight.w700));
}

// =============================================================================
// UPGRADE CONFIRM OVERLAY
// =============================================================================

class _UpgradeConfirmOverlay extends StatelessWidget {
  final SubscriptionState state;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  const _UpgradeConfirmOverlay({
    required this.state,
    required this.onConfirm,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final plan         = state.selectedPlan!;
    final currentPlan  = state.currentSubscription!.plan;
    final price        = state.priceFor(plan);
    final isProcessing = state.upgradeStatus == UpgradeStatus.processing;
    final isDone       = state.upgradeStatus == UpgradeStatus.done;

    return GestureDetector(
      onTap: isProcessing ? null : onDismiss,
      child: Container(
        // Scrim
        color: AppColors.shadow.withOpacity(0.75),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {}, // block tap-through
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
                color: AppColors.darkSurfaceContainer,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: plan.accentColor.withOpacity(0.40)),
                boxShadow: [
                  BoxShadow(
                      color: plan.accentColor.withOpacity(0.20),
                      blurRadius: 40,
                      spreadRadius: 2)
                ]),
            child: isDone
                ? _buildDoneState(plan)
                : _buildConfirmState(
                    plan, currentPlan, price, isProcessing),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmState(SubscriptionPlan plan, SubscriptionPlan current,
      double price, bool isProcessing) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      // Glow icon
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
            color: plan.accentColor.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
                color: plan.accentColor.withOpacity(0.40), width: 2)),
        child: Icon(Icons.workspace_premium_rounded,
            color: plan.accentColor, size: 30),
      ),
      const SizedBox(height: 20),

      Text('Upgrade to ${plan.name}',
          style: TextStyle(
              color: AppColors.darkOnSurface,
              fontSize: 20,
              fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      Text('Switching from ${current.name} \u2192 ${plan.name}',
          style: TextStyle(
              color: AppColors.textTertiary, fontSize: 13),
          textAlign: TextAlign.center),
      const SizedBox(height: 24),

      // Price breakdown
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: AppColors.darkOutline.withOpacity(0.25))),
        child: Column(children: [
          _confirmRow('Current plan',
              '\u20b9${current.price.toStringAsFixed(0)}/mo'),
          const SizedBox(height: 10),
          _confirmRow(
              'New plan', '\u20b9${price.toStringAsFixed(0)}/mo',
              valueColor: plan.accentColor),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
                color: AppColors.darkOutline.withOpacity(0.25),
                height: 1),
          ),
          _confirmRow(
              'Difference',
              '+\u20b9${(price - current.price).abs().toStringAsFixed(0)}/mo',
              valueColor: AppColors.success),
        ]),
      ),
      const SizedBox(height: 8),
      Text('Prorated charges apply for the remaining billing period.',
          style: TextStyle(
              color: AppColors.textTertiary, fontSize: 11),
          textAlign: TextAlign.center),
      const SizedBox(height: 24),

      // Action buttons
      if (isProcessing)
        SizedBox(
            height: 50,
            child: Center(
                child: CircularProgressIndicator(
                    color: AppColors.primary, strokeWidth: 2)))
      else
        Row(children: [
          // Cancel
          Expanded(
            child: GestureDetector(
              onTap: onDismiss,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.darkOutline.withOpacity(0.40))),
                alignment: Alignment.center,
                child: Text('Cancel',
                    style: TextStyle(
                        color: AppColors.darkOnBackground,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Confirm
          Expanded(
            child: GestureDetector(
              onTap: onConfirm,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      plan.accentColor,
                      plan.accentColor.withOpacity(0.70)
                    ]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: plan.accentColor.withOpacity(0.40),
                          blurRadius: 16,
                          offset: const Offset(0, 4))
                    ]),
                alignment: Alignment.center,
                child: Text('Confirm',
                    style: TextStyle(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ]),
    ]);
  }

  Widget _buildDoneState(SubscriptionPlan plan) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.success.withOpacity(0.40), width: 2)),
        child: Icon(Icons.check_rounded, color: AppColors.success, size: 34),
      ),
      const SizedBox(height: 20),
      Text('Plan Upgraded!',
          style: TextStyle(
              color: AppColors.darkOnSurface,
              fontSize: 20,
              fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      Text('You are now on the ${plan.name} plan.',
          style: TextStyle(color: AppColors.textTertiary, fontSize: 13),
          textAlign: TextAlign.center),
    ]);
  }

  Widget _confirmRow(String label, String value, {Color? valueColor}) =>
      Row(children: [
        Text(label,
            style:
                TextStyle(color: AppColors.textTertiary, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: TextStyle(
                color: valueColor ?? AppColors.darkOnSurface,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      ]);
}

// =============================================================================
// REUSABLE PRIVATE WIDGETS
// =============================================================================

// ── Glass-morphism card ───────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Gradient gradient;

  const _GlassCard({
    required this.child,
    required this.borderColor,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadow.withOpacity(0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 8))
            ]),
        child: child,
      );
}

// ── Days remaining ring ───────────────────────────────────────────────────────

class _DaysRingWidget extends StatelessWidget {
  final int daysLeft;
  final int total;
  final Color color;

  const _DaysRingWidget({
    required this.daysLeft,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 80,
        height: 80,
        child: CustomPaint(
          painter: _RingPainter(
              progress: daysLeft / total, color: color),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$daysLeft',
                      style: TextStyle(
                          color: color,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                  Text('days',
                      style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ]),
          ),
        ),
      );
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width / 2 - 6;

    // Track ring
    canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..color       = color.withOpacity(0.12)
          ..style       = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap   = StrokeCap.round);

    // Progress arc
    canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color       = color
          ..style       = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap   = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ── Horizontal progress bar ───────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final double height;

  const _ProgressBar({
    required this.progress,
    required this.color,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
            color: AppColors.darkOutline.withOpacity(0.20),
            borderRadius: BorderRadius.circular(height)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.60)]),
                  borderRadius: BorderRadius.circular(height)),
            ),
          ),
        ),
      );
}

// ── Usage stat card ───────────────────────────────────────────────────────────

class _UsageStatCard extends StatelessWidget {
  final SubscriptionUsageStat stat;
  const _UsageStatCard({required this.stat});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.darkSurfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.darkOutline.withOpacity(0.20))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            // Icon bubble
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: stat.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(stat.icon, color: stat.color, size: 17),
            ),
            const Spacer(),
            // Percentage label
            Text('${(stat.percent * 100).round()}%',
                style: TextStyle(
                    color: stat.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800)),
          ]),
          const Spacer(),
          // Label
          Text(stat.label,
              style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5)),
          const SizedBox(height: 4),
          // used / limit
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: stat.used,
                  style: TextStyle(
                      color: AppColors.darkOnSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
              TextSpan(
                  text: ' / ${stat.limit}',
                  style: TextStyle(
                      color: AppColors.textTertiary, fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 8),
          _ProgressBar(progress: stat.percent, color: stat.color, height: 4),
        ]),
      );
}

// ── Benefit row ───────────────────────────────────────────────────────────────

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool isLast;

  const _BenefitRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Icon bubble
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: TextStyle(
                        color: AppColors.darkOnSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                        height: 1.5)),
              ]),
            ),
          ]),
          if (!isLast) ...[
            const SizedBox(height: 20),
            Divider(
                color: AppColors.darkOutline.withOpacity(0.20),
                height: 1),
          ],
        ]),
      );
}

// ── Ambient glow blobs ────────────────────────────────────────────────────────

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) => Stack(children: [
        // Top-left — primary brand glow
        Positioned(
          top: -80,
          left: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.18),
                  Colors.transparent,
                ])),
          ),
        ),
        // Bottom-right — warning/amber warmth
        Positioned(
          bottom: 100,
          right: -80,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.warning.withOpacity(0.12),
                  Colors.transparent,
                ])),
          ),
        ),
      ]);
}

// =============================================================================
// PURE HELPERS
// =============================================================================

String _fmtDate(DateTime dt) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
}