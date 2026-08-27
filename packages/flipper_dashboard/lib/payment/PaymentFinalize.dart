import 'dart:async';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_services/PaymentHandler.dart';
import 'package:flipper_services/dodo/dodo_availability.dart';
import 'package:flipper_services/dodo/dodo_client.dart';
import 'package:flipper_services/dodo/dodo_models.dart';
import 'package:flipper_services/dodo/dodo_subscription.dart';
import 'package:flipper_services/payment_rail.dart';
import 'package:flipper_services/supabase_realtime_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flipper_dashboard/payment/widgets/payment_widgets.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/models/subscription_plan.dart';

class PaymentFinalize extends StatefulWidget {
  @override
  _PaymentFinalizeState createState() => _PaymentFinalizeState();
}

class _PaymentFinalizeState extends State<PaymentFinalize> with PaymentHandler {
  bool isLoading = false;
  bool useCustomPhoneNumber = false;
  TextEditingController phoneNumberController = TextEditingController();

  StreamSubscription<List<Map<String, dynamic>>>? _subscription;
  bool _mounted = true;

  // Discount code state
  String? _discountCode;
  double _discountAmount = 0;
  double _originalPrice = 0;
  bool _isValidatingCode = false;
  String? _discountError;
  Plan? _plan;

  // ── card rail (Dodo Payments) ──────────────────────────────────────────────
  //
  // Everything below is additive: with the connector's card rail disabled or
  // unreachable, `_cardAvailable` stays false, the selector never renders, and
  // this screen behaves exactly as the Mobile-Money-only version did.
  PaymentRail _rail = PaymentRail.mtnMomo;
  bool _cardAvailable = false;
  DodoHealth? _dodoHealth;
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  /// Set once the customer has been sent to Dodo's page.
  bool _awaitingCardPayment = false;
  DodoCheckout? _pendingCheckout;
  String? _cardWaitMessage;
  bool _cardPollRunning = false;

  @override
  void initState() {
    super.initState();
    _setupPlanSubscription();
    _probeCardRail();
    _prefillEmail();
  }

  @override
  void dispose() {
    _mounted = false;
    _subscription?.cancel();
    phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Asks the connector whether card payment is sellable here.
  ///
  /// Failure is not an error state: [dodoRailHealth] answers
  /// [DodoHealth.unavailable] for an unreachable connector, and a payment screen
  /// must never fail to load because a *second* rail could not be probed.
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
  }

  Future<void> _prefillEmail() async {
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

  Future<void> _setupPlanSubscription() async {
    try {
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) throw Exception('No active business');

      // Fetch initial plan
      final fetchedPlan = await ProxyService.strategy.getPaymentPlan(
        businessId: businessId,
      );

      if (_mounted) {
        setState(() {
          _plan = fetchedPlan;
        });
      }

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

            if (updatedPlan.paymentCompletedByUser == true) {
              locator<RouterService>().navigateTo(FlipperAppRoute());
            }
          },
          onError: (error, stackTrace) => logSupabaseRealtimeError(
            error,
            source: 'plans finalize',
            stackTrace: stackTrace,
          ),
        );
    } catch (e) {
      if (!_mounted || !context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error setting up listener: $e')));
    }
  }

  /// Validates and applies a discount code
  Future<void> _validateDiscountCode(String code) async {
    if (code.trim().isEmpty) {
      setState(() {
        _discountError = null;
        _discountAmount = 0;
        _discountCode = null;
        _originalPrice = 0; // Reset original price when clearing discount
      });
      return;
    }

    setState(() {
      _isValidatingCode = true;
      _discountError = null;
    });

    try {
      final planPrice = _plan?.totalPrice?.toDouble() ?? 0;
      // Set _originalPrice to planPrice before making API calls to ensure we use current price
      _originalPrice = planPrice;

      final result = await ProxyService.strategy.validateDiscountCode(
        code: code.trim().toUpperCase(),
        planName: _plan?.selectedPlan ?? '',
        amount: _originalPrice,
      );

      if (mounted) {
        if (result['is_valid'] == true) {
          final discountType = result['discount_type'] as String;
          final discountValue = (result['discount_value'] as num).toDouble();

          final calculatedDiscount = ProxyService.strategy.calculateDiscount(
            originalPrice: _originalPrice,
            discountType: discountType,
            discountValue: discountValue,
          );

          setState(() {
            _discountCode = code.trim().toUpperCase();
            _discountAmount = calculatedDiscount;
            _discountError = null;
            _isValidatingCode = false;
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

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16.0 : 14.0,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 16.0 : 14.0,
              color: isTotal ? Theme.of(context).primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String? _getPhoneNumberError(String value) {
    String digitsOnly = value.replaceAll(' ', '');
    if (digitsOnly.isEmpty) return null;
    if (!digitsOnly.startsWith('250'))
      return 'Phone number must start with 250';
    if (digitsOnly.length < 12) return 'Phone number must be 12 digits';
    if (digitsOnly.length > 12) return 'Phone number cannot exceed 12 digits';
    String prefix = digitsOnly.substring(3, 5);
    if (!['78', '79'].contains(prefix)) {
      return 'Invalid MTN number prefix (must start with 78 or 79)';
    }
    return null;
  }

  /// A deliberately loose check: Dodo is the authority on whether it can send
  /// mail to an address, and rejecting a valid-but-unusual one here would block
  /// a payment for no reason.
  String? _getEmailError(String value) {
    final email = value.trim();
    if (email.isEmpty) return 'An email is required for the card receipt';
    if (!email.contains('@') || email.startsWith('@') || email.endsWith('@')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Sends the customer to Dodo's hosted checkout, then waits for the money.
  ///
  /// Nothing here recomputes the price: Dodo bills the amount fixed on its
  /// product, so [PaymentHandler.handleCardPayment] deliberately does not send
  /// one. That is also why a Flipper discount code cannot apply on this rail —
  /// the card card says so rather than showing a total the card will not match.
  Future<void> _handleCardPayment(Plan paymentPlan) async {
    final emailError = _getEmailError(_emailController.text);
    if (emailError != null) {
      setState(() {
        _emailError = emailError;
        isLoading = false;
      });
      return;
    }
    setState(() => _emailError = null);

    final result = await handleCardPayment(
      plan: paymentPlan,
      email: _emailController.text.trim(),
    );

    if (!_mounted) return;

    switch (result.outcome) {
      case DodoCheckoutOutcome.entitled:
        // Already paid for — the plans stream would get here too, but not
        // waiting for it saves the customer a pointless spinner.
        locator<RouterService>().navigateTo(FlipperAppRoute());
        return;

      case DodoCheckoutOutcome.resubscribeRequired:
        setState(() {
          isLoading = false;
          _awaitingCardPayment = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.message ??
                  'This subscription has ended. Choose a plan to start again.',
            ),
          ),
        );
        return;

      case DodoCheckoutOutcome.awaitingPayment:
      case DodoCheckoutOutcome.needsPaymentMethod:
        setState(() {
          isLoading = false;
          _awaitingCardPayment = true;
          _pendingCheckout = result.checkout;
          _cardWaitMessage = result.start?.reusedExisting == true
              ? 'You already had a payment page open for this plan — we '
                  'reopened it rather than starting a second subscription.'
              : null;
        });
        _startCardPolling(result.planId);
        return;

      case DodoCheckoutOutcome.couldNotOpenLink:
        // handleCardPayment turns this into CardCheckoutUnavailable, so it is
        // unreachable here; kept so a new outcome cannot slip through silently.
        setState(() => isLoading = false);
        return;
    }
  }

  /// Polls the connector until the subscription is live.
  ///
  /// Belt and braces with the `plans` realtime stream this screen already
  /// listens to: the webhook flips `payment_completed_by_user` and the stream
  /// navigates, but a customer on a flaky connection — or a webhook that never
  /// lands — should not be stuck on this screen for the connector's whole
  /// 15-minute reconcile interval.
  Future<void> _startCardPolling(String planId) async {
    if (_cardPollRunning || planId.isEmpty) return;
    _cardPollRunning = true;

    final checkout = DodoCardCheckout(DodoClient(ProxyService.http));
    final status = await checkout.awaitEntitlement(
      planId,
      isCancelled: () => !_mounted || !_awaitingCardPayment,
    );

    _cardPollRunning = false;
    if (!_mounted || !_awaitingCardPayment) return;

    if (status?.entitled == true) {
      locator<RouterService>().navigateTo(FlipperAppRoute());
      return;
    }

    setState(() {
      _cardWaitMessage = status?.lastError ??
          'We have not seen the payment yet. Finish it on the payment page, '
              'then tap "I have paid".';
    });
  }

  /// The customer says they are done. Force a read-through to Dodo rather than
  /// waiting for the webhook.
  Future<void> _checkCardPaymentNow() async {
    final planId = _plan?.id;
    if (planId == null || planId.isEmpty) return;

    setState(() {
      isLoading = true;
      _cardWaitMessage = null;
    });

    try {
      final status =
          await DodoClient(ProxyService.http).syncSubscription(planId);
      if (!_mounted) return;
      if (status.entitled) {
        locator<RouterService>().navigateTo(FlipperAppRoute());
        return;
      }
      setState(() {
        isLoading = false;
        _cardWaitMessage = status.nextAction == DodoNextAction.resubscribe
            ? 'That payment did not go through. Choose a plan to start again.'
            : 'The payment has not arrived yet. It can take a moment after you '
                'finish on the payment page.';
      });
    } on DodoException catch (e) {
      if (!_mounted) return;
      setState(() {
        isLoading = false;
        _cardWaitMessage = e.displayMessage;
      });
    } catch (e) {
      if (!_mounted) return;
      setState(() {
        isLoading = false;
        _cardWaitMessage = 'Could not check the payment just now: $e';
      });
    }
  }

  /// Shown after the customer has been handed to Dodo's checkout.
  ///
  /// Keeps the link on screen on purpose: the browser tab is easy to lose, and
  /// reopening the *same* link is what the connector's reuse rule is for — a
  /// fresh start would not put a second charge on the card, but it would create
  /// confusion this panel avoids entirely.
  Widget _buildCardWaitingPanel() {
    final link = _pendingCheckout?.paymentLink;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Waiting for your card payment',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _cardWaitMessage ??
                  'Finish the payment on the page that opened. This screen '
                      'updates on its own once it goes through.',
              style: TextStyle(fontSize: 13.5, color: Colors.blue[900]),
            ),
            if (link != null) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _reopenCheckout(link),
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('Reopen payment page'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _reopenCheckout(String link) async {
    final opened = await DodoCardCheckout(DodoClient(ProxyService.http))
        .openPaymentLink(link);
    if (!_mounted || opened) return;
    setState(() {
      _cardWaitMessage =
          'Could not open the payment page on this device. Try Mobile Money, '
          'or finish the payment on a phone or computer with a browser.';
    });
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Complete Payment',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 600 ? 200 : 20,
                  vertical: 24,
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSectionTitle(
                          context,
                          _rail.isCard
                              ? 'Card Payment'
                              : 'MTN Mobile Money Payment',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _rail.isCard
                              ? 'Payment will be processed by card on a secure '
                                  'payment page'
                              : 'Payment will be processed using MTN Mobile Money',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        // Shown only when the connector reports the card rail
                        // sellable: a deployment without Dodo configured sees
                        // this screen exactly as it was.
                        if (_cardAvailable) ...[
                          const SizedBox(height: 20),
                          PaymentRailSelector(
                            rail: _rail,
                            enabled: !isLoading && !_awaitingCardPayment,
                            onChanged: (rail) => setState(() {
                              _rail = rail;
                              _emailError = null;
                            }),
                          ),
                        ],
                        if (_plan != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Plan Summary',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  'Plan',
                                  _plan!.selectedPlan ?? 'N/A',
                                ),
                                if (_discountAmount > 0) ...[
                                  _buildDetailRow(
                                    'Subtotal',
                                    _originalPrice.toCurrencyFormatted(
                                      symbol: ProxyService.box
                                          .defaultCurrency(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Discount',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
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
                                            fontSize: 14.0,
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
                                              ? (_originalPrice -
                                                    _discountAmount)
                                              : _plan!.totalPrice)
                                          ?.toCurrencyFormatted(
                                            symbol: ProxyService.box
                                                .defaultCurrency(),
                                          ) ??
                                      'N/A',
                                  isTotal: _discountAmount > 0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          CouponToggle(
                            onCodeChanged: _validateDiscountCode,
                            errorMessage: _discountError,
                            isValidating: _isValidatingCode,
                          ),
                        ],
                        if (_rail.isMomo) ...[
                          const SizedBox(height: 24),
                          Material(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            clipBehavior: Clip.antiAlias,
                            child: SwitchListTile(
                              title: const Text(
                                'Use different phone number',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Specify a different number for payment',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              value: useCustomPhoneNumber,
                              onChanged: (bool value) {
                                setState(() {
                                  useCustomPhoneNumber = value;
                                  if (!value) {
                                    phoneNumberController.clear();
                                    ProxyService.box.writeString(
                                      key: "customPhoneNumberForPayment",
                                      value: '',
                                    );
                                  }
                                });
                              },
                              activeColor: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          if (useCustomPhoneNumber) ...[
                            const SizedBox(height: 20),
                            TextField(
                              onChanged: (value) {
                                String digitsOnly = value.replaceAll(
                                  RegExp(r'\\D'),
                                  '',
                                );
                                if (digitsOnly.length >= 1 &&
                                    !digitsOnly.startsWith('250')) {
                                  if (digitsOnly.startsWith('0')) {
                                    digitsOnly = '25$digitsOnly';
                                  } else {
                                    digitsOnly = '250$digitsOnly';
                                  }
                                }

                                String formattedNumber = '';
                                for (int i = 0; i < digitsOnly.length; i++) {
                                  if (i == 3 || i == 6 || i == 9) {
                                    formattedNumber += ' ';
                                  }
                                  formattedNumber += digitsOnly[i];
                                }

                                phoneNumberController.value = TextEditingValue(
                                  text: formattedNumber,
                                  selection: TextSelection.collapsed(
                                    offset: formattedNumber.length,
                                  ),
                                );

                                ProxyService.box.writeString(
                                  key: "customPhoneNumberForPayment",
                                  value: digitsOnly,
                                );
                              },
                              controller: phoneNumberController,
                              decoration: InputDecoration(
                                labelText: 'MTN Phone Number',
                                hintText: '250 78 123 4567',
                                prefixIcon: const Icon(Icons.phone_android),
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
                                errorText: _getPhoneNumberError(
                                  phoneNumberController.text,
                                ),
                                helperText: 'Must start with 250 78 or 250 79',
                                suffixIcon: phoneNumberController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          phoneNumberController.clear();
                                          ProxyService.box.writeString(
                                            key: "customPhoneNumberForPayment",
                                            value: '',
                                          );
                                          setState(() {});
                                        },
                                      )
                                    : null,
                              ),
                              keyboardType: TextInputType.phone,
                              maxLength: 15,
                              buildCounter:
                                  (
                                    context, {
                                    required currentLength,
                                    required isFocused,
                                    maxLength,
                                  }) {
                                    return null;
                                  },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[\d ]'),
                                ),
                              ],
                            ),
                          ],
                        ],
                        if (_rail.isCard) ...[
                          const SizedBox(height: 24),
                          PaymentCardCheckoutCard(
                            flat: true,
                            emailController: _emailController,
                            emailError: _emailError,
                            isTestMode: _dodoHealth?.isTestMode ?? false,
                            discountApplied: _discountAmount > 0,
                            onEmailChanged: (_) {
                              if (_emailError != null) {
                                setState(() => _emailError = null);
                              }
                            },
                          ),
                        ],
                        if (_awaitingCardPayment) _buildCardWaitingPanel(),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handlePayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Text(
                                    _awaitingCardPayment
                                        ? 'I have paid — check now'
                                        : _rail.isCard
                                            ? 'Continue to payment page'
                                            : 'Complete Payment',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        if (_awaitingCardPayment) ...[
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () => setState(() {
                                      // Abandons the wait, not the subscription:
                                      // the pending Dodo subscription stays, and
                                      // tapping again reopens *its* link rather
                                      // than creating a second one.
                                      _awaitingCardPayment = false;
                                      _cardWaitMessage = null;
                                    }),
                            child: const Text('Use a different payment method'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handlePayment() async {
    // Already on Dodo's page: the button is a "check now", not a second start.
    // Starting again would be safe — the connector returns the pending
    // subscription rather than creating one — but asking is faster and does not
    // reopen a browser the customer is already looking at.
    if (_awaitingCardPayment) {
      await _checkCardPaymentNow();
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      Plan? paymentPlan = await ProxyService.strategy.getPaymentPlan(
        businessId: (await ProxyService.strategy.activeBusiness())!.id,
      );

      talker.warning("CurrentPaymentPlan: $paymentPlan");

      int finalPrice = 0;
      if (_discountAmount > 0) {
        finalPrice = (_originalPrice - _discountAmount).toInt();
      } else if (ProxyService.box.couponCode() != null) {
        // Fallback to legacy check if legacy coupon is present
        final planPrice = paymentPlan?.totalPrice?.toDouble() ?? 0.0;
        final discountRate = ProxyService.box.discountRate() ?? 0.0;
        finalPrice = (planPrice - ((planPrice * discountRate) / 100)).toInt();
      } else {
        finalPrice = paymentPlan?.totalPrice?.toInt() ?? 0;
      }

      if (paymentPlan == null) {
        throw Exception("Payment plan is null");
      }

      if (_rail.isCard) {
        await _handleCardPayment(paymentPlan);
      } else {
        await handleMomoPayment(finalPrice, plan: paymentPlan);
      }
    } on CardCheckoutUnavailable catch (e) {
      // No money moved and none will. Offering Mobile Money is the useful next
      // step here, not "try again" — a device that cannot open a browser will
      // not open one on the second tap either.
      talker.warning('Card checkout unavailable: ${e.message}');
      if (_mounted) {
        setState(() {
          isLoading = false;
          _pendingCheckout = e.checkout ?? _pendingCheckout;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } on DodoException catch (e) {
      talker.warning('Card payment refused: $e');
      if (_mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.displayMessage)),
        );
      }
    } on MomoPreapprovalDeclined catch (e) {
      // Consent was refused, so nothing was charged. Worth its own message:
      // "failed to initiate payment" reads like a fault at our end and invites
      // a retry that will be refused the same way.
      talker.warning('Pre-approval declined: ${e.message}');
      if (_mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${e.message} Approve the Mobile Money request on your phone, '
              'then try again.',
            ),
          ),
        );
      }
    } catch (e, s) {
      talker.warning(e.toString());
      talker.error(s.toString());
      if (_mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initiate payment: $e')),
        );
      }
    }
  }
}
