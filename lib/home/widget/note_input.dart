import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/home/common_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NoteInput extends StatelessWidget {
  final String _hint;
  final String validationMessage;
  const NoteInput({
    String hint,
    this.validationMessage,
    Key key,
  })  : _hint = hint,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            width: 300,
            child: TextFormField(
              style: TextStyle(color: Colors.black),
              autofocus: true,
              validator: (value) {
                if (value.isEmpty) {
                  return this.validationMessage;
                }
                return null;
              },
              onChanged: (note) async {
                final store = StoreProvider.of<AppState>(context);
                store.dispatch(Note(note: note));
              },
              decoration: InputDecoration(hintText: _hint ?? ''),
            ),
          ),
        );
      },
    );
  }
}
