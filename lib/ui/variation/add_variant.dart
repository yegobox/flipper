import 'package:flutter/material.dart';

class AddVariant extends StatefulWidget {
  const AddVariant({
    Key key,
    Function onPressedCallback,
  })  : _onPressedCallback = onPressedCallback,
        super(key: key);
  final Function _onPressedCallback;
  @override
  _AddVariantState createState() => _AddVariantState();
}

class _AddVariantState extends State<AddVariant> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18,top:10),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: OutlineButton(
          child: const Text('Add Variation'),
          onPressed: widget._onPressedCallback,
        ),
      ),
    );
  }
}
