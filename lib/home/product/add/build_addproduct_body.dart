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
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_product_viewmodel.dart';

class BuildAddProductBody extends StatelessWidget {
  const BuildAddProductBody({Key key, this.vm}) : super(key: key);
  final CommonViewModel vm;


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddProductViewmodel>.reactive(
      viewModelBuilder: () => AddProductViewmodel(),
      onModelReady: (AddProductViewmodel model) {
        model.getTemporalProduct(vm: vm,context: context);
        model.initFields(TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController());
      },
      builder: (BuildContext context, AddProductViewmodel model, Widget child) {
        if(model.busy){
          return const SizedBox.shrink();
        }
        return WillPopScope(
          onWillPop: model.onWillPop,
          child: Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Create Product',
              disableButton: model.isLocked,
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
                   const Text(
                      'Product'
                    ),
                    //nameField
                    Padding(
                      padding: const EdgeInsets.only(left:18,right:18),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          style: Theme.of(context).textTheme.bodyText1.copyWith(color:Colors.black),
                          controller: model.nameController,
                          validator: Validators.isValid,
                          onChanged: (String name) async {
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
                    const CategorySection(),
                    const CenterDivider(
                      width: 300,
                    ),
                    const ListDivider(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:18,right:18),
                      child: Container(
                        width: double.infinity,
                        child:const Text(
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
                    RetailPriceWidget(
                      models: model, //add productmodel
                    ),
                    const CenterDivider(
                      width: double.infinity,
                    ),
                    SupplyPriceWidget(
                      vm: vm,
                      addModel: model,
                    ),
                    
                    const SkuView(),
                    VariationList(productId: vm.tmpItem.id),
                    AddVariant(
                      onPressedCallback: () {
                        model.createVariant(productId:model.productId);
                      },
                    ),
                     const CenterDivider(
                      width: double.infinity,
                    ),
                    DescriptionWidget(model:model)
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
