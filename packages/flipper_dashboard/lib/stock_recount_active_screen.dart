import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/stock_recount.model.dart';
import 'package:supabase_models/brick/models/stock_recount_item.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:intl/intl.dart';

class StockRecountActiveScreen extends StatefulWidget {
  final String recountId;

  const StockRecountActiveScreen({
    Key? key,
    required this.recountId,
  }) : super(key: key);

  @override
  State<StockRecountActiveScreen> createState() =>
      _StockRecountActiveScreenState();
}

class _StockRecountActiveScreenState extends State<StockRecountActiveScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  Variant? _selectedVariant;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submitRecount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Recount'),
        content: const Text(
          'Are you sure you want to submit this recount? '
          'This will update all stock levels and cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ProxyService.strategy.submitRecount(recountId: widget.recountId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recount submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting recount: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _addOrUpdateItem() async {
    if (_selectedVariant == null || _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a product and enter quantity')),
      );
      return;
    }

    final quantity = double.tryParse(_quantityController.text);
    if (quantity == null || quantity < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }

    try {
      await ProxyService.strategy.addOrUpdateRecountItem(
        recountId: widget.recountId,
        variantId: _selectedVariant!.id,
        countedQuantity: quantity,
        notes:
            'Counted on ${DateFormat('MMM dd, HH:mm').format(DateTime.now())}',
      );

      if (mounted) {
        setState(() {
          _selectedVariant = null;
          _quantityController.clear();
          _searchController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added to recount')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding item: $e')),
        );
      }
    }
  }

  Future<void> _removeItem(String itemId) async {
    try {
      await ProxyService.strategy.removeRecountItem(itemId: itemId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing item: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StockRecount?>(
      future: ProxyService.strategy.getRecount(recountId: widget.recountId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final recount = snapshot.data;
        if (recount == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Recount Not Found')),
            body: const Center(child: Text('Recount not found')),
          );
        }

        final isDraft = recount.status == 'draft';

        return Scaffold(
          appBar: AppBar(
            title: Text(isDraft ? 'Stock Recount' : 'View Recount'),
            actions: [
              if (isDraft && !_isSubmitting)
                TextButton.icon(
                  onPressed: _submitRecount,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              if (_isSubmitting)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              // Recount Info Card
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          recount.deviceName ?? 'Unknown Device',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: recount.status == 'draft'
                                ? Colors.orange
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            recount.status.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Created ${DateFormat('MMM dd, yyyy • HH:mm').format(recount.createdAt)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    if (recount.notes != null && recount.notes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        recount.notes!,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ],
                ),
              ),

              // Add Item Section (only for draft)
              if (isDraft)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Product',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _ProductSearchField(
                              controller: _searchController,
                              onProductSelected: (variant) {
                                setState(() {
                                  _selectedVariant = variant;
                                  _quantityController.text = '';
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                                hintText: '0',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.numbers),
                              ),
                              enabled: _selectedVariant != null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _selectedVariant != null
                                ? _addOrUpdateItem
                                : null,
                            icon: const Icon(Icons.add),
                            label: const Text('Add'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedVariant != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  size: 16, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Selected: ${_selectedVariant!.name}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                onPressed: () {
                                  setState(() {
                                    _selectedVariant = null;
                                    _searchController.clear();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              // Items List
              Expanded(
                child: FutureBuilder<List<StockRecountItem>>(
                  future: ProxyService.strategy
                      .getRecountItems(recountId: widget.recountId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final items = snapshot.data ?? [];

                    if (items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No items yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isDraft
                                  ? 'Start scanning or searching for products'
                                  : 'This recount has no items',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _RecountItemCard(
                          item: item,
                          isDraft: isDraft,
                          onRemove: () => _removeItem(item.id),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductSearchField extends StatefulWidget {
  final TextEditingController controller;
  final Function(Variant) onProductSelected;

  const _ProductSearchField({
    required this.controller,
    required this.onProductSelected,
  });

  @override
  State<_ProductSearchField> createState() => _ProductSearchFieldState();
}

class _ProductSearchFieldState extends State<_ProductSearchField> {
  List<Variant> _searchResults = [];
  bool _isSearching = false;

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) return;

      // Search for variants - using empty list for taxTyCds as it's not needed for search
      final variants = await ProxyService.strategy.variants(
        branchId: branchId,
        taxTyCds: [],
      );

      final filtered = variants
          .where((v) => v.name.toLowerCase().contains(query.toLowerCase()))
          .take(10)
          .toList();

      setState(() {
        _searchResults = filtered;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          decoration: const InputDecoration(
            labelText: 'Search Product',
            hintText: 'Enter product name...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: _performSearch,
        ),
        if (_isSearching)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (_searchResults.isNotEmpty && !_isSearching)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final variant = _searchResults[index];
                return ListTile(
                  dense: true,
                  title: Text(variant.name),
                  subtitle: Text('SKU: ${variant.sku ?? 'N/A'}'),
                  onTap: () {
                    widget.onProductSelected(variant);
                    setState(() {
                      _searchResults = [];
                    });
                    widget.controller.text = variant.name;
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class _RecountItemCard extends StatelessWidget {
  final StockRecountItem item;
  final bool isDraft;
  final VoidCallback onRemove;

  const _RecountItemCard({
    required this.item,
    required this.isDraft,
    required this.onRemove,
  });

  Color _getDifferenceColor() {
    final diff = item.difference;
    if (diff > 0) return Colors.green;
    if (diff < 0) return Colors.red;
    return Colors.grey;
  }

  IconData _getDifferenceIcon() {
    final diff = item.difference;
    if (diff > 0) return Icons.arrow_upward;
    if (diff < 0) return Icons.arrow_downward;
    return Icons.remove;
  }

  @override
  Widget build(BuildContext context) {
    final diff = item.difference;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isDraft)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onRemove,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(
                  label: 'Previous',
                  value: item.previousQuantity.toString(),
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                _InfoChip(
                  label: 'Counted',
                  value: item.countedQuantity.toString(),
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  label: 'Difference',
                  value: '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(0)}',
                  color: _getDifferenceColor(),
                  icon: _getDifferenceIcon(),
                ),
              ],
            ),
            if (item.notes != null && item.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                item.notes!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData? icon;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
