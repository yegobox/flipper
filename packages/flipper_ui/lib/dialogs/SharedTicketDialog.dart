import 'package:dropdown_search/dropdown_search.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Helper to show the dialog in WoltModalSheet style
Future<void> showSharedTicketDialog({
  required BuildContext context,
  required ITransaction transaction,
  required CoreViewModel model,
}) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        _buildSharedTicketPage(context, transaction, model),
      ];
    },
    modalTypeBuilder: (context) => WoltModalType.dialog(),
  );
}

/// The Sliver Page for WoltModalSheet
SliverWoltModalSheetPage _buildSharedTicketPage(
  BuildContext context,
  ITransaction transaction,
  CoreViewModel model,
) {
  final formKey = GlobalKey<SharedTicketFormState>();

  return SliverWoltModalSheetPage(
    backgroundColor: Colors.white,
    pageTitle: Container(
      padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF01B8E4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.receipt_long_rounded,
                color: Color(0xFF01B8E4), size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            'Park Transaction',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: const Color(0xFF1A1C1E),
            ),
          ),
        ],
      ),
    ),
    mainContentSliversBuilder: (_) => [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
            bottom:
                120.0, // Added padding to ensure content is visible above stickyActionBar
          ),
          child: SharedTicketForm(
            key: formKey,
            transaction: transaction,
            model: model,
          ),
        ),
      ),
    ],
    stickyActionBar: Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => formKey.currentState?.submit(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF01B8E4),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Park Transaction',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
    ),
  );
}

class SharedTicketDialog extends StatefulWidget {
  const SharedTicketDialog({
    Key? key,
    required this.transaction,
    required this.onClose,
  }) : super(key: key);

  final ITransaction transaction;
  final VoidCallback onClose;

  @override
  State<SharedTicketDialog> createState() => _SharedTicketDialogState();
}

class _SharedTicketDialogState extends State<SharedTicketDialog> {
  final GlobalKey<SharedTicketFormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    children: [
                      Text(
                        'Park Transaction',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close, color: Colors.grey),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SharedTicketForm(
                      key: _formKey,
                      transaction: widget.transaction,
                      model: model,
                      onSuccess: widget.onClose,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onClose,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 52),
                            side: const BorderSide(color: Color(0xFFE1E2E4)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF42474E),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _formKey.currentState?.submit(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF01B8E4),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 52),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Park",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SharedTicketForm extends StatefulWidget {
  const SharedTicketForm({
    Key? key,
    required this.transaction,
    required this.model,
    this.onSuccess,
  }) : super(key: key);

  final ITransaction transaction;
  final CoreViewModel model;
  final VoidCallback? onSuccess;

  @override
  SharedTicketFormState createState() => SharedTicketFormState();
}

class SharedTicketFormState extends State<SharedTicketForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ticketNameController;
  late TextEditingController _noteController;

  bool _isLoan = false;
  DateTime? _dueDate;
  Customer? _selectedCustomer;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _ticketNameController =
        TextEditingController(text: widget.transaction.ticketName);
    _noteController = TextEditingController(text: widget.transaction.note);
    _isLoan = widget.transaction.isLoan ?? false;
    _dueDate = widget.transaction.dueDate;
  }

  @override
  void dispose() {
    _ticketNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (_isSaving) return;
    if (_formKey.currentState?.validate() ?? false) {
      if (mounted) setState(() => _isSaving = true);
      try {
        widget.transaction.isLoan = _isLoan;
        widget.transaction.dueDate = _isLoan ? _dueDate?.toUtc() : null;

        await widget.model.saveTicket(
          ticketName: _ticketNameController.text,
          transaction: widget.transaction,
          ticketNote: _noteController.text,
          customerId: _selectedCustomer?.id,
        );
        widget.onSuccess?.call();
        if (mounted && widget.onSuccess == null) {
          Navigator.of(context).pop();
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        color: const Color(0xFF42474E),
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF01B8E4), size: 20),
      filled: true,
      fillColor: const Color(0xFFF1F4F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF01B8E4), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade300, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: LinearProgressIndicator(
                backgroundColor: Color(0xFFF1F4F9),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF01B8E4)),
                minHeight: 2,
              ),
            ),
          TextFormField(
            enabled: !_isSaving,
            controller: _ticketNameController,
            style: GoogleFonts.poppins(fontSize: 15),
            decoration: _buildInputDecoration(
                'Ticket Name', Icons.label_important_outline),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter ticket name";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _noteController,
            style: GoogleFonts.poppins(fontSize: 15),
            decoration:
                _buildInputDecoration('Notes (Optional)', Icons.notes_rounded),
            enabled: !_isSaving,
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Customer>>(
            future: Future.value(
              ProxyService.getStrategy(Strategy.capella).customers(
                branchId: ProxyService.box.getBranchId() ?? '00',
              ),
            ),
            builder: (context, snapshot) {
              final customers = snapshot.data ?? [];
              if (_selectedCustomer == null &&
                  widget.transaction.customerId != null) {
                try {
                  _selectedCustomer = customers
                      .firstWhere((c) => c.id == widget.transaction.customerId);
                } catch (_) {}
              }

              return DropdownSearch<Customer>(
                items: (filter, loadProps) => customers
                    .where((c) =>
                        c.custNm
                            ?.toLowerCase()
                            .contains(filter.toLowerCase()) ??
                        false)
                    .toList(),
                compareFn: (i, s) => i.id == s.id,
                selectedItem: _selectedCustomer,
                decoratorProps: DropDownDecoratorProps(
                  decoration: _buildInputDecoration(
                      'Attach Customer', Icons.person_outline_rounded),
                ),
                enabled: !_isSaving,
                onChanged: (Customer? newValue) {
                  setState(() => _selectedCustomer = newValue);
                },
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: _buildInputDecoration(
                        'Search customers...', Icons.search),
                  ),
                  menuProps: MenuProps(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  itemBuilder: (context, item, isDisabled, isSelected) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF01B8E4).withOpacity(0.05)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        selected: isSelected,
                        title: Text(item.custNm ?? 'Unknown',
                            style: GoogleFonts.poppins(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400)),
                        subtitle: Text(item.telNo ?? '',
                            style: GoogleFonts.poppins(fontSize: 12)),
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color(0xFF01B8E4).withOpacity(0.1),
                          child: Text((item.custNm ?? 'U')[0].toUpperCase(),
                              style: const TextStyle(
                                  color: Color(0xFF01B8E4), fontSize: 14)),
                        ),
                      ),
                    );
                  },
                ),
                itemAsString: (Customer c) => c.custNm ?? 'Unknown',
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Theme(
              data: ThemeData(
                unselectedWidgetColor: const Color(0xFF01B8E4),
              ),
              child: CheckboxListTile(
                title: Text('Mark as Loan',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: const Color(0xFF1A1C1E),
                    )),
                subtitle: Text('Track payment later',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey.shade600)),
                value: _isLoan,
                activeColor: const Color(0xFF01B8E4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onChanged: _isSaving
                    ? null
                    : (val) {
                        setState(() {
                          _isLoan = val ?? false;
                          if (_isLoan && _dueDate == null) {
                            _dueDate = DateTime.now()
                                .toUtc()
                                .add(const Duration(days: 7));
                          }
                        });
                      },
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ),
          ),
          if (_isLoan) ...[
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF01B8E4).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFF01B8E4).withValues(alpha: 0.2)),
              ),
              child: InkWell(
                onTap: _isSaving
                    ? null
                    : () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _dueDate ??
                              DateTime.now()
                                  .toUtc()
                                  .add(const Duration(days: 7)),
                          firstDate: DateTime.now().toUtc(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF01B8E4),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => _dueDate = picked.toUtc());
                        }
                      },
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        color: Color(0xFF01B8E4), size: 18),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pick a due date',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey.shade600)),
                        Text(
                          _dueDate != null
                              ? '${_dueDate!.toLocal().toString().split(' ')[0]}'
                              : 'Select Date',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF1A1C1E),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: Color(0xFF01B8E4)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
