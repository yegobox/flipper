import 'package:flipper_dashboard/payment/payment_format.dart';
import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:flipper_dashboard/payment/widgets/payment_widgets.dart';
import 'package:flipper_dashboard/utils/error_handler.dart';
import 'package:flipper_models/exceptions.dart' show FailedPaymentException;
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/subscription_plan_template.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

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
  bool _splitEnabled = false;
  int _installmentCount = 1;
  bool _isProceeding = false;

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

  void _onInstallmentChanged(int count) {
    setState(() => _installmentCount = count);
    ProxyService.box.writeInt(key: 'numberOfPayments', value: count);
  }

  Future<void> _proceed() async {
    final selectedTemplate = _selectedTemplate;
    if (selectedTemplate == null || _isProceeding) return;

    final numberOfPayments = _splitEnabled ? _installmentCount : 1;
    final totalPrice = _totalPrice * numberOfPayments;

    setState(() => _isProceeding = true);

    try {
      await ProxyService.strategy.saveOrUpdatePaymentPlan(
        businessId: (await ProxyService.strategy.activeBusiness())!.id,
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

      if (!mounted) return;
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
    } finally {
      if (mounted) {
        setState(() => _isProceeding = false);
      }
    }
  }

  Widget _buildCatalogError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _catalogError!,
              textAlign: TextAlign.center,
              style: PaymentTypography.body(),
            ),
            const SizedBox(height: 16),
            PaymentPrimaryButton(
              label: 'Retry',
              icon: null,
              onPressed: () {
                setState(() {
                  _isLoadingCatalog = true;
                  _catalogError = null;
                });
                _loadCatalog();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContentChildren() {
    final template = _selectedTemplate;
    final yearlyDiscount = template?.yearlyDiscountPercent ?? 20;
    final templates = _catalog?.templates ?? const [];

    return [
      PaymentIntroBlock(
        title: 'Select the plan that works for you',
        subtitle:
            'Switch between plans anytime. Yearly billing saves you ${yearlyDiscount.round()}%.',
      ),
      PaymentSegment2(
        isYearly: _isYearlyPlan,
        yearlyDiscountPercent: yearlyDiscount,
        onChanged: (yearly) {
          setState(() {
            _isYearlyPlan = yearly;
            _calculatePrice();
          });
        },
      ),
      Column(
        children: [
          for (var i = 0; i < templates.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            PaymentPlanTile(
              name: templates[i].name,
              priceLine: formatPaymentTilePrice(
                templates[i],
                isYearly: _isYearlyPlan,
              ),
              icon: templates[i].resolveIcon(),
              selected: _selectedTemplateId == templates[i].id,
              onTap: () {
                setState(() {
                  _selectedTemplateId = templates[i].id;
                  _additionalDevices = 0;
                  _selectedAddonSlugs.clear();
                  _calculatePrice();
                });
              },
            ),
          ],
        ],
      ),
      if (template != null && template.addons.isNotEmpty) ...[
        PaymentSectionLabel(
          template.isEnterprise ? 'Enterprise Services' : 'Additional Services',
        ),
        for (var i = 0; i < template.addons.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          PaymentAddonRow(
            name: template.addons[i].name,
            priceLine: formatPaymentAddonPrice(
              template,
              template.addons[i],
              isYearly: _isYearlyPlan,
            ),
            enabled: _selectedAddonSlugs.contains(template.addons[i].slug),
            onChanged: (value) {
              setState(() {
                if (value) {
                  _selectedAddonSlugs.add(template.addons[i].slug);
                } else {
                  _selectedAddonSlugs.remove(template.addons[i].slug);
                }
                _calculatePrice();
              });
            },
          ),
        ],
      ],
      if (template != null)
        PaymentTotalCard(
          total: _totalPrice,
          subtitle: paymentSelectionSubtitle(
            planName: template.name,
            addonNames: _selectedAddonNames,
          ),
          isYearly: _isYearlyPlan,
        ),
      PaymentSplitSection(
        splitEnabled: _splitEnabled,
        onSplitChanged: (enabled) {
          setState(() {
            _splitEnabled = enabled;
            if (!enabled) {
              _installmentCount = 1;
              ProxyService.box.writeInt(key: 'numberOfPayments', value: 1);
            }
          });
        },
        installmentCount: _installmentCount,
        onInstallmentChanged: _onInstallmentChanged,
        total: _totalPrice,
      ),
      Column(
        children: [
          PaymentPrimaryButton(
            label: 'Proceed to Payment',
            loading: _isProceeding,
            loadingLabel: 'Setting up your plan…',
            onPressed: template != null && !_isLoadingCatalog ? _proceed : null,
          ),
          const SizedBox(height: 10),
          const PaymentCtaNote(),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingCatalog) {
      return const Scaffold(
        backgroundColor: PaymentTokens.app,
        body: PaymentCenterLoading(message: 'Loading plans…'),
      );
    }

    if (_catalogError != null) {
      return Scaffold(
        backgroundColor: PaymentTokens.app,
        body: _buildCatalogError(),
      );
    }

    return PaymentScreenShell(
      title: 'Payment Plan',
      showBack: false,
      overlay: _isProceeding
          ? const PaymentLoadingOverlay(message: 'Setting up your plan…')
          : null,
      children: _buildContentChildren(),
    );
  }
}
