// ignore_for_file: unused_result

import 'package:flipper_dashboard/BulkAddProduct.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/HandleScannWhileSelling.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_dashboard/ImportPurchasePage.dart';
import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/add_product_buttons.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/style_widget/button.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:badges/badges.dart' as badges;

class SearchField extends StatefulHookConsumerWidget {
  const SearchField({
    Key? key,
    required this.controller,
    required this.showOrderButton,
    required this.showIncomingButton,
    required this.showAddButton,
    required this.showDatePicker,
  }) : super(key: key);

  final TextEditingController controller;
  final bool showOrderButton;
  final bool showIncomingButton;
  final bool showAddButton;
  final bool showDatePicker;

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends ConsumerState<SearchField>
    with DateCoreWidget, HandleScannWhileSelling, Refresh {
  final _textSubject = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    hasText = false;
    focusNode = FocusNode();
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    setState(() {
      hasText = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    // final orders = ref.watch(ordersStreamProvider);

    final stringValue = ref.watch(stringProvider);
    final orders = ref.watch(stockRequestsProvider((filter: stringValue)));

    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.001;
    final deviceType = _getDeviceType(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: ViewModelBuilder<CoreViewModel>.nonReactive(
        viewModelBuilder: () => CoreViewModel(),
        onViewModelReady: (model) {
          _textSubject.debounceTime(Duration(seconds: 2)).listen((value) {
            processDebouncedValue(value, model, widget.controller);
          });
        },
        builder: (a, model, b) {
          return TextFormField(
            controller: widget.controller,
            maxLines: null,
            focusNode: focusNode,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            onFieldSubmitted: (value) => _textSubject,
            onChanged: (value) {
              _textSubject.add(value);
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
              ),
              prefixIcon: IconButton(
                onPressed: () {
                  // Handle search functionality here
                },
                icon: Icon(FluentIcons.search_24_regular),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  toggleSearch(),
                  calc(model: model),
                  (deviceType == 'Phone' || deviceType == 'Phablet') == true
                      ? SizedBox.shrink()
                      : orders.when(
                          data: (orders) => widget.showOrderButton
                              ? orderButton(orders)
                              : SizedBox.shrink(),
                          loading: () => SizedBox.shrink(),
                          error: (err, stack) => Text('Error: $err'),
                        ),
                  if (widget.showIncomingButton &&
                      (deviceType != 'Phone' || deviceType != 'Phablet'))
                    incomingButton(),
                  if (widget.showAddButton)
                    addButton().shouldSeeTheApp(ref, AppFeature.Sales),
                  if (widget.showDatePicker) datePicker(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconButton calc({required CoreViewModel model}) {
    return IconButton(
      onPressed: () => _handleShowingCustomAmountCalculator(model: model),
      icon: Icon(FluentIcons.calculator_20_regular, color: Colors.grey),
    );
  }

  IconButton incomingButton() {
    return IconButton(
      onPressed: _handlePurchaseImport,
      icon: Icon(FluentIcons.expand_up_right_16_regular, color: Colors.grey),
    );
  }

  IconButton toggleSearch() {
    return IconButton(
      onPressed: () {
        ref.read(toggleProvider.notifier).state =
            !ref.read(toggleProvider.notifier).state;

        if (!ref.read(toggleProvider)) {
          ref.read(searchStringProvider.notifier).emitString(value: '');
        }
      },
      icon: ref.watch(toggleProvider)
          ? Icon(FluentIcons.search_16_regular, color: Colors.blue)
          : Icon(FluentIcons.search_16_regular, color: Colors.grey),
    );
  }

  IconButton addButton() {
    return IconButton(
      onPressed: hasText ? _clearSearchText : _handleAddProduct,
      icon: hasText
          ? Icon(FluentIcons.dismiss_24_regular, color: Colors.grey)
          : Icon(FluentIcons.add_20_regular, color: Colors.grey),
    );
  }

  IconButton orderButton(List<StockRequest> orders) {
    return IconButton(
      onPressed: () => _handleReceiveOrderToggle(),
      icon: _buildOrderIcon(orders),
    );
  }

  void _handleReceiveOrderToggle() {
    final deviceType = _getDeviceType(context);
    ProxyService.box.writeBool(key: 'isOrdering', value: true);

    refreshPendingTransactionWithExpense();
    if (deviceType == 'Phone' || deviceType == 'Phablet') {
      _routerService.navigateTo(OrdersRoute());
    } else {
      _routerService.navigateTo(OrdersRoute());
    }
  }

  Widget _buildOrderIcon(List<StockRequest> orders) {
    return badges.Badge(
      badgeContent:
          Text(orders.length.toString(), style: TextStyle(color: Colors.white)),
      child: Icon(FluentIcons.cart_24_regular, color: Colors.grey),
    );
  }

  void _clearSearchText() {
    ref.read(searchStringProvider.notifier).emitString(value: '');
    widget.controller.clear();
    setState(() {
      hasText = false;
    });
  }

  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  void _handlePurchaseImport() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: _getDeviceType(context) == "Phone" ||
                _getDeviceType(context) == "Phablet"
            ? SizedBox.shrink()
            : ImportPurchasePage(),
      ),
    );
  }

  void _handleShowingCustomAmountCalculator({required CoreViewModel model}) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400, // Adjust this value as needed
            maxHeight: MediaQuery.of(context).size.height *
                0.8, // 80% of screen height
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity, // Ensure full width
                    height: 800,
                    child: KeyPadView(
                      isBigScreen: true,
                      model: model,
                      accountingMode: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAddProduct() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AddProductDialog(
        onChoiceSelected: (isBulk) {
          // Navigator.of(context).pop();
          if (isBulk) {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => OptionModal(
                child: _getDeviceType(context) == "Phone" ||
                        _getDeviceType(context) == "Phablet"
                    ? AddProductButtons()
                    : BulkAddProduct(),
              ),
            ).then((value) {});
          } else {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => OptionModal(
                child: _getDeviceType(context) == "Phone" ||
                        _getDeviceType(context) == "Phablet"
                    ? AddProductButtons()
                    : ProductEntryScreen(),
              ),
            ).then((value) {});
          }
        },
      ),
    );
  }
}

class AddProductDialog extends StatelessWidget {
  final Function(bool) onChoiceSelected;

  const AddProductDialog({Key? key, required this.onChoiceSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      title: const Center(
        child: Text('Add Product',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add some padding to the dialog content
          const SizedBox(height: 16),
          FlipperButton(
            textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
              onChoiceSelected(false); // Classic add
            },
            text: 'Add Product (Classic)',
          ),
          const SizedBox(height: 16),
          FlipperButton(
            onPressed: () {
              Navigator.of(context).pop();
              onChoiceSelected(true); // Bulk add
            },
            textColor: Colors.black,
            text: 'Bulk Add Product',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
