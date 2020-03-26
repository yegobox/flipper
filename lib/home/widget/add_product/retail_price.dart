import 'package:flipper/generated/l10n.dart';
import 'package:flipper/theme.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          style: GoogleFonts.lato(
            fontStyle: FontStyle.normal,
            color: AppTheme.addProduct.accentColor,
            fontSize: AppTheme.addProduct.textTheme.bodyText1
                .copyWith(fontSize: 12)
                .fontSize,
          ),
          onChanged: (retailPrice) async {
            if (retailPrice != '' || retailPrice == null) {
              setState(() {
                DataManager.retailPrice = double.parse(retailPrice);
              });
            } else {
              setState(() {
                DataManager.retailPrice = 0.0;
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
