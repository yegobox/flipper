import 'package:customappbar/customappbar.dart';
import 'package:flipper/home/category/category_section.dart';
import 'package:flipper/home/product/center_divider.dart';
import 'package:flipper/home/product/description_widget.dart';
import 'package:flipper/home/product/list_divider.dart';
import 'package:flipper/home/product/retail/retail_price_widget.dart';
import 'package:flipper/home/product/section_select_unit.dart';
import 'package:flipper/home/product/sku/sku_view.dart';
import 'package:flipper/home/product/widget/build_image_holder.dart';
import 'package:flipper/home/variation/add_variant.dart';
import 'package:flipper/home/variation/variation_list.dart';
import 'package:flipper/home/widget/supplier/supply_price_widget.dart';

import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'add_product_viewmodel.dart';

class BuildAddProductBody extends StatelessWidget {
  const BuildAddProductBody({Key key, this.vm}) : super(key: key);
  final CommonViewModel vm;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddProductViewmodel>.reactive(
      viewModelBuilder: () => AddProductViewmodel(),
      onModelReady: (AddProductViewmodel model) => model.getTemporalProduct(vm: vm,context: context),
      builder: (BuildContext context, AddProductViewmodel model, Widget child) {
        if(model.busy){
          return const CircularProgressIndicator();
        }
        return WillPopScope(
          onWillPop: model.onWillPop,
          child: Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Create Product',
              disableButton: model.action == null ? true : model.isLocked,
              showActionButton: true,
              onPressedCallback: () async {
                await model.handleCreateItem(vm: vm);
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
                    BuildImageHolder(
                      vm: vm,
                    ),
                    Text(
                      'Product',
                      style: GoogleFonts.lato(
                        fontStyle: FontStyle.normal,
                        color: Theme.of(context).accentColor,
                        fontSize:
                            Theme.of(context).textTheme.bodyText1.fontSize,
                      ),
                    ),
                    //nameField
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          style: GoogleFonts.lato(
                            fontStyle: FontStyle.normal,
                            color: Theme.of(context).accentColor,
                            fontSize:
                                Theme.of(context).textTheme.bodyText1.fontSize,
                          ),
                          validator: Validators.isValid,
                          onChanged: (String name) async {
                            await model.updateNameField(name, vm);
                          },
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            focusColor: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const CategorySection(),
                    CenterDivider(
                      width: 300,
                    ),
                    const ListDivider(
                      height: 24,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: Text(
                          'PRICE AND INVENTORY',
                          style: GoogleFonts.lato(
                            fontStyle: FontStyle.normal,
                            color: Theme.of(context).accentColor,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 12)
                                .fontSize,
                          ),
                        ),
                      ),
                    ),

                    CenterDivider(
                      width: 300,
                    ),
                    const SectionSelectUnit(),
                    Center(
                      child: Container(
                        width: 300,
                        child: const Divider(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    RetailPriceWidget(
                      productId: model.productId,
                    ),
                    SupplyPriceWidget(
                      vm: vm,
                    ),
                    const SkuView(),
                    VariationList(productId: vm.tmpItem.id),
                    AddVariant(
                      onPressedCallback: () {
                        model.createVariant(vm);
                      },
                    ),
                    DescriptionWidget()
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
