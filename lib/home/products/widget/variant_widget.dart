import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/functions.dart';
import 'package:flipper/home/products/view_single_item_view.dart';
import 'package:flipper/home/variations/variation_viewmodel.dart';
import 'package:flipper/home/widget/add_product/variation_list.dart';

import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class VariantWidget extends StatefulWidget {
  const VariantWidget(
      {Key key,
      @required this.itemColor,
      @required this.vm,
      @required this.itemName,
      @required this.productId})
      : super(key: key);
  final String itemColor;
  final CommonViewModel vm;
  final String itemName;
  final String productId;

  @override
  _VariantWidgetState createState() => _VariantWidgetState();
}

class _VariantWidgetState extends State<VariantWidget> {
  ActionsTableData _actions;

  int _deleteCount;
  final FlipperNavigationService _navigationService =
      ProxyService.nav;
  // ignore: always_specify_types
  final List<bool> _selections = List.generate(2, (int index) => false);

  String _name;


  Widget categorySelector(List<ProductTableData> item, CommonViewModel vm) {
    // TODO(richard): load from couchbase_lite
    return StreamBuilder(
        stream:
            vm.database.categoryDao.getCategoryByIdStream(item[0].categoryId),
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoryTableData>> snapshot) {
          if (snapshot.data == null) {
            return const Text('');
          }
          return Text(snapshot.data[0].name);
        });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VariationViewModel>.reactive(
      viewModelBuilder: () => VariationViewModel(),
      onModelReady: (VariationViewModel model) => model.getProducts(),
      builder: (BuildContext context, VariationViewModel model, Widget child) {
        if (model.busy) {
          return const CircularProgressIndicator();
        }
        return WillPopScope(
          onWillPop: onWillPop,
          child: Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                Routing.navigator.pop();
              },
              title: 'Edit Item',
              disableButton: _actions == null ? true : _actions.isLocked,
              showActionButton: true,
              onPressedCallback: () async {
                model.handleEditItem(selections: _selections);
              },
              actionButtonName: 'Save',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigationService.navigateTo(Routing.editItemTitle);
                      },
                      child: Container(
                          height: 80,
                          width: 80,
                          color: HexColor(widget.vm.currentColor == null
                              ? widget.itemColor
                              : widget.vm.currentColor.hexCode)),
                    ),
                    const Text('New Item'),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          initialValue: widget.itemName,
                          style: const TextStyle(color: Colors.black),
                          validator: Validators.isValid,
                          onChanged: (String name) async {
                            // TODO(richard):
                          },
                          decoration: const InputDecoration(
                              hintText: 'Name', focusColor: Colors.black),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: GestureDetector(
                          onTap: () {
                            _navigationService.navigateTo(
                              Routing.editCategoryScreen,
                              arguments: EditCategoryScreenArguments(
                                productId: widget.productId,
                              ),
                            );
                          },
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0.3),
                            leading: const Text('Category'),
                            trailing: Wrap(
                              children: <Widget>[
                                StreamBuilder(
                                  stream: widget.vm.database.productDao
                                      .getItemByIdStream(widget.productId),
                                  builder: (context,
                                      AsyncSnapshot<List<ProductTableData>>
                                          snapshot) {
                                    if (snapshot.data == null ||
                                        snapshot.data.isEmpty) {
                                      return const Text('Select Category');
                                    }
                                    return snapshot.data == null ||
                                            snapshot.data.isEmpty
                                        ? const Text('Select Category')
                                        : categorySelector(
                                            snapshot.data, widget.vm);
                                  },
                                ),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: const Divider(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      height: 24,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: const Text('PRICE AND INVENTORY'),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: const Divider(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: GestureDetector(
                          onTap: () {
                            _navigationService.navigateTo(Routing.editUnitType,
                                arguments: EditUnitTypeScreenArguments(
                                    itemId: widget.productId));
                          },
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0.3),
                            leading: const Text('Unit Type'),
                            trailing: Wrap(
                              children: <Widget>[
                                // FIXME(ricahrd):
                                StreamBuilder(
                                    stream: widget.vm.database.productDao
                                        .getItemByIdStream(widget.productId),
                                    builder: (context,
                                        AsyncSnapshot<List<ProductTableData>>
                                            item) {
                                      if (item.data == null) {
                                        return Text('');
                                      }
                                      if (item.data.length == 0) {
                                        return Text('');
                                      }

                                      return StreamBuilder(
                                          stream: widget.vm.database.unitDao
                                              .getUnitStream(
                                                  item.data[0].idLocal),
                                          builder: (context,
                                              AsyncSnapshot<List<UnitTableData>>
                                                  unit) {
                                            if (unit.data == null) {
                                              return Text('');
                                            }
                                            return Text(unit.data[0].name);
                                          });
                                    }),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const CustomDivider(),
                    VariationList(
                      productId: widget.productId,
                    ),
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 340,
                        child: OutlineButton(
                          color: HexColor('#ecf0f1'),
                          child: const Text('Add Variation'),
                          onPressed: () async {
                            if (_actions != null) {
                              // FIXME(richard): change storage
                              widget.vm.database.actionsDao.updateAction(
                                  _actions.copyWith(isLocked: true));

                              Routing.navigator
                                  .pushNamed(Routing.addVariationScreen);
                            }
                          },
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      trailing: ToggleButtons(
                        children: [
                          const Text('18%'),
                          const Text('0%'),
                        ],
                        isSelected: _selections,
                        onPressed: (int index) {
                          setState(() {
                            _selections[index] = !_selections[index];
                          });
                        },
                      ),
                      leading: const Text('Tax'),
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      color: _deleteCount == 1
                          ? Colors.redAccent[700]
                          : Colors.white,
                      width: 340,
                      child: OutlineButton(
                        onPressed: () {
                          setState(() {
                            _deleteCount += 1;
                          });
                          if (_deleteCount == 2) {
                            // TODO(richard): pass real productId
                            model.closeAndDelete(context: context,productId:'1');
                          }
                        },
                        child: Text('Delete Item',
                            style: TextStyle(
                                color: _deleteCount == 1
                                    ? Colors.white
                                    : Colors.black)),
                      ),
                    ),
                    Container(
                      height: 64,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
