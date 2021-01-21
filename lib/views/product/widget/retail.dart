
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';

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
  final TTForm tForm = TTForm();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black),
          onChanged: (String retailPrice) async {},
          decoration: const InputDecoration(
              hintText: 'Retail Price', focusColor: Colors.blue),
        ),
      ),
    );
  }
}
