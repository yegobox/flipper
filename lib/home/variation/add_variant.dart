
import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';

class AddVariant extends StatefulWidget {
  AddVariant({
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
    return Center(
      child: SizedBox(
        height: 50,
        width: 340,
        child: OutlineButton(
          color: HexColor('#ecf0f1'),
          child: Text('Add Variation'),
          onPressed: widget._onPressedCallback,
        ),
      ),
    );
  }
}
