// ignore_for_file: unused_result
import 'package:flipper_dashboard/create/category_selector.dart';
import 'package:flipper_dashboard/widgets/contact_picker_button.dart';
import 'package:flipper_models/db_model_export.dart' hide Category;
import 'package:supabase_models/brick/models/category.model.dart' show Category;
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
// import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/momo_ussd_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:synchronized/synchronized.dart';

/// Widget for creating MoMo/Airtel mobile money transactions in the cashbook
class MomoTransactionForm extends ConsumerStatefulWidget {
  /// The transaction type: either 'Cash In' or 'Cash Out'
  final String transactionType;

  /// Callback when the user cancels the form
  final VoidCallback onCancel;

  /// Callback when the transaction is completed (dialed and saved)
  final VoidCallback onComplete;

  const MomoTransactionForm({
    Key? key,
    required this.transactionType,
    required this.onCancel,
    required this.onComplete,
  }) : super(key: key);

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
    _updateUssdPreview(); // Initialize the notifier
  }

  void _updateUssdPreview() {
    _ussdPreviewNotifier.value = _amountController
        .text; // Use amount text as the value to trigger updates
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = _isIncome;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with Icon and Title
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (isIncome ? Colors.green : const Color(0xFFFF0331))
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isIncome
                            ? Colors.green
                            : const Color(0xFFFF0331),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.phone_android,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isIncome ? 'MoMo Cash In' : 'MoMo Cash Out',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: isIncome
                                      ? Colors.green
                                      : const Color(0xFFFF0331),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isIncome
                                ? 'Receive money via MTN MoMo'
                                : 'Send money via MTN MoMo',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment Type Selector
              _buildPaymentTypeSelector(),
              const SizedBox(height: 20),

              // Phone Number or MoMo Code Input
              if (_paymentType == MomoPaymentType.phoneNumber)
                _buildPhoneNumberField()
              else
                _buildMomoCodeField(),
              const SizedBox(height: 20),

              // Amount field
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '${ProxyService.box.defaultCurrency()} ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  prefixIcon: const Icon(Icons.attach_money),
                  helperText:
                      'Enter the amount to ${isIncome ? "receive" : "send"}',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // Category selector
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isIncome ? 'Cash in for' : 'Cash out for',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Select category',
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                      ],
                    ),
                    const CategorySelector.transactionMode(),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  prefixIcon: const Icon(Icons.notes),
                  helperText: 'Add any additional notes about this transaction',
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 20),

              // USSD Preview (for user reference)
              ValueListenableBuilder<String>(
                valueListenable: _ussdPreviewNotifier,
                builder: (context, _, __) {
                  return _amountController.text.isNotEmpty
                      ? _buildUssdPreview()
                      : const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),

              // Info banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The USSD code will be dialed automatically. Confirm the transaction on your phone.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isBusy ? null : widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: colorScheme.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isBusy ? null : _handleDialAndSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isIncome
                            ? Colors.green
                            : const Color(0xFFFF0331),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _isBusy
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.phone, size: 22),
                      label: Text(
                        _isBusy ? 'Processing...' : 'Dial & Save',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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

  Widget _buildPaymentTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildPaymentTypeButton(
              type: MomoPaymentType.phoneNumber,
              icon: Icons.phone,
              label: 'Phone Number',
            ),
          ),
          Expanded(
            child: _buildPaymentTypeButton(
              type: MomoPaymentType.momoCode,
              icon: Icons.qr_code,
              label: 'MoMo Code',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTypeButton({
    required MomoPaymentType type,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _paymentType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _paymentType = type;
        });
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Recipient Phone Number',
        hintText: '0788 123 456',
        helperText: 'MTN or Airtel number',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: const Icon(Icons.phone),
        suffixIcon: ContactPickerButton(
          onPhoneSelected: (phone) {
            setState(() {
              _phoneController.text = phone;
            });
            HapticFeedback.lightImpact();
          },
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
    );
  }

  Widget _buildMomoCodeField() {
    return TextFormField(
      controller: _momoCodeController,
      decoration: InputDecoration(
        labelText: 'MoMo Payment Code',
        hintText: 'Enter code from recipient',
        helperText: 'Usually 6-10 digits',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: const Icon(Icons.qr_code),
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFCC00).withValues(alpha: 0.1),
            const Color(0xFFFFCC00).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCC00), width: 1.5),
      ),
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
                child: const Icon(
                  Icons.dialpad,
                  size: 20,
                  color: Colors.black87,
                ),
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
                  backgroundColor: const Color(
                    0xFFFFCC00,
                  ).withValues(alpha: 0.2),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              ussdCode,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
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

      // Validate category selection
      final String branchId = ProxyService.box.getBranchId()!;
      final Category? category = await ProxyService.strategy.activeCategory(
        branchId: branchId,
      );

      if (category == null) {
        if (mounted) {
          showWarningNotification(context, 'Please select a category first');
          setState(() => _isBusy = false);
        }
        return;
      }

      // Generate USSD code
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

      // Try to dial the USSD code
      final dialSuccess = await MomoUssdService.dialUssdCode(ussdCode);

      if (!dialSuccess) {
        // Show the code for manual dialing if automatic dial fails
        if (mounted) {
          showWarningNotification(
            context,
            'Could not open dialer. Please dial manually: $ussdCode',
          );
        }
      }

      // Save the transaction regardless of dial success
      await _saveTransaction(
        amount: amount,
        isIncome: isIncome,
        category: category,
        paymentDetails: paymentDetails,
      );

      if (mounted) {
        showSuccessNotification(
          context,
          'MoMo transaction saved. Please confirm manually after completion.',
        );
        widget.onComplete();
      }
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

  Future<void> _saveTransaction({
    required double amount,
    required bool isIncome,
    required Category category,
    required String paymentDetails,
  }) async {
    await _lock.synchronized(() async {
      final String branchId = ProxyService.box.getBranchId()!;

      // Create the transaction
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

      // Get utility variant for the transaction
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

      // Combine payment details with description
      final note = _descriptionController.text.isNotEmpty
          ? '${_descriptionController.text}\n$paymentDetails'
          : paymentDetails;

      // Collect payment and mark as waiting for MoMo completion
      ITransaction updatedTransaction = await ProxyService.strategy
          .collectPayment(
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
          );

      // Mark transaction with special MoMo waiting status
      await ProxyService.strategy.updateTransaction(
        transaction: updatedTransaction,
        status: WAITING_MOMO_COMPLETE,
        subTotal: amount,
      );

      talker.info(
        'MomoTransactionForm: Transaction saved with WAITING_MOMO_COMPLETE status',
      );

      // Refresh providers
      ref.refresh(
        transactionItemsProvider(transactionId: pendingTransaction.id),
      );
      ref.refresh(pendingTransactionStreamProvider(isExpense: !isIncome));
      ref.refresh(dashboardTransactionsProvider);
    });
  }
}
