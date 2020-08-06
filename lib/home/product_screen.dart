import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/home/products/product_view_widget.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/theme.dart';
import 'package:flipper/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({Key key}) : super(key: key);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isEmpty = true;
  bool _hasErrors = false;

  String _filter_key;

  @override
  Widget build(BuildContext context) {
    final theme = _hasErrors
        ? AppTheme.inputDecorationErrorTheme
        : (_isEmpty
            ? AppTheme.inputDecorationEmptyTheme
            : AppTheme.inputDecorationFilledTheme);
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
                        width: 400,
                        child: TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          maxLength: 20,
                          enabled: true,
                          onChanged: (value) {
                            if (value != null || value != '') {
                              setState(() {
                                _filter_key = value;
                              });
                            }
                          },
                          style: GoogleFonts.lato(fontStyle: FontStyle.normal),
                          decoration: InputDecoration(
                            hintText: 'Search',
                          ).applyDefaults(theme),
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
                  builder: (context,
                      AsyncSnapshot<List<ProductTableData>> products) {
                    List<ProductTableData> productfilter;
                    if (products.data == null) {
                      return Text('');
                    }
                    if (_filter_key != null && _filter_key != '') {
                      productfilter = products.data
                          .where((element) => element.name
                              .toUpperCase()
                              .contains(_filter_key.toUpperCase()))
                          .toList();
                    } else {
                      productfilter = products.data;
                    }

                    return ProductsView(
                      context: context,
                      data: productfilter,
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
