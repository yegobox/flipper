import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';

class NewTicket extends StatefulWidget {
  const NewTicket({Key? key, required this.transaction, required this.onClose})
      : super(key: key);
  final ITransaction transaction;
  final VoidCallback onClose;

  @override
  NewTicketState createState() => NewTicketState();
}

class NewTicketState extends State<NewTicket> {
  final _formKey = GlobalKey<FormState>();
  final _swipeController = TextEditingController();
  final _noteController = TextEditingController();
  bool _noteValue = false;
  bool _ticketNameValue = false;
  bool _isLoan = false;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    // Prefill ticket name if available
    if (widget.transaction.ticketName != null &&
        widget.transaction.ticketName!.isNotEmpty) {
      _swipeController.text = widget.transaction.ticketName!;
      _ticketNameValue = true;
    }

    // Prefill note if available
    if (widget.transaction.note != null &&
        widget.transaction.note!.isNotEmpty) {
      _noteController.text = widget.transaction.note!;
      _noteValue = true;
    }
    // Prefill loan value if available
    if (widget.transaction.isLoan != null) {
      _isLoan = widget.transaction.isLoan!;
    }
    // Prefill dueDate if available
    if (widget.transaction.dueDate != null) {
      _dueDate = widget.transaction.dueDate;
    }
  }

  @override
  void dispose() {
    _swipeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            constraints: BoxConstraints(
              maxWidth: 500,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF01B8E4).withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Ticket',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: const Color(0xFF01B8E4),
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close, color: Colors.black54),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                // Form content
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ticket Name Field
                            TextFormField(
                              controller: _swipeController,
                              decoration: InputDecoration(
                                labelText: 'Ticket Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter ticket name or swipe";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  _ticketNameValue = val.isNotEmpty;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Note Field
                            TextFormField(
                              controller: _noteController,
                              decoration: InputDecoration(
                                labelText: 'Notes',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a note";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  _noteValue = val.isNotEmpty;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Loan Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: _isLoan,
                                  onChanged: (val) {
                                    setState(() {
                                      _isLoan = val ?? false;
                                      // If checked, set default due date if not already set
                                      if (_isLoan && _dueDate == null) {
                                        _dueDate = DateTime.now().add(const Duration(days: 7));
                                      }
                                      // If unchecked, clear due date
                                      if (!_isLoan) {
                                        _dueDate = null;
                                      }
                                    });
                                  },
                                  activeColor: const Color(0xFF01B8E4),
                                ),
                                Text(
                                  'Mark as Loan',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (_isLoan)
                                  InkWell(
                                    onTap: () async {
                                      DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(const Duration(days: 365)),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          _dueDate = picked;
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.event, color: Colors.blue, size: 20),
                                        const SizedBox(width: 4),
                                        Text(
                                          _dueDate != null
                                              ? 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}'
                                              : 'Set Due Date',
                                          style: GoogleFonts.poppins(
                                            color: Colors.blue,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Footer with Save button
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.onClose,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black54,
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _ticketNameValue && _noteValue
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  // Set loan value and due date on transaction before saving
                                  widget.transaction.isLoan = _isLoan;
                                  widget.transaction.dueDate = _isLoan ? _dueDate : null;
                                  model.saveTicket(
                                    ticketName: _swipeController.text,
                                    transaction: widget.transaction,
                                    ticketNote: _noteController.text,
                                  );
                                  Navigator.of(context).pop();
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01B8E4),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: Text(
                          'Save Ticket',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
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
