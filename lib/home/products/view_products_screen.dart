import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/home/products/product_view_widget.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ViewProductsScreen extends StatefulWidget {
  ViewProductsScreen({Key key}) : super(key: key);

  @override
  _ViewProductsScreenState createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Routing.navigator.pop();
            },
            title: S.of(context).allItems,
            showActionButton: false,
            onPressedCallback: () async {},
            icon: Icons.close,
            multi: 1,
            bottomSpacer: 48,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                  stream: vm.database.productDao
                      .getProductStream(branchId: vm.branch.id),
                  builder: (context,
                      AsyncSnapshot<List<ProductTableData>> products) {
                    if (products.data == null) {
                      return Text('');
                    }
                    return ProductsView(
                      context: context,
                      shouldSeeItem: true,
                      data: products.data,
                      vm: vm,
                      showCreateItemOnTop: true,
                      createButtonName: S.of(context).createItem,
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
