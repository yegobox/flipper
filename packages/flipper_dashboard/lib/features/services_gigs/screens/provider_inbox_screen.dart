import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/features/services_gigs/models/service_gig_request.dart';
import 'package:flipper_dashboard/features/services_gigs/screens/gig_request_detail_screen.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_provider_repository.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_request_repository.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Provider view: incoming service requests, accept / decline within the accept window.
class ProviderInboxScreen extends StatefulWidget {
  const ProviderInboxScreen({Key? key}) : super(key: key);

  @override
  State<ProviderInboxScreen> createState() => _ProviderInboxScreenState();
}

class _ProviderInboxScreenState extends State<ProviderInboxScreen> {
  final _repo = ServiceGigRequestRepository();
  final _providerRepo = ServiceGigProviderRepository();
  List<ServiceGigRequest> _items = [];
  Map<String, String?> _customerNames = {};
  bool _loading = true;
  String? _actingOnId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _repo.listIncomingForProvider();
    list.sort(_sortIncoming);
    final ids = list.map((e) => e.customerUserId).toSet();
    final names = <String, String?>{};
    for (final id in ids) {
      names[id] = await _providerRepo.getDisplayNameForUserId(id);
    }
    if (!mounted) return;
    setState(() {
      _items = list;
      _customerNames = names;
      _loading = false;
    });
  }

  String _customerLabel(ServiceGigRequest r) {
    final n = _customerNames[r.customerUserId];
    if (n != null && n.isNotEmpty) return n;
    final id = r.customerUserId;
    if (id.length > 10) {
      return context.flipperL10n.gigsCustomerShortId(
        id.substring(id.length - 6),
      );
    }
    return context.flipperL10n.customer;
  }

  Future<void> _openDetail(ServiceGigRequest r) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => GigRequestDetailScreen(
          requestId: r.id,
          headline: context.flipperL10n.gigsRequestFrom(_customerLabel(r)),
        ),
      ),
    );
    if (changed == true && mounted) await _load();
  }

  int _sortIncoming(ServiceGigRequest a, ServiceGigRequest b) {
    int rank(ServiceGigRequest r) {
      if (r.status == 'requested' && r.canProviderRespond) return 0;
      if (r.status == 'requested') return 1;
      if (r.status == 'pending_payment') return 2;
      return 3;
    }

    final c = rank(a).compareTo(rank(b));
    if (c != 0) return c;
    return b.createdAt.compareTo(a.createdAt);
  }

  Future<void> _accept(ServiceGigRequest r) async {
    setState(() => _actingOnId = r.id);
    try {
      await _repo.acceptRequest(r.id);
      if (!mounted) return;
      showSuccessNotification(
        context,
        context.flipperL10n.gigsAcceptedCustomerCanPay,
      );
      await _load();
    } on ServiceGigRequestException catch (e) {
      if (mounted) showErrorNotification(context, e.message);
    } catch (_) {
      if (mounted) {
        showErrorNotification(context, context.flipperL10n.gigsErrAcceptRetry);
      }
    } finally {
      if (mounted) setState(() => _actingOnId = null);
    }
  }

  Future<void> _decline(ServiceGigRequest r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          context.flipperL10n.gigsDeclineRequestTitle,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        content: Text(
          context.flipperL10n.gigsDeclineRequestBody,
          style: GoogleFonts.outfit(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              context.flipperL10n.cancel,
              style: GoogleFonts.outfit(),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: Text(
              context.flipperL10n.gigsDecline,
              style: GoogleFonts.outfit(),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _actingOnId = r.id);
    try {
      await _repo.declineRequest(r.id);
      if (!mounted) return;
      showInfoNotification(context, context.flipperL10n.gigsRequestDeclined);
      await _load();
    } on ServiceGigRequestException catch (e) {
      if (mounted) showErrorNotification(context, e.message);
    } catch (_) {
      if (mounted) {
        showErrorNotification(context, context.flipperL10n.gigsErrDeclineRetry);
      }
    } finally {
      if (mounted) setState(() => _actingOnId = null);
    }
  }

  static String _statusLabel(FlipperAppLocalizations l10n, String status) {
    switch (status) {
      case 'requested':
        return l10n.gigsAwaitingYourResponse;
      case 'pending_payment':
        return l10n.gigsWaitingForCustomerPayment;
      default:
        return gigStatusShortLabel(l10n, status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd().add_jm();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          context.flipperL10n.gigsIncomingRequests,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: const Color(0xFF0D9488),
        child: _loading
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : _items.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 56,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.flipperL10n.gigsNoRequestsYet,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.flipperL10n.gigsInboxEmptyHint,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final r = _items[i];
                  final acting = _actingOnId == r.id;
                  final showActions = r.canProviderRespond;

                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: InkWell(
                      onTap: () => _openDetail(r),
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _customerLabel(r),
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _statusLabel(context.flipperL10n, r.status),
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: const Color(0xFF0F766E),
                                    ),
                                  ),
                                ),
                                if (r.status == 'requested' &&
                                    !r.canProviderRespond)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      context
                                          .flipperL10n
                                          .gigsAcceptDeadlinePassed,
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if (r.requestedService != null &&
                                r.requestedService!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                r.requestedService!,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Text(
                              r.customerMessage,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                height: 1.4,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            if (r.paymentAmountRwf != null &&
                                r.paymentAmountRwf! >= 100) ...[
                              const SizedBox(height: 8),
                              Text(
                                context.flipperL10n.gigsCustomerBudget(
                                  '${r.paymentAmountRwf}',
                                ),
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            Text(
                              context.flipperL10n.gigsReceivedAt(
                                df.format(r.createdAt.toLocal()),
                              ),
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (r.status == 'requested' &&
                                r.canProviderRespond) ...[
                              const SizedBox(height: 4),
                              Text(
                                context.flipperL10n.gigsRespondBy(
                                  df.format(r.acceptDeadlineAt.toLocal()),
                                ),
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amber.shade900,
                                ),
                              ),
                            ],
                            if (r.isAwaitingPayment &&
                                r.paymentDeadlineAt != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                context.flipperL10n.gigsPaymentDueBy(
                                  df.format(r.paymentDeadlineAt!.toLocal()),
                                ),
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                            if (showActions) ...[
                              const SizedBox(height: 16),
                              if (acting)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => _decline(r),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red.shade700,
                                          side: BorderSide(
                                            color: Colors.red.shade300,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        child: Text(
                                          context.flipperL10n.gigsDecline,
                                          style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: FilledButton(
                                        onPressed: () => _accept(r),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF0D9488,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        child: Text(
                                          context.flipperL10n.gigsAccept,
                                          style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
