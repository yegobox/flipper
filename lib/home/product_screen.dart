import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/products/product_view_widget.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key key}) : super(key: key);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final bool _isEmpty = true;
  final bool _hasErrors = false;

  String _filterKey;

  @override
  Widget build(BuildContext context) {
    final InputDecorationTheme theme = _hasErrors
        ? AppTheme.inputDecorationErrorTheme
        : (_isEmpty
            ? AppTheme.inputDecorationEmptyTheme
            : AppTheme.inputDecorationFilledTheme);
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
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
                          onChanged: (String value) {
                            if (value != null || value != '') {
                              setState(() {
                                _filterKey = value;
                              });
                            }
                          },
                          style: GoogleFonts.lato(fontStyle: FontStyle.normal),
                          decoration: const InputDecoration(
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
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProductTableData>> products) {
                    List<ProductTableData> productfilter;
                    if (products.data == null) {
                      return const SizedBox.shrink();
                    }
                    if (_filterKey != null && _filterKey != '') {
                      productfilter = products.data
                          .where((ProductTableData element) => element.name
                              .toUpperCase()
                              .contains(_filterKey.toUpperCase()))
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
                      createButtonName: 'Create New',
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
