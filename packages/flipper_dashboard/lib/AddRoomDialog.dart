import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_services/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_services/proxy.dart';

class AddRoomDialog extends StatefulHookConsumerWidget {
  final Function(Map<String, dynamic>) onRoomAdded;

  const AddRoomDialog({
    super.key,
    required this.onRoomAdded,
  });

  @override
  _AddRoomDialogState createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends ConsumerState<AddRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  final _priceController = TextEditingController();

  // Room type mapping
  final Map<String, String> _roomTypes = {
    'Single': '01',
    'Double': '02',
    'Suite': '03',
    'Deluxe': '04',
  };

  String? _selectedRoomType;

  @override
  void dispose() {
    _roomNumberController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _roomNumberController,
                label: 'Room Number',
                hint: 'Enter room number',
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildRoomTypeDropdown(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                label: 'Price per Night',
                hint: 'Enter price',
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.hotel,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Add Room',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildRoomTypeDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedRoomType,
      decoration: InputDecoration(
        labelText: 'Room Type',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      items: _roomTypes.keys.map((String roomType) {
        return DropdownMenuItem<String>(
          value: roomType,
          child: Text(roomType),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedRoomType = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a room type' : null,
    );
  }

  Widget _buildButtons() {
    final isLoading = ref.watch(loadingProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed:
              isLoading.isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: isLoading.isLoading ? null : _handleSave,
          child: isLoading.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add Room'),
        ),
      ],
    );
  }

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        ref.read(loadingProvider.notifier).startLoading();

        // Create temp product like DesktopProductAdd
        final model = ScannViewModel();
        Product? product = await model.createProduct(
          name: TEMP_PRODUCT,
          createItemCode: false,
        );

        if (product != null) {
          ref.read(unsavedProductProvider.notifier).emitProduct(value: product);

          // Set product name
          model.setProductName(name: _roomNumberController.text);

          // Create stock for the room variant
          String stockId = const Uuid().v4();
          Stock roomStock = Stock(
            id: stockId,
            lastTouched: DateTime.now().toUtc(),
            rsdQty: 0.0,
            initialStock: 0.0,
            branchId: ProxyService.box.getBranchId(),
            currentStock: 0.0,
          );

          // Create a room variant first
          Variant roomVariant = Variant(
            name: _roomNumberController.text,
            retailPrice: double.tryParse(_priceController.text) ?? 0.0,
            supplyPrice: double.tryParse(_priceController.text) ?? 0.0,
            propertyTyCd: "01",
            roomTypeCd: _roomTypes[_selectedRoomType] ?? "03",
            ttCatCd: "TT",
            itemTyCd: "3", // Service type
            taxTyCd: "TT", // Tax type code
            taxName: "TT", // Tax name
            taxPercentage: 3.0,
            qty: 0.0,
            stock: roomStock,
            stockId: stockId,
          );

          // Add variant using model.addVariant like DesktopProductAdd
          await model.addVariant(
            model: model,
            productName: _roomNumberController.text,
            countryofOrigin: "RW",
            rates: {"TT": TextEditingController(text: "3.0")},
            color: "#FF0000",
            dates: {},
            retailPrice: double.tryParse(_priceController.text) ?? 0.0,
            supplyPrice: double.tryParse(_priceController.text) ?? 0.0,
            variations: [roomVariant],
            product: product,
            selectedProductType: "3", // Service type
            packagingUnit: "NT",
            categoryId: null,
            roomTypeCd: _roomTypes[_selectedRoomType] ?? "03",
            propertyTyCd: "01",
            ttCatCd: "TT",
            onCompleteCallback: (List<Variant> variants) async {
              // Update room-specific fields after variant is saved
            },
          );

          // Save product like DesktopProductAdd
          await model.saveProduct(
            mproduct: product,
            color: "#FF0000",
            inUpdateProcess: false,
            productName: _roomNumberController.text,
          );

          // Refresh providers
          final combinedNotifier = ref.read(refreshProvider);
          combinedNotifier.performActions(productName: "", scanMode: true);
        }

        ref.read(loadingProvider.notifier).stopLoading();
        Navigator.of(context).pop();
        toast('Room added successfully');

        final roomData = {
          'roomNumber': _roomNumberController.text,
          'roomType': _selectedRoomType ?? '',
          'price': double.tryParse(_priceController.text) ?? 0.0,
        };
        widget.onRoomAdded(roomData);
      } catch (e) {
        ref.read(loadingProvider.notifier).stopLoading();
        toast('Error adding room: ${e.toString()}');
      }
    }
  }
}
