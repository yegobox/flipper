// ignore_for_file: unused_result

import 'package:device_type/device_type.dart';
import 'package:flipper_dashboard/ImportPurchasePage.dart';
import 'package:flipper_dashboard/keypad_view.dart';
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
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:badges/badges.dart' as badges;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

    _handleScanningMode(value, model);
  }

  void _handleScanningMode(String value, CoreViewModel model) async {
    widget.controller.clear();
    _hasText = false;

    /// if the state is not true then we are not in search mode, we are in scan mode
    /// this means that we can simply search and display item as user search
    /// this is useful when a customer want to search item mabybe want to edit it while not in
    /// selling mode.
    if (!ref.read(toggleProvider.notifier).state) {
      ref.read(searchStringProvider.notifier).emitString(value: '');
      if (value.isNotEmpty) {
        Variant? variant = await ProxyService.realm.variant(name: value);
        if (variant != null && variant.id != null) {
          Stock? stock = await ProxyService.realm
              .stockByVariantId(variantId: variant.id!, nonZeroValue: false);
          ITransaction currentTransaction = await ProxyService.realm
              .manageTransaction(transactionType: TransactionType.sale);
          //// TODO: suport sell of composite item while scanning see itemRow @line 107 for how it is done
          await model.saveTransaction(
              variation: variant,
              amountTotal: variant.retailPrice,
              customItem: false,
              pendingTransaction: currentTransaction,
              currentStock: stock!.currentStock,
              partOfComposite: false);
          final pendingTransaction =
              ref.watch(pendingTransactionProvider(TransactionType.sale));

          await Future.delayed(Duration(microseconds: 500));
          ref.refresh(transactionItemsProvider(pendingTransaction.value?.id));
          await Future.delayed(Duration(microseconds: 500));
          ref.refresh(transactionItemsProvider(pendingTransaction.value?.id));
        }
      }
    } else {
      /// we do normal search of item
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
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.001;

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
          return TextFormField(
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
                  if (widget.showOrderButton) orderButton(orders),
                  if (widget.showIncomingButton) incomingButton(),
                  if (widget.showAddButton) addButton(),
                  if (widget.showDatePicker) datePicker(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconButton datePicker() {
    return IconButton(
      onPressed: _handleDateTimePicker,
      icon: Icon(Icons.date_range, color: Colors.grey),
    );
  }

  IconButton calc({required CoreViewModel model}) {
    return IconButton(
      onPressed: () => _handleShowingCustomAmountCalculator(model: model),
      icon: Icon(Icons.calculate_outlined, color: Colors.grey),
    );
  }

  IconButton incomingButton() {
    return IconButton(
      onPressed: _handlePurchaseImport,
      icon: Icon(Icons.close_fullscreen_outlined, color: Colors.grey),
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
          ? Icon(Icons.search, color: Colors.blue)
          : Icon(Icons.search_off, color: Colors.grey),
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

  void _handleReceiveOrderToggle() {
    ref.read(receivingOrdersModeProvider.notifier).toggleReceiveOrder();
    _routerService.navigateTo(OrdersRoute());
  }

  Widget _buildOrderIcon(AsyncValue<List<ITransaction>> orders) {
    return switch (orders) {
      AsyncData(:final value) => badges.Badge(
          badgeContent: Text(value.length.toString(),
              style: TextStyle(color: Colors.white)),
          child: Icon(FluentIcons.cart_24_regular, color: Colors.grey),
        ),
      AsyncError() => badges.Badge(
          badgeContent: Text("0", style: TextStyle(color: Colors.white)),
          child: Icon(FluentIcons.cart_24_regular, color: Colors.grey),
        ),
      _ => const badges.Badge(
          badgeContent: Text("0", style: TextStyle(color: Colors.white)),
          child: Icon(FluentIcons.cart_24_regular, color: Colors.grey),
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
