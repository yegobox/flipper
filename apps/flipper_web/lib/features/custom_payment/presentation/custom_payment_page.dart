import 'package:flipper_localize/flipper_localize.dart';
import 'dart:async';

import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/custom_payment/application/custom_payment_controller.dart';
import 'package:flipper_web/features/custom_payment/application/custom_payment_providers.dart';
import 'package:flipper_web/features/custom_payment/data/business_search_repository.dart';
import 'package:flipper_web/features/custom_payment/data/custom_payment_api.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// `/custom-payment` — sales staff charge a negotiated price.
///
/// Pick the business, type the agreed amount and period, choose the rail, and
/// either the customer approves a MoMo prompt on their phone or staff send
/// them a card checkout link. On success the reference ids are shown with
/// copy buttons; the connector has already made the amount the plan's
/// recurring price and retired whatever the business was on before.
///
/// Gated on the signed-in user's `billing_staff` row; everyone else sees a
/// closed door, and the connector refuses their token anyway.
class CustomPaymentPage extends ConsumerStatefulWidget {
  const CustomPaymentPage({super.key});

  @override
  ConsumerState<CustomPaymentPage> createState() => _CustomPaymentPageState();
}

class _CustomPaymentPageState extends ConsumerState<CustomPaymentPage> {
  final _searchController = TextEditingController();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _noteController = TextEditingController();

  Timer? _debounce;
  String _query = '';
  BusinessHit? _business;
  CustomPaymentCadence _cadence = CustomPaymentCadence.monthly;
  CustomPaymentRail _rail = CustomPaymentRail.momo;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _amountController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  int get _amount =>
      int.tryParse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
      0;

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  void _pick(BusinessHit hit) {
    setState(() {
      _business = hit;
      _query = '';
      _searchController.clear();
      if (_phoneController.text.isEmpty && (hit.phoneNumber ?? '').isNotEmpty) {
        _phoneController.text = hit.phoneNumber!;
      }
      if (_emailController.text.isEmpty && (hit.email ?? '').isNotEmpty) {
        _emailController.text = hit.email!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final staff = ref.watch(billingStaffMemberProvider);
    final payment = ref.watch(customPaymentControllerProvider);
    final cardAvailable =
        ref.watch(customPaymentCardAvailableProvider).value ?? false;

    // The two-column rail only makes sense while the operator is filling the
    // form. The access gate and the settled receipt are self-contained blocks
    // that read better centred, so they stay single-column.
    final member = staff.value;
    final settled = payment.isSettled && payment.view != null;
    final showForm = staff.hasValue && member != null && !settled;

    return PaymentScreenShell(
      key: const Key('custom-payment-page'),
      title: context.flipperL10n.webPayTitle,
      showBack: true,
      onBack: () => context.go('/accounting'),
      badge: dodoBuildMode == 'test'
          ? PaymentHeaderBadge(label: context.flipperL10n.webBillingTestBadge)
          : null,
      overlay: payment.stage == CustomPaymentStage.submitting
          ? PaymentLoadingOverlay(
              message:
                  payment.message ?? context.flipperL10n.webBillingOneMoment,
            )
          : null,
      aside: showForm
          ? _asideBlocks(
              context,
              payment: payment,
              cardAvailable: cardAvailable,
            )
          : null,
      children: showForm
          ? _formBlocks(
              context,
              staffName: member.displayName,
              payment: payment,
              cardAvailable: cardAvailable,
            )
          : [
              staff.when(
                loading: () => Padding(
                  padding: const EdgeInsets.all(40),
                  child: PaymentCenterLoading(
                    message: context.flipperL10n.webPayCheckingAccess,
                  ),
                ),
                error: (error, _) => _Gate(
                  key: const Key('custom-payment-gate'),
                  message: context.flipperL10n.webPayCouldNotCheckAccess(
                    _describe(error),
                  ),
                ),
                data: (member) => member == null
                    ? _Gate(
                        key: const Key('custom-payment-gate'),
                        message: context.flipperL10n.webPayStaffOnlyBody,
                      )
                    : _SettledCard(
                        view: payment.view!,
                        onNewPayment: () {
                          ref
                              .read(customPaymentControllerProvider.notifier)
                              .reset();
                          setState(() {
                            _business = null;
                            _amountController.clear();
                            _noteController.clear();
                          });
                        },
                      ),
              ),
            ],
    );
  }

  CustomPaymentRail _effectiveRail(bool cardAvailable) =>
      cardAvailable ? _rail : CustomPaymentRail.momo;

  String get _periodSuffix => _cadence == CustomPaymentCadence.yearly
      ? context.flipperL10n.webPayPerYear
      : context.flipperL10n.webPayPerMonth;

  /// The form column.
  List<Widget> _formBlocks(
    BuildContext context, {
    String? staffName,
    required CustomPaymentState payment,
    required bool cardAvailable,
  }) {
    final rail = _effectiveRail(cardAvailable);
    final locked = payment.isBusy;
    final l10n = context.flipperL10n;

    return [
      PaymentIntroBlock(
        title: l10n.webPayNegotiatedPrice,
        subtitle: staffName == null
            ? l10n.webPayNegotiatedBody
            : '${l10n.webPayNegotiatedBody} ${l10n.webPaySignedInAs(staffName)}',
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaymentSectionLabel(l10n.business),
          const SizedBox(height: 8),
          if (_business == null) ...[
            PaymentInput(
              key: const Key('custom-payment-search'),
              controller: _searchController,
              hintText: l10n.webPaySearchHint,
              leadingIcon: FluentIcons.search_20_regular,
              onChanged: _onSearchChanged,
              autofocus: true,
              trailing: _searchController.text.isEmpty
                  ? null
                  : PaymentInputClearButton(
                      onPressed: () => setState(() {
                        _searchController.clear();
                        _query = '';
                      }),
                    ),
            ),
            const SizedBox(height: 8),
            _SearchResults(query: _query, onPick: _pick),
          ] else
            _BusinessChip(
              key: const Key('custom-payment-business'),
              business: _business!,
              onChange: locked ? null : () => setState(() => _business = null),
            ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaymentSectionLabel(l10n.webPayAgreedAmount),
          const SizedBox(height: 8),
          PaymentInput(
            key: const Key('custom-payment-amount'),
            controller: _amountController,
            hintText: l10n.webPayAmountHint,
            leadingIcon: FluentIcons.money_20_regular,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            mono: true,
            suffixText: _periodSuffix,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          IgnorePointer(
            ignoring: locked,
            child: PaymentCadenceSegment(
              cadence: _cadence == CustomPaymentCadence.yearly
                  ? BillingCadence.yearly
                  : BillingCadence.monthly,
              cadences: const [BillingCadence.monthly, BillingCadence.yearly],
              yearlyDiscountPercent: 0,
              onChanged: (value) => setState(() {
                _cadence = value == BillingCadence.yearly
                    ? CustomPaymentCadence.yearly
                    : CustomPaymentCadence.monthly;
              }),
            ),
          ),
        ],
      ),
      if (cardAvailable)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PaymentSectionLabel(l10n.webPayCustomerPaysWith),
            const SizedBox(height: 8),
            PaymentRailSelector(
              key: const Key('custom-payment-rail'),
              rail: rail.isCard ? PaymentRail.card : PaymentRail.mtnMomo,
              enabled: !locked,
              onChanged: (value) => setState(() {
                _rail = value.isCard
                    ? CustomPaymentRail.card
                    : CustomPaymentRail.momo;
              }),
            ),
          ],
        ),
      if (rail.isMomo)
        PaymentMobileMoneyCard(
          key: const Key('custom-payment-phone'),
          useDifferentNumber: true,
          onUseDifferentChanged: (_) {},
          phoneController: _phoneController,
          onPhoneChanged: (_) => setState(() {}),
          phoneError:
              _phoneController.text.isNotEmpty &&
                  !MomoMsisdn.isPlausible(_phoneController.text)
              ? l10n.webBillingInvalidMomo
              : null,
        )
      else
        PaymentCardCheckoutCard(
          key: const Key('custom-payment-card'),
          emailController: _emailController,
          onEmailChanged: (_) => setState(() {}),
          isTestMode: dodoBuildMode == 'test',
          pendingCheckoutLink: payment.checkoutLink,
          onOpenPendingLink: payment.checkoutLink == null
              ? null
              : () => _openLink(payment.checkoutLink!),
        ),
      if (rail.isCard && payment.checkoutLink != null)
        _LinkRow(
          key: const Key('custom-payment-link'),
          link: payment.checkoutLink!,
          onCopy: () =>
              _copy(context, payment.checkoutLink!, l10n.webPayLinkCopied),
          onOpen: () => _openLink(payment.checkoutLink!),
        ),
      PaymentInput(
        key: const Key('custom-payment-note'),
        controller: _noteController,
        hintText: l10n.webPayNoteHint,
        leadingIcon: FluentIcons.note_20_regular,
      ),
    ];
  }

  /// The sticky rail: what is about to be charged, and the button that does
  /// it. Keeping the total and the call to action together, and in view while
  /// the operator scrolls the form, is the point of the two-column layout —
  /// nobody should be able to press Charge without the amount on screen.
  List<Widget> _asideBlocks(
    BuildContext context, {
    required CustomPaymentState payment,
    required bool cardAvailable,
  }) {
    final rail = _effectiveRail(cardAvailable);
    final locked = payment.isBusy;
    final l10n = context.flipperL10n;
    final cadenceLabel = _cadence == CustomPaymentCadence.yearly
        ? l10n.booksFreqYearly
        : l10n.booksFreqMonthly;

    return [
      PaymentSummaryCard(
        key: const Key('custom-payment-summary'),
        rows: [
          PaymentSummaryRow(
            label: l10n.business,
            value: _business == null
                ? l10n.webPayNotSelected
                : (_business!.name.isEmpty ? _business!.id : _business!.name),
          ),
          PaymentSummaryRow(
            label: l10n.webPayBillingPeriod,
            value: cadenceLabel,
          ),
          PaymentSummaryRow(
            label: l10n.webPayPaysWith,
            value: rail.isCard ? l10n.webPayCard : 'Mobile Money',
          ),
          PaymentSummaryRow(
            label: l10n.webPayPricePerPeriod,
            value: '${formatPaymentRwf(_amount)} RWF',
            mono: true,
            highlight: true,
          ),
        ],
      ),
      PaymentTotalCard(
        key: const Key('custom-payment-total'),
        total: _amount,
        subtitle: l10n.webPayChargedNow,
        cadence: _cadence == CustomPaymentCadence.yearly
            ? BillingCadence.yearly
            : BillingCadence.monthly,
      ),
      _StageBanner(payment: payment),
      if (payment.inFlight != null) _InFlightNote(inFlight: payment.inFlight!),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaymentPrimaryButton(
            key: const Key('custom-payment-submit'),
            label: rail.isCard
                ? l10n.webPayCreateCardLink
                : l10n.webPayChargeByMomo(formatPaymentRwf(_amount)),
            loading: locked,
            loadingLabel: payment.stage == CustomPaymentStage.awaitingApproval
                ? l10n.webPayWaitingCustomerApproval
                : payment.stage == CustomPaymentStage.awaitingCheckout
                ? l10n.webBillingWaitingCard
                : l10n.webPayStartingShort,
            onPressed: locked || _business == null || _amount <= 0
                ? null
                : () => _confirmAndSubmit(context, rail),
          ),
          if (payment.stage == CustomPaymentStage.failed ||
              payment.stage == CustomPaymentStage.timedOut) ...[
            const SizedBox(height: 8),
            PaymentSecondaryButton(
              key: const Key('custom-payment-retry'),
              label: payment.stage == CustomPaymentStage.timedOut
                  ? l10n.webBillingCheckAgain
                  : l10n.webBillingStartOver,
              onPressed: () {
                final controller = ref.read(
                  customPaymentControllerProvider.notifier,
                );
                if (payment.stage == CustomPaymentStage.timedOut) {
                  controller.checkAgain();
                } else {
                  controller.reset();
                }
              },
            ),
          ],
          const SizedBox(height: 8),
          PaymentCtaNote(
            provider: rail.isCard ? 'Dodo Payments' : 'MTN Mobile Money',
          ),
        ],
      ),
    ];
  }

  Future<void> _confirmAndSubmit(
    BuildContext context,
    CustomPaymentRail rail,
  ) async {
    final business = _business!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.flipperL10n.webPayConfirmTitle),
        content: Text(
          '${business.name}\n'
          '${context.flipperL10n.webPayConfirmSummary(formatPaymentRwf(_amount), _cadence == CustomPaymentCadence.yearly ? context.flipperL10n.booksFreqYearly : context.flipperL10n.booksFreqMonthly, rail.isCard ? context.flipperL10n.webPayCard : 'Mobile Money')}'
          '\n\n'
          '${rail.isCard ? context.flipperL10n.webPayConfirmBodyCard : context.flipperL10n.webPayConfirmBodyMomo}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.flipperL10n.cancel),
          ),
          FilledButton(
            key: const Key('custom-payment-confirm'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.flipperL10n.webPayCharge),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    await ref
        .read(customPaymentControllerProvider.notifier)
        .submit(
          CustomPaymentDraft(
            businessId: business.id,
            amountRwf: _amount,
            cadence: _cadence,
            rail: rail,
            phoneNumber: rail.isMomo ? _phoneController.text.trim() : null,
            email: rail.isCard ? _emailController.text.trim() : null,
            customerName: business.name,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
            returnUrl: rail.isCard
                ? Uri.base
                      .replace(path: '/custom-payment', query: null)
                      .toString()
                : null,
          ),
        );
  }

  Future<void> _openLink(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  static Future<void> _copy(
    BuildContext context,
    String value,
    String toast,
  ) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(toast), duration: const Duration(seconds: 2)),
    );
  }

  static String _describe(Object error) =>
      error.toString().replaceFirst('Exception: ', '');
}

// ─────────────────────────────────────────────────────────────────────────────
// Pieces
// ─────────────────────────────────────────────────────────────────────────────

class _Gate extends StatelessWidget {
  const _Gate({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentHeroBlock(
          headline: context.flipperL10n.webPayStaffOnly,
          body: message,
          tone: PaymentHeroTone.error,
        ),
        const SizedBox(height: PaymentTokens.blockGap),
        PaymentSecondaryButton(
          label: context.flipperL10n.webPayBackToBooks,
          onPressed: () => context.go('/accounting'),
        ),
      ],
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query, required this.onPick});

  final String query;
  final ValueChanged<BusinessHit> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.trim().length < 2) return const SizedBox.shrink();
    final results = ref.watch(businessSearchProvider(query));
    return results.when(
      loading: () => Padding(
        padding: const EdgeInsets.all(12),
        child: PaymentCenterLoading(
          message: context.flipperL10n.webPaySearching,
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          context.flipperL10n.webPaySearchFailed(
            error.toString().replaceFirst('Exception: ', ''),
          ),
          style: PaymentTypography.body(color: PaymentTokens.loss),
        ),
      ),
      data: (hits) => hits.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                context.flipperL10n.webPayNoBusinessMatches(query),
                style: PaymentTypography.hint(),
              ),
            )
          : Column(
              key: const Key('custom-payment-results'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final hit in hits) ...[
                  PaymentPayerTile(
                    key: Key('custom-payment-hit-${hit.id}'),
                    name: hit.name.isEmpty ? hit.id : hit.name,
                    subtitle: hit.summary.isEmpty ? hit.id : hit.summary,
                    onTap: () => onPick(hit),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
    );
  }
}

class _BusinessChip extends StatelessWidget {
  const _BusinessChip({super.key, required this.business, this.onChange});

  final BusinessHit business;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: PaymentTokens.blueTint,
        borderRadius: BorderRadius.circular(PaymentTokens.rMd),
      ),
      child: Row(
        children: [
          const Icon(
            FluentIcons.building_shop_20_regular,
            size: 18,
            color: PaymentTokens.blue700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  business.name.isEmpty ? business.id : business.name,
                  style: PaymentTypography.cardTitle(),
                ),
                Text(
                  [
                    business.summary,
                    business.id,
                  ].where((s) => s.isNotEmpty).join(' · '),
                  style: PaymentTypography.hint(),
                ),
              ],
            ),
          ),
          if (onChange != null)
            TextButton(
              key: const Key('custom-payment-change-business'),
              onPressed: onChange,
              child: Text(context.flipperL10n.webPayChange),
            ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    super.key,
    required this.link,
    required this.onCopy,
    required this.onOpen,
  });

  final String link;
  final VoidCallback onCopy;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SelectableText(
            link,
            maxLines: 1,
            style: PaymentTypography.segmentMono(),
          ),
        ),
        IconButton(
          key: const Key('custom-payment-copy-link'),
          tooltip: context.flipperL10n.webPayCopyLink,
          onPressed: onCopy,
          icon: const Icon(FluentIcons.copy_20_regular),
        ),
        IconButton(
          tooltip: context.flipperL10n.webPayOpen,
          onPressed: onOpen,
          icon: const Icon(FluentIcons.open_20_regular),
        ),
      ],
    );
  }
}

class _StageBanner extends StatelessWidget {
  const _StageBanner({required this.payment});

  final CustomPaymentState payment;

  @override
  Widget build(BuildContext context) {
    final message = payment.message;
    if (message == null || payment.stage == CustomPaymentStage.idle) {
      return const SizedBox.shrink();
    }
    final (Color tint, Color ink, IconData icon) = switch (payment.stage) {
      CustomPaymentStage.failed => (
        PaymentTokens.lossTint,
        PaymentTokens.loss,
        FluentIcons.error_circle_20_regular,
      ),
      CustomPaymentStage.timedOut => (
        PaymentTokens.warnTint,
        PaymentTokens.warnAmber,
        FluentIcons.clock_20_regular,
      ),
      CustomPaymentStage.settled => (
        PaymentTokens.gainTint,
        PaymentTokens.gainInk,
        FluentIcons.checkmark_circle_20_regular,
      ),
      _ => (
        PaymentTokens.blueTint,
        PaymentTokens.blue700,
        FluentIcons.phone_20_regular,
      ),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        key: const Key('custom-payment-stage'),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(PaymentTokens.rMd),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: ink),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: PaymentTypography.body(color: ink)),
            ),
          ],
        ),
      ),
    );
  }
}

class _InFlightNote extends StatelessWidget {
  const _InFlightNote({required this.inFlight});

  final CustomPaymentView inFlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        '${context.flipperL10n.webPayExistingPayment(inFlight.id, inFlight.status.wireValue)}'
        '${inFlight.paymentLink == null ? '' : ' — ${context.flipperL10n.webPayLinkSuffix(inFlight.paymentLink!)}'}',
        style: PaymentTypography.hint(),
      ),
    );
  }
}

/// The receipt: every id support might need, each with a copy button.
class _SettledCard extends StatelessWidget {
  const _SettledCard({required this.view, required this.onNewPayment});

  final CustomPaymentView view;
  final VoidCallback onNewPayment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final rows = <PaymentSummaryRow>[
      PaymentSummaryRow(
        label: l10n.webPayReference,
        value: view.id,
        mono: true,
        highlight: true,
      ),
      PaymentSummaryRow(
        label: l10n.business,
        value: view.businessId,
        mono: true,
      ),
      if (view.planId != null)
        PaymentSummaryRow(
          label: l10n.webBillingPlan,
          value: view.planId!,
          mono: true,
        ),
      PaymentSummaryRow(
        label: l10n.amount,
        value:
            '${formatPaymentRwf(view.amount)} ${view.currency} ${view.cadence.label.toLowerCase()}',
      ),
      PaymentSummaryRow(label: l10n.webPayRail, value: view.rail.label),
      if (view.nextBillingDate != null)
        PaymentSummaryRow(
          label: l10n.webPayPaidThrough,
          value: view.nextBillingDate!,
        ),
      if (view.chargeId != null)
        PaymentSummaryRow(
          label: l10n.webPayMomoCharge,
          value: view.chargeId!,
          mono: true,
        ),
      if (view.financialTransactionId != null)
        PaymentSummaryRow(
          label: l10n.webPayMtnTransaction,
          value: view.financialTransactionId!,
          mono: true,
        ),
      if (view.dodoSubscriptionId != null)
        PaymentSummaryRow(
          label: l10n.webPayDodoSubscription,
          value: view.dodoSubscriptionId!,
          mono: true,
        ),
      if (view.dodoPaymentId != null)
        PaymentSummaryRow(
          label: l10n.webPayDodoPayment,
          value: view.dodoPaymentId!,
          mono: true,
        ),
      if (view.previous.cancelledDodoSubscriptionId != null)
        PaymentSummaryRow(
          label: l10n.webPayCancelledCardSub,
          value: view.previous.cancelledDodoSubscriptionId!,
          mono: true,
        ),
      if (view.previous.revokedPreapprovalId != null)
        PaymentSummaryRow(
          label: l10n.webPayRevokedMandate,
          value: view.previous.revokedPreapprovalId!,
          mono: true,
        ),
    ];
    final receipt = rows.map((r) => '${r.label}: ${r.value}').join('\n');

    return Column(
      key: const Key('custom-payment-settled'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: PaymentTokens.gainTint,
            borderRadius: BorderRadius.circular(PaymentTokens.rMd),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                FluentIcons.checkmark_circle_20_regular,
                size: 20,
                color: PaymentTokens.gainInk,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.webPayPaid,
                      style: PaymentTypography.cardTitle(
                        color: PaymentTokens.gainInk,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.webPaySettledBody,
                      style: PaymentTypography.body(
                        color: PaymentTokens.gainInk,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: PaymentTokens.blockGap),
        PaymentSummaryCard(title: l10n.webPayReference, rows: rows),
        const SizedBox(height: 12),
        PaymentSecondaryButton(
          key: const Key('custom-payment-copy-receipt'),
          label: l10n.webPayCopyAllIds,
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: receipt));
            if (!context.mounted) return;
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(
                content: Text(l10n.webPayCopied),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        PaymentPrimaryButton(
          key: const Key('custom-payment-new'),
          label: l10n.webPayNewPayment,
          onPressed: onNewPayment,
        ),
      ],
    );
  }
}
