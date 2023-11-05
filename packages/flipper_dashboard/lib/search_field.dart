import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/add_product_buttons.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:flipper_services/constants.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SearchField extends StatefulWidget {
  SearchField({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late ValueNotifier<bool> _hasText;
  @override
  void initState() {
    super.initState();
    _hasText = ValueNotifier<bool>(false);
    widget.controller.addListener(() {
      _hasText.value = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
        viewModelBuilder: () => ProductViewModel(),
        builder: (a, model, b) {
          return TextFormField(
            controller: widget.controller,
            onChanged: (value) {
              model.search(value);
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
              ),
              hintText: 'Search items here',
              prefixIcon: IconButton(
                onPressed: null,
                icon: Icon(FluentIcons.search_24_regular),
              ),
              suffixIcon: ValueListenableBuilder<bool>(
                valueListenable: _hasText,
                builder: (context, hasText, _) {
                  return Row(
                    children: [
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          model.toggleScanningMode();
                        },
                        icon: Icon(
                          model.isScanningMode
                              ? FluentIcons.scan_24_regular
                              : FluentIcons.camera_switch_24_regular,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: hasText
                            ? () {
                                widget.controller.clear();
                                _hasText.value = false;
                              }
                            : null,
                        icon: hasText
                            ? Icon(FluentIcons.dismiss_24_regular)
                            : IconButton(
                                onPressed: () {
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
                                icon: Icon(FluentIcons.add_20_regular),
                              ),
                      )
                    ],
                  );
                },
              ),
            ),
          );
        });
  }
}
