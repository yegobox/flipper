import 'package:collection/collection.dart';
import 'package:flipper_dashboard/create/retail_price.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_dashboard/product_form.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'create/build_image_holder.dart';
import 'package:flipper_services/constants.dart';
import 'create/category_selector.dart';
import 'create/section_select_unit.dart';
import 'create/supply_price_widget.dart';
import 'create/variation_list.dart';
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
  final _formKey = GlobalKey<FormState>();
  final ProductForm productForm = ProductForm();

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
        await _initializeProduct(model);
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, dynamic) {
            if (didPop) return;
            _handleWillPop(context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text("Create Product"),
              actions: [
                FlipperButton(
                    text: "Save",
                    onPressed: () {
                      if (!model.lock &&
                          (_formKey.currentState?.validate() ?? false)) {
                        _saveProduct(model);
                      }
                    })
              ],
            ),
            body: _buildBody(model),
          ),
        );
      },
    );
  }

  Future<void> _initializeProduct(ProductViewModel model) async {
    _resetBarcode(model);
    await _loadProductData(model);
    _initializeForm(model);
  }

  void _resetBarcode(ProductViewModel model) {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        model.productService.setBarcode('');
      });
    }
  }

  Future<void> _loadProductData(ProductViewModel model) async {
    Product product = await model.getProduct(productId: widget.productId);
    ref.read(unsavedProductProvider.notifier).emitProduct(value: product);
    model.loadCategories();
    model.loadColors();
    model.loadUnits();
  }

  void _initializeForm(ProductViewModel model) {
    widget.productId == null
        ? model.setProductName(name: ' ')
        : ref.read(unsavedProductProvider)?.name;

    if (widget.productId != null) {
      _fillFormForExistingProduct(model);
    }
  }

  Future<void> _fillFormForExistingProduct(ProductViewModel model) async {
    List<Variant> variants = await ProxyService.strategy.variants(
      productId: widget.productId!,
      branchId: ProxyService.box.getBranchId()!,
    );

    Variant? regularVariant =
        variants.firstWhereOrNull((variant) => variant.name == 'Regular');
    if (regularVariant == null) return;

    productForm.productNameController.text = model.kProductName!;
    _setPrice(
        regularVariant.retailPrice!, productForm.retailPriceController, model);
    _setPrice(regularVariant.supplyPrice!, productForm.supplyPriceController);
  }

  void _setPrice(double price, TextEditingController controller,
      [ProductViewModel? model]) {
    if (price != 0.0) {
      controller.text = price.toString();
      model?.lockButton(false);
    }
  }

  Widget _buildBody(ProductViewModel model) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              _buildProductHeader(),
              _buildProductNameField(model),
              CategorySelector(),
              _buildPriceAndInventorySection(),
              _buildUnitSelector(),
              _buildPriceFields(model),
              _buildExpiryDatePicker(model),
              _buildVariationList(model),
              _buildAddVariationButton(model),
            ],
          ),
        ),
        _buildBarCodeScanner(model),
      ],
    );
  }

  Widget _buildProductHeader() {
    return Column(
      children: [
        verticalSpaceSmall,
        if (ref.read(unsavedProductProvider) != null)
          ColorAndImagePlaceHolder(
            currentColor: ref.read(unsavedProductProvider)!.color,
            product: ref.read(unsavedProductProvider),
          ),
        Text(
          'Product',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildProductNameField(ProductViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Product Name",
        ),
        controller: productForm.productNameController,
        onChanged: (value) => model.setProductName(name: value),
      ),
    );
  }

  Widget _buildPriceAndInventorySection() {
    return Column(
      children: [
        verticalSpaceSmall,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Flippertext('PRICE AND INVENTORY'),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitSelector() {
    return ref.read(unsavedProductProvider) == null
        ? const SizedBox.shrink()
        : SectionSelectUnit(
            product: ref.read(unsavedProductProvider)!,
            type: 'product',
          );
  }

  Widget _buildPriceFields(ProductViewModel model) {
    return Column(
      children: [
        verticalSpaceSmall,
        RetailPrice(
          controller: productForm.retailPriceController,
          onModelUpdate: (value) =>
              _updatePrice(value, model, isPriceUpdate: true),
        ),
        verticalSpaceSmall,
        SupplyPrice(
          controller: productForm.supplyPriceController,
          onModelUpdate: (value) => _updatePrice(value, model),
        ),
      ],
    );
  }

  Future<void> _updatePrice(String value, ProductViewModel model,
      {bool isPriceUpdate = false}) async {
    String trimmed = value.trim();
    if (trimmed.isEmpty) {
      if (isPriceUpdate) model.lockButton(true);
      return;
    }

    double? parsedValue = double.tryParse(trimmed);
    if (parsedValue == null) {
      if (isPriceUpdate) model.lockButton(true);
      return;
    }

    if (isPriceUpdate) model.lockButton(false);
    await model.updateRegularVariant(
      retailPrice: isPriceUpdate ? parsedValue : null,
      supplyPrice: !isPriceUpdate ? parsedValue : null,
      inUpdateProcess: true,
      productId: ref.read(unsavedProductProvider)?.id,
    );
  }

  Widget _buildExpiryDatePicker(ProductViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: FlipperButton(
          text: _getExpiryDateText(),
          onPressed: () => _showDatePicker(model),
        ),
      ),
    );
  }

  String _getExpiryDateText() {
    final product = ref.read(unsavedProductProvider);
    if (product == null || product.expiryDate == null) {
      return 'Expiry Date';
    }
    return 'Expires at ${formatter.format(DateTime.tryParse(product.expiryDate!) ?? DateTime.now())}';
  }

  void _showDatePicker(ProductViewModel model) {
    // Show the date picker
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((selectedDate) {
      if (selectedDate != null) {
        // If a date is selected, update the expiry date in the model
        model.updateExpiryDate(selectedDate);
      }
    });
  }

  Widget _buildVariationList(ProductViewModel model) {
    String? id = ref.read(unsavedProductProvider)?.id;
    return StreamBuilder<List<Variant>>(
      stream: ProxyService.strategy.geVariantStreamByProductId(
        productId: id!,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final List<Variant> variations = snapshot.data ?? [];
        if (variations.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: VariationList(
            variations: variations,
            deleteVariant: model.deleteVariant,
          ),
        );
      },
    );
  }

  Widget _buildAddVariationButton(ProductViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: FlipperButton(
          text: 'Add Variation',
          onPressed: () => model.navigateAddVariation(
            context: context,
            productId: ref.read(unsavedProductProvider)!.id,
          ),
        ),
      ),
    );
  }

  Widget _buildBarCodeScanner(ProductViewModel model) {
    return StreamBuilder<String>(
      stream: model.getBarCode().asBroadcastStream(),
      builder: (context, snapshot) {
        productForm.barCodeController.text = snapshot.data ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: GestureDetector(
            onTap: () =>
                _routerService.navigateTo(ScannViewRoute(intent: 'addBarCode')),
            child: BoxInputField(
              enabled: false,
              controller: productForm.barCodeController,
              trailing: const Icon(Icons.center_focus_weak, color: primary),
              placeholder: 'BarCode',
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveProduct(ProductViewModel model) async {
    if (model.kProductName == " ") {
      showToast(context, 'Provide name for the product');
      return;
    }

    Product product = await model.getProduct(productId: widget.productId);
    await model.saveProduct(
      mproduct: product,
      color: model.currentColor,
      inUpdateProcess: widget.productId != null,
      productName: model.kProductName!,
    );

    ref
        .read(productsProvider(ProxyService.box.getBranchId()!).notifier)
        .addProducts(products: [product]);

    await _updateRegularVariant(model);

    _routerService.clearStackAndShow(CheckOutRoute(isBigScreen: false));
  }

  Future<void> _updateRegularVariant(ProductViewModel model) async {
    await model.updateRegularVariant(
      inUpdateProcess: true,
      retailPrice: double.parse(productForm.retailPriceController.text),
      productId: ref.read(unsavedProductProvider)?.id,
    );

    await model.updateRegularVariant(
      inUpdateProcess: true,
      supplyPrice:
          double.tryParse(productForm.supplyPriceController.text) ?? 0.0,
      productId: ref.read(unsavedProductProvider)?.id,
    );
  }

  void _handleWillPop(BuildContext context) {
    onWillPop(
      context: context,
      navigationPurpose: NavigationPurpose.back,
      message: 'You have unsaved product, do you want to discard?',
    );
  }
}
