import 'package:customappbar/customappbar.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';

class CameraPreview extends StatefulWidget {
  CameraPreview({Key key, this.image}) : super(key: key);
  final dynamic image;

  @override
  _CameraPreviewState createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<CameraPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onPop: () {
          Routing.navigator.pop();
        },
        title: 'Preview',
        icon: Icons.keyboard_backspace,
        multi: 3,
        bottomSpacer: 52,
      ),
      body: Wrap(
        children: <Widget>[Image.file(widget.image)],
      ),
    );
  }
}
