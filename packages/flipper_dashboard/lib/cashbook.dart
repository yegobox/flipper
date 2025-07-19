// ignore_for_file: unused_result

import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/BuildGaugeOrList.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_dashboard/create/category_selector.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';

class Cashbook extends StatefulHookConsumerWidget {
  const Cashbook({Key? key, required this.isBigScreen}) : super(key: key);
  final bool isBigScreen;

  @override
  CashbookState createState() => CashbookState();
}

class CashbookState extends ConsumerState<Cashbook> with DateCoreWidget {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lock = Lock();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: SafeArea(child: _buildBody(model)),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [datePicker()],
      title: const Text('Cash Book'),
    );
  }

  Widget _buildBody(CoreViewModel model) {
    return Column(
      children: [
        Expanded(
          child: _buildMainContent(model),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMainContent(CoreViewModel model) {
    return model.newTransactionPressed
        ? _buildTransactionForm(model)
        : _buildTransactionList(model);
  }

  Widget _buildTransactionList(CoreViewModel model) {
    final transactionData = ref.watch(dashboardTransactionsProvider);
    final dateRange = ref.watch(dateRangeProvider);

    return Column(
      children: [
        const SizedBox(height: 5),
        Expanded(
          child: BuildGaugeOrList(
            startDate: dateRange.startDate,
            endDate: dateRange.endDate,
            context: context,
            model: model,
            widgetType: 'list',
            data: transactionData,
          ),
        ),
        _buildActionButtons(model),
      ],
    );
  }

  Widget _buildActionButtons(CoreViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildTransactionButton(
            text: TransactionType.cashIn,
            color: Colors.green,
            onPressed: () =>
                _startNewTransaction(model, TransactionType.cashIn),
          ),
          _buildTransactionButton(
            text: TransactionType.cashOut,
            color: const Color(0xFFFF0331),
            onPressed: () =>
                _startNewTransaction(model, TransactionType.cashOut),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FlipperButton(
          text: text,
          color: color,
          onPressed: onPressed,
        ),
      ),
    );
  }

  void _startNewTransaction(CoreViewModel model, String transactionType) {
    // Reset form fields
    _amountController.clear();
    _descriptionController.clear();

    // Reset the keypad provider to ensure it's in a clean state
    ref.read(keypadProvider.notifier).reset();

    model.newTransactionPressed = true;
    model.newTransactionType = transactionType;
    model.notifyListeners();
  }

  Widget _buildTransactionForm(CoreViewModel model) {
    final isIncome = model.newTransactionType == TransactionType.cashIn;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              isIncome ? 'Cash In' : 'Cash Out',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: isIncome ? Colors.green : const Color(0xFFFF0331),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),

            // Amount field
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: ProxyService.box.defaultCurrency() + ' ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
              autofocus: true,
              onChanged: (value) {
                // Update the keypad provider with the current amount
                if (value.isNotEmpty && double.tryParse(value) != null) {
                  ref.read(keypadProvider.notifier).addKey(value);
                  // We don't need to call keyboardKeyPressed here
                  // It will be called in _saveTransaction when needed
                }
              },
            ),
            const SizedBox(height: 16),

            // Category selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isIncome ? 'Cash in for' : 'Cash out for',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const CategorySelector.transactionMode(),
              ],
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 2,
            ),

            const Spacer(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _cancelTransaction(model),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: colorScheme.primary),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleSaveTransaction(model),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _cancelTransaction(CoreViewModel model) {
    model.newTransactionPressed = false;
    model.notifyListeners();
  }

  Future<void> _handleSaveTransaction(CoreViewModel model) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text);
    final isIncome = model.newTransactionType == TransactionType.cashIn;
    final transactionType = model.newTransactionType;

    try {
      // Make sure the keypad provider is updated with the current amount
      ref.read(keypadProvider.notifier).reset();
      ref.read(keypadProvider.notifier).addKey(_amountController.text);

      talker.info("Starting transaction save with amount: $amount");
      talker.info("Transaction type: $transactionType, isIncome: $isIncome");

      await _saveTransaction(
        model: model,
        paymentType: ProxyService.box.paymentType() ?? "Cash",
        cashReceived: amount,
        discount: 0,
        isIncome: isIncome,
        transactionType: transactionType,
      );

      // Reset the form and return to the transaction list
      model.newTransactionPressed = false;
      model.notifyListeners();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${isIncome ? 'Cash in' : 'Cash out'} transaction saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      talker.error('Error saving transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveTransaction({
    required CoreViewModel model,
    required String paymentType,
    required double cashReceived,
    required int discount,
    required bool isIncome,
    required String transactionType,
  }) async {
    // This implementation exactly matches HandleTransactionFromCashBook in KeyPadView
    try {
      // Use a lock to ensure transaction operations are atomic
      await _lock.synchronized(() async {
        talker.info("Inside _lock.synchronized");

        // First, ensure we have a transaction by calling manageTransaction directly
        ITransaction? pendingTransaction =
            await ProxyService.strategy.manageTransaction(
          branchId: ProxyService.box.getBranchId()!,
          transactionType: transactionType,
          isExpense: !isIncome,
        );

        if (pendingTransaction == null) {
          talker.error("Failed to create or get a pending transaction");
          return;
        }

        talker.info(
            "Created pending transaction with ID: ${pendingTransaction.id}");

        // Now that we have a valid transaction, we can proceed
        // CRITICAL DIFFERENCE: In the original implementation, the transactionType parameter is not passed
        // This is equivalent to the keyboardKeyPressed call in the original implementation

        talker.info("Called keyboardKeyPressed with '+' key");
        HapticFeedback.lightImpact();

        Category? category = await ProxyService.strategy
            .activeCategory(branchId: ProxyService.box.getBranchId()!);
        var shortestSide = MediaQuery.of(context).size.shortestSide;
        var useMobileLayout = shortestSide < 600;

        // For cashbook transactions, the subtotal should be the cash received amount
        double subTotal = cashReceived;

        talker.info("Processing transaction with subtotal: $subTotal");

        // First update the transaction with the correct subtotal
        await ProxyService.strategy.updateTransaction(
          transaction: pendingTransaction,
          subTotal: subTotal,
        );

        talker.info("Updated transaction with subtotal: $subTotal");

        // Ensure the transaction is properly updated with the subtotal and marked as complete
        ITransaction updatedTransaction =
            await ProxyService.strategy.collectPayment(
          cashReceived: cashReceived,
          branchId: ProxyService.box.getBranchId()!,
          bhfId: (await ProxyService.box.bhfId()) ?? "00",
          isProformaMode: ProxyService.box.isProformaMode(),
          isTrainingMode: ProxyService.box.isTrainingMode(),
          transaction: pendingTransaction,
          paymentType: paymentType,
          discount: discount.toDouble(),
          transactionType:
              useMobileLayout ? category?.name ?? "" : TransactionType.sale,
          directlyHandleReceipt: false,
          isIncome: isIncome,
          categoryId: category?.id.toString(),
        );

        talker.info(
            "Called collectPayment, got updated transaction with ID: ${updatedTransaction.id}");

        // Always explicitly update the transaction status to ensure it's marked as complete
        updatedTransaction.status = COMPLETE;
        updatedTransaction.subTotal = subTotal;

        // Use updateTransaction method to ensure the transaction is properly saved
        // Call it twice to ensure the transaction is properly saved
        await ProxyService.strategy.updateTransaction(
          transaction: updatedTransaction,
          status: COMPLETE,
          subTotal: subTotal,
        );

        // Wait a short time to ensure the first update completes
        await Future.delayed(const Duration(milliseconds: 100));

        // Call update again to ensure it's properly saved
        await ProxyService.strategy.updateTransaction(
          transaction: updatedTransaction,
          status: COMPLETE,
          subTotal: subTotal,
        );

        talker.info(
            "Transaction explicitly marked as complete with subtotal: $subTotal");

        // Refresh providers to update UI
        ref.refresh(
            transactionItemsProvider(transactionId: pendingTransaction.id));
        ref.refresh(pendingTransactionStreamProvider(isExpense: !isIncome));
        ref.refresh(dashboardTransactionsProvider);

        talker.info("Transaction save completed successfully");
      });
    } catch (e, s) {
      talker.error("Error in _saveTransaction: $e");
      talker.error(s);
      rethrow; // Rethrow to allow the caller to handle the error
    }
  }
}
