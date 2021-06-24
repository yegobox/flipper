import 'package:flipper_dashboard/loader.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/flipper_localizations.dart'; // Add this line.

class Localization {
  static AppLocalizations? of(BuildContext context) {
    return AppLocalizations.of(context);
  }
}

class FlipperBottomSheet {
  static showAddNoteToSaleBottomSheet(
      {required BusinessHomeViewModel model,
      required BuildContext context}) async {
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    TextEditingController _controller = new TextEditingController();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: Wrap(
              children: [
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      autofocus: true,
                      controller: _controller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Note is required';
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Add note',
                        fillColor: Theme.of(context)
                            .copyWith(canvasColor: Colors.cyan[50])
                            .canvasColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor('#D0D7E3')),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      minLines:
                          6, // any number you need (It works as the rows for the textarea)
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: BoxButton(
                    title: Localization.of(context)!.save,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        model.addNoteToSale(note: _controller.text);
                        ProxyService.nav.back();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
