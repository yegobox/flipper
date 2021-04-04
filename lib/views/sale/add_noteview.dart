import 'package:customappbar/customappbar.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_models/view_models/complete_sale_viewmodel.dart';
import 'package:flipper/routes/router.gr.dart';

class AddNoteView extends StatelessWidget {
  AddNoteView({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      builder:
          (BuildContext context, CompleteSaleViewModel model, Widget child) {
        return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                ProxyService.nav.popUntil(Routing.dashboard);
              },
              title: 'Add note',
              closeButton: CLOSEBUTTON.ICON,
              disableButton: false,
              showActionButton: true,
              onPressedCallback: () {
                ProxyService.nav.pop();
              },
              rightActionButtonName: 'Save',
              multi: 3,
              bottomSpacer: 49,
            ),
            body: Container(
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                  hintText: 'Add a note',
                                ),
                                keyboardType: TextInputType.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Add Note';
                                  }
                                  return null;
                                },
                                onChanged: (String note) {
                                  model.keypad.note.value = note;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => CompleteSaleViewModel(),
    );
  }
}
