import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_services/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/providers/ebm_provider.dart';

class _RoomModalPalette {
  static const Color teal = Color(0xFF10B981);
  static const Color tealSoft = Color(0xFFD1FAE5);
  static const Color title = Color(0xFF0F172A);
  static const Color muted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color handle = Color(0xFFE2E8F0);
  static const Color rwfBadgeBg = Color(0xFFF1F5F9);
}

class AddRoomDialog extends StatefulHookConsumerWidget {
  final Function(Map<String, dynamic>) onRoomAdded;

  const AddRoomDialog({super.key, required this.onRoomAdded});

  @override
  _AddRoomDialogState createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends ConsumerState<AddRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  final _priceController = TextEditingController();

  final Map<String, String> _roomTypes = {
    'Single': '01',
    'Double': '02',
    'Suite': '03',
    'Deluxe': '04',
  };

  String? _selectedRoomType;
  bool _isExempted = false;
  String? _selectedTaxCode;

  static const double _modalRadius = 32;

  @override
  void dispose() {
    _roomNumberController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  List<String> _taxCodesFor(bool vatEnabled) =>
      vatEnabled ? ['A', 'B', 'C'] : ['D'];

  String _effectiveTaxCode(bool vatEnabled) {
    final codes = _taxCodesFor(vatEnabled);
    if (_selectedTaxCode != null && codes.contains(_selectedTaxCode)) {
      return _selectedTaxCode!;
    }
    return vatEnabled ? 'B' : 'D';
  }

  InputDecoration _fieldDecoration({
    required String label,
    String? hint,
    Color? enabledBorderColor,
    Widget? suffix,
  }) {
    final borderColor = enabledBorderColor ?? _RoomModalPalette.border;
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor, width: enabledBorderColor != null ? 1.5 : 1),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: _RoomModalPalette.muted,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      label: _uppercaseLabel(label),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      border: baseBorder,
      enabledBorder: baseBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _RoomModalPalette.teal, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade600),
      ),
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(minHeight: 36, minWidth: 36),
    );
  }

  Widget _uppercaseLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: _RoomModalPalette.muted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vatEnabledAsync = ref.watch(ebmVatEnabledProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Material(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_modalRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDragHandle(),
                  const SizedBox(height: 8),
                  _buildHeader(context),
                  const SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildRoomNumberField(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: _buildRoomTypeDropdown(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPriceField(),
                  const SizedBox(height: 16),
                  vatEnabledAsync.when(
                    data: (vatEnabled) => _buildTaxCodeDropdown(vatEnabled),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  vatEnabledAsync.when(
                    data: (vatEnabled) => vatEnabled
                        ? Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildTaxExemptCard(),
                            ],
                          )
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 22),
                  _buildPrimaryButton(),
                  const SizedBox(height: 8),
                  _buildCancelButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: _RoomModalPalette.handle,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _RoomModalPalette.tealSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.apartment_rounded,
            color: _RoomModalPalette.teal,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Room',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _RoomModalPalette.title,
                      letterSpacing: -0.2,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hotel & accommodation',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _RoomModalPalette.muted,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoomNumberField() {
    return TextFormField(
      controller: _roomNumberController,
      validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
      style: const TextStyle(
        color: _RoomModalPalette.title,
        fontWeight: FontWeight.w600,
      ),
      decoration: _fieldDecoration(
        label: 'Room No.',
        hint: '101',
        enabledBorderColor: _RoomModalPalette.teal,
      ),
    );
  }

  Widget _buildRoomTypeDropdown() {
    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: _selectedRoomType,
      decoration: _fieldDecoration(label: 'Room Type'),
      hint: const Text(
        'Select',
        style: TextStyle(
          color: _RoomModalPalette.muted,
          fontWeight: FontWeight.w500,
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _RoomModalPalette.muted),
      items: _roomTypes.keys.map((String roomType) {
        return DropdownMenuItem<String>(value: roomType, child: Text(roomType));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedRoomType = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a room type' : null,
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
      style: const TextStyle(
        color: _RoomModalPalette.title,
        fontWeight: FontWeight.w600,
      ),
      decoration: _fieldDecoration(
        label: 'Price Per Night',
        hint: 'RWF 0.00',
      ).copyWith(
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Center(
            widthFactor: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _RoomModalPalette.rwfBadgeBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'RWF',
                style: TextStyle(
                  color: _RoomModalPalette.muted,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaxCodeDropdown(bool vatEnabled) {
    final taxCodes = _taxCodesFor(vatEnabled);
    final effective = _effectiveTaxCode(vatEnabled);

    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: effective,
      decoration: _fieldDecoration(label: 'Tax Code'),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _RoomModalPalette.muted),
      items: taxCodes.map((String code) {
        final label = _taxCodeLabel(code);
        return DropdownMenuItem<String>(value: code, child: Text(label));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedTaxCode = newValue;
          _isExempted = (newValue == 'A');
        });
      },
      validator: (value) => value == null ? 'Please select a tax code' : null,
    );
  }

  String _taxCodeLabel(String code) {
    switch (code) {
      case 'A':
        return 'A – Exempt';
      case 'B':
        return 'B – Standard Rate';
      case 'C':
        return 'C – Reduced Rate';
      case 'D':
        return 'D – Non-VAT';
      default:
        return code;
    }
  }

  Widget _buildTaxExemptCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _RoomModalPalette.border),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tax Exempt',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _RoomModalPalette.title,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Exempt this room from VAT',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _RoomModalPalette.muted,
                        height: 1.35,
                      ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _isExempted,
            activeThumbColor: _RoomModalPalette.teal,
            activeTrackColor: _RoomModalPalette.tealSoft,
            onChanged: (bool value) {
              setState(() {
                _isExempted = value;
                if (_isExempted) {
                  _selectedTaxCode = 'A';
                } else {
                  _selectedTaxCode = 'B';
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton() {
    final isLoading = ref.watch(loadingProvider);
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isLoading.isLoading ? null : _handleSave,
        style: FilledButton.styleFrom(
          backgroundColor: _RoomModalPalette.teal,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _RoomModalPalette.teal.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: isLoading.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text('Add Room'),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: ref.watch(loadingProvider).isLoading
            ? null
            : () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          foregroundColor: _RoomModalPalette.muted,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          'Cancel',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: _RoomModalPalette.muted,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        ref.read(loadingProvider.notifier).startLoading();

        final vatEnabled = ref.read(ebmVatEnabledProvider).maybeWhen(
              data: (v) => v,
              orElse: () => false,
            );
        final taxCode = _effectiveTaxCode(vatEnabled);

        final model = ScannViewModel();
        Product? product = await model.createProduct(
          name: TEMP_PRODUCT,
          createItemCode: false,
        );

        if (product != null) {
          ref.read(unsavedProductProvider.notifier).emitProduct(value: product);

          model.setProductName(name: _roomNumberController.text);

          String stockId = const Uuid().v4();
          Stock roomStock = Stock(
            id: stockId,
            lastTouched: DateTime.now().toUtc(),
            rsdQty: 0.0,
            initialStock: 0.0,
            branchId: ProxyService.box.getBranchId()!,
            currentStock: 0.0,
          );

          Variant roomVariant = Variant(
            branchId: ProxyService.box.getBranchId()!,
            name: _roomNumberController.text,
            retailPrice: double.tryParse(_priceController.text) ?? 0.0,
            supplyPrice: double.tryParse(_priceController.text) ?? 0.0,
            propertyTyCd: "01",
            roomTypeCd: _roomTypes[_selectedRoomType] ?? "03",
            ttCatCd: "TT",
            itemTyCd: "3",
            taxTyCd: taxCode,
            taxName: "TT",
            taxPercentage: 3.0,
            qty: 0.0,
            stock: roomStock,
            stockId: stockId,
          );

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
            selectedProductType: "3",
            packagingUnit: "NT",
            categoryId: null,
            roomTypeCd: _roomTypes[_selectedRoomType] ?? "03",
            propertyTyCd: "01",
            ttCatCd: "TT",
            onCompleteCallback: (List<Variant> variants) async {},
          );

          await model.saveProduct(
            mproduct: product,
            color: "#FF0000",
            inUpdateProcess: false,
            productName: _roomNumberController.text,
          );

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
