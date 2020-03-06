import 'package:flipper/home/widget/loader.dart';
import 'package:flipper/managers/loader_model.dart';
import 'package:flutter/material.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();
  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog() {
    Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Material(
        type: MaterialType.transparency,
        child: Loader(
          radius: 60.0,
          dotRadius: 6.0,
        ), //put my Loader here
      ),
    );
  }
}
