import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_ui/dialogs/SharedTicketDialog.dart';
import 'package:flutter/material.dart';

class NewTicket extends StatelessWidget {
  const NewTicket({Key? key, required this.transaction, required this.onClose})
    : super(key: key);

  final ITransaction transaction;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SharedTicketDialog(transaction: transaction, onClose: onClose);
  }
}
