import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TTForm {
  String price;
  String sku;
  String description;
  String name;
}

class BuildRetailPriceWidget extends StatefulWidget {
  const BuildRetailPriceWidget({
    Key key,
    @required this.vm,
    @required this.context,
    @required this.itemName,
    @required this.itemId,
  }) : super(key: key);

  final CommonViewModel vm;
  final BuildContext context;
  final int itemId;
  final String itemName;

  @override
  _BuildRetailPriceWidgetState createState() => _BuildRetailPriceWidgetState();
}

class _BuildRetailPriceWidgetState extends State<BuildRetailPriceWidget> {
  final TTForm tForm = new TTForm();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black),
          onChanged: (retailPrice) async {},
          decoration: InputDecoration(
              hintText: S.of(context).retailPrice, focusColor: Colors.blue),
        ),
      ),
    );
  }
}
