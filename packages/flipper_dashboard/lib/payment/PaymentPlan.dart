import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/exceptions.dart' show FailedPaymentException;
import 'package:flipper_models/models/subscription_plan_template.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_dashboard/utils/error_handler.dart';

class PaymentPlanUI extends StatefulWidget {
  const PaymentPlanUI({Key? key, this.skipPaymentStatusCheck = false})
      : super(key: key);

  /// Debug-only: skip auto-redirect when previewing this screen manually.
  final bool skipPaymentStatusCheck;

  @override
  _PaymentPlanUIState createState() => _PaymentPlanUIState();
}

class _PaymentPlanUIState extends State<PaymentPlanUI> {
  SubscriptionPlanCatalog? _catalog;
  String? _selectedTemplateId;
  final Set<String> _selectedAddonSlugs = {};
  int _additionalDevices = 0;
  bool _isYearlyPlan = false;
  double _totalPrice = 0;
  bool _isLoadingCatalog = true;
  String? _catalogError;
  final paymentController = TextEditingController();

  SubscriptionPlanTemplate? get _selectedTemplate =>
      _catalog?.byId(_selectedTemplateId);

  @override
  void initState() {
    super.initState();
    _loadCatalog();
    if (!widget.skipPaymentStatusCheck) {
      _checkForActivePayment();
    }
  }

  Future<void> _loadCatalog() async {
    try {
      final catalog = await ProxyService.strategy.getSubscriptionPlanCatalog();
      if (!mounted) return;
      setState(() {
        _catalog = catalog;
        _selectedTemplateId = catalog.firstOrNull?.id;
        _isLoadingCatalog = false;
        _catalogError = catalog.templates.isEmpty
            ? 'No subscription plans are available.'
            : null;
        _calculatePrice();
      });
    } catch (e) {
      talker.error('Failed to load subscription plan catalog: $e');
      if (!mounted) return;
      setState(() {
        _isLoadingCatalog = false;
        _catalogError = 'Could not load subscription plans. Please try again.';
      });
    }
  }

  /// Checks if there's an active payment plan and navigates to the appropriate screen
  Future<void> _checkForActivePayment() async {
    if (widget.skipPaymentStatusCheck) return;

    try {
      final businessId = (await ProxyService.strategy.activeBusiness())?.id;
      if (businessId != null) {
        final plan = await ProxyService.strategy.getPaymentPlan(
          businessId: businessId,
          fetchOnline: true,
          preferFresh: true,
        );

        if (plan != null) {
          try {
            await ProxyService.strategy.hasActiveSubscription(
              businessId: businessId,
              flipperHttpClient: ProxyService.http,
              fetchRemote: true,
            );

            talker.info('Active payment plan found, returning to app');
            locator<RouterService>().navigateTo(FlipperAppRoute());
            return;
          } catch (subscriptionError) {
            talker.warning(
              'Payment plan exists but is not active: $subscriptionError',
            );
            if (!kDebugMode) {
              locator<RouterService>().navigateTo(FailedPaymentRoute());
            }
            return;
          }
        }
        talker.warning('No payment plan found, staying on payment plan screen');
      }
    } catch (e) {
      talker.error('Error checking payment status: $e');
    }
  }

  void _calculatePrice() {
    final template = _selectedTemplate;
    if (template == null) {
      setState(() => _totalPrice = 0);
      return;
    }
    setState(() {
      _totalPrice = template.calculateTotal(
        isYearly: _isYearlyPlan,
        selectedAddonSlugs: _selectedAddonSlugs,
      );
    });
  }

  List<String> get _selectedAddonNames {
    final template = _selectedTemplate;
    if (template == null) return const [];
    return _selectedAddonSlugs
        .map((slug) => template.addonBySlug(slug)?.name)
        .whereType<String>()
        .toList();
  }

  Widget _buildDurationToggle() {
    final yearlyDiscount =
        _selectedTemplate?.yearlyDiscountPercent.round() ?? 20;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isYearlyPlan = false;
                  _calculatePrice();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isYearlyPlan ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Monthly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_isYearlyPlan ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isYearlyPlan = true;
                  _calculatePrice();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isYearlyPlan ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Yearly ($yearlyDiscount% off)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isYearlyPlan ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCards() {
    final templates = _catalog?.templates ?? const [];
    return Column(
      children: [
        for (var i = 0; i < templates.length; i++) ...[
          if (i > 0) SizedBox(height: 8),
          _buildPlanCard(templates[i]),
        ],
      ],
    );
  }

  Widget _buildPlanCard(SubscriptionPlanTemplate template) {
    final isSelected = _selectedTemplateId == template.id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTemplateId = template.id;
          _additionalDevices = 0;
          _selectedAddonSlugs.clear();
          _calculatePrice();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                template.resolveIcon(),
                size: 24,
                color: isSelected ? Colors.white : Colors.blue,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      template.formatListPrice(isYearly: _isYearlyPlan),
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.white70 : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalDevicesInput() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Additional devices',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              _buildCircularButton(
                Icons.remove,
                _additionalDevices > 0
                    ? () {
                        setState(() {
                          _additionalDevices--;
                          _calculatePrice();
                        });
                      }
                    : null,
              ),
              SizedBox(width: 16),
              Text(
                _additionalDevices.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 16),
              _buildCircularButton(Icons.add, () {
                setState(() {
                  _additionalDevices++;
                  _calculatePrice();
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onPressed != null ? Colors.blue : Colors.grey.shade300,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildAdditionalServices() {
    final template = _selectedTemplate;
    if (template == null || template.addons.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          template.isEnterprise ? 'Enterprise Services' : 'Additional Services',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        for (var i = 0; i < template.addons.length; i++) ...[
          if (i > 0) SizedBox(height: 8),
          _buildServiceToggle(template.addons[i]),
        ],
      ],
    );
  }

  Widget _buildServiceToggle(SubscriptionPlanAddonTemplate addon) {
    final template = _selectedTemplate!;
    final isSelected = _selectedAddonSlugs.contains(addon.slug);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addon.name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  template.formatAddonPrice(addon, isYearly: _isYearlyPlan),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Switch(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value) {
                  _selectedAddonSlugs.add(addon.slug);
                } else {
                  _selectedAddonSlugs.remove(addon.slug);
                }
                _calculatePrice();
              });
            },
            activeThumbColor: Colors.blue,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return Colors.blue;
              }
              return Colors.grey;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Flexible(
                child: Text(
                  '${_totalPrice.toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())} ${_isYearlyPlan ? '/year' : '/month'}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProceedButton() {
    final template = _selectedTemplate;
    final canProceed = template != null && !_isLoadingCatalog;

    return ElevatedButton(
      onPressed: !canProceed
          ? null
          : () async {
              final selectedTemplate = _selectedTemplate;
              if (selectedTemplate == null) return;

              final numberOfPayments =
                  int.tryParse(paymentController.text) ?? 1;
              final totalPrice = _totalPrice * numberOfPayments;

              try {
                await ProxyService.strategy.saveOrUpdatePaymentPlan(
                  businessId:
                      (await ProxyService.strategy.activeBusiness())!.id,
                  selectedPlan: selectedTemplate.name,
                  planTemplateId: selectedTemplate.id,
                  addons: _selectedAddonNames,
                  paymentMethod: 'Card',
                  numberOfPayments: numberOfPayments,
                  flipperHttpClient: ProxyService.http,
                  additionalDevices: _additionalDevices,
                  isYearlyPlan: _isYearlyPlan,
                  totalPrice: totalPrice,
                );

                locator<RouterService>().navigateTo(PaymentFinalizeRoute());
              } on FailedPaymentException catch (e) {
                talker.warning('Payment failed: ${e.message}');
                if (mounted) {
                  ErrorHandler.showErrorSnackBar(context, e);
                  locator<RouterService>().navigateTo(FailedPaymentRoute());
                }
              } catch (e, s) {
                talker.error('Error processing payment: $e');
                talker.error(s.toString());
                if (mounted) {
                  ErrorHandler.showErrorSnackBar(
                    context,
                    'An error occurred. Please try again.',
                  );
                }
              }
            },
      child: Text(
        'Proceed to Payment',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        splashFactory: InkSparkle.splashFactory,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Payment Plan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoadingCatalog
          ? Center(child: CircularProgressIndicator())
          : _catalogError != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _catalogError!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoadingCatalog = true;
                              _catalogError = null;
                            });
                            _loadCatalog();
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select the plan that works for you',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildDurationToggle(),
                        SizedBox(height: 16),
                        _buildPlanCards(),
                        SizedBox(height: 16),
                        if (_selectedPlanSupportsExtraDevices)
                          _buildAdditionalDevicesInput(),
                        SizedBox(height: 16),
                        _buildAdditionalServices(),
                        SizedBox(height: 16),
                        _buildPriceSummary(),
                        NumberOfPaymentsToggle(
                          paymentController: paymentController,
                        ),
                        SizedBox(height: 16),
                        _buildProceedButton(),
                      ],
                    ),
                  ),
                ),
    );
  }

  bool get _selectedPlanSupportsExtraDevices => false;
}
