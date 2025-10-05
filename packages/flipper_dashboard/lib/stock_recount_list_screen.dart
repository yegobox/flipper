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
        const SnackBar(content: Text('No branch selected')),
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
          SnackBar(content: Text('Error starting recount: $e')),
        );
      }
    }
  }

  Future<void> _deleteRecount(String recountId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recount'),
        content:
            const Text('Are you sure you want to delete this draft recount?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
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
            const SnackBar(content: Text('Recount deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting recount: $e')),
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
      appBar: AppBar(
        title: const Text('Stock Recount'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Stock Recount'),
                  content: const Text(
                    'Stock recount allows you to physically count your inventory '
                    'and update stock levels. Start a new session, scan or enter '
                    'product counts, and submit to update your inventory.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search recounts...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: _filterStatus == 'all',
                        onTap: () => setState(() => _filterStatus = 'all'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Draft',
                        isSelected: _filterStatus == 'draft',
                        onTap: () => setState(() => _filterStatus = 'draft'),
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
                        onTap: () => setState(() => _filterStatus = 'synced'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No recounts found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start a new recount session to begin',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
        icon: const Icon(Icons.add),
        label: const Text('New Recount'),
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
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
        return Colors.orange;
      case 'submitted':
        return Colors.blue;
      case 'synced':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (recount.status) {
      case 'draft':
        return Icons.edit_outlined;
      case 'submitted':
        return Icons.check_circle_outline;
      case 'synced':
        return Icons.cloud_done_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              recount.deviceName ?? 'Unknown Device',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                recount.status.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(recount.createdAt),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      onPressed: onDelete,
                    ),
                ],
              ),
              if (recount.notes != null && recount.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  recount.notes!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${recount.totalItemsCounted} items counted',
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
      ),
    );
  }
}
