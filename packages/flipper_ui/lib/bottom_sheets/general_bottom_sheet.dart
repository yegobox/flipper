// import 'package:flipper_dashboard/flipper_dashboard.dart';
// import 'package:flipper_dashboard/loader.dart';
// import 'package:flipper_models/realm_model_export.dart';
// import 'package:flipper_services/drive_service.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flipper_ui/helpers/hex.dart';
import 'package:flutter/material.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flipper_localize/flipper_localize.dart';

bottomSheetBuilder({
  required BuildContext context,
  required Widget header,
  required Widget body,
}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SizedBox.shrink();
      // return StatefulBuilder(
      //   builder: (context, setState) {
      //     return Theme(
      //       data: Theme.of(context).copyWith(
      //         canvasColor: Colors.transparent,
      //       ),
      //       child: SizedBox(
      //         height: MediaQuery.of(context).size.height - 120,
      //         child: AnimatedContainer(
      //           alignment: AlignmentDirectional.topCenter,
      //           duration: const Duration(seconds: 2),
      //           curve: Curves.elasticOut,
      //           decoration: const BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(18.0),
      //               topRight: Radius.circular(18.0),
      //             ),
      //           ),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: <Widget>[
      //               header,
      //               Padding(
      //                 padding: const EdgeInsets.only(left: 8.0),
      //                 child: body,
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // );
    },
  );
}

class FlipperBottomSheet {
  static showABackUpBottomSheet(
      {required dynamic model, required BuildContext context}) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: 180,
            child: Column(children: <Widget>[
              Padding(
                key: const Key('EnableBackup'),
                padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
                child: BoxButton(
                  title: 'Add Backup',
                  onTap: () async {
                    //if the payment method is not enabled, enable it first!.
                    // final drive = GoogleDrive();
                    // await drive.silentLogin();
                    model.isAutoBackupEnabled = !model.isAutoBackupEnabled;
                    // TODOupdate the business local and online about the backup
                    // now since the backup is true backup every time using the saved credentials of google drive
                    // I need to know when switching to another phone how I will decide what happen.
                    // Directory test = await getApplicationDocumentsDirectory();

                    // await for (var entity
                    //     in test.list(recursive: true, followLinks: false)) {
                    //   log(entity.path);
                    // }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Enabling backup will save your data on daily basis so you wont worry lossing data',
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  static showTicketsToSaleBottomSheet(
      {required dynamic model, required BuildContext context}) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 120,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: AnimatedContainer(
              alignment: AlignmentDirectional.topCenter,
              duration: const Duration(seconds: 2),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: model.keypad.tickets
                      .map((ticket) => SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: Column(children: <Widget>[
                              ListTile(
                                title: Text(
                                  ticket.note ?? 'No Name',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                trailing: TextButton(
                                  child: const Text(
                                    'Resume',
                                  ),
                                  onPressed: () async {
                                    await model.resumeOrder(
                                        ticketId: ticket.id);
                                    // showSimpleNotification(
                                    //     const Text('Order Restored!'),
                                    //     background: Colors.green);
                                    // ignore: use_build_context_synchronously
                                    Navigator.maybePop(context);
                                  },
                                ),
                                dense: true,
                              )
                            ]),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static showAddNoteToSaleBottomSheet(
      {required dynamic model, required BuildContext context}) async {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Wrap(
            children: [
              verticalSpaceSmall,
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    autofocus: true,
                    controller: controller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Note is required';
                      }
                      return null;
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
                    maxLines: 40,
                  ),
                ),
              ),
              verticalSpaceSmall,
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: BoxButton(
                  title: "Save",
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      model.addNoteToSale(
                        note: controller.text,
                        callback: (callback) {
                          if (callback == 1) {
                            // showSimpleNotification(
                            //   const Text('Note added!'),
                            //   background: Colors.green,
                            // );
                            Navigator.maybePop(context);
                          }
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
