import 'package:customappbar/customappbar.dart';

import 'package:flipper/domain/redux/functions.dart';

import 'package:flipper/views/variation/variation_list.dart';
import 'package:flipper_models/view_models/variation_viewmodel.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'build_variation_body.dart';

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
  int _deleteCount;
  final FlipperNavigationService _navigationService = ProxyService.nav;
  // ignore: always_specify_types
  final List<bool> _selections = List.generate(2, (int index) => false);

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
            appBar: CustomAppBar(
              onPop: () {
                Routing.navigator.pop();
              },
              title: 'Edit Item',
              disableButton: true,
              showActionButton: true,
              onPressedCallback: () async {
                model.handleEditItem(selections: _selections);
              },
              rightActionButtonName: 'Save',
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
                          color: HexColor(
                              model.sharedStateService.currentColor == null
                                  ? widget.itemColor
                                  : model
                                      .sharedStateService.currentColor.name)),
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
                                BuildVariationBody(
                                  productId: widget.productId,
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
                                arguments: EditUnitViewArguments(
                                    itemId: widget.productId));
                          },
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0.3),
                            leading: const Text('Unit Type'),
                            trailing: Wrap(
                              children: <Widget>[
                                // ignore: prefer_const_literals_to_create_immutables
                                // FIXME(richard):
                                // StreamBuilder(
                                //     stream: widget.vm.database.productDao
                                //         .getItemByIdStream(widget.productId),
                                //     builder: (context,
                                //         AsyncSnapshot<List<ProductTableData>>
                                //             item) {
                                //       if (item.data == null) {
                                //         return Text('');
                                //       }
                                //       if (item.data.length == 0) {
                                //         return Text('');
                                //       }

                                //       return StreamBuilder(
                                //           stream: widget.vm.database.unitDao
                                //               .getUnitStream(
                                //                   item.data[0].idLocal),
                                //           builder: (context,
                                //               AsyncSnapshot<List<UnitTableData>>
                                //                   unit) {
                                //             if (unit.data == null) {
                                //               return Text('');
                                //             }
                                //             return Text(unit.data[0].name);
                                //           });
                                //     }),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 5),
                    const VariationList(),
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 340,
                        child: OutlineButton(
                          color: HexColor('#ecf0f1'),
                          child: const Text('Add Variation'),
                          onPressed: () async {
                            // if (_actions != null) {

                            // FIXME(richard): change storage
                            // widget.vm.database.actionsDao.updateAction(
                            //     _actions.copyWith(isLocked: true));

                            // Routing.navigator
                            //     .pushNamed(Routing.addVariationScreen);
                            // }
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
                            model.closeAndDelete(
                                context: context, productId: '1');
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
