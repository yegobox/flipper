import 'package:flipper_dashboard/features/services_gigs/models/service_gig_request.dart';
import 'package:flipper_dashboard/features/services_gigs/screens/gig_request_detail_screen.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_provider_repository.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_request_repository.dart';
import 'package:flipper_dashboard/features/services_gigs/widgets/gig_payment_sheet.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const _kCardRadius = 10.0;
const _kPayButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

/// Customer view: requests you sent, including pay-with-MTN after the provider accepts.
class CustomerMyRequestsScreen extends StatefulWidget {
  const CustomerMyRequestsScreen({Key? key}) : super(key: key);

  @override
  State<CustomerMyRequestsScreen> createState() =>
      _CustomerMyRequestsScreenState();
}

class _CustomerMyRequestsScreenState extends State<CustomerMyRequestsScreen> {
  final _requestRepo = ServiceGigRequestRepository();
  final _providerRepo = ServiceGigProviderRepository();

  List<ServiceGigRequest> _items = [];
  Map<String, String?> _providerNames = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _requestRepo.listOutgoingForCustomer();
    list.sort(_sortOutgoing);

    final ids = list.map((e) => e.providerUserId).toSet();
    final names = <String, String?>{};
    for (final id in ids) {
      names[id] = await _providerRepo.getDisplayNameForUserId(id);
    }

    if (!mounted) return;
    setState(() {
      _items = list;
      _providerNames = names;
      _loading = false;
    });
  }

  int _sortOutgoing(ServiceGigRequest a, ServiceGigRequest b) {
    int rank(ServiceGigRequest r) {
      if (r.canCustomerPay) return 0;
      if (r.status == 'pending_payment') return 1;
      if (r.status == 'requested') return 2;
      return 3;
    }

    final c = rank(a).compareTo(rank(b));
    if (c != 0) return c;
    return b.createdAt.compareTo(a.createdAt);
  }

  String _providerLabel(ServiceGigRequest r) {
    final name = _providerNames[r.providerUserId];
    if (name != null && name.isNotEmpty) return name;
    final id = r.providerUserId;
    if (id.length > 10) return 'Provider · …${id.substring(id.length - 6)}';
    return 'Provider';
  }

  static String _statusLabel(ServiceGigRequest r) {
    switch (r.status) {
      case 'requested':
        return 'Waiting for provider';
      case 'pending_payment':
        return r.canCustomerPay ? 'Pay now' : 'Payment window ended';
      case 'paid':
        return 'Paid';
      case 'declined':
        return 'Declined by provider';
      case 'expired':
        return 'Expired';
      case 'cancelled':
        return 'Cancelled';
      case 'in_progress':
        return 'In progress';
      case 'completed':
        return 'Completed';
      default:
        return r.status;
    }
  }

  Future<void> _openDetail(ServiceGigRequest r) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => GigRequestDetailScreen(
          requestId: r.id,
          headline: _providerLabel(r),
          paymentRecipientLabel: _providerLabel(r),
        ),
      ),
    );
    if (changed == true && mounted) await _load();
  }

  Future<void> _openPay(ServiceGigRequest r) async {
    final done = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) => GigPaymentSheet(
        request: r,
        providerLabel: _providerLabel(r),
      ),
    );
    if (done == true && mounted) {
      showSuccessNotification(
        context,
        'Payment recorded. The provider can start the job.',
      );
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd().add_jm();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'My requests',
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
                      const SizedBox(height: 32),
                      Icon(
                        Icons.send_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No requests yet',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'When you ask someone for a service from Find providers, it will appear here. After they accept, you can pay with MTN within the time shown.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          height: 1.45,
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
                      return _OutgoingRequestCard(
                        request: r,
                        providerLabel: _providerLabel(r),
                        statusLabel: _statusLabel(r),
                        dateFormat: df,
                        onOpenDetail: () => _openDetail(r),
                        onOpenPay: () => _openPay(r),
                      );
                    },
                  ),
      ),
    );
  }
}

class _StatusChipStyle {
  final Color background;
  final Color foreground;

  const _StatusChipStyle({required this.background, required this.foreground});
}

_StatusChipStyle _statusChipStyle(ServiceGigRequest r) {
  if (r.canCustomerPay) {
    return _StatusChipStyle(
      background: Colors.amber.shade100,
      foreground: Colors.amber.shade900,
    );
  }
  if (r.status == 'pending_payment') {
    return _StatusChipStyle(
      background: Colors.red.shade50,
      foreground: Colors.red.shade900,
    );
  }
  switch (r.status) {
    case 'completed':
      return _StatusChipStyle(
        background: Colors.green.shade50,
        foreground: Colors.green.shade800,
      );
    case 'paid':
    case 'in_progress':
      return _StatusChipStyle(
        background: const Color(0xFF0D9488).withValues(alpha: 0.12),
        foreground: const Color(0xFF0F766E),
      );
    case 'declined':
    case 'expired':
    case 'cancelled':
      return _StatusChipStyle(
        background: Colors.grey.shade200,
        foreground: Colors.grey.shade800,
      );
    case 'requested':
    default:
      return _StatusChipStyle(
        background: Colors.blueGrey.shade50,
        foreground: Colors.blueGrey.shade800,
      );
  }
}

class _OutgoingRequestCard extends StatelessWidget {
  final ServiceGigRequest request;
  final String providerLabel;
  final String statusLabel;
  final DateFormat dateFormat;
  final VoidCallback onOpenDetail;
  final VoidCallback onOpenPay;

  const _OutgoingRequestCard({
    required this.request,
    required this.providerLabel,
    required this.statusLabel,
    required this.dateFormat,
    required this.onOpenDetail,
    required this.onOpenPay,
  });

  @override
  Widget build(BuildContext context) {
    final urgentPay = request.canCustomerPay;
    final chipStyle = _statusChipStyle(request);
    final initial = providerLabel.isNotEmpty
        ? providerLabel.characters.first.toUpperCase()
        : '?';

    final showAmount = request.paymentAmountRwf != null &&
        request.paymentAmountRwf! >= 100 &&
        (request.status == 'requested' || request.isAwaitingPayment);

    return Material(
      color: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_kCardRadius),
        side: BorderSide(
          color: urgentPay
              ? const Color(0xFF0D9488).withValues(alpha: 0.45)
              : Colors.grey.shade300,
          width: urgentPay ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpenDetail,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        const Color(0xFF0D9488).withValues(alpha: 0.12),
                    child: Text(
                      initial,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: const Color(0xFF0F766E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                providerLabel,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  height: 1.25,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: chipStyle.background,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                statusLabel,
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  color: chipStyle.foreground,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (request.requestedService != null &&
                            request.requestedService!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            request.requestedService!,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade900,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          request.customerMessage,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            height: 1.4,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
              const SizedBox(height: 10),
              if (showAmount)
                _MetaLine(
                  label: 'Agreed amount',
                  value: '${request.paymentAmountRwf} RWF',
                ),
              _MetaLine(
                icon: Icons.schedule_outlined,
                label: 'Sent',
                value: dateFormat.format(request.createdAt.toLocal()),
                dense: true,
              ),
              if (request.isAwaitingPayment &&
                  request.paymentDeadlineAt != null) ...[
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        request.canCustomerPay
                            ? Icons.timer_outlined
                            : Icons.error_outline,
                        size: 16,
                        color: request.canCustomerPay
                            ? Colors.amber.shade800
                            : Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        request.canCustomerPay
                            ? 'Pay by ${dateFormat.format(request.paymentDeadlineAt!.toLocal())}'
                            : 'You did not pay before ${dateFormat.format(request.paymentDeadlineAt!.toLocal())}',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                          color: request.canCustomerPay
                              ? Colors.amber.shade900
                              : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (request.status == 'paid' &&
                  request.paymentAmountRwf != null) ...[
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        request.mtnSettledAmountRwf != null &&
                                request.mtnSettledAmountRwf !=
                                    request.paymentAmountRwf
                            ? 'Paid ${request.paymentAmountRwf} RWF · MTN settled ${request.mtnSettledAmountRwf} RWF'
                            : 'Paid ${request.paymentAmountRwf} RWF',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (urgentPay) ...[
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onOpenPay,
                    icon: const Icon(Icons.phone_android, size: 20),
                    label: const Text('Pay with MTN'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: _kPayButtonShape,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  final String label;
  final String? value;
  final IconData? icon;
  final bool dense;

  const _MetaLine({
    required this.label,
    this.value,
    this.icon,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final caption = GoogleFonts.outfit(
      fontSize: dense ? 12 : 12,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade600,
      height: 1.35,
    );
    final valueStyle = GoogleFonts.outfit(
      fontSize: dense ? 12 : 13,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade900,
      height: 1.35,
    );

    if (value != null && icon == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('$label · ', style: caption),
            Expanded(
              child: Text(value!, style: valueStyle),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: 16, color: Colors.grey.shade500),
            ),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: RichText(
              text: TextSpan(
                style: caption.copyWith(color: Colors.grey.shade600),
                children: [
                  TextSpan(text: '$label '),
                  TextSpan(
                    text: value ?? '',
                    style: valueStyle.copyWith(color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
