import 'package:flipper_dashboard/features/services_gigs/services/service_gig_request_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminMetricsScreen extends StatefulWidget {
  const AdminMetricsScreen({super.key});

  @override
  State<AdminMetricsScreen> createState() => _AdminMetricsScreenState();
}

class _AdminMetricsScreenState extends State<AdminMetricsScreen> {
  final _repo = ServiceGigRequestRepository();
  bool _loading = true;
  ServiceGigAdminMetrics _metrics = const ServiceGigAdminMetrics(
    countsByStatus: {},
    payoutPending: 0,
    payoutDispatched: 0,
    payoutPendingTotalRwf: 0,
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final m = await _repo.adminMetrics();
    if (!mounted) return;
    setState(() {
      _metrics = m;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Services hub metrics',
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
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _MetricCard(
                    title: 'Payouts',
                    rows: [
                      _MetricRow(
                        label: 'Pending dispatch',
                        value: '${_metrics.payoutPending}',
                      ),
                      _MetricRow(
                        label: 'Dispatched',
                        value: '${_metrics.payoutDispatched}',
                      ),
                      _MetricRow(
                        label: 'Pending total (RWF)',
                        value: '${_metrics.payoutPendingTotalRwf}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _MetricCard(
                    title: 'Requests by status',
                    rows: [
                      for (final k in const [
                        'requested',
                        'pending_payment',
                        'paid',
                        'in_progress',
                        'completed',
                        'declined',
                        'expired',
                        'cancelled',
                      ])
                        _MetricRow(
                          label: k.replaceAll('_', ' '),
                          value: '${_metrics.countsByStatus[k] ?? 0}',
                        ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final List<_MetricRow> rows;

  const _MetricCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 10),
            ...rows.expand((r) => [
                  r,
                  const SizedBox(height: 8),
                ]),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
            color: Colors.grey.shade900,
          ),
        ),
      ],
    );
  }
}

