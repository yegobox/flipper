// ignore_for_file: unused_result

import 'package:flipper_dashboard/widgets/contact_picker_button.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/momo_ussd_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:synchronized/synchronized.dart';
import 'package:stacked_services/stacked_services.dart';

/// Tokens aligned with Cash Book redesign (mint, beige, primary green).
abstract final class _MomoUiColors {
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color mintAmountBg = Color(0xFFE8F8EF);
  static const Color beigeField = Color(0xFFF5F4EE);
  static const Color beigeInactive = Color(0xFFEDEADF);
  static const Color labelMuted = Color(0xFF6B7280);
  static const Color cashOutAccent = Color(0xFFFF0331);
}

/// Widget for creating MoMo/Airtel mobile money transactions in the cashbook.
class MomoTransactionForm extends ConsumerStatefulWidget {
  const MomoTransactionForm({
    Key? key,
    required this.transactionType,
    required this.coreViewModel,
    required this.onCancel,
    required this.onComplete,
  }) : super(key: key);

  /// Either [TransactionType.cashIn] or [TransactionType.cashOut].
  final String transactionType;

  /// Shared view model for category focus updates (matches cash entry form).
  final CoreViewModel coreViewModel;

  final VoidCallback onCancel;

  final VoidCallback onComplete;

  @override
  ConsumerState<MomoTransactionForm> createState() =>
      _MomoTransactionFormState();
}

class _MomoTransactionFormState extends ConsumerState<MomoTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _momoCodeController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lock = Lock();

  MomoPaymentType _paymentType = MomoPaymentType.phoneNumber;
  bool _isBusy = false;
  late final _ussdPreviewNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateUssdPreview);
    _phoneController.addListener(_updateUssdPreview);
    _momoCodeController.addListener(_updateUssdPreview);
    _updateUssdPreview();
  }

  void _updateUssdPreview() {
    _ussdPreviewNotifier.value = _amountController.text;
    setState(() {});
  }

  @override
  void dispose() {
    _amountController.removeListener(_updateUssdPreview);
    _phoneController.removeListener(_updateUssdPreview);
    _momoCodeController.removeListener(_updateUssdPreview);
    _phoneController.dispose();
    _momoCodeController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isIncome => widget.transactionType == TransactionType.cashIn;

  Color get _accentColor =>
      _isIncome ? _MomoUiColors.primaryGreen : _MomoUiColors.cashOutAccent;

  @override
  Widget build(BuildContext context) {
    final currency = ProxyService.box.defaultCurrency();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroBanner(context),
                    const SizedBox(height: 18),
                    _buildPaymentTypeSelector(),
                    const SizedBox(height: 18),
                    if (_paymentType == MomoPaymentType.phoneNumber)
                      _buildRecipientSection(context)
                    else
                      _buildMomoCodeSection(context),
                    const SizedBox(height: 18),
                    _buildAmountSection(context, currency),
                    const SizedBox(height: 18),
                    Text(
                      _isIncome ? 'CASH IN FOR' : 'CASH OUT FOR',
                      style: _captionLabelStyle(context),
                    ),
                    const SizedBox(height: 10),
                    _buildCategoryGrid(),
                    const SizedBox(height: 18),
                    Text(
                      'DESCRIPTION',
                      style: _captionLabelStyle(context),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText:
                            'Add any additional notes about this transaction...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: _MomoUiColors.beigeField,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _accentColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                      maxLines: 4,
                      minLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<String>(
                      valueListenable: _ussdPreviewNotifier,
                      builder: (context, _, __) {
                        return _amountController.text.isNotEmpty
                            ? _buildUssdPreview()
                            : const SizedBox.shrink();
                      },
                    ),
                    if (_amountController.text.isNotEmpty)
                      const SizedBox(height: 16),
                    _buildInfoBanner(context),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  TextStyle _captionLabelStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          letterSpacing: 1.1,
          fontWeight: FontWeight.w600,
          color: _MomoUiColors.labelMuted,
          fontSize: 11,
        );
  }

  Widget _buildHeroBanner(BuildContext context) {
    final bg = _accentColor.withValues(alpha: 0.12);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentColor.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.phone_android_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isIncome ? 'MoMo Cash In' : 'MoMo Cash Out',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _isIncome
                              ? const Color(0xFF166534)
                              : const Color(0xFFB91C1C),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isIncome
                        ? 'Receive money via MTN MoMo'
                        : 'Send money via MTN MoMo',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTypeSelector() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _MomoUiColors.beigeInactive,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: _paymentToggleChip(
                type: MomoPaymentType.phoneNumber,
                icon: Icons.phone_android_rounded,
                label: 'Phone Number',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _paymentToggleChip(
                type: MomoPaymentType.momoCode,
                icon: Icons.apps_rounded,
                label: 'MoMo Code',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentToggleChip({
    required MomoPaymentType type,
    required IconData icon,
    required String label,
  }) {
    final selected = _paymentType == type;
    final blue = Colors.blue.shade600;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() => _paymentType = type);
          HapticFeedback.lightImpact();
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? blue : Colors.transparent,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? blue : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                    color: selected ? blue : Colors.grey.shade700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipientSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RECIPIENT', style: _captionLabelStyle(context)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: 'MTN or Airtel number',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: _MomoUiColors.beigeField,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            prefixIcon:
                Icon(Icons.phone_outlined, color: Colors.grey.shade700),
            suffixIcon: ContactPickerButton(
              icon: Icons.person_add_alt_1_rounded,
              tooltip: 'Pick from contacts',
              onPhoneSelected: (phone) {
                setState(() => _phoneController.text = phone);
                HapticFeedback.lightImpact();
              },
            ),
            helperText: 'MTN or Airtel number',
            helperStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: _accentColor, width: 1.5),
            ),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-\+]')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a phone number';
            }
            if (!MomoUssdService.isValidPhoneNumber(value)) {
              return 'Please enter a valid Rwandan phone number (07x or 08x)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMomoCodeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PAYMENT CODE', style: _captionLabelStyle(context)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _momoCodeController,
          decoration: InputDecoration(
            hintText: 'Enter code from recipient',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: _MomoUiColors.beigeField,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            prefixIcon: Icon(Icons.apps_rounded, color: Colors.grey.shade700),
            helperText: 'Usually 6–10 digits',
            helperStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: _accentColor, width: 1.5),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a MoMo code';
            }
            if (!MomoUssdService.isValidMomoCode(value)) {
              return 'Code must be 6-10 digits';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAmountSection(BuildContext context, String currency) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _MomoUiColors.mintAmountBg,
            _MomoUiColors.mintAmountBg.withValues(alpha: 0.88),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _MomoUiColors.primaryGreen.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AMOUNT',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: _MomoUiColors.primaryGreen,
                    fontSize: 11,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    currency,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _MomoUiColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF166534),
                          letterSpacing: -0.5,
                        ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: '0',
                      hintStyle: TextStyle(color: Color(0x33166534)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid amount';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Amount must be greater than zero';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _isIncome
                    ? 'Enter the amount to receive'
                    : 'Enter the amount to send',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _MomoUiColors.primaryGreen.withValues(alpha: 0.95),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _amountChip('+500', () => _adjustAmount(500)),
                _amountChip('+1,000', () => _adjustAmount(1000)),
                _amountChip('+5,000', () => _adjustAmount(5000)),
                _amountChip('Clear', _clearAmount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _adjustAmount(double delta) {
    final text = _amountController.text.trim();
    final cur = double.tryParse(text) ?? 0;
    final next = cur + delta;
    final formatted = next == next.roundToDouble()
        ? next.toInt().toString()
        : next.toStringAsFixed(2);
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    _updateUssdPreview();
  }

  void _clearAmount() {
    _amountController.clear();
    _updateUssdPreview();
  }

  Widget _amountChip(String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF166534),
        side: BorderSide(
          color: _MomoUiColors.primaryGreen.withValues(alpha: 0.45),
        ),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label),
    );
  }

  List<Category> _sortedCategoriesForGrid(List<Category> all) {
    final active = all.where((c) => c.active ?? false).toList();
    active.sort((a, b) {
      final af = a.focused ? 0 : 1;
      final bf = b.focused ? 0 : 1;
      if (af != bf) return af.compareTo(bf);
      return (a.name ?? '').compareTo(b.name ?? '');
    });
    return active.take(3).toList();
  }

  String? _resolvedSelectedCategoryId(List<Category> categories) {
    final optimistic = ref.watch(optimisticFocusedCategoryProvider);
    if (optimistic != null && optimistic.id.isNotEmpty) {
      return optimistic.id;
    }
    try {
      final focused = categories.firstWhere(
        (c) => c.focused && (c.active ?? false),
      );
      return focused.id;
    } catch (_) {
      return null;
    }
  }

  IconData _categorySlotIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person_outline_rounded;
      case 1:
        return Icons.business_center_outlined;
      default:
        return Icons.schedule_outlined;
    }
  }

  Widget _buildCategoryGrid() {
    final categoriesAsync = ref.watch(categoryProvider);

    return categoriesAsync.when(
      data: (list) {
        final tiles = _sortedCategoriesForGrid(list);
        final selectedId = _resolvedSelectedCategoryId(list);

        return LayoutBuilder(
          builder: (context, constraints) {
            final spacing = 10.0;
            final cellWidth = (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                ...List.generate(tiles.length, (i) {
                  final c = tiles[i];
                  final sel = selectedId != null && selectedId == c.id;
                  return SizedBox(
                    width: cellWidth,
                    child: _categoryChoiceTile(
                      label: c.name ?? '',
                      icon: _categorySlotIcon(i),
                      selected: sel,
                      onTap: () => _onCategoryTap(c),
                    ),
                  );
                }),
                SizedBox(
                  width: cellWidth,
                  child: _addCategoryTile(onTap: _openCategoriesForTransaction),
                ),
              ],
            );
          },
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (e, _) => Text('Categories error: $e'),
    );
  }

  Widget _categoryChoiceTile({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: selected
                ? _MomoUiColors.mintAmountBg
                : _MomoUiColors.beigeInactive,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? _MomoUiColors.primaryGreen
                  : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color:
                    selected ? const Color(0xFF166534) : Colors.grey.shade700,
                size: 26,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color:
                      selected ? const Color(0xFF166534) : Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addCategoryTile({required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: CustomPaint(
          painter: _MomoDashedRoundedBorderPainter(
            color: Colors.grey.shade400,
            radius: 14,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.grey.shade600, size: 26),
                const SizedBox(height: 8),
                Text(
                  'Add new',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onCategoryTap(Category category) async {
    final ok =
        await widget.coreViewModel.updateCategoryCore(category: category);
    if (!mounted || !ok) return;
    ref.read(optimisticFocusedCategoryProvider.notifier).setFocused(category);
    ref.invalidate(categoryProvider);
    final bid = ProxyService.box.getBranchId();
    if (bid != null) {
      ref.invalidate(categoriesProvider(branchId: bid));
    }
    setState(() {});
  }

  Future<void> _openCategoriesForTransaction() async {
    final routerService = locator<RouterService>();
    await routerService.navigateTo(
      ListCategoriesRoute(modeOfOperation: 'transaction'),
    );
    if (!mounted) return;
    ref.invalidate(categoryProvider);
    final bid = ProxyService.box.getBranchId();
    if (bid != null) {
      ref.invalidate(categoriesProvider(branchId: bid));
    }
  }

  Widget _buildInfoBanner(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded,
                color: Colors.blue.shade700, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'The USSD code will be dialed automatically. Confirm the transaction on your phone.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final accent = _accentColor;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isBusy ? null : widget.onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade900,
              backgroundColor: _MomoUiColors.beigeField,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isBusy ? null : _handleDialAndSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _isBusy
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.phone_rounded, color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Dial & Save',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildUssdPreview() {
    String ussdCode = '';
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (amount > 0) {
      if (_paymentType == MomoPaymentType.phoneNumber &&
          _phoneController.text.isNotEmpty) {
        ussdCode = MomoUssdService.generatePhonePaymentCode(
          _phoneController.text,
          amount,
        );
      } else if (_paymentType == MomoPaymentType.momoCode &&
          _momoCodeController.text.isNotEmpty) {
        ussdCode = MomoUssdService.generateMomoCodePayment(
          _momoCodeController.text,
          amount,
        );
      }
    }

    if (ussdCode.isEmpty) return const SizedBox.shrink();

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFCC00).withValues(alpha: 0.12),
            const Color(0xFFFFCC00).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFCC00), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCC00),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.dialpad, size: 20, color: Colors.black87),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'USSD Code Preview',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  tooltip: 'Copy to clipboard',
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCC00).withValues(alpha: 0.25),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: ussdCode));
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('USSD code copied!'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SelectableText(
                  ussdCode,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDialAndSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isBusy = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final isIncome = _isIncome;

      final String branchId = ProxyService.box.getBranchId()!;
      final Category? category =
          await ProxyService.strategy.activeCategory(branchId: branchId);

      if (category == null) {
        if (mounted) {
          showWarningNotification(context, 'Please select a category first');
          setState(() => _isBusy = false);
        }
        return;
      }

      String ussdCode;
      String paymentDetails;

      if (_paymentType == MomoPaymentType.phoneNumber) {
        ussdCode = MomoUssdService.generatePhonePaymentCode(
          _phoneController.text,
          amount,
        );
        paymentDetails = 'Phone: ${_phoneController.text}';
      } else {
        ussdCode = MomoUssdService.generateMomoCodePayment(
          _momoCodeController.text,
          amount,
        );
        paymentDetails = 'MoMo Code: ${_momoCodeController.text}';
      }

      final dialSuccess = await MomoUssdService.dialUssdCode(ussdCode);

      if (!dialSuccess) {
        if (mounted) {
          showWarningNotification(
            context,
            'Could not open dialer. Please dial manually: $ussdCode',
          );
        }
      }

      final saved = await _saveTransaction(
        amount: amount,
        isIncome: isIncome,
        category: category,
        paymentDetails: paymentDetails,
        customerPhoneForCollect: _paymentType == MomoPaymentType.phoneNumber
            ? _phoneController.text.replaceAll(RegExp(r'[\s\-\+]'), '')
            : null,
      );

      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      final providerContainer = ProviderScope.containerOf(
        context,
        listen: false,
      );

      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 10),
          backgroundColor: Colors.green.shade700,
          content: const Text(
            'MoMo transaction saved as completed. It appears in Recent transactions.',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'Mark not completed',
            textColor: Colors.white,
            onPressed: () async {
              try {
                await ProxyService.strategy.updateTransaction(
                  transaction: saved,
                  status: WAITING,
                  subTotal: saved.subTotal ?? amount,
                );
                providerContainer.invalidate(cashbookRecentTransactionsProvider);
                providerContainer.invalidate(
                  transactionsScreenTransactionsProvider,
                );
                providerContainer.invalidate(dashboardTransactionsProvider);
                messenger.showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'Marked as not completed (removed from cash book recent list until completed again).',
                    ),
                  ),
                );
              } catch (e) {
                talker.error('Momo undo (mark not completed) failed: $e');
                messenger.showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red.shade700,
                    content: Text(
                      'Could not update: ${e.toString()}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      );

      widget.onComplete();
    } catch (e, s) {
      talker.error('MomoTransactionForm: Error in dial and save: $e');
      talker.error(s);
      if (mounted) {
        showErrorNotification(context, 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<ITransaction> _saveTransaction({
    required double amount,
    required bool isIncome,
    required Category category,
    required String paymentDetails,
    String? customerPhoneForCollect,
  }) async {
    return _lock.synchronized(() async {
      final String branchId = ProxyService.box.getBranchId()!;

      ITransaction? pendingTransaction = await ProxyService.strategy
          .manageTransaction(
            branchId: branchId,
            transactionType: widget.transactionType,
            isExpense: !isIncome,
          );

      if (pendingTransaction == null) {
        throw Exception('Failed to create transaction');
      }

      talker.info(
        'MomoTransactionForm: Created pending transaction: ${pendingTransaction.id}',
      );

      Variant? utilityVariant = await ProxyService.strategy.getUtilityVariant(
        name: widget.transactionType,
        branchId: branchId,
      );

      if (utilityVariant != null) {
        final today = DateTime.now();
        final dateStr =
            '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
        final itemCode =
            'MOMO-${widget.transactionType.toUpperCase()}-$dateStr';

        utilityVariant = Variant(
          id: utilityVariant.id,
          name: utilityVariant.name,
          color: utilityVariant.color,
          sku: utilityVariant.sku,
          productId: utilityVariant.productId,
          unit: utilityVariant.unit,
          productName: utilityVariant.productName,
          branchId: utilityVariant.branchId,
          taxName: utilityVariant.taxName,
          taxPercentage: utilityVariant.taxPercentage,
          retailPrice: amount,
          supplyPrice: utilityVariant.supplyPrice,
          lastTouched: utilityVariant.lastTouched,
          itemSeq: utilityVariant.itemSeq,
          isrccCd: utilityVariant.isrccCd,
          isrccNm: utilityVariant.isrccNm,
          isrcRt: utilityVariant.isrcRt,
          isrcAmt: utilityVariant.isrcAmt,
          taxTyCd: utilityVariant.taxTyCd,
          bcd: utilityVariant.bcd,
          itemClsCd: utilityVariant.itemClsCd,
          itemTyCd: utilityVariant.itemTyCd,
          itemStdNm: utilityVariant.itemStdNm,
          orgnNatCd: utilityVariant.orgnNatCd,
          pkg: utilityVariant.pkg,
          itemCd: itemCode,
          pkgUnitCd: utilityVariant.pkgUnitCd,
          qtyUnitCd: utilityVariant.qtyUnitCd,
          itemNm: utilityVariant.itemNm,
          qty: utilityVariant.qty,
          prc: utilityVariant.prc,
          splyAmt: utilityVariant.splyAmt,
          tin: utilityVariant.tin,
          bhfId: utilityVariant.bhfId,
          dftPrc: utilityVariant.dftPrc,
          addInfo: utilityVariant.addInfo,
          isrcAplcbYn: utilityVariant.isrcAplcbYn,
          useYn: utilityVariant.useYn,
          regrId: utilityVariant.regrId,
          regrNm: utilityVariant.regrNm,
          modrId: utilityVariant.modrId,
          modrNm: utilityVariant.modrNm,
          rsdQty: utilityVariant.rsdQty,
          dcRt: utilityVariant.dcRt,
          dcAmt: utilityVariant.dcAmt,
          stock: utilityVariant.stock,
          ebmSynced: utilityVariant.ebmSynced,
          taxAmt: utilityVariant.taxAmt,
        );

        await ProxyService.strategy.saveTransactionItem(
          variation: utilityVariant,
          amountTotal: amount,
          customItem: true,
          pendingTransaction: pendingTransaction,
          currentStock: 0,
          partOfComposite: false,
          doneWithTransaction: true,
          ignoreForReport: false,
        );
      }

      final note = _descriptionController.text.isNotEmpty
          ? '${_descriptionController.text}\n$paymentDetails'
          : paymentDetails;

      final phoneForCollect =
          (customerPhoneForCollect != null &&
                  customerPhoneForCollect.isNotEmpty)
              ? customerPhoneForCollect
              : null;

      ITransaction updatedTransaction =
          await ProxyService.strategy.collectPayment(
        cashReceived: amount,
        countryCode: 'RW',
        branchId: branchId,
        bhfId: (await ProxyService.box.bhfId()) ?? '00',
        isProformaMode: false,
        isTrainingMode: ProxyService.box.isTrainingMode(),
        transaction: pendingTransaction,
        paymentType: 'MTN MOMO',
        discount: 0,
        transactionType: category.name ?? widget.transactionType,
        directlyHandleReceipt: false,
        isIncome: isIncome,
        categoryId: category.id.toString(),
        note: note,
        completionStatus: COMPLETE,
        customerPhone: phoneForCollect,
      );

      final movementReceipt =
          isIncome ? TransactionType.cashIn : TransactionType.cashOut;
      await ProxyService.strategy.updateTransaction(
        transaction: updatedTransaction,
        receiptType: movementReceipt,
        updatedAt: DateTime.now(),
        lastTouched: DateTime.now(),
      );
      updatedTransaction.receiptType = movementReceipt;

      talker.info(
        'MomoTransactionForm: Transaction saved as COMPLETE (immediate cash book)',
      );

      ref.refresh(
        transactionItemsProvider(transactionId: pendingTransaction.id),
      );
      ref.refresh(pendingTransactionStreamProvider(isExpense: !isIncome));
      ref.refresh(dashboardTransactionsProvider);
      ref.invalidate(cashbookRecentTransactionsProvider);
      ref.invalidate(transactionsScreenTransactionsProvider);

      return updatedTransaction;
    });
  }
}

final class _MomoDashedRoundedBorderPainter extends CustomPainter {
  _MomoDashedRoundedBorderPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const dashLen = 5.0;
    const gap = 4.0;
    for (final metric in path.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        final next = (dist + dashLen).clamp(0.0, metric.length);
        final extract = metric.extractPath(dist, next);
        canvas.drawPath(extract, paint);
        dist = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MomoDashedRoundedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
