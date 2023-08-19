import 'package:flutter/material.dart';
import 'package:flipper_ui/flipper_ui.dart';

class MemberField extends StatelessWidget {
  MemberField(
      {Key? key,
      required this.trailingTapped,
      required this.inputChange,
      required this.controller})
      : super(key: key);
  final Function trailingTapped;
  final Function inputChange;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BoxInputField(
        controller: controller,
        trailing: Icon(Icons.clear_outlined),
        // leading: Icon(Icons.reset_tv),
        trailingTapped: () {
          trailingTapped();
        },

        /// then this will mean that on each field
        /// it will keep adding the additional field
        /// so I have to comeup with something like
        /// if the field is !empty then call add Field
        /// and only add the field only when char.leng ==1
        /// this is to know when to stop adding additional field
        /// and when is empty remove the previously added field.
        onChanged: (v) {
          inputChange(v);
        },
        placeholder: 'Add member',
      ),
    );
  }
}
