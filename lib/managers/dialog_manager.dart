
import 'package:flipper/locator.dart';
import 'package:flipper/model/dialog_models.dart';
import 'package:flipper/services/dialog_service.dart';
import 'package:flutter/material.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final FlipperDialogService _dialogService = locator<FlipperDialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(request.title),
          content: Text(request.description),
          actions: <Widget>[
            if (isConfirmationDialog)
              FlatButton(
                child: Text(request.cancelTitle),
                onPressed: () {
                  _dialogService
                      .dialogComplete(DialogResponse(confirmed: false));
                },
              ),
            FlatButton(
              child: Text(request.buttonTitle),
              onPressed: () {
                _dialogService
                    .dialogComplete(DialogResponse(confirmed: true));
              },
            ),
          ],
        ),);
  }
}
