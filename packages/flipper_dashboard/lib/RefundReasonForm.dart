import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';

class RefundReasonForm extends StatefulWidget {
  const RefundReasonForm({Key? key}) : super(key: key);

  @override
  _RefundReasonFormState createState() => _RefundReasonFormState();
}

class _RefundReasonFormState extends State<RefundReasonForm> {
  String? _selectedReason;

  final List<Map<String, String>> reasons = [
    {'value': '01', 'label': 'Wait for Approval'},
    {'value': '02', 'label': 'Approved'},
    {'value': '03', 'label': 'Cancel Requested'},
    {'value': '04', 'label': 'Canceled'},
    {'value': '05', 'label': 'Refunded'},
    {'value': '06', 'label': 'Transferred'},
  ];

  void _handleReasonChange(String? value) {
    setState(() {
      _selectedReason = value;
    });
    if (value != null) {
      ProxyService.box.writeString(key: 'getRefundReason', value: value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Refund Reason',
        ),
        value: _selectedReason,
        onChanged: _handleReasonChange,
        items: reasons.map((Map<String, String> reason) {
          return DropdownMenuItem<String>(
            value: reason['value'],
            child: Text(reason['label']!),
          );
        }).toList(),
      ),
    );
  }
}
