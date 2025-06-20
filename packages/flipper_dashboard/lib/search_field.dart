// ignore_for_file: unused_result

import 'package:flipper_dashboard/AddProductDialog.dart';
import 'package:flipper_dashboard/import_purchase_dialog.dart';
import 'package:flipper_dashboard/BulkAddProduct.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/HandleScannWhileSelling.dart';
import 'package:flipper_dashboard/notice.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/db_model_export.dart';
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
import 'package:flipper_models/providers/notice_provider.dart';
import 'dart:async';

import 'package:supabase_models/brick/models/notice.model.dart';

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
    with DateCoreWidget, HandleScannWhileSelling<SearchField> {
  final _textSubject = BehaviorSubject<String>();

  bool hasText = false;
  bool isSearching = false;
  Timer? _typingTimer;
  Timer? _shortInputTimer;
  // Increase typing pause threshold to 600ms for longer words
  static const _typingPauseThreshold = Duration(milliseconds: 600);
  // Longer pause threshold for very short inputs (1-2 chars)
  static const _shortInputPauseThreshold = Duration(milliseconds: 1000);
  // Minimum word length before auto-search triggers
  static const _minSearchLength = 3;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    setState(() {
      final text = widget.controller.text;

      if (text.isNotEmpty) {
        // Cancel any existing timers
        _typingTimer?.cancel();
        _shortInputTimer?.cancel();

        // Start a new typing timer for normal cases
        _typingTimer = Timer(_typingPauseThreshold, () {
          // Special cases to handle:
          // 1. Longer words (3+ chars)
          // 2. Complete words (contains space)
          // 3. Numeric input (likely a barcode or product code)
          bool shouldSearch = text.length >= _minSearchLength ||
              text.contains(' ') ||
              _isNumeric(text);

          if (shouldSearch) {
            _textSubject.add(text);
          }
        });

        // For very short inputs (1-2 chars), start a longer timer
        // This allows single character searches after a longer pause
        if (text.length < _minSearchLength &&
            !_isNumeric(text) &&
            !text.contains(' ')) {
          _shortInputTimer = Timer(_shortInputPauseThreshold, () {
            _textSubject.add(text);
          });
        }
      }

      hasText = text.isNotEmpty;
    });
  }

  // Helper method to check if a string is numeric (likely a barcode)
  bool _isNumeric(String str) {
    if (str.isEmpty) return false;
    return double.tryParse(str) != null;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    focusNode.dispose();
    _textSubject.close();
    _typingTimer?.cancel();
    _shortInputTimer?.cancel();
    super.dispose();
  }

  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    final stringValue = ref.watch(searchStringProvider);
    final orders = ref.watch(stockRequestsProvider(
        status: RequestStatus.pending,
        search: stringValue.isNotEmpty ? stringValue : null));
    final notice = ref.watch(noticesProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.001;
    final deviceType = _getDeviceType(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: ViewModelBuilder<CoreViewModel>.nonReactive(
        viewModelBuilder: () => CoreViewModel(),
        onViewModelReady: (model) {
          // Using a very short debounce time since we already have typing detection
          // This just prevents any potential race conditions
          _textSubject
              .debounceTime(const Duration(milliseconds: 100))
              .listen((value) {
            // Only proceed with search if:
            // 1. Not already searching
            // 2. Search term is not empty
            // 3. Current controller text matches the debounced value
            // This ensures we don't search for outdated terms if user continued typing
            if (!isSearching &&
                value.isNotEmpty &&
                widget.controller.text == value) {
              setState(() {
                isSearching = true;
              });

              processDebouncedValue(value, model, widget.controller).then((_) {
                if (mounted) {
                  setState(() {
                    isSearching = false;
                  });
                }
              });
            }
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
              prefixIcon: isSearching
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      height: 16,
                      width: 16,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        // Handle search functionality here
                      },
                      icon: Icon(FluentIcons.search_24_regular),
                    ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  toggleSearch(),
                  notices(notice: notice.value ?? []),
                  orders.when(
                    data: (orders) => widget.showOrderButton
                        ? orderButton(orders.length).shouldSeeTheApp(ref,
                            featureName: AppFeature.Orders)
                        : const SizedBox.shrink(),
                    loading: () => widget.showOrderButton
                        ? orderButton(0).shouldSeeTheApp(ref,
                            featureName: AppFeature.Orders)
                        : const SizedBox.shrink(),
                    error: (err, stack) => Text('Error: $err'),
                  ),
                  if (widget.showIncomingButton &&
                      deviceType != 'Phone' &&
                      deviceType != 'Phablet')
                    incomingButton(),
                  if (widget.showAddButton)
                    addButton().eligibleToSeeIfYouAre(ref, [UserType.ADMIN]),
                  // Remove the date picker that was unintentionally added
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

  IconButton notices({required List<Notice> notice}) {
    return IconButton(
      onPressed: () {
        handleNoticeClick(context);
      },
      icon: _buildNoticesIcon(notice: notice),
    );
  }

  Widget _buildNoticesIcon({required List<Notice> notice}) {
    return badges.Badge(
      badgeContent: Text(notice.length.toString(),
          style: const TextStyle(color: Colors.white)),
      child: Icon(FluentIcons.mail_24_regular, color: Colors.grey),
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

  IconButton orderButton(
    int orders,
  ) {
    return IconButton(
      onPressed: () {
        _handleReceiveOrderToggle();
      },
      icon: _buildOrderIcon(orders),
    );
  }

  void _handleReceiveOrderToggle() {
    try {
      ProxyService.box.writeBool(key: 'isOrdering', value: true);

      _routerService.navigateTo(OrdersRoute());
    } catch (e) {
      print(e);
    }
  }

  Widget _buildOrderIcon(int orders) {
    return badges.Badge(
      badgeContent:
          Text(orders.toString(), style: const TextStyle(color: Colors.white)),
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
    ImportPurchaseDialog.show(context);
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
                child: BulkAddProduct(),
              ),
            );
          } else {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => OptionModal(
                child: ProductEntryScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}
