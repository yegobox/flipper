import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_socials/ui/common/ui_helpers.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
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
    final l10n = context.flipperL10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.socialsRequestEarlyAccess,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          verticalSpaceTiny,
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: l10n.socialsEarlyAccessHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.socialsPleaseEnterMessage;
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
                        showSuccessNotification(
                            context, l10n.socialsThanksForInterest);

                        completer!(SheetResponse(
                          confirmed: true,
                          data: l10n.socialsThanksWeWillGetBack,
                        ));
                      }
                    },
                    style: ButtonStyle(
                      side: WidgetStateProperty.all<BorderSide>(
                        const BorderSide(color: Color(0xff006AFE)),
                      ),
                      shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                        (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xff006AFE)),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.hovered)) {
                            return Colors.blue.withValues(alpha: 0.04);
                          }
                          if (states.contains(WidgetState.focused) ||
                              states.contains(WidgetState.pressed)) {
                            return Colors.blue.withValues(alpha: 0.12);
                          }
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    child: Text(l10n.socialsExpressInterest,
                        style: const TextStyle(color: Colors.white))),
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
