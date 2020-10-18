import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SkuField extends StatefulWidget {
  const SkuField({Key key}) : super(key: key);

  @override
  _SkuFieldState createState() => _SkuFieldState();
}

class _SkuFieldState extends State<SkuField> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
           return const Text('sku field');
        // FIXME (richard):
        // return StreamBuilder(
        //   stream: vm.database.variationDao
        //       .getVariationByNameStream('Regular', vm.tmpItem.id),
        //   builder: (BuildContext context, AsyncSnapshot<List<VariationTableData>> snapshot) {
        //     if (snapshot.data == null) {
        //       return const SizedBox.shrink();
        //     }
        //     return snapshot.data == null
        //         ? Center(
        //             child: Container(
        //               width: 300,
        //               child: TextFormField(
        //                 style: const TextStyle(color: Colors.black),
        //                 onChanged: (String sku) {
        //                   setState(() {
        //                     DataManager.sku = sku;
        //                   });
        //                 },
        //                 decoration: const InputDecoration(
        //                     hintText: 'SKU', focusColor: Colors.blue),
        //               ),
        //             ),
        //           )
        //         : const SizedBox.shrink();
        //   },
        // );
      },
    );
  }
}
