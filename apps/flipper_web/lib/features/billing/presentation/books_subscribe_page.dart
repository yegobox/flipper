import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/billing/data/books_payment_rails.dart';
import 'package:flipper_web/features/billing/application/books_billing_providers.dart';
import 'package:flipper_web/features/billing/application/books_subscription_controller.dart';
import 'package:flipper_web/features/billing/data/books_entitlement.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// The paywall: which plan, for how long, paid how.
///
/// Prices come from the shared catalogue and are computed the way the mobile
/// app computes them, and the row written is the row the phone reads — so a
/// business subscribed here is subscribed everywhere.
///
/// Reached from [BooksPaywallPanel], and again by the tab Dodo redirects back
/// to after a card checkout (`/subscribe?planId=…`), which resumes polling
/// instead of asking the customer to pay twice.
class BooksSubscribePage extends ConsumerStatefulWidget {
  const BooksSubscribePage({super.key, this.resumePlanId});

  /// A card payment started earlier, to pick up rather than restart.
  final String? resumePlanId;

  @override
  ConsumerState<BooksSubscribePage> createState() => _BooksSubscribePageState();
}

class _BooksSubscribePageState extends ConsumerState<BooksSubscribePage> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  BillingCadence _cadence = BillingCadence.monthly;
  String? _templateId;
  final Set<String> _addonSlugs = {};
  PaymentRail _rail = PaymentRail.mtnMomo;
  bool _useDifferentNumber = false;
  bool _phoneSeeded = false;
  bool _resumed = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restore = ref.watch(selectedBusinessRestoreProvider);
    if (restore.isLoading) {
      return const Scaffold(
        backgroundColor: PaymentTokens.app,
        body: PaymentCenterLoading(message: 'Loading your business…'),
      );
    }

    final business = ref.watch(selectedBusinessProvider);
    if (business == null) {
      return _Message(
        message: 'Pick the business you are paying for, then the plans and '
            'their prices appear here.',
        actionLabel: 'Choose a business',
        onAction: () => context.go('/business-selection'),
      );
    }

    final businessId = business.id;
    final branchId = ref.watch(selectedBranchProvider)?.id;
    final access = ref.watch(booksAccessSnapshotProvider(businessId));
    final catalog = ref.watch(booksCatalogProvider);
    final cardAvailable =
        ref.watch(booksCardRailAvailableProvider).value ?? false;
    final payment = ref.watch(booksSubscriptionControllerProvider);

    _seedPhone(access, business.phoneNumber);
    _maybeResume(businessId);

    // A payment finished while this page was open (here, or on another
    // device): entitlement now says yes, so offer the way in.
    final unlocked = access.status == BooksAccessStatus.entitled &&
        !payment.isBusy &&
        payment.stage != BooksPaymentStage.confirmed;

    // The rail only appears once there is something to total up: a loaded
    // catalogue with plans on sale, and a payment that has not already
    // confirmed. Everything else is a single centred column.
    final showChooser = !(payment.isConfirmed || unlocked);
    final vm = showChooser && catalog.hasValue
        ? _chooserVm(
            catalog: catalog.value!,
            access: access,
            payment: payment,
            cardAvailable: cardAvailable,
          )
        : null;

    return PaymentScreenShell(
      key: const Key('books-subscribe-page'),
      title: access.hasLapsed ? 'Renew your subscription' : 'Subscribe',
      showBack: true,
      onBack: () => context.go('/accounting'),
      badge: ref.read(booksPaymentRailsProvider).isCardTestMode
          ? const PaymentHeaderBadge(label: 'TEST')
          : null,
      overlay: payment.stage == BooksPaymentStage.preparing
          ? PaymentLoadingOverlay(message: payment.message ?? 'One moment…')
          : null,
      aside: vm == null
          ? null
          : _asideBlocks(
              context,
              vm: vm,
              business: business,
              branchId: branchId,
              payment: payment,
            ),
      children: [
        PaymentIntroBlock(
          title: business.name.isEmpty ? 'Flipper Books' : business.name,
          subtitle: 'One subscription opens this business on the web, the '
              'phone and the desktop app.',
        ),
        const SizedBox(height: PaymentTokens.blockGap),
        if (!showChooser)
          _ConfirmedCard(
            message: payment.message ??
                'Your subscription is active. Books is ready to open.',
          )
        else
          catalog.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: PaymentCenterLoading(message: 'Loading plans…'),
            ),
            error: (error, _) => _Inline(
              message: 'Could not load the plans: ${_describe(error)}',
              actionLabel: 'Try again',
              onAction: () => ref.invalidate(booksCatalogProvider),
            ),
            data: (_) => vm == null
                ? const _Inline(message: 'No plans are on sale right now.')
                : _buildChooser(
                    context,
                    vm: vm,
                    payment: payment,
                    cardAvailable: cardAvailable,
                  ),
          ),
      ],
    );
  }


  /// What the chooser and the sticky rail both need. Computed once in
  /// `build`, because the total and the pay button now live in the shell's
  /// aside while the plan tiles stay in the form column — two scopes, one
  /// selection, and they must never disagree about the price.
  _ChooserVm? _chooserVm({
    required SubscriptionPlanCatalog catalog,
    required BooksAccessState access,
    required BooksPaymentState payment,
    required bool cardAvailable,
  }) {
    final templates =
        catalog.templates.where((t) => !t.isEnterprise).toList(growable: false);
    if (templates.isEmpty) return null;

    final template = _selectedTemplate(catalog, templates, access);
    return _ChooserVm(
      templates: templates,
      template: template,
      selection: BooksPlanSelection(
        template: template,
        cadence: _cadence,
        addonSlugs: _addonSlugs.toList(),
        // Mobile always writes 0 here too; extra devices are not sold per seat.
        additionalDevices: 0,
        existing: access.plan,
      ),
      locked: payment.isBusy,
      rails: ref.read(booksPaymentRailsProvider),
      rail: cardAvailable ? _rail : PaymentRail.mtnMomo,
    );
  }

  Widget _buildChooser(
    BuildContext context, {
    required _ChooserVm vm,
    required BooksPaymentState payment,
    required bool cardAvailable,
  }) {
    final templates = vm.templates;
    final template = vm.template;
    final locked = vm.locked;
    final rails = vm.rails;
    final rail = vm.rail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Locked while a charge is in flight: switching period re-prices the
        // plan, and the row being charged is the one written when Pay was
        // pressed.
        IgnorePointer(
          ignoring: locked,
          child: PaymentCadenceSegment(
            cadence: _cadence,
            cadences: const [BillingCadence.monthly, BillingCadence.yearly],
            yearlyDiscountPercent: template.yearlyDiscountPercent,
            onChanged: (value) => setState(() => _cadence = value),
          ),
        ),
        const SizedBox(height: PaymentTokens.blockGap),
        const PaymentSectionLabel('Plan'),
        for (final candidate in templates) ...[
          PaymentPlanTile(
            key: Key('books-subscribe-plan-${candidate.slug}'),
            name: candidate.name,
            priceLine: formatPaymentTilePriceFor(candidate, cadence: _cadence),
            icon: candidate.resolveIcon(),
            selected: candidate.id == template.id,
            onTap: locked
                ? () {}
                : () => setState(() {
                      _templateId = candidate.id;
                      _addonSlugs.clear();
                    }),
          ),
          const SizedBox(height: 8),
        ],
        if (template.addons.isNotEmpty) ...[
          const SizedBox(height: 8),
          const PaymentSectionLabel('Add-ons'),
          for (final addon in template.addons)
            PaymentAddonRow(
              name: addon.name,
              priceLine:
                  formatPaymentAddonPriceFor(template, addon, cadence: _cadence),
              enabled: _addonSlugs.contains(addon.slug),
              onChanged: locked
                  ? (_) {}
                  : (on) => setState(() {
                        if (on) {
                          _addonSlugs.add(addon.slug);
                        } else {
                          _addonSlugs.remove(addon.slug);
                        }
                      }),
            ),
        ],
        const SizedBox(height: PaymentTokens.blockGap),
        const PaymentSectionLabel('Pay with'),
        if (cardAvailable)
          PaymentRailSelector(
            key: const Key('books-subscribe-rail'),
            rail: rail,
            enabled: !locked,
            onChanged: (value) => setState(() => _rail = value),
          ),
        if (cardAvailable) const SizedBox(height: 12),
        if (rail == PaymentRail.mtnMomo)
          PaymentMobileMoneyCard(
            key: const Key('books-subscribe-phone'),
            useDifferentNumber: _useDifferentNumber,
            onUseDifferentChanged: locked
                ? (_) {}
                : (value) => setState(() => _useDifferentNumber = value),
            phoneController: _phoneController,
            onPhoneChanged: (_) => setState(() {}),
            phoneError: _phoneError(payment),
          )
        else
          PaymentCardCheckoutCard(
            key: const Key('books-subscribe-card'),
            emailController: _emailController,
            onEmailChanged: (_) => setState(() {}),
            isTestMode: rails.isCardTestMode,
            pendingCheckoutLink: payment.checkoutLink,
            onOpenPendingLink: payment.checkoutLink == null
                ? null
                : () => _openLink(payment.checkoutLink!),
          ),
      ],
    );
  }

  /// The sticky rail: the total and the button that charges it.
  List<Widget> _asideBlocks(
    BuildContext context, {
    required _ChooserVm vm,
    required Business business,
    required String? branchId,
    required BooksPaymentState payment,
  }) {
    final template = vm.template;
    final selection = vm.selection;
    final locked = vm.locked;
    final rail = vm.rail;

    return [
      PaymentTotalCard(
        total: selection.totalRwf,
        cadence: _cadence,
        subtitle: paymentSelectionSubtitle(
          planName: template.name,
          addonNames: selection.addonNames,
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        _StageBanner(payment: payment),
        PaymentPrimaryButton(
          key: const Key('books-subscribe-pay'),
          label: rail == PaymentRail.card
              ? 'Continue to card payment'
              : 'Pay ${formatPaymentRwf(selection.totalRwf)} RWF',
          loading: locked,
          loadingLabel: payment.stage == BooksPaymentStage.awaitingApproval
              ? 'Waiting for your approval…'
              : payment.stage == BooksPaymentStage.awaitingCheckout
                  ? 'Waiting for the card payment…'
                  : 'Preparing…',
          onPressed: locked
              ? null
              : () => _pay(
                    business: business,
                    branchId: branchId,
                    selection: selection,
                    rail: rail,
                  ),
        ),
        if (payment.stage == BooksPaymentStage.failed ||
            payment.stage == BooksPaymentStage.timedOut) ...[
          const SizedBox(height: 8),
          PaymentSecondaryButton(
            key: const Key('books-subscribe-retry'),
            label: payment.stage == BooksPaymentStage.timedOut
                ? 'Check again'
                : 'Start over',
            onPressed: () => _retry(payment, business.id),
          ),
        ],
        const SizedBox(height: 8),
        PaymentCtaNote(
          provider: rail == PaymentRail.card ? 'Dodo Payments' : 'MTN Mobile Money',
        ),
        ],
      ),
    ];
  }

  SubscriptionPlanTemplate _selectedTemplate(
    SubscriptionPlanCatalog catalog,
    List<SubscriptionPlanTemplate> templates,
    BooksAccessState access,
  ) {
    final chosen = catalog.byId(_templateId);
    if (chosen != null && !chosen.isEnterprise) return chosen;
    // A renewal starts on the plan the business already has.
    final current = catalog.byId(access.plan?.planTemplateId) ??
        catalog.byName(access.plan?.selectedPlan);
    if (current != null && !current.isEnterprise) return current;
    return templates.first;
  }

  /// The number that paid last time — or the business's — so a renewal is one
  /// tap rather than a retyped MSISDN. Only seeded while the field is untouched.
  void _seedPhone(BooksAccessState access, String businessPhone) {
    if (_phoneSeeded || _phoneController.text.isNotEmpty) return;
    final remembered = access.phoneNumber ?? businessPhone;
    if (remembered.trim().isEmpty) return;
    _phoneSeeded = true;
    _phoneController.text = remembered.trim();
  }

  void _maybeResume(String businessId) {
    final planId = widget.resumePlanId;
    if (_resumed || planId == null || planId.isEmpty) return;
    _resumed = true;
    _rail = PaymentRail.card;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(booksSubscriptionControllerProvider.notifier)
          .resumeCard(businessId: businessId, planId: planId);
    });
  }

  String? _phoneError(BooksPaymentState payment) {
    if (payment.stage != BooksPaymentStage.failed ||
        payment.rail != PaymentRail.mtnMomo) {
      return null;
    }
    final phone = _phoneController.text;
    if (phone.isNotEmpty && !MomoMsisdn.isPlausible(phone)) {
      return 'Enter a valid Mobile Money number, e.g. 0788123456.';
    }
    return null;
  }

  Future<void> _pay({
    required Business business,
    required String? branchId,
    required BooksPlanSelection selection,
    required PaymentRail rail,
  }) {
    final controller = ref.read(booksSubscriptionControllerProvider.notifier);
    if (rail == PaymentRail.card) {
      return controller.payWithCard(
        business: business,
        branchId: branchId,
        selection: selection,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
      );
    }
    return controller.payWithMomo(
      business: business,
      branchId: branchId,
      selection: selection,
      phoneNumber: _phoneController.text,
    );
  }

  void _retry(BooksPaymentState payment, String businessId) {
    final controller = ref.read(booksSubscriptionControllerProvider.notifier);
    final planId = payment.planId;
    if (payment.stage == BooksPaymentStage.timedOut &&
        payment.rail == PaymentRail.card &&
        planId != null) {
      controller.reset();
      controller.resumeCard(businessId: businessId, planId: planId);
      return;
    }
    // A MoMo timeout may have settled since: re-read before asking again.
    ref.invalidate(booksAccessStateProvider(businessId));
    controller.reset();
  }

  Future<void> _openLink(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  static String _describe(Object error) =>
      error.toString().replaceFirst('Exception: ', '');
}

class _StageBanner extends StatelessWidget {
  const _StageBanner({required this.payment});

  final BooksPaymentState payment;

  @override
  Widget build(BuildContext context) {
    final message = payment.message;
    if (message == null || payment.stage == BooksPaymentStage.idle) {
      return const SizedBox.shrink();
    }
    final (Color tint, Color ink, IconData icon) = switch (payment.stage) {
      BooksPaymentStage.failed => (
          PaymentTokens.lossTint,
          PaymentTokens.loss,
          FluentIcons.error_circle_20_regular,
        ),
      BooksPaymentStage.timedOut => (
          PaymentTokens.warnTint,
          PaymentTokens.warnAmber,
          FluentIcons.clock_20_regular,
        ),
      BooksPaymentStage.confirmed => (
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
        key: const Key('books-subscribe-stage'),
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

/// The plan selection shared by the form column and the sticky rail.
class _ChooserVm {
  const _ChooserVm({
    required this.templates,
    required this.template,
    required this.selection,
    required this.locked,
    required this.rails,
    required this.rail,
  });

  final List<SubscriptionPlanTemplate> templates;
  final SubscriptionPlanTemplate template;
  final BooksPlanSelection selection;
  final bool locked;
  final BooksPaymentRails rails;
  final PaymentRail rail;
}

class _ConfirmedCard extends StatelessWidget {
  const _ConfirmedCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: PaymentTokens.gainTint,
            borderRadius: BorderRadius.circular(PaymentTokens.rLg),
          ),
          child: Row(
            children: [
              const Icon(
                FluentIcons.checkmark_circle_24_regular,
                color: PaymentTokens.gainInk,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: PaymentTypography.body(color: PaymentTokens.gainInk),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: PaymentTokens.blockGap),
        PaymentPrimaryButton(
          key: const Key('books-subscribe-done'),
          label: 'Open Books',
          icon: FluentIcons.arrow_right_20_regular,
          onPressed: () => context.go('/accounting'),
        ),
      ],
    );
  }
}

class _Inline extends StatelessWidget {
  const _Inline({required this.message, this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(message, style: PaymentTypography.body()),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 12),
          PaymentSecondaryButton(label: actionLabel!, onPressed: onAction!),
        ],
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
    return PaymentScreenShell(
      title: 'Subscribe',
      showBack: false,
      children: [
        const SizedBox(height: 24),
        _Inline(message: message, actionLabel: actionLabel, onAction: onAction),
      ],
    );
  }
}
