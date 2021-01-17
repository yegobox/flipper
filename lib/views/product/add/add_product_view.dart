import 'package:customappbar/customappbar.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/views/category/category_view.dart';
import 'package:flipper/views/product/add/add_product_viewmodel.dart';
import 'package:flipper/views/shared/divider.dart';
import 'package:flipper/views/shared/description.dart';
import 'package:flipper/views/shared/list_divider.dart';
import 'package:flipper/views/product/retail/retail_price.dart';
import 'package:flipper/views/product/section_select_unit.dart';
import 'package:flipper/views/product/sku/sku_view.dart';
import 'package:flipper/views/shared/build_image_holder.dart';
import 'package:flipper/views/supplier/supply_price_widget.dart';
import 'package:flipper/views/variation/add_variant.dart';
import 'package:flipper/views/variation/variation_list.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/validators.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

// NOTE: this is to add a product and there related variants.
class AddProductView extends StatelessWidget {
  const AddProductView({Key key}) : super(key: key);
  Future<bool> _onWillPop(
      {BuildContext context, AddProductViewmodel model}) async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'Do you want to exit',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {},
                child: const Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  model.onClose();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddProductViewmodel>.reactive(
      viewModelBuilder: () => AddProductViewmodel(),
      onModelReady: (AddProductViewmodel model) {
        model.getTemporalProduct();
      },
      builder: (BuildContext context, AddProductViewmodel model, Widget child) {
        if (model.product == null) {
          //NOTE: fix this problem
          return const SizedBox.shrink();
        }
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Create Product',
              disableButton: model.isLocked,
              showActionButton: true,
              onPressedCallback: () async {
                await model.handleCreateItem();
                ProxyService.nav.pop();
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
                    ImagePlaceHolderView(),
                    const Text('Product'),
                    //nameField
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.black),
                          validator: Validators.isValid,
                          onChanged: (String name) async {
                            model.setName(name: name);
                            model.lock();
                          },
                          decoration: InputDecoration(
                            hintText: 'Product name',
                            fillColor: Theme.of(context)
                                .copyWith(canvasColor: Colors.white)
                                .canvasColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor('#D0D7E3')),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    CategoryView(),

                    const CenterDivider(
                      width: 300,
                    ),
                    const ListDivider(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: Container(
                        width: double.infinity,
                        child: const Text(
                          'PRICE AND INVENTORY',
                        ),
                      ),
                    ),
                    const CenterDivider(
                      width: double.infinity,
                    ),
                    const SectionSelectUnit(),
                    const CenterDivider(
                      width: double.infinity,
                    ),
                    RetailPrice(
                      models: model, //add product model
                    ),
                    const CenterDivider(
                      width: double.infinity,
                    ),
                    SupplyPrice(
                      addModel: model,
                    ),
                    GestureDetector(
                      onTap: () {
                        ProxyService.nav.navigateTo(
                          Routing.receiveStock,
                          arguments: ReceiveStockScreenArguments(
                            id: model.sharedStateService.variation.id,
                          ),
                        ); //passing a regular variantId to update
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 18, right: 18),
                        child: ListTile(
                          leading: Text('Stock'),
                          trailing: Text('Add Stock',
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ),
                    const SkuView(),
                    const ListDivider(
                      height: 10,
                    ),
                    // StockView(productId: model.product.id),
                    const ListDivider(
                      height: 10,
                    ),
                    const VariationList(),

                    AddVariant(
                      onPressedCallback: () {
                        model.createVariant(
                            productId: model.sharedStateService.product.id);
                      },
                    ),
                    const CenterDivider(
                      width: double.infinity,
                    ),
                    DescriptionWidget(model: model)
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
