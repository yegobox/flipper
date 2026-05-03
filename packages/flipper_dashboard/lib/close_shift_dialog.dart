import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/shift_data_provider.dart';
import 'package:flipper_services/proxy.dart';

class CloseShiftDialog extends StatefulHookConsumerWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const CloseShiftDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _CloseShiftDialogState createState() => _CloseShiftDialogState();
}

class _CloseShiftDialogState extends ConsumerState<CloseShiftDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _closingBalanceController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  num _cashDifference = 0.0;
  num _openingBalance = 0;
  num _cashSales = 0;
  num _expectedCash = 0;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _showConfirmation = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _closingBalanceController.addListener(_calculateCashDifference);
    _calculateCashDifference();
  }

  @override
  void dispose() {
    _closingBalanceController.removeListener(_calculateCashDifference);
    _closingBalanceController.dispose();
    _notesController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateCashDifference() {
    final closingBalance =
        double.tryParse(_closingBalanceController.text) ?? 0.0;
    setState(() {
      _cashDifference = closingBalance - _expectedCash;
    });
  }

  double _currentClosingBalance() {
    return double.tryParse(_closingBalanceController.text.trim()) ?? 0.0;
  }

  void _setClosingBalance(double value) {
    final sanitized = value.isFinite ? value : 0.0;
    final clamped = sanitized < 0 ? 0.0 : sanitized;
    final text = clamped == clamped.toInt()
        ? clamped.toInt().toString()
        : clamped.toStringAsFixed(2);
    _closingBalanceController.value = _closingBalanceController.value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
      composing: TextRange.empty,
    );
  }

  void _incrementClosingBalance() {
    _setClosingBalance(_currentClosingBalance() + 1);
  }

  void _decrementClosingBalance() {
    _setClosingBalance(_currentClosingBalance() - 1);
  }

  String _formatCurrency(num amount, {int decimalDigits = 2, String? symbol}) {
    if (amount == amount.toInt()) {
      return amount.toCurrencyFormatted(
        decimalDigits: decimalDigits,
        symbol: symbol,
      );
    }
    return amount.toCurrencyFormatted(
      decimalDigits: decimalDigits,
      symbol: symbol,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currencySymbol = ProxyService.box.defaultCurrency();
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    final shiftDataAsyncValue = ref.watch(shiftDataProvider);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        backgroundColor: colorScheme.surface,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? double.infinity : 520,
            ),
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: Form(
              key: _formKey,
              child: shiftDataAsyncValue.when(
                data: (shiftData) {
                  // Update state variables when data is available
                  _openingBalance = shiftData.openingBalance;
                  _cashSales = shiftData.cashSales;
                  _expectedCash = shiftData.expectedCash;
                  _calculateCashDifference();

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context, isSmallScreen),
                      const SizedBox(height: 16),
                      _buildShiftSummary(
                        context,
                        currencySymbol,
                        isSmallScreen,
                      ),
                      const SizedBox(height: 16),
                      _buildCashReconciliation(context, isSmallScreen),
                      const SizedBox(height: 16),
                      _buildClosingBalanceSection(
                        context,
                        currencySymbol,
                        isSmallScreen,
                      ),
                      const SizedBox(height: 16),
                      _buildCashDifferenceSection(
                        context,
                        currencySymbol,
                        isSmallScreen,
                      ),
                      const SizedBox(height: 16),
                      _buildNotesSection(context, isSmallScreen),
                      if (_hasError) ...[
                        const SizedBox(height: 12),
                        _buildErrorMessage(context),
                      ],
                      if (_showConfirmation) ...[
                        const SizedBox(height: 12),
                        _buildConfirmationSection(context, isSmallScreen),
                      ],
                      const SizedBox(height: 24),
                      _buildActionButtons(context, isSmallScreen),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text(
                    'Error loading shift data',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();
    final timeFormat = DateFormat('h:mm a');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: isSmallScreen ? 36 : 40,
              height: isSmallScreen ? 36 : 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.schedule,
                color: const Color(0xFF2B6DE9),
                size: isSmallScreen ? 18 : 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.request.title ?? 'Close Shift',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'End time: ${timeFormat.format(now)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: isSmallScreen ? 34 : 36,
              height: isSmallScreen ? 34 : 36,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.18),
                ),
              ),
              child: IconButton(
                onPressed: () =>
                    widget.completer(DialogResponse(confirmed: false)),
                icon: Icon(
                  Icons.close,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  size: isSmallScreen ? 20 : 24,
                ),
                tooltip: 'Close',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
      ],
    );
  }

  Widget _buildShiftSummary(
    BuildContext context,
    String currencySymbol,
    bool isSmallScreen,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.credit_card,
              size: isSmallScreen ? 18 : 20,
              color: colorScheme.onSurface.withValues(alpha: 0.75),
            ),
            const SizedBox(width: 8),
            Text(
              'Shift Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: isSmallScreen ? 12 : 14,
                ),
                child: _buildSummaryRow(
                  context,
                  label: 'Opening Balance',
                  value:
                      '$currencySymbol  ${_formatCurrency(_openingBalance, symbol: '')}',
                  isSmallScreen: isSmallScreen,
                  valueColor: colorScheme.onSurface,
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.outline.withValues(alpha: 0.10),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: isSmallScreen ? 12 : 14,
                ),
                child: _buildSummaryRow(
                  context,
                  label: 'Cash Sales',
                  value:
                      '$currencySymbol  ${_formatCurrency(_cashSales, symbol: '')}',
                  isSmallScreen: isSmallScreen,
                  isHighlighted: true,
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.outline.withValues(alpha: 0.10),
              ),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: isSmallScreen ? 12 : 14,
                ),
                child: _buildSummaryRow(
                  context,
                  label: 'Expected Cash',
                  value:
                      '$currencySymbol  ${_formatCurrency(_expectedCash, symbol: '')}',
                  isSmallScreen: isSmallScreen,
                  isHighlighted: true,
                  isLarge: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isSmallScreen = false,
    bool isHighlighted = false,
    bool isLarge = false,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: isSmallScreen
                ? theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style:
                (isSmallScreen
                        ? isLarge
                              ? theme.textTheme.bodyMedium
                              : theme.textTheme.bodySmall
                        : isLarge
                        ? theme.textTheme.bodyLarge
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(
                      fontWeight: isHighlighted
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isHighlighted
                          ? const Color(0xFF2B6DE9)
                          : (valueColor ?? colorScheme.onSurface),
                    ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCashReconciliation(BuildContext context, bool isSmallScreen) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2B6DE9).withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: const Color(0xFF2B6DE9),
                size: isSmallScreen ? 18 : 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Cash Reconciliation',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2B6DE9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Count the physical cash in the drawer and enter the\nclosing balance below.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF2B6DE9).withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosingBalanceSection(
    BuildContext context,
    String currencySymbol,
    bool isSmallScreen,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Closing Cash Balance',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Enter actual cash counted in the drawer',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _closingBalanceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            final balance = double.tryParse(value);
            if (balance == null || balance < 0) {
              return 'Invalid amount';
            }
            return null;
          },
          decoration: InputDecoration(
            isDense: isSmallScreen,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 10),
              child: Text(
                currencySymbol,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: SizedBox(
              width: 44,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkResponse(
                    onTap: _incrementClosingBalance,
                    radius: 18,
                    child: Icon(
                      Icons.arrow_drop_up,
                      color: colorScheme.onSurface.withValues(alpha: 0.60),
                    ),
                  ),
                  const SizedBox(height: 2),
                  InkResponse(
                    onTap: _decrementClosingBalance,
                    radius: 18,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: colorScheme.onSurface.withValues(alpha: 0.60),
                    ),
                  ),
                ],
              ),
            ),
            hintText: '0',
            filled: true,
            fillColor: const Color(0xFFF4F6FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.18),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF2B6DE9), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
          ),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCashDifferenceSection(
    BuildContext context,
    String currencySymbol,
    bool isSmallScreen,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color differenceColor;
    IconData differenceIcon;
    String differenceText;

    if (_cashDifference == 0) {
      differenceColor = colorScheme.primary;
      differenceIcon = Icons.check_circle;
      differenceText = 'Perfect Balance';
    } else if (_cashDifference > 0) {
      differenceColor = Colors.green;
      differenceIcon = Icons.add_circle;
      differenceText = 'Overage';
    } else {
      differenceColor = Colors.red;
      differenceIcon = Icons.remove_circle;
      differenceText = 'Shortage';
    }

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: differenceColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: differenceColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isSmallScreen ? 24 : 26,
                height: isSmallScreen ? 24 : 26,
                decoration: BoxDecoration(
                  color: differenceColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  differenceIcon == Icons.remove_circle
                      ? Icons.remove
                      : Icons.check,
                  color: Colors.white,
                  size: isSmallScreen ? 14 : 16,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  differenceText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: differenceColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Difference',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  '$currencySymbol  ${_formatCurrency(_cashDifference.abs(), symbol: '')}',
                  style:
                      (isSmallScreen
                              ? theme.textTheme.titleMedium
                              : theme.textTheme.headlineSmall)
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.25,
                            ),
                          ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ],
          ),
          if (_cashDifference != 0) ...[
            const SizedBox(height: 6),
            Text(
              _cashDifference > 0
                  ? 'More cash than expected'
                  : 'Less cash than expected',
              style: theme.textTheme.bodySmall?.copyWith(
                color: differenceColor.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context, bool isSmallScreen) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRequired = _cashDifference != 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Notes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: colorScheme.error.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  'Required',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          isRequired ? 'Explain the shortage' : 'Add any notes',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          minLines: 2,
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required when difference exists';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            isDense: isSmallScreen,
            contentPadding: isSmallScreen
                ? const EdgeInsets.all(12)
                : const EdgeInsets.all(16),
            hintText: isRequired
                ? 'Explain the difference...'
                : 'Enter notes...',
            filled: true,
            fillColor: const Color(0xFFF4F6FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.18),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2B6DE9), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationSection(BuildContext context, bool isSmallScreen) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: colorScheme.primary,
                size: isSmallScreen ? 18 : 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Confirm Shift Closure',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'This action cannot be undone.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isSmallScreen) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        if (_showConfirmation) ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => setState(() => _showConfirmation = false),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 12 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: colorScheme.outline),
              ),
              child: Text(
                'Go Back',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            if (!_showConfirmation) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading
                      ? null
                      : () =>
                            widget.completer(DialogResponse(confirmed: false)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              flex: _showConfirmation ? 1 : 2,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _closeShift,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF2B6DE9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            _showConfirmation ? 'Confirm Close' : 'Close Shift',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _closeShift() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final closingBalance = double.tryParse(_closingBalanceController.text);
    if (closingBalance == null) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Invalid closing balance';
      });
      return;
    }

    // Show confirmation for significant differences
    if (_cashDifference.abs() > 10 && !_showConfirmation) {
      setState(() {
        _showConfirmation = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final notes = _notesController.text.trim();

      widget.completer(
        DialogResponse(
          confirmed: true,
          data: {
            'closingBalance': closingBalance,
            'cashDifference': _cashDifference,
            'notes': notes.isEmpty ? null : notes,
            'timestamp': DateTime.now().toIso8601String(),
            'openingBalance': _openingBalance,
            'cashSales': _cashSales,
            'expectedCash': _expectedCash,
          },
        ),
      );
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to close shift: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
