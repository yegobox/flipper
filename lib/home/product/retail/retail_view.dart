import 'package:flutter/material.dart';

class RetailView extends StatefulWidget {
  const RetailView({Key key}) : super(key: key);
  @override
  _RetailViewState createState() => _RetailViewState();
  
}

class _RetailViewState extends State<RetailView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (String retailPrice) async {
            // FIXME
            // if (retailPrice != '' || retailPrice == null) {
            //   final Store<AppState> store = StoreProvider.of<AppState>(context);
            //   final VariationTableData variation = await widget
            //       .vm.database.variationDao
            //       .getVariationById(variantId: widget.vm.variant.id);

            //   await DataManager.updateVariation(
            //     variation: variation,
            //     store: store,
            //     variantName: 'Regular',
            //     retailPrice: double.parse(retailPrice),
            //   );
            //   setState(() {
            //     DataManager.retailPrice = double.parse(retailPrice);
            //   });
            // } else {
            //   setState(() {
            //     DataManager.retailPrice = 0.0;
            //   });
            // }
          },
          decoration: const InputDecoration(
              hintText: 'Retail Price', focusColor: Colors.blue),
        ),
      ),
    );
  }
}
