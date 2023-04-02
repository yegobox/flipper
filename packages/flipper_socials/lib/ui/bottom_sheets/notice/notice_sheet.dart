import 'package:flutter/material.dart';
import 'package:flipper_socials/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'notice_sheet_model.dart';

class NoticeSheet extends StackedView<NoticeSheetModel> {
  final Function(SheetResponse)? completer;
  final SheetRequest request;
  final GlobalKey<FormState> _formKey = GlobalKey();
  NoticeSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NoticeSheetModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Request Ealry Access',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          verticalSpaceTiny,
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText:
                        'Enter your email, phone number and a message why you want to join!',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    viewModel.message = value;
                  },
                  maxLines: 2,
                  onChanged: (value) {
                    viewModel.message = value;
                  },
                ),
                // add a button to send the message
                OutlinedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await viewModel.expressInterest();
                        // show a snackbar using built flutter
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thank you for your interest'),
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.all(10),
                          ),
                        );

                        completer!(SheetResponse(
                          confirmed: true,
                          data:
                              "Thank you for your interest, we will get back to you soon",
                        ));
                      }
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(color: Color(0xff006AFE)),
                      ),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                        (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff006AFE)),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.blue.withOpacity(0.04);
                          }
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)) {
                            return Colors.blue.withOpacity(0.12);
                          }
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    child: const Text('Expression of intrest',
                        style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
          verticalSpaceLarge,
        ],
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }

  @override
  NoticeSheetModel viewModelBuilder(BuildContext context) => NoticeSheetModel();
}
