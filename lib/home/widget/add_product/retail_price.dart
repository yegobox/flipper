import 'package:flipper/generated/l10n.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';

class RetailPrice extends StatefulWidget {
  RetailPrice({Key key}) : super(key: key);
  @override
  _RetailPriceState createState() => _RetailPriceState();
}

class _RetailPriceState extends State<RetailPrice> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black),
          onChanged: (retailPrice) async {
            if (retailPrice != '' || retailPrice == null) {
              setState(() {
                DataManager.retailPrice = double.parse(retailPrice);
              });
            }
          },
          decoration: InputDecoration(
              hintText: S.of(context).retailPrice, focusColor: Colors.blue),
        ),
      ),
    );
  }
}
