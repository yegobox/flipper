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

  String _formatCurrency(num amount, {int decimalDigits = 2, String? symbol}) {
    if (amount == amount.toInt()) {
      return amount.toCurrencyFormatted(decimalDigits: decimalDigits);
    }
    return amount.toCurrencyFormatted(
        decimalDigits: decimalDigits, symbol: symbol);
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
                          context, currencySymbol, isSmallScreen),
                      const SizedBox(height: 16),
                      _buildCashReconciliation(context, isSmallScreen),
                      const SizedBox(height: 16),
                      _buildClosingBalanceSection(
                          context, currencySymbol, isSmallScreen),
                      const SizedBox(height: 16),
                      _buildCashDifferenceSection(
                          context, currencySymbol, isSmallScreen),
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
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
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
          children: [
            if (!isSmallScreen)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.schedule_send,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
            if (!isSmallScreen) const SizedBox(width: 16),
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
                  Text(
                    'End time: ${timeFormat.format(now)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
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
          ],
        ),
        const SizedBox(height: 12),
        Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
      ],
    );
  }

  Widget _buildShiftSummary(
      BuildContext context, String currencySymbol, bool isSmallScreen) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shift Summary',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            context,
            label: 'Opening Balance:',
            value:
                '${_formatCurrency(_openingBalance, symbol: currencySymbol)}',
            isSmallScreen: isSmallScreen,
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            context,
            label: 'Cash Sales:',
            value: '${_formatCurrency(_cashSales, symbol: currencySymbol)}',
            isSmallScreen: isSmallScreen,
            isHighlighted: true,
          ),
          const SizedBox(height: 6),
          Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
          const SizedBox(height: 6),
          _buildSummaryRow(
            context,
            label: 'Expected Cash:',
            value: '${_formatCurrency(_expectedCash, symbol: currencySymbol)}',
            isSmallScreen: isSmallScreen,
            isHighlighted: true,
            isLarge: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isSmallScreen = false,
    bool isHighlighted = false,
    bool isLarge = false,
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
            style: (isSmallScreen
                    ? isLarge
                        ? theme.textTheme.bodyMedium
                        : theme.textTheme.bodySmall
                    : isLarge
                        ? theme.textTheme.bodyLarge
                        : theme.textTheme.bodyMedium)
                ?.copyWith(
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
              color:
                  isHighlighted ? colorScheme.primary : colorScheme.onSurface,
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
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate,
                color: colorScheme.secondary,
                size: isSmallScreen ? 18 : 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Cash Reconciliation',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Count the physical cash and enter the closing balance below.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSecondaryContainer.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosingBalanceSection(
      BuildContext context, String currencySymbol, bool isSmallScreen) {
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
          'Enter actual cash counted',
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
            contentPadding: isSmallScreen
                ? const EdgeInsets.symmetric(vertical: 12, horizontal: 12)
                : const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                ' ',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            hintText: '0.00',
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
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
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCashDifferenceSection(
      BuildContext context, String currencySymbol, bool isSmallScreen) {
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
        border: Border.all(
          color: differenceColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                differenceIcon,
                color: differenceColor,
                size: isSmallScreen ? 18 : 20,
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
              Text(
                'Difference:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: differenceColor.withValues(alpha: 0.9),
                ),
              ),
              Text(
                '${_cashDifference > 0 ? '+' : ''}${_formatCurrency(_cashDifference.abs(), symbol: currencySymbol)}',
                style: (isSmallScreen
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.headlineSmall)
                    ?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: differenceColor,
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
              Text(
                '(Required)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          isRequired ? 'Explain the difference' : 'Add any notes',
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
            hintText: isRequired ? 'Explain difference...' : 'Enter notes...',
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
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
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 20,
          ),
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
                padding:
                    EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
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
                    padding:
                        EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: colorScheme.outline),
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
                  padding:
                      EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
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
                              colorScheme.onPrimary),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.stop,
                            size: isSmallScreen ? 18 : 20,
                            color: colorScheme.onPrimary,
                          ),
                          if (!isSmallScreen) const SizedBox(width: 8),
                          if (!isSmallScreen)
                            Text(
                              _showConfirmation
                                  ? 'Confirm Close'
                                  : 'Close Shift',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: colorScheme.onPrimary,
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

      widget.completer(DialogResponse(
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
      ));
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
