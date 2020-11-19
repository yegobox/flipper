
import 'package:flipper/views/welcome/payable/payable_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NoteInput extends StatelessWidget {
  const NoteInput({
    String hint,
    this.validationMessage,
    Key key,
  })  : _hint = hint,
        super(key: key);

  final String _hint;
  final String validationMessage;

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, PayableViewModel model, Widget child) {
          return Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Container(
              width: double.infinity,
              child: TextFormField(
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.black),
                autofocus: true,
                controller: model.note,
                validator: (String value) {
                  if (value.isEmpty) {
                    return validationMessage;
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: _hint ?? ''),
              ),
            ),
          );
        },
        onModelReady: (PayableViewModel model) {
          model.initFields();
        },
        viewModelBuilder: () => PayableViewModel());
  }
}
