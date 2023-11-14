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
    widget.controller.addListener(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We can also use "ref" to listen to a provider inside the build method
    final isScanningMode = ref.watch(scanningModeProvider);
    final receiveOrderMode = ref.watch(receivingOrdersModeProvider);

    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (a, model, b) {
        return TextFormField(
          controller: widget.controller,
          maxLines: null,
          focusNode: _focusNode,
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            _hasText = value.isNotEmpty;
            ref.read(searchStringProvider.notifier).emitString(value: value);
            if (isScanningMode) {
              toast("Scanning" + value);
            }
            if (isScanningMode) {
              Future.delayed(Duration(seconds: 2), () {
                if (mounted) {
                  widget.controller.clear();
                  _hasText = false;
                  _focusNode.requestFocus();
                  ref.read(searchStringProvider.notifier).emitString(value: '');
                }
              });
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

                    //ProxyService.isar.clear();
                    if (isScanningMode) {
                      toast("Scanning mode Activated");
                    } else {
                      toast("Scanning mode DeActivated");
                    }
                  },
                  icon: Icon(
                    isScanningMode
                        ? FluentIcons.camera_switch_24_regular
                        : FluentIcons.camera_switch_24_regular,
                    color: isScanningMode ? Colors.green : Colors.blue,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref
                        .read(receivingOrdersModeProvider.notifier)
                        .toggleReceiveOrder();
                    if (receiveOrderMode) {
                      toast("receiveOrderMode Activated");
                    } else {
                      toast("receiveOrderMode DeActivated");
                    }
                  },
                  icon: Icon(
                    receiveOrderMode
                        ? FluentIcons.cart_24_regular
                        : FluentIcons.cart_24_regular,
                    color: receiveOrderMode ? Colors.amber : Colors.blue,
                  ),
                ),
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
