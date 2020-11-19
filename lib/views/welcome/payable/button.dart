import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';

class button extends StatelessWidget {
  const button(
      {Key key,
      @required bool disableButton,
      @required Function onPressedCallback,
      @required String buttonName})
      : _disableButton = disableButton,
        _buttonName = buttonName,
        _onPressedCallback = onPressedCallback,
        super(key: key);

  final Function _onPressedCallback;
  final bool _disableButton;
  final String _buttonName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Container(
        color: _disableButton != null && _disableButton
            ? HexColor('#b2bec3')
            : HexColor('#0984e3'),
        child: FlatButton(
          onPressed: _disableButton ? null : _onPressedCallback,
          child: Text(
            _buttonName,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
