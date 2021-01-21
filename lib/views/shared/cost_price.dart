
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';

class BuildCostPriceWidget extends StatefulWidget {
  const BuildCostPriceWidget(
      {Key key,
      @required this.vm,
      @required this.context,
      @required this.itemName,
      @required this.itemId})
      : super(key: key);

  final CommonViewModel vm;
  final int itemId;
  final String itemName;
  final BuildContext context;

  @override
  _BuildCostPriceWidgetState createState() => _BuildCostPriceWidgetState();
}

class _BuildCostPriceWidgetState extends State<BuildCostPriceWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black),
          onChanged: (costPrice) async {
//             ProductTableData item = await widget.vm.database.productDao.getItemBy(
//               name: widget.itemName,
// //              branchId: '001',
//               itemId: widget.itemId,
//             );

            // VariationTableData variation = await widget.vm.database.variationDao
            //     .getVariationBy('tmp', widget.vm.branch.id);

            // StoreProvider.of<AppState>(context).dispatch(
            //   SaveRegular(
            //     costPrice: double.parse(costPrice),
            //     retailPrice: 0,
            //     name: variation.name,
            //   ),
            // );
            //on typing here should save Regular Item variation
          },
          decoration: InputDecoration(
              hintText: 'Cost Price', focusColor: Colors.blue),
        ),
      ),
    );
  }
}
