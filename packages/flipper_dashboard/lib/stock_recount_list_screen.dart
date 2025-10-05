import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/stock_recount.model.dart';
import 'package:intl/intl.dart';
import 'stock_recount_active_screen.dart';

class StockRecountListScreen extends StatefulWidget {
  const StockRecountListScreen({Key? key}) : super(key: key);

  @override
  State<StockRecountListScreen> createState() => _StockRecountListScreenState();
}

class _StockRecountListScreenState extends State<StockRecountListScreen> {
  String _filterStatus = 'all';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _startNewRecount() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('No branch selected'),
            ],
          ),
          backgroundColor: Color(0xFFE67E22),
        ),
      );
      return;
    }

    try {
      final deviceId = await ProxyService.strategy.getPlatformDeviceId();
      final recount = await ProxyService.strategy.startRecountSession(
        branchId: branchId,
        userId: ProxyService.box.getUserId()?.toString(),
        deviceId: deviceId,
        deviceName: 'Device ${deviceId?.substring(0, 8) ?? 'Unknown'}',
        notes: 'Stock recount session',
      );

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                StockRecountActiveScreen(recountId: recount.id),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting recount: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<void> _deleteRecount(String recountId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFEF4444),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Delete Recount'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this draft recount? This action cannot be undone.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ProxyService.strategy.deleteRecount(recountId: recountId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Recount deleted successfully'),
                ],
              ),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting recount: $e'),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return const Scaffold(
        body: Center(
          child: Text('No branch selected'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Stock Recount',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF0078D4).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.info_outline,
                color: Color(0xFF0078D4),
                size: 20,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0078D4).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.inventory_2_rounded,
                          color: Color(0xFF0078D4),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('About Stock Recount'),
                    ],
                  ),
                  content: const Text(
                    'Stock recount allows you to physically count your inventory '
                    'and update stock levels. Start a new session, scan or enter '
                    'product counts, and submit to update your inventory.',
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Got it',
                        style: TextStyle(
                          color: Color(0xFF0078D4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'About Stock Recount',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar with modern design
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search recounts...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF0078D4),
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
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
                      borderSide: const BorderSide(
                        color: Color(0xFF0078D4),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Filter Chips
                Row(
                  children: [
                    const Icon(
                      Icons.filter_list,
                      size: 18,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Filter:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
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
                                  setState(() => _filterStatus = 'all'),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Draft',
                              isSelected: _filterStatus == 'draft',
                              onTap: () =>
                                  setState(() => _filterStatus = 'draft'),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Submitted',
                              isSelected: _filterStatus == 'submitted',
                              onTap: () =>
                                  setState(() => _filterStatus = 'submitted'),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Synced',
                              isSelected: _filterStatus == 'synced',
                              onTap: () =>
                                  setState(() => _filterStatus = 'synced'),
                            ),
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
          // Recounts List
          Expanded(
            child: StreamBuilder<List<StockRecount>>(
              stream: ProxyService.strategy.recountsStream(
                branchId: branchId,
                status: _filterStatus == 'all' ? null : _filterStatus,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                var recounts = snapshot.data ?? [];

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  recounts = recounts.where((recount) {
                    final searchableText =
                        '${recount.deviceName} ${recount.notes} ${recount.status}'
                            .toLowerCase();
                    return searchableText.contains(_searchQuery);
                  }).toList();
                }

                if (recounts.isEmpty) {
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
                          child: Icon(
                            Icons.inventory_2_rounded,
                            size: 80,
                            color:
                                const Color(0xFF0078D4).withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No recounts found',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Try adjusting your search or filters'
                              : 'Start a new recount session to begin',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            onPressed: _startNewRecount,
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Start New Recount'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0078D4),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: recounts.length,
                  itemBuilder: (context, index) {
                    final recount = recounts[index];
                    return _RecountCard(
                      recount: recount,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                StockRecountActiveScreen(recountId: recount.id),
                          ),
                        );
                      },
                      onDelete: recount.status == 'draft'
                          ? () => _deleteRecount(recount.id)
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startNewRecount,
        icon: const Icon(Icons.add, size: 22),
        label: const Text(
          'New Recount',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        backgroundColor: const Color(0xFF0078D4),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0078D4) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF0078D4) : Colors.grey[300]!,
            width: 1,
          ),
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
}

class _RecountCard extends StatelessWidget {
  final StockRecount recount;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _RecountCard({
    required this.recount,
    required this.onTap,
    this.onDelete,
  });

  Color _getStatusColor() {
    switch (recount.status) {
      case 'draft':
        return const Color(0xFFE67E22); // Orange
      case 'submitted':
        return const Color(0xFF0078D4); // Blue
      case 'synced':
        return const Color(0xFF10B981); // Green
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBackgroundColor() {
    switch (recount.status) {
      case 'draft':
        return const Color(0xFFFFF4E5); // Light orange
      case 'submitted':
        return const Color(0xFFE3F2FD); // Light blue
      case 'synced':
        return const Color(0xFFD1FAE5); // Light green
      default:
        return Colors.grey[100]!;
    }
  }

  IconData _getStatusIcon() {
    switch (recount.status) {
      case 'draft':
        return Icons.edit_note_rounded;
      case 'submitted':
        return Icons.check_circle_rounded;
      case 'synced':
        return Icons.cloud_done_rounded;
      default:
        return Icons.info_outline;
    }
  }

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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getStatusBackgroundColor(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and timestamp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                recount.deviceName ?? 'Unknown Device',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusBackgroundColor(),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                recount.status.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateFormat.format(recount.createdAt),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Delete button
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 22,
                      ),
                      color: const Color(0xFFEF4444),
                      onPressed: onDelete,
                      tooltip: 'Delete recount',
                    ),
                ],
              ),
              // Notes section
              if (recount.notes != null && recount.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.notes,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          recount.notes!,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Items counted info
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0078D4).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF0078D4).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0078D4).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.inventory_2_rounded,
                        size: 16,
                        color: Color(0xFF0078D4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${recount.totalItemsCounted} ${recount.totalItemsCounted == 1 ? 'item' : 'items'} counted',
                      style: const TextStyle(
                        color: Color(0xFF0078D4),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
