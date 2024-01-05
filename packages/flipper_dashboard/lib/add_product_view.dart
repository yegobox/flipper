import 'package:flipper_dashboard/create/retail_price.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_dashboard/product_form.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'create/build_image_holder.dart';
import 'package:flipper_services/constants.dart';
import 'create/category_selector.dart';
import 'create/divider.dart';
import 'create/section_select_unit.dart';
import 'create/supply_price_widget.dart';
import 'create/variation_list.dart';
import 'customappbar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:intl/intl.dart';

class AddProductView extends StatefulHookConsumerWidget {
  const AddProductView({Key? key, this.productId}) : super(key: key);
  final String? productId;

  @override
  AddProductViewState createState() => AddProductViewState();
}

class AddProductViewState extends ConsumerState<AddProductView> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final _sub = GlobalKey<FormState>();
  final productForm = ProductForm();

  @override
  void dispose() {
    productForm.dispose();
    super.dispose();
  }

  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      onViewModelReady: (model) async {
        // Reset barcode on initialization.
        if (SchedulerBinding.instance.schedulerPhase ==
            SchedulerPhase.persistentCallbacks) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            model.productService.setBarcode('');
          });
        }

        Product product = await model.getProduct(productId: widget.productId);
        ref.read(productProvider.notifier).emitProduct(value: product);
        model.loadCategories();
        await model.loadColors();
        model.loadUnits();

        // Start locking the save button.
        widget.productId == null
            ? model.setName(name: ' ')
            : ref.read(productProvider)?.name;

        // Get the regular variant to fill in the form in edit mode.
        if (widget.productId != null) {
          List<Variant> variants = await ProxyService.isar
              .getVariantByProductId(productId: widget.productId!);

          // Filter variants to get the regular variant.
          Variant regularVariant =
              variants.firstWhere((variant) => variant.name == 'Regular');

          productForm.productNameController.text = model.kProductName;

          if (regularVariant.retailPrice.toString() != '0.0') {
            productForm.retailPriceController.text =
                regularVariant.retailPrice.toString();

            model.lockButton(false);
          }
          if (regularVariant.supplyPrice.toString() != '0.0') {
            productForm.supplyPriceController.text =
                regularVariant.supplyPrice.toString();
          }
        }
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) {
              return;
            }
            onWillPop(
              context: context,
              navigationPurpose: NavigationPurpose.back,
              message: 'You have unsaved product, do you want to discard?',
            );
          },
          child: Scaffold(
            appBar: CustomAppBar(
              onPop: () async {
                _routerService.navigateTo(CheckOutRoute(
                  isBigScreen: false,
                ));
              },
              title: 'Create Product',
              disableButton: model.lock,
              showActionButton: true,
              onActionButtonClicked: () async {
                if (model.productName == " ") {
                  showToast(context, 'Provide name for the product');
                  return;
                }

                Product product =
                    await model.getProduct(productId: widget.productId);
                await model.saveProduct(
                    mproduct: product,
                    inUpdateProcess: widget.productId != null);

                ref
                    .read(productsProvider(ProxyService.box.getBranchId()!)
                        .notifier)
                    .addProducts(products: [
                  ...[product]
                ]);
                // Re-update the product default variant with retail price.
                await model.updateRegularVariant(
                    inUpdateProcess: true,
                    retailPrice:
                        double.parse(productForm.retailPriceController.text),
                    productId: ref.read(productProvider)?.id);

                await model.updateRegularVariant(
                    inUpdateProcess: true,
                    supplyPrice: double.tryParse(
                            productForm.supplyPriceController.text) ??
                        0.0,
                    productId: ref.read(productProvider)?.id);

                _routerService.clearStackAndShow(CheckOutRoute(
                  isBigScreen: false,
                ));
              },
              rightActionButtonName: 'Save',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 48.99,
            ),
            body: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Form(
                    key: _sub,
                    child: Column(children: <Widget>[
                      verticalSpaceSmall,
                      ref.read(productProvider) == null
                          ? const SizedBox.shrink()
                          : ColorAndImagePlaceHolder(
                              currentColor: ref.read(productProvider)!.color,
                              product: ref.read(productProvider),
                            ),
                      Text(
                        'Product',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                enabled: true,
                                border: OutlineInputBorder(),
                                hintText: "Product Name"),
                            controller: productForm.productNameController,
                            onChanged: (value) {
                              model.setName(name: value);
                            },
                          ),
                        ),
                      ),
                      CategorySelector(categories: model.categories),
                      verticalSpaceSmall,
                      Padding(
                        padding: EdgeInsets.only(left: 18, right: 18),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text('PRICE AND INVENTORY',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                      const CenterDivider(
                        width: double.infinity,
                      ),
                      ref.read(productProvider) == null
                          ? const SizedBox.shrink()
                          : SectionSelectUnit(
                              product: ref.read(productProvider)!,
                              type: 'product',
                            ),
                      verticalSpaceSmall,
                      verticalSpaceSmall,
                      RetailPrice(
                        controller: productForm.retailPriceController,
                        onModelUpdate: (value) async {
                          String trimed = value.trim();
                          if (trimed.isNotEmpty) {
                            double? parsedValue = double.tryParse(value);
                            if (parsedValue != null) {
                              model.lockButton(false);
                              await model.updateRegularVariant(
                                  retailPrice: parsedValue,
                                  inUpdateProcess: true,
                                  productId: ref.read(productProvider)?.id);
                            } else {
                              model.lockButton(true);
                            }
                          } else {
                            model.lockButton(true);
                          }
                        },
                      ),
                      verticalSpaceSmall,
                      SupplyPrice(
                        controller: productForm.supplyPriceController,
                        onModelUpdate: (value) async {
                          String trimed = value.trim();
                          if (trimed.isNotEmpty) {
                            double? parsedValue = double.tryParse(value);
                            if (parsedValue != null) {
                              await model.updateRegularVariant(
                                  supplyPrice: parsedValue,
                                  inUpdateProcess: true,
                                  productId: ref.read(productProvider)?.id);
                            } else {
                              return '.';
                            }
                          }
                        },
                      ),
                      verticalSpaceSmall,
                      Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            child: Text(
                                (ref.read(productProvider) == null ||
                                        (ref.read(productProvider) != null &&
                                            ref
                                                    .read(productProvider)!
                                                    .expiryDate ==
                                                null))
                                    ? 'Expiry Date'
                                    : 'Expires at ' +
                                        formatter.format(DateTime.tryParse(ref
                                                .read(productProvider)!
                                                .expiryDate!) ??
                                            DateTime.now()),
                                style: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                )),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.resolveWith<
                                  OutlinedBorder>(
                                (states) => RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xffF2F2F2)),
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
                              DatePicker.showPicker(context,
                                  showTitleActions: true,
                                  onChanged: (date) {}, onConfirm: (date) {
                                model.updateExpiryDate(date);
                              }, locale: LocaleType.en);
                            },
                          ),
                        ),
                      ),
                      verticalSpaceSmall,
                      verticalSpaceSmall,
                      StreamBuilder<List<Variant>>(
                        stream: ProxyService.isar.geVariantStreamByProductId(
                            productId: ref.read(productProvider)?.id ?? '0'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            final List<Variant> variations =
                                snapshot.data ?? [];
                            if (variations.isEmpty) {
                              return const SizedBox.shrink();
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, right: 18),
                                child: VariationList(
                                  variations: variations,
                                  deleteVariant: (id) {
                                    model.deleteVariant(id: id);
                                  },
                                ),
                              );
                            }
                          }
                        },
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 18, right: 18, top: 2),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: TextButton(
                            child: Text('Add Variation',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400)),
                            onPressed: () {
                              model.navigateAddVariation(
                                  context: context,
                                  productId: ref.read(productProvider)!.id);
                            },
                          ),
                        ),
                      ),
                    ])),
                StreamBuilder<String>(
                    stream: model.getBarCode().asBroadcastStream(),
                    builder: (context, snapshot) {
                      productForm.barCodeController.text =
                          snapshot.hasData ? snapshot.data! : '';
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 18,
                          right: 18,
                          top: 20,
                          bottom: 30,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _routerService.navigateTo(
                                ScannViewRoute(intent: 'addBarCode'));
                          },
                          child: BoxInputField(
                            enabled: false,
                            controller: productForm.barCodeController,
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
