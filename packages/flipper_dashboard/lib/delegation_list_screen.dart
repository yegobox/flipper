import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_models/brick/models/transaction_delegation.model.dart';
import 'package:intl/intl.dart';

final delegationsProvider =
    StreamProvider.autoDispose<List<TransactionDelegation>>((ref) async* {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) {
    yield [];
    return;
  }

  // Get device ID for filtering
  final devices = await ProxyService.getStrategy(Strategy.capella)
      .getDevicesByBranch(branchId: branchId);
  if (devices.isEmpty) {
    yield [];
    return;
  }

  yield* ProxyService.getStrategy(Strategy.capella).delegationsStream(
    branchId: branchId,
    onDeviceId: devices.first.id,
  );
});

class DelegationListScreen extends ConsumerStatefulWidget {
  const DelegationListScreen({super.key});

  @override
  ConsumerState<DelegationListScreen> createState() =>
      _DelegationListScreenState();
}

class _DelegationListScreenState extends ConsumerState<DelegationListScreen> {
  String _filterStatus = 'all';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _retryDelegation(TransactionDelegation delegation) async {
    try {
      final updatedDelegation = delegation.copyWith(
        status: 'delegated',
        updatedAt: DateTime.now().toUtc(),
      );
      await repository.upsert<TransactionDelegation>(updatedDelegation);

      if (mounted) {
        showCustomSnackBarUtil(context, 'Retrying delegation...');
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Error retrying delegation',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return const Scaffold(
        body: Center(child: Text('No branch selected')),
      );
    }

    final delegationsAsync = ref.watch(delegationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Transaction Delegations',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF0078D4).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline,
                  color: Color(0xFF0078D4), size: 20),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0078D4).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.print,
                            color: Color(0xFF0078D4), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text('About Delegations'),
                    ],
                  ),
                  content: const Text(
                    'Transaction delegations allow mobile devices to send print jobs to desktop printers. '
                    'Failed delegations can be retried from this screen.',
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Got it',
                          style: TextStyle(
                              color: Color(0xFF0078D4),
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'About Delegations',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search delegations...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search,
                        color: Color(0xFF0078D4), size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xFF0078D4), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) =>
                      setState(() => _searchQuery = value.toLowerCase()),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.filter_list,
                        size: 18, color: Color(0xFF6B7280)),
                    const SizedBox(width: 8),
                    Text('Filter:',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700])),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                                label: 'All',
                                isSelected: _filterStatus == 'all',
                                onTap: () =>
                                    setState(() => _filterStatus = 'all')),
                            const SizedBox(width: 8),
                            _FilterChip(
                                label: 'Failed',
                                isSelected: _filterStatus == 'failed',
                                onTap: () =>
                                    setState(() => _filterStatus = 'failed')),
                            const SizedBox(width: 8),
                            _FilterChip(
                                label: 'Delegated',
                                isSelected: _filterStatus == 'delegated',
                                onTap: () => setState(
                                    () => _filterStatus = 'delegated')),
                            const SizedBox(width: 8),
                            _FilterChip(
                                label: 'Completed',
                                isSelected: _filterStatus == 'completed',
                                onTap: () => setState(
                                    () => _filterStatus = 'completed')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: delegationsAsync.when(
              data: (delegations) {
                var filtered = delegations;

                if (_filterStatus != 'all') {
                  filtered =
                      filtered.where((d) => d.status == _filterStatus).toList();
                }

                if (_searchQuery.isNotEmpty) {
                  filtered = filtered.where((d) {
                    final searchable =
                        '${d.transactionId} ${d.customerName ?? ''} ${d.status}'
                            .toLowerCase();
                    return searchable.contains(_searchQuery);
                  }).toList();
                }

                // Sort: failed first, then by date descending
                filtered.sort((a, b) {
                  if (a.status == 'failed' && b.status != 'failed') return -1;
                  if (a.status != 'failed' && b.status == 'failed') return 1;
                  return b.delegatedAt.compareTo(a.delegatedAt);
                });

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF0078D4).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.print,
                              size: 80,
                              color: const Color(0xFF0078D4)
                                  .withValues(alpha: 0.7)),
                        ),
                        const SizedBox(height: 24),
                        Text('No delegations found',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800])),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Try adjusting your search or filters'
                              : 'Delegations will appear here',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 15),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _DelegationCard(
                    delegation: filtered[index],
                    onRetry: filtered[index].status == 'failed'
                        ? () => _retryDelegation(filtered[index])
                        : null,
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0078D4) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isSelected ? const Color(0xFF0078D4) : Colors.grey[300]!,
                width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      );
}

class _DelegationCard extends StatelessWidget {
  final TransactionDelegation delegation;
  final VoidCallback? onRetry;

  const _DelegationCard({required this.delegation, this.onRetry});

  Color _getStatusColor() => switch (delegation.status) {
        'failed' => const Color(0xFFEF4444),
        'delegated' => const Color(0xFFE67E22),
        'completed' => const Color(0xFF10B981),
        _ => Colors.grey,
      };

  Color _getStatusBackgroundColor() => switch (delegation.status) {
        'failed' => const Color(0xFFFEF2F2),
        'delegated' => const Color(0xFFFFF4E5),
        'completed' => const Color(0xFFD1FAE5),
        _ => Colors.grey[100]!,
      };

  IconData _getStatusIcon() => switch (delegation.status) {
        'failed' => Icons.error_outline_rounded,
        'delegated' => Icons.schedule_rounded,
        'completed' => Icons.check_circle_rounded,
        _ => Icons.info_outline,
      };

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: _getStatusBackgroundColor(),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(_getStatusIcon(),
                      color: _getStatusColor(), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              delegation.customerName ??
                                  'Transaction ${delegation.transactionId.substring(0, 8)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                color: _getStatusBackgroundColor(),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              delegation.status.toUpperCase(),
                              style: TextStyle(
                                  color: _getStatusColor(),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(dateFormat.format(delegation.delegatedAt),
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onRetry != null)
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 22),
                    color: const Color(0xFF0078D4),
                    onPressed: onRetry,
                    tooltip: 'Retry delegation',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _InfoRow(
                      icon: Icons.receipt,
                      label: 'Receipt Type',
                      value: delegation.receiptType),
                  const SizedBox(height: 8),
                  _InfoRow(
                      icon: Icons.payment,
                      label: 'Payment',
                      value: delegation.paymentType),
                  const SizedBox(height: 8),
                  _InfoRow(
                      label: 'Amount',
                      value: delegation.subTotal.toCurrencyFormatted()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;

  const _InfoRow({this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
          ],
          Text('$label:',
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600))),
        ],
      );
}
