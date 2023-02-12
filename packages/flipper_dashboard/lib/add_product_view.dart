import 'package:flipper_routing/routes.logger.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({Key? key, this.productId}) : super(key: key);
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
      onViewModelReady: (model) async {
        // start by reseting bar code.
        if (SchedulerBinding.instance.schedulerPhase ==
            SchedulerPhase.persistentCallbacks) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            model.productService.setBarcode('');
          });
        }

        await model.getTempOrCreateProduct(productId: widget.productId);
        model.loadCategories();
        model.loadColors();
        model.loadUnits();
        //start locking the save button
        model.setName(productName: ' ');

        /// get the regular variant then get it's price to fill in the form when we are in edit mode!
        /// normal this is a List of variants where match the productId and take where we have the regular variant
        if (widget.productId != null) {
          log.i(widget.productId);
          List<Variant> variants = await ProxyService.isarApi
              .getVariantByProductId(productId: widget.productId!);
          //filter the variants where we have the regular variant and get one of them
          Variant regularVariant =
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
                model.rebuildUi();
                GoRouter.of(context).pop();
              },
              title: 'Create Product',
              disableButton: model.lock,
              showActionButton: true,
              onPressedCallback: () async {
                await model.addProduct(mproduct: model.product);
                // then re-update the product default variant with retail price
                // retailPriceController this is to present missing out key stroke.
                await model.updateRegularVariant(
                    retailPrice: double.parse(retailPriceController.text),
                    productId: model.product.id);
                await model.updateRegularVariant(
                    supplyPrice: double.parse(supplyPriceController.text),
                    productId: model.product.id);
                await model.loadProducts();
                GoRouter.of(context).pop();
              },
              rightActionButtonName: 'Save',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 50,
            ),
            body: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Column(children: <Widget>[
                  verticalSpaceSmall,
                  model.product == null
                      ? const SizedBox.shrink()
                      : ColorAndImagePlaceHolder(
                          currentColor: model.currentColor,
                          product: model.product,
                        ),
                  const Text('Product'),
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            enabled: true,
                            border: OutlineInputBorder(),
                            hintText: "Product Name"),
                        controller: productName,
                        onChanged: (value) {
                          /// for locking on unlocking the save button
                          model.setName(productName: value);
                        },
                      ),
                    ),
                  ),
                  CategorySelector(categories: model.categories),
                  verticalSpaceSmall,
                  const Padding(
                    padding: EdgeInsets.only(left: 18, right: 18),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'PRICE AND INVENTORY',
                      ),
                    ),
                  ),
                  const CenterDivider(
                    width: double.infinity,
                  ),
                  model.product == null
                      ? const SizedBox.shrink()
                      : SectionSelectUnit(
                          product: model.product,
                          type: 'product',
                        ),
                  verticalSpaceSmall,
                  verticalSpaceSmall,
                  RetailPrice(
                    controller: retailPriceController,
                    onModelUpdate: (value) async {
                      String trimed = value.trim();
                      if (trimed.isNotEmpty) {
                        model.isPriceSet(true);
                        await model.updateRegularVariant(
                            retailPrice: double.parse(value),
                            productId: model.product.id);
                      } else {
                        model.isPriceSet(false);
                      }
                    },
                  ),
                  verticalSpaceSmall,
                  SupplyPrice(
                    controller: supplyPriceController,
                    onModelUpdate: (value) async {
                      String trimed = value.trim();
                      if (trimed.isNotEmpty) {
                        await model.updateRegularVariant(
                            supplyPrice: double.parse(value),
                            productId: model.product.id);
                      }
                    },
                  ),
                  verticalSpaceSmall,
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        child: Text(
                            (model.product == null ||
                                    (model.product != null &&
                                        model.product.expiryDate == null))
                                ? 'Expiry Date'
                                : 'Expires at ' +
                                    formatter.format(DateTime.parse(
                                        model.product.expiryDate)),
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff006AFE)),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.blue.withOpacity(0.04);
                              }
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return Colors.blue.withOpacity(0.12);
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          DatePicker.showPicker(context, showTitleActions: true,
                              onChanged: (date) {
                            log.i('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          }, onConfirm: (date) {
                            model.updateExpiryDate(date);
                          }, locale: LocaleType.en);
                        },
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  verticalSpaceSmall,
                  model.variants == null
                      ? const SizedBox.shrink()
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
                      child: TextButton(
                        child: Text('Add Variation',
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            )),
                        onPressed: () {
                          model.navigateAddVariation(
                              context: context, productId: model.product.id!);
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
                            GoRouter.of(context)
                                .go(Routes.scann + "/addBarCode");
                          },
                          child: BoxInputField(
                            enabled: false,
                            controller: barCode,
                            trailing: const Icon(
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
