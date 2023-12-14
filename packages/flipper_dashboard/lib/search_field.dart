// ignore_for_file: unused_result

import 'dart:developer';
import 'package:flipper_services/proxy.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/add_product_buttons.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/isar_models.dart';
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
    widget.controller.addListener(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
    _textSubject.debounceTime(Duration(seconds: 1)).listen((value) {
      // Process the debounced value
      log('Processing value: $value', name: 'logic');
      ref.read(searchStringProvider.notifier).emitString(value: value);

      widget.controller.clear();
      _hasText = false;
      _focusNode.requestFocus();
      ref.read(searchStringProvider.notifier).emitString(value: '');

      ref.refresh(outerVariantsProvider(ProxyService.box.getBranchId()!));
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textSubject.close();
    super.dispose();
  }

  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (a, model, b) {
        return TextFormField(
          controller: widget.controller,
          maxLines: null,
          focusNode: _focusNode,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) async {
            _textSubject.add(value);

            ITransaction currentTransaction =
                await ProxyService.isar.manageTransaction();
            if (ref.watch(scanningModeProvider) && value.isNotEmpty) {
              Variant? variant = await ProxyService.isar.variant(name: value);
              if (variant != null) {
                Stock? stock = await ProxyService.isar
                    .stockByVariantId(variantId: variant.id);

                await model.saveTransaction(
                    variation: variant,
                    amountTotal: variant.retailPrice,
                    customItem: false,
                    pendingTransaction: currentTransaction,
                    currentStock: stock.currentStock);
                ref.refresh(transactionItemsProvider);
                ref.refresh(searchStringProvider);
              }
            }
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            ),
            // hintText: 'Search items here',
            prefixIcon: IconButton(
              onPressed: () {
                // Handle search functionality here
              },
              icon: Icon(FluentIcons.search_24_regular),
            ),
            suffixIcon: Wrap(
              children: [
                IconButton(
                  onPressed: () {
                    ref
                        .read(scanningModeProvider.notifier)
                        .toggleScanningMode();
                    if (ref.watch(scanningModeProvider)) {
                      toast("Scanning mode Activated");
                    } else {
                      ref.refresh(
                          productsProvider(ProxyService.box.getBranchId()!));
                      toast("Scanning mode DeActivated");
                    }
                  },
                  icon: Icon(
                    ref.watch(scanningModeProvider)
                        ? FluentIcons.camera_switch_24_regular
                        : FluentIcons.camera_switch_24_regular,
                    color: ref.watch(scanningModeProvider)
                        ? Colors.green
                        : Colors.blue,
                  ),
                ),
                ProxyService.remoteConfig.isOrderFeatureOrderEnabled()
                    ? IconButton(
                        onPressed: () {
                          ref
                              .read(receivingOrdersModeProvider.notifier)
                              .toggleReceiveOrder();
                          _routerService.navigateTo(OrdersRoute());
                        },
                        icon: badges.Badge(
                          badgeContent:
                              Text('3', style: TextStyle(color: Colors.white)),
                          child: Icon(FluentIcons.cart_24_regular,
                              color: Colors.blue),
                        ),
                      )
                    : SizedBox.shrink(),
                IconButton(
                  onPressed: _hasText
                      ? () {
                          widget.controller.clear();
                          _hasText = false;
                        }
                      : () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => OptionModal(
                              child: isDesktopOrWeb
                                  ? ProductEntryScreen()
                                  : AddProductButtons(),
                            ),
                          );
                        },
                  icon: _hasText
                      ? Icon(FluentIcons.dismiss_24_regular)
                      : Icon(FluentIcons.add_20_regular),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
