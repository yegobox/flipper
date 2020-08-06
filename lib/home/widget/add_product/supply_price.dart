import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/theme.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class SupplyPrice extends StatefulWidget {
  SupplyPrice({Key key, this.vm}) : super(key: key);
  @override
  _SupplyPriceState createState() => _SupplyPriceState();
  final CommonViewModel vm;
}

class _SupplyPriceState extends State<SupplyPrice> {
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
          onChanged: (supplyPrice) async {
            if (supplyPrice != '' || supplyPrice == null) {
              final store = StoreProvider.of<AppState>(context);
              VariationTableData variation = await widget
                  .vm.database.variationDao
                  .getVariationById(variantId: widget.vm.variant.id);
              await DataManager.updateVariation(
                variation: variation,
                store: store,
                variantName: 'Regular',
                supplyPrice: double.parse(supplyPrice),
              );
              setState(() {
                DataManager.supplyPrice = double.parse(supplyPrice);
              });
            } else {
              setState(() {
                DataManager.supplyPrice = 0.0;
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
