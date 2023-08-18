import 'package:flipper_dashboard/add_product_buttons.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  SearchField({Key? key, required this.controller, required this.model})
      : super(key: key);
  final TextEditingController controller;
  final ProductViewModel model;
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
    return TextFormField(
      controller: widget.controller,
      onChanged: (value) {
        widget.model.search(value);
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
            return IconButton(
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
                          context: context,
                          builder: (context) => const OptionModal(
                            child: AddProductButtons(),
                          ),
                        );
                      },
                      icon: Icon(FluentIcons.add_20_regular),
                    ),
            );
          },
        ),
      ),
    );
  }
}
