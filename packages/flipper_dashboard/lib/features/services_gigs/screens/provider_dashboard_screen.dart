import 'package:flipper_dashboard/features/services_gigs/models/service_gig_chat_message.dart';
import 'package:flipper_dashboard/features/services_gigs/models/service_gig_provider.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_provider_repository.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_request_repository.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Earnings summary, request counts, and availability for a registered provider.
class ProviderDashboardScreen extends StatefulWidget {
  final ServiceGigProvider profile;

  const ProviderDashboardScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<ProviderDashboardScreen> createState() => _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  final _requestRepo = ServiceGigRequestRepository();
  final _providerRepo = ServiceGigProviderRepository();
  ProviderGigEarningsSummary? _earnings;
  int _openRequests = 0;
  int _activeJobs = 0;
  bool _loading = true;
  bool _busyAvailability = false;
  late bool _available;

  @override
  void initState() {
    super.initState();
    _available = widget.profile.isAvailable;
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final uid = widget.profile.userId;
    try {
      final earnings = await _requestRepo.summarizeProviderEarnings(uid);
      final incoming = await _requestRepo.listIncomingForProvider();
      var open = 0;
      var active = 0;
      for (final r in incoming) {
        if (r.status == 'requested' || r.status == 'pending_payment') {
          open++;
        }
        if (r.status == 'paid' || r.status == 'in_progress') {
          active++;
        }
      }
      if (!mounted) return;
      setState(() {
        _earnings = earnings;
        _openRequests = open;
        _activeJobs = active;
      });
    } catch (e, st) {
      talker.error('ProviderDashboardScreen._load failed', e, st);
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _toggleAvailability(bool v) async {
    final uid = ProxyService.box.getUserId();
    if (uid == null || uid.isEmpty) return;
    setState(() {
      _busyAvailability = true;
      _available = v;
    });
    final ok = await _providerRepo.updateAvailability(userId: uid, isAvailable: v);
    if (!mounted) return;
    setState(() => _busyAvailability = false);
    if (!ok) {
      setState(() => _available = !v);
      showErrorNotification(
        context,
        'Could not update availability on the server.',
      );
    } else {
      showSuccessNotification(
        context,
        v ? 'You are visible to customers.' : 'You are marked unavailable.',
      );
    }
  }

  String _fmtRwf(int n) {
    return n.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Provider dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
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
            : ListView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Text(
                    widget.profile.displayName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: SwitchListTile(
                      title: Text(
                        'Accept new requests',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'When off, customers can still open your profile but booking is disabled.',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      value: _available,
                      onChanged: _busyAvailability ? null : _toggleAvailability,
                      activeThumbColor: const Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _metricCard(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Recorded payments (RWF)',
                    value: _earnings == null
                        ? '—'
                        : _fmtRwf(_earnings!.totalPaymentRwf),
                    subtitle:
                        '${_earnings?.fundedJobCount ?? 0} funded job(s) in hub data',
                  ),
                  const SizedBox(height: 10),
                  _metricCard(
                    icon: Icons.inbox_outlined,
                    title: 'Open requests',
                    value: '$_openRequests',
                    subtitle: 'Awaiting response or payment',
                  ),
                  const SizedBox(height: 10),
                  _metricCard(
                    icon: Icons.construction_outlined,
                    title: 'Active jobs',
                    value: '$_activeJobs',
                    subtitle: 'Paid or in progress',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Payouts and platform fees are handled by your existing MTN and ledger flows.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 1.4,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0D9488)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
