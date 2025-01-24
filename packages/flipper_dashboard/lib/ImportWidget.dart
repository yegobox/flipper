import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:flipper_models/providers/variants_provider.dart';

class ImportSalesWidget extends StatefulHookConsumerWidget {
  final Future<List<Variant>>? futureResponse;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function() saveItemName;
  final void Function() acceptAllImport;
  final void Function(Variant? selectedItem) selectItem;
  final Variant? selectedItem;
  final List<Variant> finalItemList;

  const ImportSalesWidget({
    super.key,
    required this.futureResponse,
    required this.formKey,
    required this.nameController,
    required this.supplyPriceController,
    required this.retailPriceController,
    required this.saveItemName,
    required this.acceptAllImport,
    required this.selectItem,
    required this.selectedItem,
    required this.finalItemList,
  });

  @override
  ImportSalesWidgetState createState() => ImportSalesWidgetState();
}

class ImportSalesWidgetState extends ConsumerState<ImportSalesWidget> {
  bool _isLoading = false;
  Map<String, TextEditingController> _searchControllers = {};
  Map<String, bool> _showSearchResults = {};

  // Add map to store original names
  Map<String, String> _originalNames = {};

  Future<void> _handleApproval(Variant item) async {
    setState(() => _isLoading = true);
    try {
      // Implement your approval logic here
      item.imptItemSttsCd = "3";

      item.ebmSynced = false;

      final URI = await ProxyService.box.getServerUrl();

      /// update this single item modfied
      await VariantPatch.patchVariant(
        URI: URI!,
        identifier: item.id,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
      );
      await StockPatch.patchStock(
        identifier: item.id,
        URI: URI,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
      );
      await ProxyService.tax.updateImportItems(
          item: item, URI: await ProxyService.box.getServerUrl() ?? "");
      item.ebmSynced = true;
      ProxyService.strategy.updateVariant(updatables: [item]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error approving item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRejection(Variant item) async {
    setState(() => _isLoading = true);
    try {
      // Implement your rejection logic here
      await Future.delayed(const Duration(seconds: 1)); // Simulated API call
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item rejected successfully'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateVariant(Variant originalItem, Variant selectedVariant) {
    setState(() {
      final index = widget.finalItemList.indexOf(originalItem);
      if (index != -1) {
        widget.finalItemList[index] = selectedVariant.copyWith(
          imptItemSttsCd: originalItem.imptItemSttsCd,
          stock: originalItem.stock,
        );
      }
      _showSearchResults[originalItem.id] = false;
      _searchControllers[originalItem.id]?.text = selectedVariant.name;
    });
  }

  Widget _buildSearchResults(String itemId, int branchId, double width) {
    return Consumer(
      builder: (context, ref, child) {
        final searchQuery = _searchControllers[itemId]?.text ?? '';
        final variantSearch = ref.watch(variantProvider(
          transactionId: itemId,
          branchId: branchId,
          key: searchQuery,
        ));

        return variantSearch.when(
          data: (variants) => variants.isEmpty
              ? const SizedBox.shrink()
              : Material(
                  // Add Material widget for proper elevation
                  elevation: 8,
                  child: Container(
                    width: width,
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: variants.length,
                      itemBuilder: (context, index) {
                        final variant = variants[index];
                        return ListTile(
                          title: Text(variant.name),
                          subtitle: Text(variant.hsCd?.toString() ?? ''),
                          onTap: () {
                            final originalItem =
                                widget.finalItemList.firstWhere(
                              (item) => item.id == itemId,
                            );
                            _updateVariant(originalItem, variant);
                          },
                        );
                      },
                    ),
                  ),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Error: $error'),
        );
      },
    );
  }

  Widget _buildVariantSearchCell(Variant item, double width) {
    // Store original name when creating the controller
    _searchControllers.putIfAbsent(
      item.id,
      () {
        _originalNames[item.id] = item.itemNm ?? item.name;
        return TextEditingController(text: item.itemNm ?? item.name);
      },
    );

    return Stack(
      clipBehavior: Clip.none, // Allow search results to overflow
      children: [
        TextFormField(
          controller: _searchControllers[item.id],
          decoration: InputDecoration(
            hintText: 'Search variants...',
            suffixIcon: IconButton(
              icon: Icon(
                _showSearchResults[item.id] == true
                    ? Icons.close
                    : Icons.search,
              ),
              onPressed: () {
                setState(() {
                  if (_showSearchResults[item.id] == true) {
                    // Restore original name when closing search
                    _searchControllers[item.id]?.text =
                        _originalNames[item.id] ?? '';
                    _showSearchResults[item.id] = false;
                  } else {
                    _showSearchResults[item.id] = true;
                  }
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _showSearchResults[item.id] = value.isNotEmpty;
            });
          },
        ),
        if (_showSearchResults[item.id] == true)
          Positioned(
            top: 48, // Adjust to position right below the input
            left: 0,
            right: 0, // Add right constraint
            child: _buildSearchResults(item.id, item.branchId!, width),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<Variant>>(
            future: widget.futureResponse,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      Text('No Data.'),
                    ],
                  ),
                );
              }

              final itemList = snapshot.data ?? [];
              widget.finalItemList
                ..clear()
                ..addAll(itemList);

              return SizedBox(
                width: constraints.maxWidth,
                child: Form(
                  key: widget.formKey,
                  child: Column(
                    children: [
                      _buildInputRow(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildDataTable(itemList, constraints.maxWidth),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildInputRow() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: widget.nameController,
                hintText: 'Enter a name',
                prefixIcon: Icons.inventory,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: widget.supplyPriceController,
                hintText: 'Enter supply price',
                prefixIcon: Icons.attach_money,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Supply price is required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: widget.retailPriceController,
                hintText: 'Enter retail price',
                prefixIcon: Icons.point_of_sale,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Retail price is required' : null,
              ),
            ),
            const SizedBox(width: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : widget.saveItemName,
          icon: const Icon(Icons.save),
          label: const Text('Save Changes'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : widget.acceptAllImport,
          icon: const Icon(Icons.done_all),
          label: const Text('Accept All'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable(List<Variant> itemList, double availableWidth) {
    // Calculate column widths based on available width
    final itemNameWidth = availableWidth * 0.25; // 25% of width
    final hsCodeWidth = availableWidth * 0.15; // 15% of width
    final quantityWidth = availableWidth * 0.15; // 15% of width
    final statusWidth = availableWidth * 0.25; // 25% of width
    final actionsWidth = availableWidth * 0.20; // 20% of width
    //print("Items Length:${itemList.length}");

    return Card(
      elevation: 2,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 200),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              columnSpacing: 24.0,
              headingRowHeight: 56.0,
              dataRowHeight: 52.0,
              horizontalMargin: 16.0,
              columns: [
                DataColumn(
                  label: SizedBox(
                    width: itemNameWidth,
                    child: const Text(
                      'Item Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: hsCodeWidth,
                    child: const Text(
                      'HS Code',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: quantityWidth,
                    child: const Text(
                      'Quantity',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: statusWidth,
                    child: const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: actionsWidth,
                    child: const Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              rows: List<DataRow>.generate(
                itemList.length,
                (index) {
                  final item = itemList[index];
                  final isWaitingApproval = item.imptItemSttsCd == "2";

                  return DataRow(
                    selected: item == widget.selectedItem,
                    onSelectChanged: _isLoading
                        ? null
                        : (selected) =>
                            widget.selectItem(selected == true ? item : null),
                    color: isWaitingApproval
                        ? WidgetStateProperty.all(Colors.orange.shade50)
                        : null,
                    cells: [
                      DataCell(
                        SizedBox(
                          width: itemNameWidth,
                          child: _buildVariantSearchCell(item, itemNameWidth),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: hsCodeWidth,
                          child: Text(item.hsCd?.toString() ?? ''),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: quantityWidth,
                          child:
                              Text('${item.stock!.rsdQty} ${item.qtyUnitCd}'),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: statusWidth,
                          child: isWaitingApproval
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Waiting Approval',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : const Text('Processed'),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: actionsWidth,
                          child: isWaitingApproval
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : () => _handleApproval(item),
                                      tooltip: 'Approve',
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(8),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.red,
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : () => _handleRejection(item),
                                      tooltip: 'Reject',
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(8),
                                    ),
                                  ],
                                )
                              : const Text('-'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
