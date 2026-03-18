import 'dart:async';
import 'package:flipper_models/helperModels/talker.dart' as talker_import;
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/PaymentHandler.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/repository.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flipper_web/services/ditto_service.dart';
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
  models.Plan? _plan;
  bool _usePhoneNumber = false;
  bool _mounted = true;
  bool _waitingForPaymentCompletion = false;
  Timer? _paymentTimeoutTimer;
  Timer? _paymentCompletionPollTimer;
  StreamSubscription<List<models.Plan>>? _subscription;

  // Discount code state
  String? _discountCode;
  double _discountAmount = 0;
  double _originalPrice = 0;
  bool _isValidatingCode = false;
  String? _discountError;

  // Skip payment limit state - managed by CapellaSettingsMixin
  PaymentSkipSettings? _skipSettings;
  bool _isLoadingSkipCount = true;

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
    _setupPlanSubscription();
    _loadSkipCount();
    _fadeController.forward();
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
        ditto.sync.registerSubscription(
          'SELECT * FROM payment_skip_settings WHERE businessId = :businessId',
          arguments: {'businessId': businessId},
        );
        ditto.store.registerObserver(
          'SELECT * FROM payment_skip_settings WHERE businessId = :businessId',
          arguments: {'businessId': businessId},
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

  @override
  void dispose() {
    _mounted = false;
    _subscription?.cancel();
    _phoneNumberController.dispose();
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
      final businessId = (await ProxyService.strategy.activeBusiness())?.id;
      if (businessId == null) throw Exception('No active business');

      final fetchedPlan = await ProxyService.strategy.getPaymentPlan(
        businessId: businessId,
      );

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
      });

      // Set up real-time subscription (optional when offline - may fail)
      try {
        _subscription = Repository()
            .subscribeToRealtime<models.Plan>(
              policy: OfflineFirstGetPolicy.alwaysHydrate,
              query: Query(
                where: [const Where('businessId').isExactly(businessId)],
              ),
            )
            .listen((updatedPlans) {
              if (updatedPlans.isNotEmpty) {
                final updatedPlan = updatedPlans.first;
                if (!_mounted) return;

                setState(() {
                  _plan = updatedPlan;
                });

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
              }
            });
      } catch (_) {
        // Subscription may fail when offline; we already have the plan from Ditto/Brick
      }
    } catch (e) {
      if (!_mounted || !context.mounted) return;

      setState(() {
        _errorMessage = 'Error loading plan details: $e';
        _isLoading = false;
      });

      // Defer SnackBar to ensure context is valid
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showCustomSnackBarUtil(
            context,
            'Payment Failed try again',
            backgroundColor: Colors.red,
            showCloseButton: true,
          );
        }
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
      final planPrice = _plan?.totalPrice?.toDouble() ?? 0;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Payment Issue',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _isLoading
            ? KeyedSubtree(key: const ValueKey('loading'), child: _buildLoadingState())
            : _waitingForPaymentCompletion
                ? KeyedSubtree(key: const ValueKey('waiting'), child: _buildPaymentWaitingState())
                : KeyedSubtree(
                    key: const ValueKey('content'),
                    child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 32),
                    if (_plan != null) _buildPlanDetails(_plan!),
                    if (_errorMessage != null) _buildErrorMessage(),
                    const SizedBox(height: 16),
                    if (_plan != null)
                      CouponToggle(
                        onCodeChanged: _validateDiscountCode,
                        errorMessage: _discountError,
                        isValidating: _isValidatingCode,
                      ),
                    const SizedBox(height: 24),
                    if (_plan != null) _buildPhoneNumberSection(),
                    const SizedBox(height: 32),
                    _buildRetryButton(context),
                    const SizedBox(height: 24),
                    _buildHelpSection(),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading payment details',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait a moment...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentWaitingState() {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 48),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primary.withValues(alpha: 0.15),
                        primary.withValues(alpha: 0.06),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.25),
                        blurRadius: 24,
                        spreadRadius: -4,
                      ),
                      BoxShadow(
                        color: primary.withValues(alpha: 0.1),
                        blurRadius: 40,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.phone_android_rounded,
                    size: 44,
                    color: primary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(
            'Complete Payment on Your Phone',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'A payment request has been sent to your MTN Mobile Money.\nOpen your phone and approve the transaction.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: primary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWaitingDot(0),
              const SizedBox(width: 8),
              _buildWaitingDot(1),
              const SizedBox(width: 8),
              _buildWaitingDot(2),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Checking payment status...',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildWaitingDot(int index) {
    final opacities = [0.5, 0.75, 1.0];
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withValues(alpha: opacities[index]),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildHeaderSection() {
    final theme = Theme.of(context);
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
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFFFF5F5),
                      const Color(0xFFFFEBEE),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE53E3E).withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFE53E3E).withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.payment_rounded,
                  size: 44,
                  color: Color(0xFFE53E3E),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Payment Needs Attention',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Don\'t worry, this happens sometimes.\nLet\'s get you sorted out quickly.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorMessage() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE53E3E).withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE53E3E).withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE53E3E).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red.shade600,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberSection() {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surface;
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.phone_android_rounded,
                  color: primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Mobile Money Payment',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Payment will be processed using MTN Mobile Money',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: Text(
              'Use different phone number',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Try with another MTN number if the current one failed',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
            value: _usePhoneNumber,
            onChanged: (value) {
              setState(() {
                _usePhoneNumber = value;
                if (!value) {
                  _phoneNumberController.clear();
                }
              });
            },
            activeThumbColor: Theme.of(context).colorScheme.primary,
            contentPadding: EdgeInsets.zero,
          ),
          if (_usePhoneNumber) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'MTN Phone Number',
                hintText: '250 78 123 4567',
                prefixIcon: const Icon(Icons.phone_android),
                suffixIcon: _phoneNumberController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _phoneNumberController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorText: _getPhoneNumberError(_phoneNumberController.text),
                helperText: 'Must start with 250 78 or 250 79',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ],
              onChanged: (value) {
                // Keep original formatting logic exactly as is
                if (value.length <= 3) {
                  _phoneNumberController.text = value;
                } else if (value.length <= 5) {
                  _phoneNumberController.text =
                      '${value.substring(0, 3)} ${value.substring(3)}';
                } else if (value.length <= 8) {
                  _phoneNumberController.text =
                      '${value.substring(0, 3)} ${value.substring(3, 5)} ${value.substring(5)}';
                } else {
                  _phoneNumberController.text =
                      '${value.substring(0, 3)} ${value.substring(3, 5)} ${value.substring(5, 8)} ${value.substring(8)}';
                }
                _phoneNumberController.selection = TextSelection.collapsed(
                  offset: _phoneNumberController.text.length,
                );
                setState(() {});
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed:
                _isLoading || _plan == null || _waitingForPaymentCompletion
                ? null
                : () async {
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
                      // If payment initiation succeeds, show waiting state
                      if (_mounted) {
                        setState(() {
                          _waitingForPaymentCompletion = true;
                          _isLoading = false;
                        });
                        // Start timeout timer (5 minutes)
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
                                backgroundColor: Colors.red,
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
                    } catch (e) {
                      _paymentTimeoutTimer?.cancel();
                      if (!_mounted) return;
                      setState(() {
                        _errorMessage = 'Payment failed: $e';
                        _waitingForPaymentCompletion = false;
                      });

                      // Add shake animation on error
                      _shakeController.forward().then((_) {
                        _shakeController.reset();
                      });

                      showCustomSnackBarUtil(
                        context,
                        'Payment failed try again',
                        backgroundColor: Colors.red,
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
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 2,
              shadowColor: primary.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Processing...',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        size: 22,
                        color: theme.colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Try Again',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
        if (!_isLoadingSkipCount) ...[
          if (!_canSkip)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE53E3E).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.block_rounded,
                    color: Colors.red.shade600,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Maximum skip limit reached. Please complete payment to continue.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              'You can skip $_remainingSkips more time${_remainingSkips == 1 ? '' : 's'}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: _isLoadingSkipCount || !_canSkip
                ? null
                : () async {
                    await _incrementSkipCount();
                    locator<RouterService>().navigateTo(FlipperAppRoute());
                  },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: _canSkip
                    ? theme.colorScheme.outline.withValues(alpha: 0.5)
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              _canSkip ? 'Skip for Now' : 'Skip Limit Reached',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _canSkip
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanDetails(models.Plan plan) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary.withValues(alpha: 0.06),
            primary.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary.withValues(alpha: 0.12),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Payment Summary',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: primary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Plan', plan.selectedPlan ?? 'N/A'),
          if (_discountAmount > 0) ...[
            _buildDetailRow(
              'Subtotal',
              _originalPrice.toCurrencyFormatted(
                symbol: ProxyService.box.defaultCurrency(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Discount',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.green,
                        ),
                      ),
                      if (_discountCode != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          '($_discountCode)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    '-${_discountAmount.toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          _buildDetailRow(
            _discountAmount > 0 ? 'Total' : 'Price',
            (_discountAmount > 0
                        ? (_originalPrice - _discountAmount)
                        : plan.totalPrice)
                    ?.toCurrencyFormatted(
                      symbol: ProxyService.box.defaultCurrency(),
                    ) ??
                'N/A',
            isTotal: _discountAmount > 0,
          ),
          _buildDetailRow(
            'Billing',
            plan.isYearlyPlan == true ? 'Yearly' : 'Monthly',
          ),
          if (plan.additionalDevices != null && plan.additionalDevices! > 0)
            _buildDetailRow(
              'Additional Devices',
              plan.additionalDevices.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
              fontSize: isTotal ? 18.0 : 16.0,
              color: isTotal ? Colors.green : Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18.0 : 16.0,
              color: isTotal ? Colors.green : Colors.black87,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withValues(alpha: 0.06),
            primary.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  color: primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Need Help?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Common issues:\n• Insufficient funds\n• Network connectivity\n• Incorrect phone number\n• Payment method restrictions',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: () {
              // Handle contact support
            },
            style: TextButton.styleFrom(
              foregroundColor: primary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.support_agent_rounded, size: 18, color: primary),
                const SizedBox(width: 6),
                Text(
                  'Contact Support',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Retry payment with mobile money. Returns payment reference when successful.
  Future<String?> _retryPayment(
    BuildContext context, {
    required models.Plan plan,
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

    // Calculate the discounted price for payment
    final planPrice = plan.totalPrice?.toDouble() ?? 0.0;
    final finalPrice = planPrice - _discountAmount;
    final finalPriceInt = finalPrice > 0 ? finalPrice.toInt() : 0;

    // Handle mobile money payment with the discounted price.
    // Returns payment reference when successful, for polling status.
    return handleMomoPayment(finalPriceInt, plan: plan);
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
          final completed = await ProxyService.ht.checkPaymentStatus(
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
