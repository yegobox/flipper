import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/widget/add_product/variation_list.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flipper/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'widget/variant_widget.dart';

class TForm {
  String price;
  String sku;
  String description;
  String name;
}

class ViewSingleItemScreen extends StatefulWidget {
 const ViewSingleItemScreen({
    Key key,
    @required this.productId,
    @required this.itemName,
    @required this.itemColor,
  }) : super(key: key);
  final String productId;

  final String itemName;
  final String itemColor;

  @override
  _ViewSingleItemScreenState createState() => _ViewSingleItemScreenState();
}

class _ViewSingleItemScreenState extends State<ViewSingleItemScreen> {
  final TForm tForm =  TForm();
  

  ActionsTableData _actions;

  String _name;

  int _deleteCount;
  
  // ignore: always_specify_types
  final List<bool> _selections = List.generate(2, (int index) => false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _name = widget.itemName;
      _deleteCount = 0;
    });
    _getSaveStatus();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return VariantWidget(itemColor: widget.itemColor,vm: vm,itemName: widget.itemName,productId:widget.productId);
      },
    );
  }

  void _getSaveStatus() async {
    final ActionsTableData result = await StoreProvider.of<AppState>(context)
        .state
        .database
        .actionsDao
        .getActionBy('save');

    if (_name == null) {
      await StoreProvider.of<AppState>(context)
          .state
          .database
          .actionsDao
          .updateAction(result.copyWith(isLocked: true));
    } else {
      await StoreProvider.of<AppState>(context)
          .state
          .database
          .actionsDao
          .updateAction(result.copyWith(isLocked: false));
    }
    final ActionsTableData res = await StoreProvider.of<AppState>(context)
        .state
        .database
        .actionsDao
        .getActionBy('save');
    setState(() {
      _actions = res;
    });
  }

  Widget categorySelector(List<ProductTableData> item, CommonViewModel vm) {
    return StreamBuilder(
        stream:
            vm.database.categoryDao.getCategoryByIdStream(item[0].categoryId),
        builder: (context, AsyncSnapshot<List<CategoryTableData>> snapshot) {
          if (snapshot.data == null) {
            return Text('');
          }
          return Text(snapshot.data[0].name);
        });
  }

  
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: const Divider(
          color: Colors.black,
        ),
      ),
    );
  }
}
