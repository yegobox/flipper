import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/home/items/item_view_widget.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({Key key}) : super(key: key);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              Center(
                //search form.
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          validator: Validators.isStringHasMoreChars,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: vm.database.productDao
                      .getProductStream(branchId: vm.branch.id),
                  builder:
                      //todo: get item from couchdb, set type of item returned to Item make it common as ganza. then list item.
                      (context,
                          AsyncSnapshot<List<ProductTableData>> snapshot) {
                    if (snapshot.data == null) {
                      return Text("");
                    }

                    return ItemsView(
                      context: context,
                      data: snapshot.data,
                      vm: vm,
                      shouldSeeItem: false,
                      showCreateItemOnTop: false,
                      createButtonName: S.of(context).createNew,
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
