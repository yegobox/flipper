import 'package:flipper/localization.dart';
import 'package:flipper/routes.logger.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'create/build_image_holder.dart';
import 'create/category_selector.dart';
import 'create/divider.dart';
import 'create/retail_price.dart';
import 'create/section_select_unit.dart';
import 'create/supply_price_widget.dart';
import 'create/variation_list.dart';
import 'customappbar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:intl/intl.dart';

class AddProductView extends StatelessWidget {
  AddProductView({Key? key}) : super(key: key);
  final log = getLogger('AddProductView');
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      // ignore: todo
      // TODO:show a modal for confirming if we want to exit
      return false;
    }

    return ViewModelBuilder<ProductViewModel>.reactive(
      onModelReady: (model) {
        model.createTemporalProduct();
        model.loadCategories();
        model.loadColors();
        model.loadUnits();
        //start locking the save button
        model.setName(name: ' ');
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: CustomAppBar(
              onPop: () async {
                await model.loadProducts();
                ProxyService.nav.back();
              },
              title: 'Create Product',
              disableButton: model.lock,
              showActionButton: true,
              onPressedCallback: () async {
                await model.addProduct(mproduct: model.product.toJson());
                await model.loadProducts();
                ProxyService.nav.back();
              },
              rightActionButtonName: 'Save',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 50,
            ),
            body: ListView(
              physics: const AlwaysScrollableScrollPhysics(), // new
              children: <Widget>[
                Column(children: <Widget>[
                  verticalSpaceSmall,
                  model.product == null
                      ? SizedBox.shrink()
                      : ImagePlaceHolderView(
                          currentColor: model.currentColor,
                          product: model.product,
                        ),
                  const Text('Product'),
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.black),
                        // validator: Validators.isValid,
                        onChanged: (String name) async {
                          model.setName(name: name);
                        },
                        decoration: InputDecoration(
                          hintText: Localization.of(context)!.productName,
                          fillColor: Theme.of(context)
                              .copyWith(canvasColor: Colors.white)
                              .canvasColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor('#D0D7E3')),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CategorySelector(categories: model.categories),
                  verticalSpaceSmall,
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
                  model.product == null
                      ? SizedBox.shrink()
                      : SectionSelectUnit(
                          product: model.product,
                          type: 'product',
                        ),
                  verticalSpaceSmall,
                  verticalSpaceSmall,
                  RetailPrice(onModelUpdate: (value) {
                    if (value.length > 0) {
                      model.updateRegularVariant(
                          retailPrice: double.parse(value));
                    }
                  }),
                  verticalSpaceSmall,
                  SupplyPrice(onModelUpdate: (value) {
                    model.updateRegularVariant(
                        supplyPrice: double.parse(value));
                  }),
                  verticalSpaceSmall,
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: BoxButton.outline(
                      onTap: () {
                        DatePicker.showPicker(context, showTitleActions: true,
                            onChanged: (date) {
                          log.i('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          model.updateExpiryDate(date);
                        }, locale: LocaleType.en);
                      },
                      title: (model.product == null ||
                              (model.product != null &&
                                  model.product.expiryDate == null))
                          ? 'Add Expiry Date (optional)'
                          : 'Expires at ' +
                              formatter.format(
                                  DateTime.parse(model.product.expiryDate)),
                    ),
                  ),
                  verticalSpaceSmall,
                  verticalSpaceSmall,
                  model.variants == null
                      ? SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: VariationList(
                            variations: model.variants!,
                            model: model,
                            deleteVariant: (id) {
                              model.deleteVariant(id: id);
                            },
                          ),
                        ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18, right: 18, top: 10),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: OutlineButton(
                        child: const Text('Add Variation'),
                        onPressed: () {
                          model.navigateAddVariation(
                              productId: model.product.id);
                        },
                      ),
                    ),
                  ),
                ])
              ],
            ),
          ),
        );
      },
    );
  }
}
