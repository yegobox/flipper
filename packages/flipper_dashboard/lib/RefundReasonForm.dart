import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';

class RefundReasonForm extends StatefulWidget {
  const RefundReasonForm({Key? key}) : super(key: key);

  @override
  _RefundReasonFormState createState() => _RefundReasonFormState();
}

class _RefundReasonFormState extends State<RefundReasonForm> {
  String? _selectedReason;

  static const List<String> reasonValues = ['01', '02', '03', '04', '05', '06'];

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
        decoration: InputDecoration(
          labelText: context.flipperL10n.refundReason,
        ),
        initialValue: _selectedReason,
        onChanged: _handleReasonChange,
        items: reasonValues.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(_reasonLabel(context, value)),
          );
        }).toList(),
      ),
    );
  }

  String _reasonLabel(BuildContext context, String value) {
    return switch (value) {
      '01' => context.flipperL10n.waitForApproval,
      '02' => context.flipperL10n.approved,
      '03' => context.flipperL10n.cancelRequested,
      '04' => context.flipperL10n.canceled,
      '05' => context.flipperL10n.refunded,
      '06' => context.flipperL10n.transferred,
      _ => value,
    };
  }
}
