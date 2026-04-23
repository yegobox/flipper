import 'package:flipper_dashboard/features/services_gigs/services/service_gig_provider_repository.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_request_repository.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AdminPayoutDispatchScreen extends StatefulWidget {
  const AdminPayoutDispatchScreen({super.key});

  @override
  State<AdminPayoutDispatchScreen> createState() =>
      _AdminPayoutDispatchScreenState();
}

class _AdminPayoutDispatchScreenState extends State<AdminPayoutDispatchScreen> {
  final _repo = ServiceGigRequestRepository();
  final _providerRepo = ServiceGigProviderRepository();
  bool _loading = true;
  String? _actingOnId;
  var _items = <dynamic>[];
  final _providerNames = <String, String?>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _repo.listAdminPayoutQueue();
    final ids = list.map((e) => e.providerUserId).toSet();
    final names = <String, String?>{};
    for (final id in ids) {
      names[id] = await _providerRepo.getDisplayNameForUserId(id);
    }
    if (!mounted) return;
    setState(() {
      _items = list;
      _providerNames
        ..clear()
        ..addAll(names);
      _loading = false;
    });
  }

  String _providerLabel(String providerUserId) {
    final n = _providerNames[providerUserId];
    if (n != null && n.isNotEmpty) return n;
    if (providerUserId.length > 10) {
      return 'Provider · …${providerUserId.substring(providerUserId.length - 6)}';
    }
    return 'Provider';
  }

  Future<void> _markDispatched(String requestId) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Payout reference',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: 'MTN / ledger reference',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.outfit()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            child: Text('Mark dispatched', style: GoogleFonts.outfit()),
          ),
        ],
      ),
    );
    final ref = ctrl.text;
    ctrl.dispose();
    if (ok != true) return;
    setState(() => _actingOnId = requestId);
    try {
      await _repo.markProviderPayoutDispatched(
        requestId: requestId,
        reference: ref,
      );
      if (!mounted) return;
      showSuccessNotification(context, 'Marked dispatched.');
      await _load();
    } on ServiceGigRequestException catch (e) {
      if (!mounted) return;
      showErrorNotification(context, e.message);
    } finally {
      if (mounted) setState(() => _actingOnId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd().add_jm();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Dispatch payouts',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFDC2626),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: const Color(0xFFDC2626),
        child: _loading
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 140),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : _items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      const SizedBox(height: 20),
                      Icon(
                        Icons.payments_outlined,
                        size: 44,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'No payouts pending',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'When jobs are funded, they will appear here until dispatched.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
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
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final r = _items[i];
                      final acting = _actingOnId == r.id;
                      final amt = r.paymentAmountRwf ?? 0;

                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: ListTile(
                          title: Text(
                            _providerLabel(r.providerUserId),
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'Amount: $amt RWF · ${r.status.replaceAll('_', ' ')}\nSent ${df.format(r.createdAt.toLocal())}',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                height: 1.35,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          isThreeLine: true,
                          trailing: acting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.check_circle_outline),
                                  color: const Color(0xFFDC2626),
                                  tooltip: 'Mark dispatched',
                                  onPressed: () => _markDispatched(r.id),
                                ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

