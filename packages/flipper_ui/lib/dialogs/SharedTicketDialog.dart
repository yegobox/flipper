import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/park_transaction_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_ui/widgets/async_action_gradient_button.dart';
import 'package:flipper_ui/widgets/sheet_dismiss_button.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// MPOS park-transaction sheet tokens (design_handoff_mobile_pos).
const Color _kPrimary = Color(0xFF2563EB);
const Color _kInk = Color(0xFF111827);
const Color _kLabel = Color(0xFF9CA3AF);
const Color _kCardBorder = Color(0xFFE5E7EB);
const Color _kLoanPurple = Color(0xFF6B4EA2);
const Color _kLoanBg = Color(0xFFF5F9FF);
const double _kSheetRadius = 26;
const double _kFieldRadius = 14;

enum _DuePreset { oneWeek, twoWeeks, oneMonth, custom }

/// Park-transaction sheet (bottom sheet on mobile, centered dialog on wide).
Future<void> showSharedTicketDialog({
  required BuildContext context,
  required ITransaction transaction,
}) {
  final formKey = GlobalKey<SharedTicketFormState>();
  final isSaving = ValueNotifier(false);
  final useBottomSheet = MediaQuery.sizeOf(context).width < 600;

  return WoltModalSheet.show(
    context: context,
    enableDrag: useBottomSheet,
    barrierDismissible: true,
    modalTypeBuilder: (context) =>
        useBottomSheet ? WoltModalType.bottomSheet() : WoltModalType.dialog(),
    pageListBuilder: (context) {
      return [
        _buildSharedTicketPage(
          context,
          transaction,
          formKey,
          isSaving,
          useBottomSheet: useBottomSheet,
        ),
      ];
    },
  ).whenComplete(isSaving.dispose);
}

double _parkTicketScrollBottomInset(BuildContext context) {
  const footerHeight = 14.0 + 56.0 + 20.0;
  const clearance = 12.0;
  return footerHeight + clearance + MediaQuery.paddingOf(context).bottom;
}

SliverWoltModalSheetPage _buildSharedTicketPage(
  BuildContext context,
  ITransaction transaction,
  GlobalKey<SharedTicketFormState> formKey,
  ValueNotifier<bool> isSaving, {
  required bool useBottomSheet,
}) {
  return SliverWoltModalSheetPage(
    backgroundColor: Colors.white,
    hasTopBarLayer: false,
    forceMaxHeight: useBottomSheet,
    pageTitle: const SizedBox.shrink(),
    mainContentSliversBuilder: (_) => [
      SliverToBoxAdapter(
        child: ClipRRect(
          borderRadius: useBottomSheet
              ? const BorderRadius.vertical(top: Radius.circular(_kSheetRadius))
              : BorderRadius.zero,
          child: SharedTicketForm(
            key: formKey,
            transaction: transaction,
            isSavingNotifier: isSaving,
            scrollBottomInset: _parkTicketScrollBottomInset(context),
          ),
        ),
      ),
    ],
    stickyActionBar: _ParkTicketFooter(
      transaction: transaction,
      formKey: formKey,
      isSavingNotifier: isSaving,
    ),
  );
}

class _ParkTicketFooter extends StatelessWidget {
  const _ParkTicketFooter({
    required this.transaction,
    required this.formKey,
    required this.isSavingNotifier,
  });

  final ITransaction transaction;
  final GlobalKey<SharedTicketFormState> formKey;
  final ValueNotifier<bool> isSavingNotifier;

  @override
  Widget build(BuildContext context) {
    final currency = ProxyService.box.defaultCurrency();
    final amount = (transaction.subTotal ?? 0.0)
        .toCurrencyFormatted(symbol: currency);

    return ValueListenableBuilder<bool>(
      valueListenable: isSavingNotifier,
      builder: (context, isSaving, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: _kCardBorder)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSaving)
                const LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: Color(0xFFF3F4F6),
                  valueColor: AlwaysStoppedAnimation<Color>(_kPrimary),
                ),
              SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'AMOUNT',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: _kLabel,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            amount,
                            style: _monoStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: _kInk,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: AsyncActionGradientButton(
                        idleLabel: 'Park transaction',
                        loadingLabel: 'Parking…',
                        icon: Icons.bookmark_rounded,
                        syncNotifier: isSavingNotifier,
                        canStart: () =>
                            formKey.currentState?.validate() ?? false,
                        onPressed: () =>
                            formKey.currentState?.submit() ?? Future.value(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SharedTicketDialog extends StatefulWidget {
  const SharedTicketDialog({
    super.key,
    required this.transaction,
    required this.onClose,
  });

  final ITransaction transaction;
  final VoidCallback onClose;

  @override
  State<SharedTicketDialog> createState() => _SharedTicketDialogState();
}

class _SharedTicketDialogState extends State<SharedTicketDialog> {
  final GlobalKey<SharedTicketFormState> _formKey = GlobalKey();
  final ValueNotifier<bool> _isSaving = ValueNotifier(false);

  @override
  void dispose() {
    _isSaving.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: SharedTicketForm(
                  key: _formKey,
                  transaction: widget.transaction,
                  onSuccess: widget.onClose,
                  isSavingNotifier: _isSaving,
                  scrollBottomInset: 8,
                ),
              ),
            ),
            _ParkTicketFooter(
              transaction: widget.transaction,
              formKey: _formKey,
              isSavingNotifier: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}

class SharedTicketForm extends ConsumerStatefulWidget {
  const SharedTicketForm({
    super.key,
    required this.transaction,
    this.onSuccess,
    this.isSavingNotifier,
    this.scrollBottomInset = 120,
  });

  final ITransaction transaction;
  final VoidCallback? onSuccess;
  final ValueNotifier<bool>? isSavingNotifier;
  final double scrollBottomInset;

  @override
  SharedTicketFormState createState() => SharedTicketFormState();
}

class SharedTicketFormState extends ConsumerState<SharedTicketForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ticketNameController;
  late TextEditingController _noteController;

  bool _isLoan = false;
  DateTime? _dueDate;
  _DuePreset _duePreset = _DuePreset.twoWeeks;
  Customer? _selectedCustomer;
  List<Customer> _customers = [];
  bool _loadingCustomers = true;

  @override
  void initState() {
    super.initState();
    _ticketNameController = TextEditingController(
      text: widget.transaction.ticketName ?? '',
    );
    _noteController = TextEditingController(
      text: widget.transaction.note ?? '',
    );
    _isLoan = widget.transaction.isLoan ?? false;
    _dueDate = widget.transaction.dueDate;
    if (_isLoan && _dueDate == null) {
      _applyPreset(_DuePreset.twoWeeks);
    } else if (_dueDate != null) {
      _duePreset = _DuePreset.custom;
    }
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      final customers = await ProxyService.getStrategy(Strategy.capella)
          .customers(branchId: ProxyService.box.getBranchId() ?? '00');
      if (!mounted) return;
      setState(() {
        _customers = customers;
        _loadingCustomers = false;
        if (_selectedCustomer == null &&
            widget.transaction.customerId != null) {
          try {
            _selectedCustomer = customers.firstWhere(
              (c) => c.id == widget.transaction.customerId,
            );
          } catch (_) {}
        }
      });
    } catch (_) {
      if (mounted) setState(() => _loadingCustomers = false);
    }
  }

  @override
  void dispose() {
    _ticketNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _applyPreset(_DuePreset preset) {
    final days = switch (preset) {
      _DuePreset.oneWeek => 7,
      _DuePreset.twoWeeks => 14,
      _DuePreset.oneMonth => 30,
      _DuePreset.custom => null,
    };
    if (days == null) return;
    setState(() {
      _duePreset = preset;
      _dueDate = DateTime.now().toUtc().add(Duration(days: days));
    });
  }

  bool get _isSaving => widget.isSavingNotifier?.value ?? false;

  bool validate() => _formKey.currentState?.validate() ?? false;

  Future<void> submit() async {
    final saving = widget.isSavingNotifier;
    if (saving == null) return;

    try {
      widget.transaction.isLoan = _isLoan;
      widget.transaction.dueDate = _isLoan ? _dueDate?.toUtc() : null;

      await ref.read(parkTransactionProvider.notifier).park(
        ticketName: _ticketNameController.text.trim(),
        transaction: widget.transaction,
        ticketNote: _noteController.text.trim(),
        customerId: _selectedCustomer?.id,
      );
      widget.onSuccess?.call();
      if (mounted && widget.onSuccess == null) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to park transaction: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _pickCustomer() async {
    if (_isSaving || _loadingCustomers) return;

    final picked = await showModalBottomSheet<Object?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_kSheetRadius)),
      ),
      builder: (sheetContext) {
        var query = '';
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filtered = _customers.where((c) {
              final name = (c.custNm ?? '').toLowerCase();
              final phone = (c.telNo ?? '').toLowerCase();
              final q = query.toLowerCase();
              return name.contains(q) || phone.contains(q);
            }).toList();

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 12,
                  bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _SheetHandle(),
                    Text(
                      'Attach customer',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: _kInk,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (v) => setSheetState(() => query = v),
                      style: GoogleFonts.poppins(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Search customers…',
                        hintStyle: GoogleFonts.poppins(color: _kLabel),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(_kFieldRadius),
                          borderSide: const BorderSide(color: _kCardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(_kFieldRadius),
                          borderSide: const BorderSide(color: _kCardBorder),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filtered.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.person_off_outlined),
                              title: Text(
                                'No customer',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () =>
                                  Navigator.pop(sheetContext, false),
                            );
                          }
                          final c = filtered[index - 1];
                          final initial =
                              (c.custNm ?? '?').trim()[0].toUpperCase();
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: _customerAvatar(initial, size: 40),
                            title: Text(
                              c.custNm ?? 'Unknown',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              _formatPhoneDisplay(c.telNo ?? ''),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: _kLabel,
                              ),
                            ),
                            onTap: () => Navigator.pop(sheetContext, c),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (!mounted) return;
    if (picked == false) {
      setState(() => _selectedCustomer = null);
    } else if (picked is Customer) {
      setState(() => _selectedCustomer = picked);
    }
  }

  Future<void> _pickDueDate() async {
    if (_isSaving) return;
    final picked = await showDatePicker(
      context: context,
      initialDate: (_dueDate ?? DateTime.now().toUtc()).toLocal(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: _kPrimary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked.toUtc();
        _duePreset = _DuePreset.custom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = widget.isSavingNotifier;
    if (saving == null) {
      return _buildForm(context, isSaving: false);
    }
    return ValueListenableBuilder<bool>(
      valueListenable: saving,
      builder: (context, isSaving, _) => _buildForm(context, isSaving: isSaving),
    );
  }

  Widget _buildForm(BuildContext context, {required bool isSaving}) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: widget.scrollBottomInset,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHandle(),
            _ParkHeader(
              onClose: isSaving
                  ? null
                  : () {
                      if (widget.onSuccess != null) {
                        widget.onSuccess!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
            ),
            if (isSaving) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Color(0xFFF3F4F6),
                valueColor: AlwaysStoppedAnimation<Color>(_kPrimary),
              ),
            ],
            const SizedBox(height: 22),
            _fieldLabel('Ticket name'),
            const SizedBox(height: 8),
            _borderedField(
              controller: _ticketNameController,
              enabled: !isSaving,
              icon: Icons.local_offer_outlined,
              hint: 'Ticket name',
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Enter a ticket name'
                  : null,
            ),
            const SizedBox(height: 18),
            _fieldLabel('Notes', trailing: 'Optional'),
            const SizedBox(height: 8),
            _borderedField(
              controller: _noteController,
              enabled: !isSaving,
              icon: Icons.dehaze_rounded,
              hint: 'Add notes',
              maxLines: 3,
              minHeight: 88,
            ),
            const SizedBox(height: 18),
            _fieldLabel('Attach customer', trailing: 'Optional'),
            const SizedBox(height: 8),
            _customerField(isSaving: isSaving),
            const SizedBox(height: 18),
            _loanSection(isSaving: isSaving),
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: _isLoan
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
                        _fieldLabel('Payment due'),
                        const SizedBox(height: 10),
                        _duePresetRow(isSaving: isSaving),
                        const SizedBox(height: 10),
                        _dueDateRow(isSaving: isSaving),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customerField({required bool isSaving}) {
    if (_loadingCustomers) {
      return _surfaceBox(
        minHeight: 64,
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2, color: _kPrimary),
          ),
        ),
      );
    }

    final name = _selectedCustomer?.custNm?.trim();
    final phone = _formatPhoneDisplay(_selectedCustomer?.telNo?.trim() ?? '');
    final hasCustomer = name != null && name.isNotEmpty;
    final initial =
        hasCustomer ? name[0].toUpperCase() : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isSaving ? null : _pickCustomer,
        borderRadius: BorderRadius.circular(_kFieldRadius),
        child: _surfaceBox(
          minHeight: 64,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              if (initial != null)
                _customerAvatar(initial, size: 40)
              else
                Icon(Icons.person_add_alt_1_outlined,
                    size: 22, color: Colors.grey.shade400),
              const SizedBox(width: 12),
              Expanded(
                child: hasCustomer
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _kInk,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (phone.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              phone,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: _kLabel,
                              ),
                            ),
                          ],
                        ],
                      )
                    : Text(
                        'Select customer',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _kLabel,
                        ),
                      ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade500, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loanSection({required bool isSaving}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _kLoanBg,
        borderRadius: BorderRadius.circular(_kFieldRadius),
        border: Border.all(color: _kPrimary.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _kLoanPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mark as loan',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: _kInk,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Track payment for later collection',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _kPrimary,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.92,
            child: CupertinoSwitch(
              value: _isLoan,
              activeTrackColor: _kPrimary,
              onChanged: isSaving
                  ? null
                  : (val) {
                      setState(() {
                        _isLoan = val;
                        if (_isLoan && _dueDate == null) {
                          _applyPreset(_DuePreset.twoWeeks);
                        }
                      });
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _duePresetRow({required bool isSaving}) {
    return Row(
      children: [
        Expanded(
          child: _presetChip('1 week', _DuePreset.oneWeek, isSaving: isSaving),
        ),
        const SizedBox(width: 8),
        Expanded(
          child:
              _presetChip('2 weeks', _DuePreset.twoWeeks, isSaving: isSaving),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _presetChip('1 month', _DuePreset.oneMonth, isSaving: isSaving),
        ),
      ],
    );
  }

  Widget _presetChip(
    String label,
    _DuePreset preset, {
    required bool isSaving,
  }) {
    final selected = _duePreset == preset;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isSaving ? null : () => _applyPreset(preset),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEEF4FF) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? _kPrimary : _kCardBorder,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? _kPrimary : _kLabel,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dueDateRow({required bool isSaving}) {
    final dateText =
        _dueDate != null ? _formatIsoDate(_dueDate!.toLocal()) : 'Select date';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isSaving ? null : _pickDueDate,
        borderRadius: BorderRadius.circular(_kFieldRadius),
        child: _surfaceBox(
          minHeight: 56,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _kPrimary.withValues(alpha: 0.25),
                  ),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: _kPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Due date',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _kLabel,
                      ),
                    ),
                    Text(
                      dateText,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _kInk,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey.shade500, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _borderedField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required bool enabled,
    String? Function(String?)? validator,
    int maxLines = 1,
    double minHeight = 52,
  }) {
    return _surfaceBox(
      minHeight: minHeight,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: Row(
        crossAxisAlignment:
            maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: maxLines > 1 ? 16 : 0),
            child: Icon(icon, size: 20, color: Colors.grey.shade400),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              maxLines: maxLines,
              validator: validator,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _kInk,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _kLabel,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: maxLines > 1 ? 16 : 14,
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _surfaceBox({
    required Widget child,
    double minHeight = 52,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_kFieldRadius),
        border: Border.all(color: _kCardBorder),
      ),
      child: child,
    );
  }
}

class _ParkHeader extends StatelessWidget {
  const _ParkHeader({this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF4FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.bookmark_rounded, color: _kPrimary, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Park transaction',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: _kInk,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hold this sale to finish later',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _kLabel,
                ),
              ),
            ],
          ),
        ),
        SheetDismissButton(onPressed: onClose),
      ],
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFD1D5DB),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

Widget _fieldLabel(String label, {String? trailing}) {
  return Row(
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _kLabel,
        ),
      ),
      if (trailing != null) ...[
        const Spacer(),
        Text(
          trailing,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _kLabel,
          ),
        ),
      ],
    ],
  );
}

Widget _customerAvatar(String initial, {double size = 36}) {
  return Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4A9EFF), Color(0xFF2563EB)],
      ),
    ),
    child: Text(
      initial,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: size * 0.42,
      ),
    ),
  );
}

String _formatIsoDate(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}

String _formatPhoneDisplay(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 10) {
    return '${digits.substring(0, 4)} ${digits.substring(4, 7)} '
        '${digits.substring(7)}';
  }
  if (digits.length == 12 && digits.startsWith('250')) {
    final local = digits.substring(3);
    return '${local.substring(0, 4)} ${local.substring(4, 7)} '
        '${local.substring(7)}';
  }
  return raw;
}

TextStyle _monoStyle({
  required double fontSize,
  FontWeight fontWeight = FontWeight.w500,
  Color color = _kInk,
}) {
  return FlipperFonts.mono(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: -0.3,
  );
}
