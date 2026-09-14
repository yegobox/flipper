import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/billing/application/books_billing_providers.dart';
import 'package:flipper_web/features/billing/data/books_entitlement.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Holds Books behind the subscription.
///
/// Wrapped around the `/accounting` route. A business whose shared `plans`
/// row is paid and current sees [child]; anything else sees the lock, with
/// the one way out — pay. There is deliberately no "skip": the phone and the
/// desktop app read the same row and would not honour a web-only pass.
///
/// Fails open on an error: a paying customer whose network blinked gets Books,
/// not a paywall. The lock is for businesses that have not paid, never for
/// businesses that could not be checked.
class BooksBillingGate extends ConsumerWidget {
  const BooksBillingGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On a reload the selection is restored from storage a beat after the
    // route builds; asking for entitlement before that would ask about no
    // business at all and wave the reload through.
    final restore = ref.watch(selectedBusinessRestoreProvider);
    if (restore.isLoading) {
      return const _GateLoading(key: Key('books-paywall-loading'));
    }

    final businessId = ref.watch(selectedBusinessProvider)?.id;
    if (businessId != null && businessId.isNotEmpty) {
      // Kept alive for as long as the gate is on screen so a payment settled
      // on another device unlocks this tab without a reload.
      ref.watch(booksPlanRealtimeProvider(businessId));
    }

    final access = ref.watch(booksAccessStateProvider(businessId));
    return access.when(
      loading: () => const _GateLoading(key: Key('books-paywall-loading')),
      error: (_, __) => child,
      data: (state) => state.grantsAccess
          ? child
          : BooksPaywallPanel(access: state, businessId: businessId),
    );
  }
}

class _GateLoading extends StatelessWidget {
  const _GateLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: PaymentTokens.app,
      body: PaymentCenterLoading(message: 'Checking your subscription…'),
    );
  }
}

/// The lock itself, split out so it can be laid out and tested without an
/// entitlement state behind it.
class BooksPaywallPanel extends StatelessWidget {
  const BooksPaywallPanel({
    super.key,
    required this.access,
    this.businessId,
  });

  final BooksAccessState access;
  final String? businessId;

  @override
  Widget build(BuildContext context) {
    final lapsed = access.hasLapsed;

    return Scaffold(
      key: const Key('books-paywall-panel'),
      backgroundColor: PaymentTokens.app,
      body: Container(
        decoration: BoxDecoration(gradient: PaymentTokens.screenBackground),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: PaymentTokens.surface,
                    borderRadius: BorderRadius.circular(PaymentTokens.rLg),
                    border: Border.all(color: PaymentTokens.line),
                    boxShadow: PaymentTokens.sh1,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: PaymentTokens.blueTint,
                          borderRadius:
                              BorderRadius.circular(PaymentTokens.rMd),
                        ),
                        child: const Icon(
                          FluentIcons.lock_closed_20_regular,
                          size: 22,
                          color: PaymentTokens.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        lapsed
                            ? 'Your subscription has ended'
                            : 'Flipper Books needs a subscription',
                        style: PaymentTypography.introTitle(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lapsed
                            ? 'Nothing has been deleted — your books, sales '
                                'and stock are all still here. Renew the '
                                'subscription to open them again.'
                            : 'One subscription covers this business on the '
                                'web, the phone and the desktop app. Pay once '
                                'and Flipper opens everywhere you use it.',
                        style: PaymentTypography.body(),
                      ),
                      if (access.isAwaitingSettlement) ...[
                        const SizedBox(height: 12),
                        Text(
                          'A payment is already on its way. If you approved '
                          'it on your phone, this unlocks as soon as Mobile '
                          'Money confirms it.',
                          style: PaymentTypography.hint(),
                        ),
                      ],
                      const SizedBox(height: 20),
                      PaymentPrimaryButton(
                        key: const Key('books-paywall-subscribe'),
                        label: lapsed ? 'Renew now' : 'Choose a plan',
                        icon: FluentIcons.premium_20_regular,
                        onPressed: () => context.go('/subscribe'),
                      ),
                      const SizedBox(height: 8),
                      PaymentSecondaryButton(
                        label: 'Switch business',
                        onPressed: () => context.go('/business-selection'),
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
