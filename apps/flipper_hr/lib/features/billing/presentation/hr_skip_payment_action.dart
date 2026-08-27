import 'package:flipper_hr/features/billing/application/hr_billing_providers.dart';
import 'package:flipper_hr/features/billing/data/hr_billing_repository.dart';
import 'package:flipper_hr/features/billing/data/hr_entitlement.dart';
import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The way out of the paywall that isn't paying: spends one of a limited
/// number of skips for [businessId], then refreshes entitlement so the caller
/// unlocks on the next frame.
///
/// Shared by [HrPaywallPanel] and [HrSubscribePage] so the "may this business
/// skip, and how" logic lives in exactly one place. Renders nothing when
/// [access] doesn't offer a skip — payment isn't due, or none are left.
class HrSkipPaymentAction extends ConsumerStatefulWidget {
  const HrSkipPaymentAction({
    super.key,
    required this.businessId,
    required this.access,
  });

  final String businessId;
  final HrAccessState access;

  @override
  ConsumerState<HrSkipPaymentAction> createState() =>
      _HrSkipPaymentActionState();
}

class _HrSkipPaymentActionState extends ConsumerState<HrSkipPaymentAction> {
  bool _busy = false;
  String? _error;

  Future<void> _skip() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    // Only a failed *skip* is the user's problem. Once the server has recorded
    // it, a refresh that then trips must not be reported as "could not skip" —
    // that reads as no skip spent when one already was.
    var skipped = false;
    try {
      await ref
          .read(hrBillingRepositoryProvider)
          .skipPayment(businessId: widget.businessId);
      skipped = true;
      ref.invalidate(hrAccessStateProvider(widget.businessId));
      await ref.read(hrAccessStateProvider(widget.businessId).future);
    } on HrBillingException catch (e) {
      if (!skipped && mounted) setState(() => _error = e.message);
    } catch (e) {
      if (!skipped && mounted) {
        setState(() => _error = 'Could not skip this payment: $e');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.access.canSkipPayment) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        TextButton(
          key: const Key('hr-skip-payment'),
          onPressed: _busy ? null : _skip,
          style: TextButton.styleFrom(foregroundColor: HrTokens.ink2),
          child: Text(
            _busy
                ? 'Skipping…'
                : 'Skip for now (${widget.access.skipsRemaining} left)',
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _error!,
              style: const TextStyle(fontSize: 12, color: HrTokens.danger),
            ),
          ),
      ],
    );
  }
}
