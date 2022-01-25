import 'package:localize/localize.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'create/build_image_holder.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/routes.router.dart';
import 'create/category_selector.dart';
import 'create/divider.dart';
import 'create/retail_price.dart';
import 'create/section_select_unit.dart';
import 'create/supply_price_widget.dart';
import 'create/variation_list.dart';
import 'customappbar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddProductView extends StatefulWidget {
  AddProductView({Key? key, this.productId}) : super(key: key);
  final int? productId;

  @override
  _AddProductViewState createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final log = getLogger('AddProductView');

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  TextEditingController barCode = TextEditingController();

  TextEditingController productName = TextEditingController(text: '');

  TextEditingController retailPriceController = TextEditingController(text: '');

  TextEditingController supplyPriceController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      // ignore: todo
      // TODO:show a modal for confirming if we want to exit
      return false;
    }

    return ViewModelBuilder<ProductViewModel>.reactive(
      onModelReady: (model) async {
        // start by reseting bar code.
        if (SchedulerBinding.instance?.schedulerPhase ==
            SchedulerPhase.persistentCallbacks) {
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            model.productService.setBarcode('');
          });
        }

        await model.loadTemporalproductOrEditIfProductIdGiven(
            productId: widget.productId);
        model.loadCategories();
        model.loadColors();
        model.loadUnits();
        //start locking the save button
        model.setName(name: ' ');

        /// get the regular variant then get it's price to fill in the form when we are in edit mode!
        /// normal this is a List of variants where match the productId and take where we have the regular variant
        if (widget.productId != null) {
          log.i(widget.productId);
          List<VariantSync> variants = ProxyService.api
              .getVariantByProductId(productId: widget.productId!);
          //filter the variants where we have the regular variant and get one of them
          VariantSync regularVariant =
              variants.firstWhere((variant) => variant.name == 'Regular');

          productName.text = model.kProductName;

          if (regularVariant.retailPrice.toString() != '0.0') {
            retailPriceController.text = regularVariant.retailPrice.toString();

            model.isPriceSet(true);
          }
          if (regularVariant.supplyPrice.toString() != '0.0') {
            supplyPriceController.text = regularVariant.supplyPrice.toString();
          }
        }
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
                await model.addProduct(
                    mproduct: model.product.toJson(), name: productName.text);
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
                      : ColorAndImagePlaceHolder(
                          currentColor: model.currentColor,
                          product: model.product,
                        ),
                  const Text('Product'),
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.black,
                            ),
                        controller: productName,
                        onChanged: (value) {
                          /// for locking on unlocking the save button
                          model.setName(name: value);
                        },
                        decoration: InputDecoration(
                          hintText: FLocalization.of(context).productName,
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
                    padding: EdgeInsets.only(left: 18.w, right: 18.w),
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
                  RetailPrice(
                    controller: retailPriceController,
                    onModelUpdate: (value) {
                      String trimed = value.trim();
                      if (trimed.length > 0) {
                        model.isPriceSet(true);
                        model.updateRegularVariant(
                            retailPrice: double.parse(value));
                      } else {
                        model.isPriceSet(false);
                      }
                    },
                  ),
                  verticalSpaceSmall,
                  SupplyPrice(
                    controller: supplyPriceController,
                    onModelUpdate: (value) {
                      model.updateRegularVariant(
                          supplyPrice: double.parse(value));
                    },
                  ),
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
                          ? 'Expiry Date'
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
                    padding: const EdgeInsets.only(left: 18, right: 18, top: 2),
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
                ]),
                StreamBuilder<String>(
                    stream: model.getBarCode().asBroadcastStream(),
                    builder: (context, snapshot) {
                      barCode.text = snapshot.hasData ? snapshot.data! : '';
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 18,
                          right: 18,
                          top: 20,
                          bottom: 30,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            ProxyService.nav.navigateTo(
                              Routes.qrview,
                              arguments:
                                  ScannViewArguments(intent: 'addBarCode'),
                            );
                          },
                          child: BoxInputField(
                            enabled: false,
                            controller: barCode,
                            trailing: Icon(
                              Icons.center_focus_weak,
                              color: primary,
                            ),
                            placeholder: 'BarCode',
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
