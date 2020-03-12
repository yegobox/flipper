import 'package:flipper/generated/l10n.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';

class SupplyPrice extends StatefulWidget {
  SupplyPrice({Key key}) : super(key: key);
  @override
  _SupplyPriceState createState() => _SupplyPriceState();
}

class _SupplyPriceState extends State<SupplyPrice> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black),
          onChanged: (supplyPrice) async {
            if (supplyPrice != '' || supplyPrice == null) {
              setState(() {
                DataManager.supplyPrice = double.parse(supplyPrice);
              });
            }
          },
          decoration: InputDecoration(
              hintText: S.of(context).supplyPrice, focusColor: Colors.blue),
        ),
      ),
    );
  }
}
