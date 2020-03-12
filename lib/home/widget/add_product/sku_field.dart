import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SkuField extends StatefulWidget {
  SkuField({Key key}) : super(key: key);

  @override
  _SkuFieldState createState() => _SkuFieldState();
}

class _SkuFieldState extends State<SkuField> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return StreamBuilder(
          stream: vm.database.variationDao
              .getVariationByNameStream("Regular", vm.tmpItem.id),
          builder: (context, AsyncSnapshot<List<VariationTableData>> snapshot) {
            if (snapshot.data == null) {
              return Text("");
            }
            return snapshot.data == null
                ? Center(
                    child: Container(
                      width: 300,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        onChanged: (sku) {
                          setState(() {
                            DataManager.sku = sku;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: "SKU", focusColor: Colors.blue),
                      ),
                    ),
                  )
                : Text("");
          },
        );
      },
    );
  }
}
