import 'package:flipper_hr/features/billing/application/hr_billing_providers.dart';
import 'package:flipper_hr/features/billing/application/hr_subscription_controller.dart';
import 'package:flipper_hr/features/billing/data/hr_entitlement.dart';
import 'package:flipper_hr/features/billing/data/hr_msisdn.dart';
import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The paywall: what the plan costs, what it covers, and the one action that
/// pays for it.
///
/// Every figure on this page comes from `hr_plan_quote()`. Nothing is priced
/// client-side, so what is shown here is what the plan row will be written at
/// and what Mobile Money will collect.
class HrSubscribePage extends ConsumerStatefulWidget {
  const HrSubscribePage({super.key});

  @override
  ConsumerState<HrSubscribePage> createState() => _HrSubscribePageState();
}

class _HrSubscribePageState extends ConsumerState<HrSubscribePage> {
  final _phoneController = TextEditingController();
  bool _isYearly = false;
  bool _phoneTouched = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final business = ref.watch(selectedBusinessProvider);
    final businessId = business?.id;

    if (businessId == null) {
      return _Message(
        message:
            'Pick the business you are paying for, then the plan and its price '
            'appear here.',
        actionLabel: 'Choose a business',
        onAction: () => context.go('/business-selection'),
      );
    }

    final access = ref.watch(hrAccessSnapshotProvider(businessId));
    // The number that paid last time, so a renewal is one tap rather than a
    // retyped MSISDN. Only seeded while the field is untouched.
    if (!_phoneTouched && _phoneController.text.isEmpty) {
      final remembered = access.phoneNumber;
      if (remembered != null && remembered.isNotEmpty) {
        _phoneController.text = HrMsisdn.toLocal(remembered);
      }
    }

    final quoteRequest = HrQuoteRequest(
      businessId: businessId,
      isYearly: _isYearly,
    );
    final quote = ref.watch(hrPlanQuoteProvider(quoteRequest));
    final payment = ref.watch(hrSubscriptionControllerProvider);

    // No Scaffold: this page already sits inside the shell's, and nesting one
    // repainted the workspace background a different colour behind the card.
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: DecoratedBox(
              decoration: HrTokens.panel(),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: quote.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => _Message(
                  message:
                      'Could not load the plan: '
                      '${error.toString().replaceFirst('Exception: ', '')}',
                  actionLabel: 'Try again',
                  onAction: () =>
                      ref.invalidate(hrPlanQuoteProvider(quoteRequest)),
                ),
                data: (quote) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      access.hasLapsed
                          ? 'Renew your subscription'
                          : 'Subscribe to Flipper',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: HrTokens.ink1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      business?.name ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: HrTokens.ink3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _BillingPeriodToggle(
                      isYearly: _isYearly,
                      // Locked while a charge is in flight: switching period
                      // re-prices the plan, and the row being charged is the one
                      // that was written when Pay was pressed.
                      onChanged: payment.isBusy
                          ? null
                          : (value) => setState(() => _isYearly = value),
                    ),
                    const SizedBox(height: 16),
                    _PlanCard(quote: quote),
                    const SizedBox(height: 20),
                    _PhoneField(
                      controller: _phoneController,
                      enabled: !payment.isBusy,
                      onChanged: (_) {
                        if (!_phoneTouched) {
                          setState(() => _phoneTouched = true);
                        } else {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _PaymentAction(
                      quote: quote,
                      payment: payment,
                      phone: _phoneController.text,
                      onPay: () => ref
                          .read(hrSubscriptionControllerProvider.notifier)
                          .pay(
                            businessId: businessId,
                            phoneNumber: _phoneController.text,
                            slug: quote.slug,
                            isYearly: _isYearly,
                          ),
                      onDone: () => context.go('/people'),
                      onRetry: () => ref
                          .read(hrSubscriptionControllerProvider.notifier)
                          .reset(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BillingPeriodToggle extends StatelessWidget {
  const _BillingPeriodToggle({required this.isYearly, required this.onChanged});

  final bool isYearly;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('hr-billing-period'),
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: HrTokens.surface2,
        borderRadius: BorderRadius.circular(HrTokens.radiusMd),
        border: Border.all(color: HrTokens.line),
      ),
      child: Row(
        children: [
          _Segment(
            label: 'Monthly',
            selected: !isYearly,
            onTap: onChanged == null ? null : () => onChanged!(false),
          ),
          _Segment(
            label: 'Yearly',
            selected: isYearly,
            onTap: onChanged == null ? null : () => onChanged!(true),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? HrTokens.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(HrTokens.radiusSm),
        elevation: selected ? 1 : 0,
        shadowColor: Colors.black12,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(HrTokens.radiusSm),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: onTap == null
                    ? HrTokens.ink4
                    : selected
                        ? HrTokens.ink1
                        : HrTokens.ink2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The tier, its price, and what it covers — including how much of it this
/// business is already using, so "50 employees" is a number they can act on
/// rather than a claim.
class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.quote});

  final HrPlanQuote quote;

  @override
  Widget build(BuildContext context) {
    final full = quote.fullAmountRwf;
    final allowance = quote.allowance;

    return Container(
      key: const Key('hr-plan-card'),
      decoration: HrTokens.panel(color: HrTokens.sidebarBg2),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quote.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: HrTokens.ink1,
              ),
            ),
            if (quote.description != null) ...[
              const SizedBox(height: 4),
              Text(
                quote.description!,
                style: const TextStyle(fontSize: 12.5, color: HrTokens.ink3),
              ),
            ],
            const SizedBox(height: 14),
            // Wrap, not Row: a yearly figure in a narrow card is wider than it
            // looks, and a price is the one thing on this page that must never
            // be clipped.
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 6,
              children: [
                Text(
                  '${formatRwf(quote.amountRwf)} RWF',
                  key: const Key('hr-plan-amount'),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: HrTokens.ink1,
                    height: 1.15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    quote.periodLabel,
                    style: const TextStyle(fontSize: 13, color: HrTokens.ink3),
                  ),
                ),
              ],
            ),
            // Test pricing shows both figures side by side. A discounted charge
            // presented as a full one is how a test run gets mistaken for a
            // real sale.
            if (quote.testMode && full != null && full != quote.amountRwf) ...[
              const SizedBox(height: 6),
              Text(
                'Test pricing is on — normally ${formatRwf(full)} RWF '
                '${quote.periodLabel}.',
                key: const Key('hr-plan-test-mode'),
                style: const TextStyle(
                  fontSize: 12,
                  color: HrTokens.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (quote.features.isNotEmpty) ...[
              const SizedBox(height: 16),
              for (final feature in quote.features)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 17,
                        color: HrTokens.accent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: HrTokens.ink2,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            if (allowance.hasLimits) ...[
              const Divider(height: 28, color: HrTokens.line),
              const Text(
                'What this business is using',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: HrTokens.ink3,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 10),
              _UsageRow(
                label: 'POS users',
                used: allowance.posUsersUsed,
                limit: allowance.maxPosUsers,
              ),
              _UsageRow(
                label: 'Branches',
                used: allowance.branchesUsed,
                limit: allowance.maxBranches,
              ),
              _UsageRow(
                label: 'HR employees',
                used: allowance.employeesUsed,
                limit: allowance.maxHrEmployees,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow({required this.label, required this.used, required this.limit});

  final String label;
  final int used;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    final cap = limit;
    final exhausted = cap != null && used >= cap;
    // A count alone hides the shape of the problem: "5 of 1" and "5 of 5" read
    // the same in a list until one of them is a bar running past its end.
    final fraction = cap == null || cap <= 0
        ? 0.0
        : (used / cap).clamp(0.0, 1.0).toDouble();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: HrTokens.ink2),
              ),
              Text(
                cap == null ? '$used · unlimited' : '$used of $cap',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: exhausted ? HrTokens.danger : HrTokens.ink1,
                ),
              ),
            ],
          ),
          if (cap != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 4,
                backgroundColor: HrTokens.line,
                valueColor: AlwaysStoppedAnimation<Color>(
                  exhausted ? HrTokens.danger : HrTokens.accent,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
    required this.enabled,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final value = controller.text;
    final invalid = value.trim().isNotEmpty && !HrMsisdn.isValid(value);
    return TextField(
      key: const Key('hr-momo-phone'),
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
      onChanged: onChanged,
      style: const TextStyle(fontSize: 15, color: HrTokens.ink1),
      decoration: InputDecoration(
        labelText: 'Mobile Money number',
        hintText: '0788123456',
        prefixIcon: const Icon(
          Icons.smartphone_outlined,
          size: 18,
          color: HrTokens.ink3,
        ),
        filled: true,
        fillColor: enabled ? HrTokens.surface : HrTokens.surface2,
        labelStyle: const TextStyle(fontSize: 13, color: HrTokens.ink3),
        hintStyle: const TextStyle(color: HrTokens.ink4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HrTokens.radiusMd),
          borderSide: const BorderSide(color: HrTokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HrTokens.radiusMd),
          borderSide: const BorderSide(color: HrTokens.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HrTokens.radiusMd),
          borderSide: const BorderSide(color: HrTokens.accent, width: 1.6),
        ),
        errorText: invalid
            ? 'Enter a valid MTN or Airtel number, e.g. 0788123456.'
            : null,
      ),
    );
  }
}

/// The button, and whatever the charge is currently doing.
class _PaymentAction extends StatelessWidget {
  const _PaymentAction({
    required this.quote,
    required this.payment,
    required this.phone,
    required this.onPay,
    required this.onDone,
    required this.onRetry,
  });

  final HrPlanQuote quote;
  final HrPaymentState payment;
  final String phone;
  final VoidCallback onPay;
  final VoidCallback onDone;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message = payment.message;

    if (payment.stage == HrPaymentStage.confirmed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatusLine(
            key: const Key('hr-payment-confirmed'),
            icon: Icons.check_circle_outline,
            color: HrTokens.success,
            message: message ?? 'Payment received.',
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 46,
            child: FilledButton(
              key: const Key('hr-payment-continue'),
              onPressed: onDone,
              style: _payButtonStyle,
              child: const Text('Open Flipper HR'),
            ),
          ),
        ],
      );
    }

    final failed =
        payment.stage == HrPaymentStage.failed ||
        payment.stage == HrPaymentStage.timedOut;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (message != null && message.isNotEmpty) ...[
          _StatusLine(
            key: Key(failed ? 'hr-payment-failed' : 'hr-payment-progress'),
            icon: failed ? Icons.error_outline : Icons.phonelink_ring_outlined,
            color: failed ? HrTokens.danger : HrTokens.ink2,
            message: message,
          ),
          const SizedBox(height: 12),
        ],
        FilledButton.icon(
          key: const Key('hr-pay-button'),
          style: _payButtonStyle,
          onPressed: payment.isBusy || !HrMsisdn.isValid(phone)
              ? null
              : (failed ? onRetry : onPay),
          icon: payment.isBusy
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.smartphone),
          label: Text(
            switch (payment.stage) {
              HrPaymentStage.preparing => 'Preparing…',
              HrPaymentStage.awaitingApproval => 'Waiting for your approval…',
              HrPaymentStage.failed ||
              HrPaymentStage.timedOut => 'Try again',
              _ => 'Pay ${formatRwf(quote.amountRwf)} RWF with Mobile Money',
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'You will get a Mobile Money prompt on this number. Approving it '
          'charges ${formatRwf(quote.amountRwf)} RWF.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: HrTokens.ink3,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

/// One button shape for the whole flow — pay, retry and continue are the same
/// action in three states, and three heights made them look like three things.
final ButtonStyle _payButtonStyle = FilledButton.styleFrom(
  backgroundColor: HrTokens.accent,
  foregroundColor: Colors.white,
  minimumSize: const Size.fromHeight(46),
  textStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(HrTokens.radiusMd),
  ),
);

class _StatusLine extends StatelessWidget {
  const _StatusLine({
    super.key,
    required this.icon,
    required this.color,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel)),
            ],
          ),
        ),
      ),
    );
  }
}
