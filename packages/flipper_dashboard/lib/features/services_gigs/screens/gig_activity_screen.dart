import 'package:flipper_dashboard/features/services_gigs/models/service_gig_request.dart';
import 'package:flipper_dashboard/features/services_gigs/screens/gig_request_detail_screen.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_provider_repository.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_request_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// In-app activity feed from your gig requests (customer + provider roles).
class GigActivityScreen extends StatefulWidget {
  const GigActivityScreen({Key? key}) : super(key: key);

  @override
  State<GigActivityScreen> createState() => _GigActivityScreenState();
}

class _GigActivityScreenState extends State<GigActivityScreen> {
  final _requestRepo = ServiceGigRequestRepository();
  final _providerRepo = ServiceGigProviderRepository();
  List<_ActivityRow> _rows = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final out = await _requestRepo.listOutgoingForCustomer();
    final inc = await _requestRepo.listIncomingForProvider();
    final nameCache = <String, String?>{};

    Future<String?> nameFor(String userId) async {
      if (nameCache.containsKey(userId)) return nameCache[userId];
      final n = await _providerRepo.getDisplayNameForUserId(userId);
      nameCache[userId] = n;
      return n;
    }

    final rows = <_ActivityRow>[];
    final seen = <String>{};
    for (final r in out) {
      if (!seen.add(r.id)) continue;
      final other = await nameFor(r.providerUserId);
      rows.add(_ActivityRow(
        request: r,
        asCustomer: true,
        otherPartyLabel: other ?? 'Provider',
      ));
    }
    for (final r in inc) {
      if (!seen.add(r.id)) continue;
      final persisted = r.customerDisplayName?.trim();
      final other = (persisted != null && persisted.isNotEmpty)
          ? persisted
          : 'Customer';
      rows.add(_ActivityRow(
        request: r,
        asCustomer: false,
        otherPartyLabel: other,
      ));
    }
    rows.sort((a, b) => b.request.updatedAt.compareTo(a.request.updatedAt));

    if (!mounted) return;
    setState(() {
      _rows = rows;
      _loading = false;
    });
  }

  Future<void> _open(_ActivityRow row) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => GigRequestDetailScreen(
          requestId: row.request.id,
          headline: row.asCustomer
              ? row.otherPartyLabel
              : 'Request from ${row.otherPartyLabel}',
          paymentRecipientLabel:
              row.asCustomer ? row.otherPartyLabel : null,
        ),
      ),
    );
    if (changed == true && mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd().add_jm();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
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
            : _rows.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      Icon(Icons.notifications_none_outlined,
                          size: 56, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No activity yet',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'When you send or receive service requests, updates appear here. '
                        'Pull down to refresh.',
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
                    padding: const EdgeInsets.all(16),
                    itemCount: _rows.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final row = _rows[i];
                      final r = row.request;
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: InkWell(
                          onTap: () => _open(row),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  row.asCustomer
                                      ? 'Request to ${row.otherPartyLabel}'
                                      : 'Request from ${row.otherPartyLabel}',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  r.statusLabel,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(r.statusColor),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Updated ${df.format(r.updatedAt.toLocal())}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
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

class _ActivityRow {
  final ServiceGigRequest request;
  final bool asCustomer;
  final String otherPartyLabel;

  _ActivityRow({
    required this.request,
    required this.asCustomer,
    required this.otherPartyLabel,
  });
}
