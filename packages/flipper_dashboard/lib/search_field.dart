// ignore_for_file: unused_result

import 'dart:developer';
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
    log('Processing value: $value', name: 'logic');
    ref.read(searchStringProvider.notifier).emitString(value: value);
    // search product by name an if found add it to the current list

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
      Variant? variant = await ProxyService.isar.variant(name: value);
      if (variant != null) {
        Stock? stock = await ProxyService.isar
            .stockByVariantId(variantId: variant.id!, nonZeroValue: false);
        ITransaction currentTransaction = await ProxyService.isar
            .manageTransaction(transactionType: TransactionType.custom);

        await model.saveTransaction(
          variation: variant,
          amountTotal: variant.retailPrice,
          customItem: false,
          pendingTransaction: currentTransaction,
          currentStock: stock!.currentStock,
        );
        await model.keyboardKeyPressed(key: '+');
        ref.refresh(pendingTransactionProvider(TransactionType.custom).future);
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
    final isScanningMode = ref.watch(scanningModeProvider);
    final currentLocation = ref.watch(buttonIndexProvider);
    return ViewModelBuilder<CoreViewModel>.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (a, model, b) {
        return TextFormField(
          controller: widget.controller,
          maxLines: null,
          focusNode: _focusNode,
          textInputAction: TextInputAction.done,
          // onFieldSubmitted: (value) => _textSubject.add(value),
          onFieldSubmitted: isScanningMode
              ? (value) => _processDebouncedValue(value, model)
              : null,
          onChanged: isScanningMode
              ? null
              : (value) => _processDebouncedValue(value, model),
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
            suffixIcon: Wrap(
              children: [
                if ([0, 1, 2, 4].contains(currentLocation)) indicatorButton(),
                if (ProxyService.remoteConfig.isOrderFeatureOrderEnabled() &&
                    [0, 1, 2, 4].contains(currentLocation))
                  orderButton(orders),
                if ([0, 1, 2, 4].contains(currentLocation)) addButton(),
                if (currentLocation == 1) datePicker(),
              ],
            ),
          ),
        );
      },
    );
  }

  IconButton datePicker() {
    return IconButton(
      onPressed: _handleDateTimePicker,
      icon: Icon(Icons.date_range, color: Colors.blue),
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
      AsyncError() => Text("0"),
      _ => const Text("0"),
    };
  }

  void _clearSearchText() {
    ref.read(searchStringProvider.notifier).emitString(value: '');
    widget.controller.clear();
    _hasText = false;
  }

  void _handleAddProduct() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: isDesktopOrWeb ? ProductEntryScreen() : AddProductButtons(),
      ),
    );
  }

  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      PickerDateRange date = args.value as PickerDateRange;
      if (date.endDate != null && date.endDate != null) {
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
