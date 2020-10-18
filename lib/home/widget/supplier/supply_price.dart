import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';

class SupplyPrice extends StatefulWidget {
  const SupplyPrice({Key key, this.vm}) : super(key: key);
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
            color: Theme.of(context).accentColor,
            fontSize: Theme.of(context).textTheme.bodyText1
                .copyWith(fontSize: 12)
                .fontSize,
          ),
          onChanged: (String supplyPrice) async {
            if (supplyPrice != '' || supplyPrice == null) {
              final Store<AppState> store = StoreProvider.of<AppState>(context);
              final VariationTableData variation = await widget
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
          decoration: const InputDecoration(
              hintText: 'Suply Price', focusColor: Colors.blue),
        ),
      ),
    );
  }
}
