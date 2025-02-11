// ignore_for_file: unused_result

import 'package:flipper_dashboard/AddProductDialog.dart';
import 'package:flipper_dashboard/BulkAddProduct.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/HandleScannWhileSelling.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
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

  bool hasText = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    setState(() {
      if (widget.controller.text.isNotEmpty) {
        _textSubject.add(widget.controller.text);
      }

      hasText = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    focusNode.dispose();
    _textSubject.close();
    super.dispose();
  }

  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
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
          _textSubject.debounceTime(const Duration(seconds: 2)).listen((value) {
            processDebouncedValue(value, model, widget.controller);
          });
        },
        builder: (context, model, _) {
          return TextFormField(
            controller: widget.controller,
            focusNode: focusNode,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
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
                  if (deviceType != 'Phone' && deviceType != 'Phablet')
                    orders.when(
                      data: (orders) => widget.showOrderButton
                          ? orderButton(orders)
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (err, stack) => Text('Error: $err'),
                    ),
                  if (widget.showIncomingButton &&
                      deviceType != 'Phone' &&
                      deviceType != 'Phablet')
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

  IconButton orderButton(List<InventoryRequest> orders) {
    return IconButton(
      onPressed: _handleReceiveOrderToggle,
      icon: _buildOrderIcon(orders),
    );
  }

  void _handleReceiveOrderToggle() {
    ProxyService.box.writeBool(key: 'isOrdering', value: true);

    refreshPendingTransactionWithExpense();
    _routerService.navigateTo(OrdersRoute());
  }

  Widget _buildOrderIcon(List<InventoryRequest> orders) {
    return badges.Badge(
      badgeContent: Text(orders.length.toString(),
          style: const TextStyle(color: Colors.white)),
      child: Icon(FluentIcons.cart_24_regular, color: Colors.grey),
    );
  }

  void _clearSearchText() {
    /// if we are not in search mode then automaticaly clear input
    if (!ref.read(toggleProvider)) {
      ref.read(searchStringProvider.notifier).emitString(value: '');
    }

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
            ? const SizedBox.shrink()
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
            maxWidth: 400,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 800,
                    child: KeyPadView(
                      onConfirm: () {
                        // Handle the pop action here
                        Navigator.of(context).pop();
                      },
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
          if (isBulk) {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => OptionModal(
                child: _getDeviceType(context) == "Phone" ||
                        _getDeviceType(context) == "Phablet"
                    ? const AddProductButtons()
                    : const BulkAddProduct(),
              ),
            );
          } else {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => OptionModal(
                child: _getDeviceType(context) == "Phone" ||
                        _getDeviceType(context) == "Phablet"
                    ? const AddProductButtons()
                    : const ProductEntryScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}
