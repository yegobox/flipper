import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/splash/popup.dart';
import 'package:flipper/presentation/splash/popup_content.dart';
import 'package:flutter/material.dart';

class LandscapeButton extends StatefulWidget {
  LandscapeButton({Key key, this.showBottomSheetCallback}) : super(key: key);
  final VoidCallback showBottomSheetCallback;
  @override
  _LandscapeButtonState createState() => _LandscapeButtonState();
}

class _LandscapeButtonState extends State<LandscapeButton> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 1,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 20,
            ),
            Container(
              color: Colors.blue,
              child: SizedBox(
                width: 380,
                height: 60,
                child: FlatButton(
                  onPressed: widget.showBottomSheetCallback,
                  color: Colors.blue,
                  child: Text(
                    S.of(context).createAccount,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            Container(
              color: Colors.white,
              child: SizedBox(
                width: 380,
                height: 60,
                child: OutlineButton(
                  color: Colors.blue,
                  child: Text(
                    S.of(context).signIn,
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onPressed: widget.showBottomSheetCallback,
                ),
              ),
            ),
            Container(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          content: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }
}
