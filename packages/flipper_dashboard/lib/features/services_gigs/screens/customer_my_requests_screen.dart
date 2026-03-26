import 'package:flipper_dashboard/features/services_gigs/models/service_gig_request.dart';
import 'package:flipper_dashboard/features/services_gigs/screens/gig_request_detail_screen.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_provider_repository.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_request_repository.dart';
import 'package:flipper_dashboard/features/services_gigs/widgets/gig_payment_sheet.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'My requests',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
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
                      Icon(Icons.send_outlined,
                          size: 56, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No requests yet',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'When you ask someone for a service from Find providers, it will appear here. After they accept, you can pay with MTN within the time shown.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
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
                      final urgentPay = r.canCustomerPay;

                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: urgentPay
                                ? const Color(0xFF0D9488).withValues(alpha: 0.5)
                                : Colors.grey.shade200,
                            width: urgentPay ? 1.5 : 1,
                          ),
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
                                _providerLabel(r),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _statusLabel(r),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: const Color(0xFF0F766E),
                                ),
                              ),
                              if (r.requestedService != null &&
                                  r.requestedService!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  r.requestedService!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                r.customerMessage,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              if (r.paymentAmountRwf != null &&
                                  r.paymentAmountRwf! >= 100 &&
                                  (r.status == 'requested' ||
                                      r.isAwaitingPayment)) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Agreed amount: ${r.paymentAmountRwf} RWF',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                'Sent ${df.format(r.createdAt.toLocal())}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              if (r.isAwaitingPayment &&
                                  r.paymentDeadlineAt != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  r.canCustomerPay
                                      ? 'Pay by ${df.format(r.paymentDeadlineAt!.toLocal())}'
                                      : 'You did not pay before ${df.format(r.paymentDeadlineAt!.toLocal())}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: r.canCustomerPay
                                        ? Colors.amber.shade900
                                        : Colors.red.shade700,
                                  ),
                                ),
                              ],
                              if (r.status == 'paid' &&
                                  r.paymentAmountRwf != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  r.mtnSettledAmountRwf != null &&
                                          r.mtnSettledAmountRwf !=
                                              r.paymentAmountRwf
                                      ? 'Paid ${r.paymentAmountRwf} RWF · MTN settled ${r.mtnSettledAmountRwf} RWF'
                                      : 'Paid ${r.paymentAmountRwf} RWF',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ],
                              if (urgentPay) ...[
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: () => _openPay(r),
                                    icon: const Icon(Icons.phone_android),
                                    label: const Text('Pay with MTN'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFF0D9488),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
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
