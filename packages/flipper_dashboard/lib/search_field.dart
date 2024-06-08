import 'package:device_type/device_type.dart';
import 'package:flipper_dashboard/ImportPurchasePage.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/add_product_buttons.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:badges/badges.dart' as badges;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SearchField extends StatefulHookConsumerWidget {
  SearchField({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends ConsumerState<SearchField> {
  late bool _hasText;
  late FocusNode _focusNode;
  final _textSubject = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    _hasText = false;
    _focusNode = FocusNode();
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    setState(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
  }

  void _processDebouncedValue(String value, CoreViewModel model) {
    ref.read(searchStringProvider.notifier).emitString(value: value);
    _focusNode.requestFocus();

    if (ref.read(scanningModeProvider)) {
      _handleScanningMode(value, model);
    }

    ref.refresh(outerVariantsProvider(ProxyService.box.getBranchId()!));
  }

  void _handleScanningMode(String value, CoreViewModel model) async {
    ref.read(searchStringProvider.notifier).emitString(value: '');
    widget.controller.clear();
    _hasText = false;
    if (value.isNotEmpty) {
      Variant? variant = await ProxyService.realm.variant(name: value);
      if (variant != null) {
        Stock? stock = await ProxyService.realm
            .stockByVariantId(variantId: variant.id!, nonZeroValue: false);
        ITransaction currentTransaction = await ProxyService.realm
            .manageTransaction(transactionType: TransactionType.sale);

        await model.saveTransaction(
          variation: variant,
          amountTotal: variant.retailPrice,
          customItem: false,
          pendingTransaction: currentTransaction,
          currentStock: stock!.currentStock,
        );
        await model.keyboardKeyPressed(key: '+');
        ref.refresh(pendingTransactionProvider(TransactionType.sale).future);
        ref.refresh(transactionItemsProvider(currentTransaction.id));
        ref.refresh(searchStringProvider);
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersStreamProvider);
    final currentLocation = ref.watch(buttonIndexProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.05;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: ViewModelBuilder<CoreViewModel>.nonReactive(
        viewModelBuilder: () => CoreViewModel(),
        onViewModelReady: (model) {
          _textSubject.debounceTime(Duration(seconds: 2)).listen((value) {
            _processDebouncedValue(value, model);
          });
        },
        builder: (a, model, b) {
          return SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: widget.controller,
                  maxLines: null,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) => _textSubject,
                  onChanged: (value) {
                    _textSubject.add(value);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 1.0),
                    ),
                    prefixIcon: IconButton(
                      onPressed: () {
                        // Handle search functionality here
                      },
                      icon: Icon(FluentIcons.search_24_regular),
                    ),
                    suffixIcon: Wrap(
                      children: [
                        if ([0, 1, 2, 4].contains(currentLocation))
                          indicatorButton(),
                        if (ProxyService.remoteConfig
                                .isOrderFeatureOrderEnabled() &&
                            [0, 1, 2, 4].contains(currentLocation))
                          orderButton(orders),
                        if ([0, 1, 2, 4].contains(currentLocation))
                          incomingButton(),
                        if ([0, 1, 2, 4].contains(currentLocation)) addButton(),
                        if (currentLocation == 1) datePicker(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconButton datePicker() {
    return IconButton(
      onPressed: _handleDateTimePicker,
      icon: Icon(Icons.date_range, color: Colors.blue),
    );
  }

  IconButton incomingButton() {
    return IconButton(
      onPressed: _handlePurchaseImport,
      icon: Icon(Icons.close_fullscreen_outlined, color: Colors.blue),
    );
  }

  IconButton addButton() {
    return IconButton(
      onPressed: _hasText ? _clearSearchText : _handleAddProduct,
      icon: _hasText
          ? Icon(FluentIcons.dismiss_24_regular)
          : Icon(FluentIcons.add_20_regular),
    );
  }

  IconButton orderButton(AsyncValue<List<ITransaction>> orders) {
    return IconButton(
      onPressed: () => _handleReceiveOrderToggle(),
      icon: _buildOrderIcon(orders),
    );
  }

  IconButton indicatorButton() {
    return IconButton(
      onPressed: _handleScanningModeToggle,
      icon: Icon(
        ref.watch(scanningModeProvider)
            ? FluentIcons.camera_switch_24_regular
            : FluentIcons.camera_switch_24_regular,
        color: ref.watch(scanningModeProvider) ? Colors.green : Colors.blue,
      ),
    );
  }

  void _handleScanningModeToggle() {
    ref.read(scanningModeProvider.notifier).toggleScanningMode();
    toast(ref.watch(scanningModeProvider)
        ? "Scanning mode Activated"
        : "Scanning mode DeActivated");
  }

  void _handleReceiveOrderToggle() {
    ref.read(receivingOrdersModeProvider.notifier).toggleReceiveOrder();
    _routerService.navigateTo(OrdersRoute());
  }

  Widget _buildOrderIcon(AsyncValue<List<ITransaction>> orders) {
    return switch (orders) {
      AsyncData(:final value) => badges.Badge(
          badgeContent: Text(value.length.toString(),
              style: TextStyle(color: Colors.white)),
          child: Icon(FluentIcons.cart_24_regular, color: Colors.blue),
        ),
      AsyncError() => badges.Badge(
          badgeContent: Text("0", style: TextStyle(color: Colors.white)),
          child: Icon(FluentIcons.cart_24_regular, color: Colors.blue),
        ),
      _ => const badges.Badge(
          badgeContent: Text("0", style: TextStyle(color: Colors.white)),
          child: Icon(FluentIcons.cart_24_regular, color: Colors.blue),
        ),
    };
  }

  void _clearSearchText() {
    ref.read(searchStringProvider.notifier).emitString(value: '');
    widget.controller.clear();
    setState(() {
      _hasText = false;
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
        child: _getDeviceType(context) == "Phone"
            ? SizedBox.shrink()
            : ImportPurchasePage(),
      ),
    );
  }

  void _handleAddProduct() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: _getDeviceType(context) == "Phone"
            ? AddProductButtons()
            : ProductEntryScreen(),
      ),
    );
  }

  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      PickerDateRange date = args.value as PickerDateRange;
      if (date.endDate != null) {
        showSnackBar(context, "Date range selected",
            textColor: Colors.white, backgroundColor: Colors.purple);
        ref.read(dateRangeProvider.notifier).setStartDate(date.startDate!);
        ref.read(dateRangeProvider.notifier).setEndDate(date.endDate!);
        ref.refresh(transactionListProvider);
      }
    }
  }

  void _handleDateTimePicker() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: SfDateRangePicker(
          onSubmit: (v) {
            Navigator.maybePop(context);
          },
          onCancel: () {
            Navigator.maybePop(context);
          },
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.range,
          showActionButtons: true,
          navigationDirection: DateRangePickerNavigationDirection.vertical,
          navigationMode: DateRangePickerNavigationMode.scroll,
          showNavigationArrow: true,
          initialSelectedRange: PickerDateRange(
            DateTime.now().subtract(const Duration(days: 4)),
            DateTime.now().add(
              const Duration(days: 3),
            ),
          ),
        ),
      ),
    );
  }
}
