import 'dart:async';
import 'package:flipper_models/helperModels/talker.dart' as talker_import;
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/PaymentHandler.dart';
import 'package:flipper_services/dodo/dodo_availability.dart';
import 'package:flipper_services/dodo/dodo_client.dart';
import 'package:flipper_services/dodo/dodo_models.dart';
import 'package:flipper_services/dodo/dodo_subscription.dart';
import 'package:flipper_services/payment_rail.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/supabase_realtime_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/models/subscription_plan.dart';
import 'package:flipper_models/models/subscription_plan_template.dart';
import 'package:flipper_payments/flipper_payments.dart' show BillingCadence;
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_dashboard/payment/payment_format.dart';
import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:flipper_dashboard/payment/widgets/payment_widgets.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_models/sync/capella/mixins/settings_mixin.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FailedPayment extends StatefulWidget {
  const FailedPayment({Key? key}) : super(key: key);

  @override
  _FailedPaymentState createState() => _FailedPaymentState();
}

class _FailedPaymentState extends State<FailedPayment>
    with PaymentHandler, CapellaSettingsMixin, TickerProviderStateMixin {
  late final TextEditingController _phoneNumberController;
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  Repository get repository => Repository();

  @override
  Talker get talker => talker_import.talker;

  @override
  DittoService get dittoService => DittoService.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move error handling here if needed, or ensure _setupPlanSubscription defers SnackBar
  }

  bool _isLoading = true;
  String? _errorMessage;
  Plan? _plan;
  bool _usePhoneNumber = false;
  bool _mounted = true;
  bool _waitingForPaymentCompletion = false;
  Timer? _paymentTimeoutTimer;
  Timer? _paymentCompletionPollTimer;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  // Discount code state
  String? _discountCode;
  double _discountAmount = 0;
  double _originalPrice = 0;
  bool _isValidatingCode = false;
  String? _discountError;

  // Skip payment limit state - managed by CapellaSettingsMixin
  PaymentSkipSettings? _skipSettings;
  bool _isLoadingSkipCount = true;

  // Plan switching state - allows user to switch/upgrade plan before retry
  SubscriptionPlanCatalog? _catalog;
  String? _switchPlanTemplateId;
  BillingCadence _switchPlanCadence = BillingCadence.monthly;
  final Set<String> _switchPlanAddonSlugs = {};
  bool _planWasActive = false;

  /// Matches backend [calculateAccumulatedDueAmount] / MTN validation; null until loaded.
  double? _chargeBaseRwf;

  // ── card rail (Dodo Payments) ─────────────────────────────────────────────
  //
  // This screen is where switching rails matters most: a customer whose MoMo
  // charge keeps failing is exactly the customer a card is for. Everything here
  // is additive — with the card rail unavailable, `_cardAvailable` stays false,
  // nothing new renders, and the retry path below is the one that shipped.
  PaymentRail _rail = PaymentRail.mtnMomo;
  bool _cardAvailable = false;
  DodoHealth? _dodoHealth;
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  DodoCheckout? _pendingCheckout;
  bool _cardPollRunning = false;
  bool _railInitialisedFromPlan = false;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();

    // Initialize animations for UI enhancement
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Keep original setup logic intact
    _loadPlanCatalog();
    _setupPlanSubscription();
    _loadSkipCount();
    _fadeController.forward();
    _probeCardRail();
    _prefillBillingEmail();
  }

  /// Asks the connector whether card payment is sellable here. Never throws:
  /// an unreachable connector simply means no card option.
  Future<void> _probeCardRail() async {
    final health = await dodoRailHealth();
    if (!_mounted) return;
    setState(() {
      _dodoHealth = health;
      // `readyForThisBuild`, not `ready`: the connector can be ready on live
      // while the mode this build transacts in has no credentials. Offering
      // Card then would fail on the first tap.
      _cardAvailable = health.readyForThisBuild;
    });
    _syncRailWithPlan();
  }

  /// Resume the waiting state when a checkout is already in flight.
  ///
  /// Tapping "Pay by card" hands off to the browser, and the OS is free to stop
  /// or recreate the Flutter view while the customer is on Dodo's page. When
  /// they come back, `initState` has run fresh — `_waitingForPaymentCompletion`
  /// is false — so the screen renders as if nothing were pending and shows no
  /// sign that a payment is being confirmed.
  ///
  /// The connector already knows: a `pending` subscription still holding a usable
  /// payment link *is* an unfinished checkout. Asking it on load is what makes
  /// the waiting state survive the hand-off.
  ///
  /// Deliberately does not resume for a terminal or entitled subscription —
  /// there is nothing to wait for — and never for the MoMo rail, whose waiting
  /// state is a bounded five-minute poll with different semantics.
  Future<void> _resumeCardCheckoutIfPending() async {
    if (!_cardAvailable || _waitingForPaymentCompletion) return;
    final planId = _plan?.id;
    if (planId == null || planId.isEmpty) return;
    if (!_rail.isCard) return;

    final DodoSubscriptionStatus status;
    try {
      // Cheap: the connector answers from its own row, with no Dodo round trip.
      status = await DodoClient(ProxyService.http).subscriptionForPlan(planId);
    } catch (e) {
      // No subscription yet, or the connector is unreachable. Either way there
      // is nothing to resume, and this must never block the screen.
      talker.info('No Dodo checkout to resume for plan $planId: $e');
      return;
    }

    if (!_mounted || status.entitled) return;
    final resumable = status.nextAction == DodoNextAction.openPaymentLink ||
        status.nextAction == DodoNextAction.updatePaymentMethod;
    if (!resumable || !status.checkout.hasLink) return;

    talker.info(
      'Resuming an in-flight Dodo checkout for plan $planId '
      '(${status.status}/${status.nextAction.name})',
    );
    setState(() {
      _waitingForPaymentCompletion = true;
      _pendingCheckout = status.checkout;
    });
    _startCardPolling(planId);
  }

  /// Preselects the rail the plan is already on.
  ///
  /// A customer whose subscription is a Dodo one should land on the card tab —
  /// asking them to re-pick it every time is how a retry ends up on the wrong
  /// rail. Runs once, and only towards `card`: [PaymentRail.fromWire] answers
  /// `mtnMomo` for every legacy value, so this can never move an existing MoMo
  /// plan anywhere.
  void _syncRailWithPlan() {
    if (_railInitialisedFromPlan || !_cardAvailable) return;
    final plan = _plan;
    if (plan == null) return;
    _railInitialisedFromPlan = true;
    final railFromPlan = PaymentRail.fromWire(plan.paymentMethod);
    if (railFromPlan.isCard && _rail.isMomo) {
      setState(() => _rail = railFromPlan);
    }
    // Both the rail and the plan are known now, which is what the resume check
    // needs. Fire-and-forget: it must not delay the screen.
    unawaited(_resumeCardCheckoutIfPending());
  }

  Future<void> _prefillBillingEmail() async {
    try {
      final business = await ProxyService.strategy.activeBusiness();
      final email = business?.email?.toString().trim();
      if (!_mounted || email == null || email.isEmpty || email == 'null') return;
      if (_emailController.text.trim().isEmpty) {
        _emailController.text = email;
      }
    } catch (e) {
      talker.warning('Could not prefill the billing email: $e');
    }
  }

  /// Loose on purpose — Dodo is the authority on deliverability, and rejecting
  /// an unusual but valid address here would block a payment for no reason.
  String? _getEmailError(String value) {
    final email = value.trim();
    if (email.isEmpty) return 'An email is required for the card receipt';
    if (!email.contains('@') || email.startsWith('@') || email.endsWith('@')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<void> _loadSkipCount() async {
    try {
      final businessId = (await ProxyService.strategy.activeBusiness())?.id;
      if (businessId == null) {
        talker.error('No active business found');
        if (mounted) {
          setState(() {
            _isLoadingSkipCount = false;
          });
        }
        return;
      }

      // Register for realtime updates
      final ditto = dittoService.dittoInstance;
      if (ditto != null) {
        final preparedSkip = prepareDqlSyncSubscription(
          'SELECT * FROM payment_skip_settings WHERE businessId = :businessId',
          {'businessId': businessId},
        );
        ditto.sync.registerSubscription(
          preparedSkip.dql,
          arguments: preparedSkip.arguments,
        );
      }

      final settings = await getPaymentSkipSettings(businessId: businessId);
      if (mounted) {
        setState(() {
          _skipSettings = settings;
          _isLoadingSkipCount = false;
        });
      }
    } catch (e) {
      talker.error('Error loading skip count: $e');
      if (mounted) {
        setState(() {
          _isLoadingSkipCount = false;
        });
      }
    }
  }

  Future<void> _incrementSkipCount() async {
    try {
      final businessId = (await ProxyService.strategy.activeBusiness())?.id;
      if (businessId == null) {
        talker.error('No active business found');
        return;
      }

      await incrementPaymentSkipCount(businessId: businessId);

      // Wait a bit for Ditto to sync the change
      await Future.delayed(const Duration(milliseconds: 300));

      // Reload settings to get updated count
      final settings = await getPaymentSkipSettings(businessId: businessId);
      if (mounted) {
        setState(() {
          _skipSettings = settings;
        });
      }
    } catch (e) {
      talker.error('Error incrementing skip count: $e');
    }
  }

  bool get _canSkip {
    return _isLoadingSkipCount ||
        (_skipSettings?.skipCount ?? 0) < (_skipSettings?.maxSkipsAllowed ?? 5);
  }

  int get _remainingSkips {
    return (_skipSettings?.maxSkipsAllowed ?? 5) -
        (_skipSettings?.skipCount ?? 0);
  }

  SubscriptionPlanTemplate? get _selectedSwitchTemplate =>
      _catalog?.byId(_switchPlanTemplateId);

  List<String> get _switchPlanAdditionalServices {
    final template = _selectedSwitchTemplate;
    if (template == null) return const [];
    return _switchPlanAddonSlugs
        .map((slug) => template.addonBySlug(slug)?.name)
        .whereType<String>()
        .toList();
  }

  Future<void> _loadPlanCatalog() async {
    try {
      final catalog = await ProxyService.strategy.getSubscriptionPlanCatalog();
      if (!mounted) return;
      setState(() {
        _catalog = catalog;
        if (_switchPlanTemplateId == null) {
          _switchPlanTemplateId = catalog.firstOrNull?.id;
        }
        if (_plan != null) {
          _initSwitchPlanFromPlan(_plan);
        }
      });
    } catch (e) {
      talker.error('Failed to load subscription plan catalog: $e');
    }
  }

  SubscriptionPlanTemplate? _switchTemplateForPlan(Plan? plan) {
    if (_catalog == null) return null;
    if (plan == null) return _catalog!.firstOrNull;
    return _catalog!.byId(plan.planTemplateId) ??
        _catalog!.byName(plan.selectedPlan) ??
        _catalog!.firstOrNull;
  }

  Set<String> _savedAddonSlugsForPlan(Plan plan) {
    final template = _switchTemplateForPlan(plan);
    if (template == null) return const {};
    final savedNames =
        plan.addons?.map((a) => a.addonName).whereType<String>().toSet() ??
            const {};
    return template.addons
        .where((addon) => savedNames.contains(addon.name))
        .map((addon) => addon.slug)
        .toSet();
  }

  /// Initialize plan switch state from current plan
  void _initSwitchPlanFromPlan(Plan? plan) {
    if (plan == null) return;
    final template = _switchTemplateForPlan(plan);
    _switchPlanTemplateId = template?.id ?? _catalog?.firstOrNull?.id;
    // `rule` first: `is_yearly_plan` cannot express a daily plan, so reading it
    // alone is what made a daily subscription show as Monthly here.
    _switchPlanCadence = plan.rule != null
        ? BillingCadence.fromWire(plan.rule)
        : ((plan.isYearlyPlan ?? false)
            ? BillingCadence.yearly
            : BillingCadence.monthly);
    _switchPlanAddonSlugs
      ..clear()
      ..addAll(_savedAddonSlugsForPlan(plan));
    _planWasActive = _isPlanStillActive(plan);
  }

  bool _isPlanStillActive(Plan plan) {
    final next = plan.nextBillingDate;
    if (next == null) return false;
    try {
      final d = DateTime.parse(next.toString().split('T')[0]);
      return d.isAfter(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  /// Charge base before discounts: server accumulated due, or catalogue when switching plan.
  double _baseChargeBeforeDiscount(Plan plan) {
    if (_switchUiDiffersFromPlan(plan)) {
      return _calculateSwitchPlanPrice();
    }
    return _chargeBaseRwf ?? plan.totalPrice?.toDouble() ?? 0.0;
  }

  double _totalDisplayAmount(Plan plan) {
    if (_discountAmount > 0) {
      final sub = _originalPrice > 0
          ? _originalPrice
          : _baseChargeBeforeDiscount(plan);
      return sub - _discountAmount;
    }
    return _baseChargeBeforeDiscount(plan);
  }

  Future<void> _refreshAmountDue(String planId) async {
    try {
      final data = await ProxyService.ht.getPlanAmountDue(
        flipperHttpClient: ProxyService.http,
        planId: planId,
      );
      if (!_mounted) return;
      final raw = data?['amountDue'];
      final amt = raw is num ? raw.toDouble() : double.tryParse('$raw');
      if (amt != null) {
        setState(() {
          _chargeBaseRwf = amt;
        });
      }
    } catch (e) {
      talker.error('Failed to load amount due: $e');
    }
  }

  /// Calculate price for switched plan from Supabase catalogue.
  double _calculateSwitchPlanPrice() {
    final template = _selectedSwitchTemplate;
    if (template == null) return 0;
    return template.calculateTotalFor(
      cadence: _switchPlanCadence,
      selectedAddonSlugs: _switchPlanAddonSlugs,
    );
  }

  /// True when the switch-plan UI does not match the saved plan (user changed tier, billing cycle, or add-ons).
  bool _switchUiDiffersFromPlan(Plan p) {
    final savedTemplate = _switchTemplateForPlan(p);
    if (_switchPlanTemplateId != savedTemplate?.id) return true;
    if (_switchPlanCadence != BillingCadence.fromWire(p.rule)) return true;
    final savedSlugs = _savedAddonSlugsForPlan(p);
    if (savedSlugs.length != _switchPlanAddonSlugs.length) return true;
    for (final slug in _switchPlanAddonSlugs) {
      if (!savedSlugs.contains(slug)) return true;
    }
    return false;
  }

  /// Build plan for retry: when the user did not change anything in the switch UI, keep the saved
  /// plan's [totalPrice], [rule], and tiers — do not replace with catalogue [_calculateSwitchPlanPrice].
  Plan _buildEffectivePlanForRetry() {
    final base = _plan!;
    if (!_switchUiDiffersFromPlan(base)) {
      return base;
    }
    final template = _selectedSwitchTemplate;
    final price = _calculateSwitchPlanPrice();
    return Plan(
      id: base.id,
      businessId: base.businessId,
      branchId: base.branchId,
      selectedPlan: template?.name ?? base.selectedPlan,
      planTemplateId: template?.id ?? base.planTemplateId,
      additionalDevices: base.additionalDevices ?? 0,
      isYearlyPlan: _switchPlanCadence.isYearly,
      totalPrice: price.toInt(),
      createdAt: base.createdAt,
      paymentCompletedByUser: base.paymentCompletedByUser,
      rule: _switchPlanCadence.wireValue,
      paymentMethod: base.paymentMethod ?? 'MTNMOMO',
      nextBillingDate: base.nextBillingDate,
      numberOfPayments: base.numberOfPayments ?? 1,
      addons: base.addons,
      phoneNumber: base.phoneNumber,
      externalId: base.externalId,
      paymentStatus: base.paymentStatus,
      lastProcessedAt: base.lastProcessedAt,
      lastError: base.lastError,
      updatedAt: base.updatedAt,
      lastUpdated: base.lastUpdated,
      processingStatus: base.processingStatus,
    );
  }

  @override
  void dispose() {
    _mounted = false;
    _subscription?.cancel();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _shakeController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _paymentTimeoutTimer?.cancel();
    _paymentCompletionPollTimer?.cancel();
    super.dispose();
  }

  // Keep original validation logic exactly as is
  String? _getPhoneNumberError(String value) {
    String digitsOnly = value.replaceAll(' ', '');

    if (digitsOnly.isEmpty) {
      return null;
    }

    if (!digitsOnly.startsWith('250')) {
      return 'Phone number must start with 250';
    }

    if (digitsOnly.length < 12) {
      return 'Phone number must be 12 digits';
    }

    if (digitsOnly.length > 12) {
      return 'Phone number cannot exceed 12 digits';
    }

    String prefix = digitsOnly.substring(3, 5);
    if (!['78', '79'].contains(prefix)) {
      return 'Invalid MTN number prefix (must start with 78 or 79)';
    }

    return null;
  }

  // Keep original setup logic exactly as is
  Future<void> _setupPlanSubscription() async {
    try {
      // Avoid an infinite spinner when Brick, Ditto, or Supabase never completes (e.g. flaky network).
      final businessId = (await ProxyService.strategy
          .activeBusiness()
          .timeout(const Duration(seconds: 15)))?.id;
      if (businessId == null) throw Exception('No active business');

      final fetchedPlan = await ProxyService.strategy
          .getPaymentPlan(
            businessId: businessId,
            fetchOnline: true,
            preferFresh: true,
          )
          .timeout(const Duration(seconds: 30));

      if (!_mounted) return;

      // Auto-enable phone input when plan and business have no phone.
      // Use strategy.getBusiness (local Brick cache) instead of Supabase so it works offline.
      final planPhone = fetchedPlan?.phoneNumber?.trim();
      String? businessPhone;
      if ((planPhone == null || planPhone.isEmpty) &&
          fetchedPlan?.businessId != null) {
        try {
          final biz = await ProxyService.strategy.getBusiness(
            businessId: fetchedPlan!.businessId!,
          );
          businessPhone = biz?.phoneNumber?.trim();
          // Fallback: try Ditto user_access when strategy returns null (e.g. Capella)
          if ((businessPhone == null || businessPhone.isEmpty) &&
              ProxyService.ditto.isReady()) {
            final userId = ProxyService.box.getUserId();
            if (userId != null) {
              final userAccess = await ProxyService.ditto.getUserAccess(userId);
              if (userAccess != null && userAccess.containsKey('businesses')) {
                final businesses =
                    userAccess['businesses'] as List<dynamic>? ?? [];
                for (final b in businesses) {
                  final m = Map<String, dynamic>.from(b as Map);
                  if (m['id'] == fetchedPlan.businessId) {
                    final raw = m['phone_number'] ?? m['phoneNumber'];
                    businessPhone = raw != null ? raw.toString().trim() : null;
                    break;
                  }
                }
              }
            }
          }
        } catch (_) {
          // Offline or fetch failed: assume no business phone, enable phone input
          businessPhone = null;
        }
      }
      final needsPhoneInput =
          (planPhone == null || planPhone.isEmpty) &&
          (businessPhone == null || businessPhone.isEmpty);

      setState(() {
        _plan = fetchedPlan;
        _isLoading = false;
        if (needsPhoneInput) _usePhoneNumber = true;
        _initSwitchPlanFromPlan(fetchedPlan);
      });
      _syncRailWithPlan();

      final pid = fetchedPlan?.id;
      if (pid != null) {
        unawaited(_refreshAmountDue(pid));
      }

      // Realtime from Supabase (plans are not in local Brick/SQLite)
      try {
        _subscription = Supabase.instance.client
            .from('plans')
            .stream(primaryKey: ['id'])
            .eq('business_id', businessId)
            .listen((rows) {
              if (rows.isEmpty) return;
              final updatedPlan = Plan.fromSupabaseJson(
                Map<String, dynamic>.from(rows.first),
              );
              if (!_mounted) return;

              setState(() {
                _plan = updatedPlan;
              });

              unawaited(_refreshAmountDue(updatedPlan.id!));

              if (updatedPlan.paymentCompletedByUser == true) {
                _paymentTimeoutTimer?.cancel();
                _paymentCompletionPollTimer?.cancel();
                if (_mounted) {
                  setState(() {
                    _waitingForPaymentCompletion = false;
                  });
                  locator<RouterService>().navigateTo(FlipperAppRoute());
                }
              }
            },
            onError: (error, stackTrace) => logSupabaseRealtimeError(
              error,
              source: 'plans failed payment',
              stackTrace: stackTrace,
            ),
          );
      } catch (_) {
        // Subscription fails when offline; initial plan came from Ditto / getPaymentPlan
      }
    } catch (e) {
      if (!_mounted) return;

      final message = e is TimeoutException
          ? 'Loading took too long. Check your connection, refresh the page, or try again.'
          : 'Error loading plan details: $e';

      setState(() {
        _errorMessage = message;
        _isLoading = false;
      });

      // Defer SnackBar to ensure context is valid
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showCustomSnackBarUtil(
          context,
          'Payment Failed try again',
          backgroundColor: Colors.red,
          showCloseButton: true,
        );
      });
    }
  }

  /// Validates and applies a discount code
  Future<void> _validateDiscountCode(String code) async {
    if (code.trim().isEmpty) {
      setState(() {
        _discountError = null;
        _discountAmount = 0;
        _discountCode = null;
      });
      return;
    }

    setState(() {
      _isValidatingCode = true;
      _discountError = null;
    });

    try {
      final planPrice =
          _plan != null ? _baseChargeBeforeDiscount(_plan!) : 0.0;
      // Initialize _originalPrice to planPrice if it's unset (<= 0) before validation
      final effectiveOriginalPrice = _originalPrice <= 0
          ? planPrice
          : _originalPrice;

      final result = await ProxyService.strategy.validateDiscountCode(
        code: code.trim().toUpperCase(),
        planName: _plan?.selectedPlan ?? '',
        amount: effectiveOriginalPrice,
      );

      if (mounted) {
        if (result['is_valid'] == true) {
          final discountType = result['discount_type'] as String;
          final discountValue = (result['discount_value'] as num).toDouble();

          final calculatedDiscount = ProxyService.strategy.calculateDiscount(
            originalPrice: effectiveOriginalPrice,
            discountType: discountType,
            discountValue: discountValue,
          );

          setState(() {
            _discountCode = code.trim().toUpperCase();
            _discountAmount = calculatedDiscount;
            _discountError = null;
            _isValidatingCode = false;
            // Only update _originalPrice if it was previously unset or different
            if (_originalPrice <= 0) {
              _originalPrice = planPrice;
            }
          });

          talker.info(
            'Discount code applied: $code - ${discountType == 'percentage' ? '${discountValue}%' : 'RWF $discountValue'}',
          );
        } else {
          setState(() {
            _discountError = result['error_message'] as String?;
            _discountAmount = 0;
            _discountCode = null;
            _isValidatingCode = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _discountError = 'Failed to validate code';
          _discountAmount = 0;
          _discountCode = null;
          _isValidatingCode = false;
        });
      }
      talker.error('Error validating discount code: $e');
    }
  }

  /// Debug-only shortcut to preview Payment Plan without active-subscription redirect.
  Widget _debugPaymentPlanButton() {
    return TextButton(
      onPressed: () => locator<RouterService>().replaceWith(
        PaymentPlanUIRoute(skipPaymentStatusCheck: true),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      child: Text(
        'Payment Plan',
        style: PaymentTypography.inlineLabel(
          color: PaymentTokens.blue,
        ).copyWith(fontSize: 13, fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _plan == null) {
      return const Scaffold(
        backgroundColor: PaymentTokens.app,
        body: PaymentCenterLoading(message: 'Loading payment details…'),
      );
    }

    if (_waitingForPaymentCompletion) {
      // No `overlay` here: it renders opaque and full-screen, which would hide
      // the "Reopen payment page" / "Not now" buttons that
      // _buildPaymentWaitingContent() already provides below — leaving the
      // customer stuck on a bare spinner with no way to reopen the link or
      // back out.
      return PaymentScreenShell(
        title: 'Payment Issue',
        showBack: false,
        actions: kDebugMode ? [_debugPaymentPlanButton()] : null,
        children: [
          _buildPaymentWaitingContent(),
        ],
      );
    }

    return PaymentScreenShell(
      title: 'Payment Issue',
      showBack: false,
      actions: kDebugMode ? [_debugPaymentPlanButton()] : null,
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: _buildHeaderSection(),
        ),
        if (_plan != null)
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildPlanDetails(_plan!),
          ),
        if (_errorMessage != null)
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildErrorMessage(),
          ),
        if (_plan != null)
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildSwitchPlanSection(),
          ),
        if (_plan != null)
          FadeTransition(
            opacity: _fadeAnimation,
            child: PaymentDiscountSection(
              onCodeChanged: _validateDiscountCode,
              errorMessage: _discountError,
              isValidating: _isValidatingCode,
            ),
          ),
        // A customer whose Mobile Money charge keeps failing is exactly who a
        // card is for, so the choice belongs on this screen — but only when the
        // connector says the card rail is sellable.
        if (_plan != null && _cardAvailable)
          FadeTransition(
            opacity: _fadeAnimation,
            child: PaymentRailSelector(
              rail: _rail,
              enabled: !_isLoading && !_waitingForPaymentCompletion,
              onChanged: (rail) => setState(() {
                _rail = rail;
                _emailError = null;
                _errorMessage = null;
              }),
            ),
          ),
        if (_plan != null)
          FadeTransition(
            opacity: _fadeAnimation,
            child: _rail.isCard
                ? _buildCardSection()
                : _buildPhoneNumberSection(),
          ),
        FadeTransition(
          opacity: _fadeAnimation,
          child: _buildRetryButton(context),
        ),
        FadeTransition(
          opacity: _fadeAnimation,
          child: _buildHelpSection(),
        ),
      ],
    );
  }

  Widget _buildPaymentWaitingContent() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: PaymentTokens.blueTint,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: PaymentTokens.blueTint2),
                ),
                child: Icon(
                  _rail.isCard
                      ? FluentIcons.credit_card_person_24_regular
                      : FluentIcons.phone_24_regular,
                  size: 38,
                  color: PaymentTokens.blue,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          _rail.isCard
              ? 'Complete Payment on the Card Page'
              : 'Complete Payment on Your Phone',
          style: PaymentTypography.heroHeadline(),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          _rail.isCard
              ? 'Enter your card details on the page that opened.\n'
                  'This screen updates on its own once the payment goes through.'
              : 'A payment request has been sent to your MTN Mobile Money.\n'
                  'Open your phone and approve the transaction.',
          style: PaymentTypography.body(),
          textAlign: TextAlign.center,
        ),
        if (_rail.isCard && _pendingCheckout?.paymentLink != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _reopenCheckout(_pendingCheckout!.paymentLink!),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Reopen payment page'),
          ),
        ],
        // The waiting screen has no back button, so without this a customer who
        // abandoned the checkout — or whose screen resumed into a stale pending
        // subscription — would be stuck watching a spinner with no way out.
        if (_rail.isCard) ...[
          const SizedBox(height: 4),
          TextButton(
            onPressed: _stopWaitingForCard,
            child: const Text('Not now — back to payment options'),
          ),
        ],
        const SizedBox(height: 32),
        const SizedBox(
          width: 46,
          height: 46,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: PaymentTokens.blue,
            backgroundColor: PaymentTokens.line,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Checking payment status…',
          style: PaymentTypography.hint(),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value *
                10 *
                (0.5 - (0.5 * _shakeAnimation.value)) *
                2,
            0,
          ),
          child: const PaymentHeroBlock(
            headline: 'Payment Needs Attention',
            body:
                "Don't worry, this happens sometimes.\nLet's get you sorted out quickly.",
          ),
        );
      },
    );
  }

  Widget _buildSwitchPlanSection() {
    final template = _selectedSwitchTemplate;
    final yearlyDiscount = template?.yearlyDiscountPercent ?? 20;
    final templates = _catalog?.templates ?? const [];

    return PaymentAccordion(
      title: 'Switch or upgrade plan',
      subtitleOpen: 'Tap to collapse',
      subtitleClosed: 'Choose a different plan before retrying',
      initiallyOpen: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_planWasActive)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PaymentTokens.blueTint,
                borderRadius: BorderRadius.circular(PaymentTokens.rMd),
                border: Border.all(color: PaymentTokens.blueTint2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    FluentIcons.info_16_regular,
                    size: 18,
                    color: PaymentTokens.blue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your plan is still active. You can upgrade or switch plans below. '
                      'The new plan will apply from your next billing cycle.',
                      style: PaymentTypography.hint(),
                    ),
                  ),
                ],
              ),
            ),
          PaymentCadenceSegment(
            cadence: _switchPlanCadence,
            yearlyDiscountPercent: yearlyDiscount,
            onChanged: (cadence) {
              setState(() => _switchPlanCadence = cadence);
            },
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < templates.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            PaymentPlanTile(
              name: templates[i].name,
              priceLine: formatPaymentTilePriceFor(
                templates[i],
                cadence: _switchPlanCadence,
              ),
              icon: templates[i].resolveIcon(),
              selected: _switchPlanTemplateId == templates[i].id,
              onTap: () {
                setState(() {
                  _switchPlanTemplateId = templates[i].id;
                  _switchPlanAddonSlugs.clear();
                  _discountCode = null;
                  _discountAmount = 0;
                });
              },
            ),
          ],
          if (template != null && template.addons.isNotEmpty) ...[
            const SizedBox(height: 12),
            PaymentSectionLabel(
              template.isEnterprise
                  ? 'Enterprise Services'
                  : 'Additional Services',
            ),
            const SizedBox(height: 8),
            for (final addon in template.addons) ...[
              PaymentAddonRow(
                name: addon.name,
                priceLine: formatPaymentAddonPriceFor(
                  template,
                  addon,
                  cadence: _switchPlanCadence,
                ),
                enabled: _switchPlanAddonSlugs.contains(addon.slug),
                onChanged: (selected) {
                  setState(() {
                    if (selected) {
                      _switchPlanAddonSlugs.add(addon.slug);
                    } else {
                      _switchPlanAddonSlugs.remove(addon.slug);
                    }
                  });
                },
              ),
              const SizedBox(height: 8),
            ],
          ],
          PaymentTotalCard(
            label: 'New plan total',
            total: _calculateSwitchPlanPrice(),
            subtitle: template?.name ?? '',
            cadence: _switchPlanCadence,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PaymentTokens.lossTint,
        borderRadius: BorderRadius.circular(PaymentTokens.rMd),
        border: Border.all(
          color: PaymentTokens.loss.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            FluentIcons.warning_20_regular,
            color: PaymentTokens.loss,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: PaymentTypography.body().copyWith(
                color: PaymentTokens.loss,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _formatPhoneInput(String value) {
    final digits = value.replaceAll(' ', '');
    if (digits.length <= 3) {
      _phoneNumberController.text = digits;
    } else if (digits.length <= 5) {
      _phoneNumberController.text =
          '${digits.substring(0, 3)} ${digits.substring(3)}';
    } else if (digits.length <= 8) {
      _phoneNumberController.text =
          '${digits.substring(0, 3)} ${digits.substring(3, 5)} ${digits.substring(5)}';
    } else {
      _phoneNumberController.text =
          '${digits.substring(0, 3)} ${digits.substring(3, 5)} ${digits.substring(5, 8)} ${digits.substring(8)}';
    }
    _phoneNumberController.selection = TextSelection.collapsed(
      offset: _phoneNumberController.text.length,
    );
    setState(() {});
  }

  Widget _buildPhoneNumberSection() {
    return PaymentMobileMoneyCard(
      useDifferentNumber: _usePhoneNumber,
      onUseDifferentChanged: (value) {
        setState(() {
          _usePhoneNumber = value;
          if (!value) {
            _phoneNumberController.clear();
          }
        });
      },
      phoneController: _phoneNumberController,
      onPhoneChanged: _formatPhoneInput,
      phoneError: _usePhoneNumber
          ? _getPhoneNumberError(_phoneNumberController.text)
          : null,
    );
  }

  Widget _buildCardSection() {
    return PaymentCardCheckoutCard(
      emailController: _emailController,
      emailError: _emailError,
      isTestMode: _dodoHealth?.isTestMode ?? false,
      discountApplied: _discountAmount > 0,
      pendingCheckoutLink: _pendingCheckout?.paymentLink,
      onOpenPendingLink: _pendingCheckout?.paymentLink == null
          ? null
          : () => _reopenCheckout(_pendingCheckout!.paymentLink!),
      onEmailChanged: (_) {
        if (_emailError != null) setState(() => _emailError = null);
      },
    );
  }

  Future<void> _reopenCheckout(String link) async {
    final opened = await DodoCardCheckout(DodoClient(ProxyService.http))
        .openPaymentLink(link);
    if (!_mounted || opened) return;
    setState(() {
      _errorMessage =
          'Could not open the payment page on this device. Try Mobile Money, '
          'or finish the payment on a phone or computer with a browser.';
    });
  }

  /// The card retry, kept entirely apart from [_retryPayment].
  ///
  /// Nothing about the Mobile Money path is reused or reordered here on
  /// purpose: that path takes consent then pushes a debit and polls MTN, and
  /// grafting a hosted checkout into it is how you end up breaking the rail
  /// that works. The two only meet at the `plans` row.
  Future<void> _startCardRetry(BuildContext context) async {
    final plan = _plan;
    if (plan == null) return;

    final emailError = _getEmailError(_emailController.text);
    if (emailError != null) {
      setState(() => _emailError = emailError);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _emailError = null;
    });

    try {
      // Carry any plan switch the user made above into the card subscription;
      // Dodo prices the tier from the catalogue, so the tier has to be right.
      final effectivePlan = _buildEffectivePlanForRetry();
      final result = await handleCardPayment(
        plan: effectivePlan,
        email: _emailController.text.trim(),
      );

      if (!_mounted) return;

      switch (result.outcome) {
        case DodoCheckoutOutcome.entitled:
          setState(() => _isLoading = false);
          locator<RouterService>().navigateTo(FlipperAppRoute());
          return;

        case DodoCheckoutOutcome.resubscribeRequired:
          setState(() {
            _isLoading = false;
            _errorMessage = result.message ??
                'This subscription has ended. Pick a plan above to start again.';
          });
          return;

        case DodoCheckoutOutcome.awaitingPayment:
        case DodoCheckoutOutcome.needsPaymentMethod:
          setState(() {
            _isLoading = false;
            _waitingForPaymentCompletion = true;
            _pendingCheckout = result.checkout;
          });
          // Longer than the Mobile Money timeout: a card, possibly through a
          // 3-D Secure step, in a browser the customer had to switch to, is not
          // a 90-second affair.
          _paymentTimeoutTimer?.cancel();
          _paymentTimeoutTimer = Timer(const Duration(minutes: 12), () {
            if (!_mounted) return;
            setState(() {
              _waitingForPaymentCompletion = false;
              _errorMessage =
                  'We have not seen the card payment yet. If you completed it, '
                  'reopen this screen in a moment — it can take a little while '
                  'to arrive.';
            });
          });
          _startCardPolling(result.planId);
          return;

        case DodoCheckoutOutcome.couldNotOpenLink:
          // handleCardPayment raises CardCheckoutUnavailable for this, so this
          // arm should be unreachable. It still reports, rather than returning
          // silently: a silent arm here is indistinguishable from a dead button,
          // which is exactly the failure that is hardest to diagnose.
          setState(() {
            _isLoading = false;
            _pendingCheckout = result.checkout;
            _errorMessage = result.message ??
                'Could not open the card payment page on this device. Use the '
                    'link below, or pay with Mobile Money.';
          });
          _reportCardFailure(context, _errorMessage!);
          return;
      }
    } on CardCheckoutUnavailable catch (e) {
      if (!_mounted) return;
      setState(() {
        _isLoading = false;
        _pendingCheckout = e.checkout ?? _pendingCheckout;
        _errorMessage = e.message;
      });
      _reportCardFailure(context, e.message);
    } on DodoException catch (e) {
      if (!_mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.displayMessage;
      });
      _reportCardFailure(context, e.displayMessage);
    } catch (e) {
      if (!_mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Card payment could not be started: $e';
      });
      _reportCardFailure(context, 'Card payment could not be started.');
    }
  }

  /// Leave the card waiting state without treating it as a failure.
  ///
  /// Nothing is cancelled upstream: the Dodo subscription stays pending and its
  /// link stays valid, so the customer can finish later and the connector's
  /// webhook still settles it. This only stops *this screen* waiting.
  void _stopWaitingForCard() {
    _paymentTimeoutTimer?.cancel();
    if (!_mounted) return;
    setState(() {
      _waitingForPaymentCompletion = false;
      _errorMessage = null;
    });
  }

  /// Surface a card failure the same way the Mobile Money path does.
  ///
  /// Setting `_errorMessage` alone renders a panel that can sit below the fold
  /// on a long screen, so the only thing the user reliably notices is the shake
  /// — which reads as "I tapped and it blinked and nothing happened". The
  /// MoMo arm below has always shown a snackbar; this makes the card arm match.
  void _reportCardFailure(BuildContext context, String message) {
    _shakeController.forward().then((_) => _shakeController.reset());
    talker.error('Card payment failed: $message');
    if (!mounted) return;
    showCustomSnackBarUtil(
      context,
      message,
      backgroundColor: PaymentTokens.loss,
      showCloseButton: true,
    );
  }

  /// Waits for the card money to land.
  ///
  /// Separate from [_startPaymentCompletionPolling] because the questions are
  /// different: that one asks MTN about a reference, this one asks the connector
  /// about a subscription — and forces a read-through to Dodo every few polls,
  /// so a webhook that never arrives costs seconds rather than the connector's
  /// whole reconcile interval.
  Future<void> _startCardPolling(String planId) async {
    if (_cardPollRunning || planId.isEmpty) return;
    _cardPollRunning = true;

    final status = await DodoCardCheckout(DodoClient(ProxyService.http))
        .awaitEntitlement(
      planId,
      isCancelled: () => !_mounted || !_waitingForPaymentCompletion,
    );

    _cardPollRunning = false;
    if (!_mounted || !_waitingForPaymentCompletion) return;

    _paymentTimeoutTimer?.cancel();

    if (status?.entitled == true) {
      setState(() => _waitingForPaymentCompletion = false);
      locator<RouterService>().navigateTo(FlipperAppRoute());
      return;
    }

    setState(() {
      _waitingForPaymentCompletion = false;
      _errorMessage = status?.lastError ??
          'The card payment has not come through. Try again, or use Mobile '
              'Money.';
    });
  }

  Widget _buildRetryButton(BuildContext context) {
    final retrying = _isLoading && !_waitingForPaymentCompletion;

    return Column(
      children: [
        PaymentPrimaryButton(
          label: _rail.isCard ? 'Pay by card' : 'Try Again',
          loading: retrying,
          loadingLabel: _rail.isCard ? 'Opening…' : 'Retrying…',
          icon: _rail.isCard
              ? FluentIcons.credit_card_person_20_regular
              : FluentIcons.arrow_sync_20_regular,
          onPressed: _plan == null || _waitingForPaymentCompletion
              ? null
              : () async {
                  // The card rail has its own start-and-wait; the Mobile Money
                  // path below is untouched by it.
                  if (_rail.isCard) {
                    await _startCardRetry(context);
                    return;
                  }

                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });

                  try {
                    final paymentRef = await _retryPayment(
                      context,
                      plan: _plan!,
                      isLoading: _isLoading,
                      phoneNumber: _usePhoneNumber
                          ? _phoneNumberController.text
                          : null,
                    );
                    if (_mounted) {
                      setState(() {
                        _waitingForPaymentCompletion = true;
                        _isLoading = false;
                      });
                      _paymentTimeoutTimer?.cancel();
                      _paymentTimeoutTimer = Timer(
                        const Duration(minutes: 5),
                        () {
                          if (_mounted) {
                            _paymentCompletionPollTimer?.cancel();
                            setState(() {
                              _waitingForPaymentCompletion = false;
                              _errorMessage =
                                  'Payment timeout. Please try again.';
                            });
                            showCustomSnackBarUtil(
                              context,
                              'Payment timeout. Please try again.',
                              backgroundColor: PaymentTokens.loss,
                              showCloseButton: true,
                            );
                          }
                        },
                      );
                      final businessId = _plan!.businessId;
                      final planId = _plan!.id;
                      if (businessId != null && planId != null) {
                        _startPaymentCompletionPolling(
                          businessId,
                          paymentRef,
                          planId,
                        );
                      }
                    }
                  } on MomoPreapprovalDeclined catch (e) {
                    // The payer refused the Mobile Money mandate, so we never
                    // asked for their money. Saying "payment failed" here sends
                    // them looking for a debit that does not exist.
                    _paymentTimeoutTimer?.cancel();
                    if (!_mounted) return;
                    setState(() {
                      _errorMessage = e.message;
                      _waitingForPaymentCompletion = false;
                    });

                    _shakeController.forward().then((_) {
                      _shakeController.reset();
                    });

                    showCustomSnackBarUtil(
                      context,
                      'Nothing was charged. Approve the Mobile Money request on '
                      'your phone, then try again.',
                      backgroundColor: const Color(0xFF0B1220),
                      showCloseButton: true,
                    );
                  } catch (e) {
                    _paymentTimeoutTimer?.cancel();
                    if (!_mounted) return;
                    setState(() {
                      _errorMessage = 'Payment failed: $e';
                      _waitingForPaymentCompletion = false;
                    });

                    _shakeController.forward().then((_) {
                      _shakeController.reset();
                    });

                    showCustomSnackBarUtil(
                      context,
                      _usePhoneNumber
                          ? 'Payment failed. Try again.'
                          : 'Payment failed again. Try a different MTN number or plan.',
                      backgroundColor: const Color(0xFF0B1220),
                      showCloseButton: true,
                    );
                  } finally {
                    if (_mounted && !_waitingForPaymentCompletion) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
        ),
        const SizedBox(height: 12),
        if (!_isLoadingSkipCount) ...[
          if (!_canSkip)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: PaymentTokens.lossTint,
                borderRadius: BorderRadius.circular(PaymentTokens.rMd),
                border: Border.all(
                  color: PaymentTokens.loss.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'Maximum skip limit reached. Please complete payment to continue.',
                style: PaymentTypography.body().copyWith(
                  color: PaymentTokens.loss,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            Text(
              'You can skip $_remainingSkips more time${_remainingSkips == 1 ? '' : 's'}',
              style: PaymentTypography.hint(),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 8),
        ],
        PaymentSecondaryButton(
          label: _canSkip ? 'Skip for Now' : 'Skip Limit Reached',
          onPressed: _isLoadingSkipCount || !_canSkip
              ? null
              : () async {
                  await _incrementSkipCount();
                  locator<RouterService>().navigateTo(FlipperAppRoute());
                },
        ),
      ],
    );
  }

  Widget _buildPlanDetails(Plan plan) {
    final currency = ProxyService.box.defaultCurrency();
    final priceLabel = _discountAmount > 0 ? 'Total' : 'Price';
    final rows = <PaymentSummaryRow>[
      PaymentSummaryRow(
        label: 'Plan',
        value:
            _switchTemplateForPlan(plan)?.name ?? plan.selectedPlan ?? 'N/A',
      ),
      if (_discountAmount > 0) ...[
        PaymentSummaryRow(
          label: 'Subtotal',
          value: formatPaymentTotal(
            _originalPrice > 0 ? _originalPrice : _baseChargeBeforeDiscount(plan),
          ),
          mono: true,
        ),
        PaymentSummaryRow(
          label: _discountCode != null
              ? 'Discount ($_discountCode)'
              : 'Discount',
          value: '- ${formatPaymentRwf(_discountAmount)} $currency',
          mono: true,
          highlight: true,
        ),
      ],
      PaymentSummaryRow(
        label: priceLabel,
        value: formatPaymentTotal(_totalDisplayAmount(plan)),
        mono: true,
      ),
      PaymentSummaryRow(
        label: 'Billing',
        value: BillingCadence.fromWire(plan.rule).label,
      ),
      if (plan.additionalDevices != null && plan.additionalDevices! > 0)
        PaymentSummaryRow(
          label: 'Additional Devices',
          value: plan.additionalDevices.toString(),
        ),
    ];

    return PaymentSummaryCard(rows: rows);
  }

  Widget _buildHelpSection() {
    return PaymentHelpCard(
      onTap: () {
        // Handle contact support
      },
    );
  }

  // Retry payment with mobile money. Returns payment reference when successful.
  Future<String?> _retryPayment(
    BuildContext context, {
    required Plan plan,
    required bool isLoading,
    String? phoneNumber,
  }) async {
    if (_usePhoneNumber) {
      final phoneValue = (phoneNumber ?? '').trim();
      if (phoneValue.isEmpty) {
        throw Exception('Please enter your MTN phone number.');
      }
      final phoneError = _getPhoneNumberError(phoneValue);
      if (phoneError != null) {
        throw Exception(phoneError);
      }
      final cleanPhone = phoneValue.replaceAll(' ', '').replaceAll('+', '');
      // Save to plan in Supabase
      await Supabase.instance.client
          .from('plans')
          .update({'phone_number': cleanPhone})
          .eq('id', plan.id!);
      plan.phoneNumber = cleanPhone;
    } else {
      // Use plan phone, or fetch from business in Supabase
      var planPhone = plan.phoneNumber
          ?.replaceAll(' ', '')
          .replaceAll('+', '')
          .trim();
      if (planPhone == null || planPhone.isEmpty) {
        final biz = await Supabase.instance.client
            .from('businesses')
            .select('phone_number')
            .eq('id', plan.businessId!)
            .maybeSingle();
        final bizPhone = (biz?['phone_number'] as String?)
            ?.replaceAll(' ', '')
            .replaceAll('+', '')
            .trim();
        if (bizPhone == null || bizPhone.isEmpty) {
          throw Exception(
            'Phone number is required for MTN Mobile Money. '
            'Please enable "Use different phone number" and enter your MTN number.',
          );
        }
        // Save business phone to plan in Supabase for future use
        await Supabase.instance.client
            .from('plans')
            .update({'phone_number': bizPhone})
            .eq('id', plan.id!);
        plan.phoneNumber = bizPhone;
      }
    }

    // Use effective plan (includes any plan switch/upgrade from UI)
    final effectivePlan = _buildEffectivePlanForRetry();
    effectivePlan.phoneNumber = plan.phoneNumber;

    // Save switched plan to backend before payment (handleMomoPayment also saves,
    // but we ensure plan is persisted with switched values). Include add-on-only changes.
    if (_switchUiDiffersFromPlan(plan)) {
      await ProxyService.strategy.saveOrUpdatePaymentPlan(
        businessId: (await ProxyService.strategy.activeBusiness())!.id,
        selectedPlan: _selectedSwitchTemplate?.name ?? effectivePlan.selectedPlan ?? 'Mobile',
        planTemplateId: _selectedSwitchTemplate?.id,
        additionalDevices: effectivePlan.additionalDevices ?? 0,
        isYearlyPlan: _switchPlanCadence.isYearly,
        rule: _switchPlanCadence.wireValue,
        totalPrice: _calculateSwitchPlanPrice(),
        paymentMethod: 'MTNMOMO',
        plan: effectivePlan,
        addons: _switchPlanAdditionalServices.isNotEmpty
            ? _switchPlanAdditionalServices
            : null,
        flipperHttpClient: ProxyService.http,
      );
    }

    // Charge accumulated due from server when not switching plans (matches MTN validation).
    final planPrice = _switchUiDiffersFromPlan(plan)
        ? _calculateSwitchPlanPrice()
        : _baseChargeBeforeDiscount(plan);
    final finalPrice = planPrice - _discountAmount;
    final finalPriceInt = finalPrice > 0 ? finalPrice.toInt() : 0;

    // Handle mobile money payment with the discounted price.
    // Returns payment reference when successful, for polling status.
    return handleMomoPayment(finalPriceInt, plan: effectivePlan);
  }

  /// Polls for payment completion when we have a reference or can check plan.
  /// When MTN confirms success via checkPaymentStatus, we update the plan in
  /// Supabase ourselves (backend PaymentChecker may not have run yet).
  void _startPaymentCompletionPolling(
    String businessId, [
    String? paymentReference,
    String? planId,
  ]) {
    const pollInterval = Duration(seconds: 12);

    void poll() async {
      if (!_mounted || !_waitingForPaymentCompletion) return;

      try {
        // Fast path: check MTN API directly when we have the reference.
        // Backend PaymentChecker may not have updated the plan yet, so we
        // update Supabase ourselves when MTN confirms success.
        if (paymentReference != null && paymentReference.isNotEmpty) {
          // Read the verdict first: `checkPaymentStatus` reports a refusal and
          // a not-yet identically, so on its own the screen spins for the full
          // five minutes on a charge MTN turned down in the first ten seconds.
          final settlement = await ProxyService.ht.momoSettlement(
            flipperHttpClient: ProxyService.http,
            paymentReference: paymentReference,
          );
          if (settlement.isFailed && _mounted) {
            _paymentTimeoutTimer?.cancel();
            _paymentCompletionPollTimer?.cancel();
            setState(() {
              _waitingForPaymentCompletion = false;
              _errorMessage = settlement.reason?.trim().isNotEmpty == true
                  ? '${settlement.reason} Nothing was charged — try again.'
                  : 'The payment was declined. Nothing was charged — try again.';
            });
            return;
          }

          final completed = settlement.isSuccessful &&
              // Still routed through checkPaymentStatus: that is what settles
              // the local payment row and grants credits, exactly once.
              await ProxyService.ht.checkPaymentStatus(
                flipperHttpClient: ProxyService.http,
                paymentReference: paymentReference,
              );
          if (completed && _mounted) {
            _paymentTimeoutTimer?.cancel();
            _paymentCompletionPollTimer?.cancel();
            if (planId != null) {
              try {
                await ProxyService.ht.finalizePaymentOnSuccess(
                  flipperHttpClient: ProxyService.http,
                  planId: planId,
                  paymentReference: paymentReference,
                );
              } catch (e) {
                talker.error('Failed to finalize payment on backend: $e');
              }
            }
            setState(() => _waitingForPaymentCompletion = false);
            locator<RouterService>().navigateTo(FlipperAppRoute());
            return;
          }
        }

        // Backup: fetch fresh plan from backend (skip Ditto cache)
        final plan = await ProxyService.strategy.getPaymentPlan(
          businessId: businessId,
          fetchOnline: true,
          preferFresh: true,
        );
        if (plan != null &&
            (plan.paymentCompletedByUser == true ||
                (plan.paymentStatus?.toUpperCase() == 'COMPLETED'))) {
          if (_mounted) {
            _paymentTimeoutTimer?.cancel();
            _paymentCompletionPollTimer?.cancel();
            setState(() => _waitingForPaymentCompletion = false);
            locator<RouterService>().navigateTo(FlipperAppRoute());
          }
        }
      } catch (e) {
        talker.error('Payment completion poll error: $e');
      }

      if (_mounted && _waitingForPaymentCompletion) {
        _paymentCompletionPollTimer = Timer(pollInterval, poll);
      }
    }

    _paymentCompletionPollTimer = Timer(pollInterval, poll);
  }
}
