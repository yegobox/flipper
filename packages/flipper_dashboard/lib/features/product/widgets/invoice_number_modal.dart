import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

class InvoiceNumberModal extends StatefulWidget {
  const InvoiceNumberModal({Key? key}) : super(key: key);

  @override
  State<InvoiceNumberModal> createState() => _InvoiceNumberModalState();
}

class _InvoiceNumberModalState extends State<InvoiceNumberModal> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleCancel(BuildContext context) {
    Navigator.pop(context); // Close invoice modal
    toast("Product Saved Successfully");
    Navigator.maybePop(context); // Close the parent DesktopProductAdd modal
  }

  void _handleSuccess(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final number = int.parse(_controller.text);
      Navigator.pop(context, number); // Close invoice modal
      toast("Product Saved Successfully");
      Navigator.maybePop(context); // Close the parent DesktopProductAdd modal
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Assign this with existing invoice number?'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Invoice Number',
            hintText: 'Enter the invoice number',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an invoice number';
            }
            return null;
          },
          onFieldSubmitted: (_) => _handleSuccess(context),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _handleCancel(context),
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () => _handleSuccess(context),
          child: const Text('Yes'),
        ),
      ],
    );
  }
}

Future<int?> showInvoiceNumberModal(BuildContext context) {
  return showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => const InvoiceNumberModal(),
  );
}
