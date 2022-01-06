import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flipper_dashboard/loader.dart';
import 'package:flipper_models/models/view_models/business_home_viewmodel.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/flipper_localizations.dart';
import 'package:overlay_support/overlay_support.dart'; // Add this line.
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class Localization {
  static AppLocalizations? of(BuildContext context) {
    return AppLocalizations.of(context);
  }
}

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
      return StatefulBuilder(
        builder: (context, setState) {
          return Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 120,
              //  height: MediaQuery.of(context).size.height * 0.8,
              child: AnimatedContainer(
                alignment: AlignmentDirectional.topCenter,
                duration: const Duration(seconds: 2),
                curve: Curves.elasticOut,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    header,
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: body,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class FlipperBottomSheet {
  static showAddPaymentMethod(
      {required BusinessHomeViewModel model,
      required BuildContext context}) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: 180,
            child: Container(
                child: Column(children: <Widget>[
              Padding(
                key: Key('EnableBackup'),
                padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 10.h),
                child: BoxButton(
                  title: 'Add Backup',
                  onTap: () async {
                    //if the payment method is not enabled, enable it first!.
                    final drive = GoogleDrive();
                    Directory dir = await getApplicationDocumentsDirectory();

                    await drive.upload(File(path.context
                        .canonicalize(dir.path + '/db_1/data.mdb')));
                    // TODOupdate the business local and online about the backup
                    // now since the backup is true backup every time using the saved credentials of google drive
                    // I need to know when switching to another phone how I will decide what happen.
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Enabling backup will save your data on daily basis so you wont worry lossing data',
                ),
              ),
            ])),
          ),
        );
      },
    );
  }

  static showTicketsToSaleBottomSheet(
      {required BusinessHomeViewModel model,
      required BuildContext context}) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
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
                  children: model.tickets
                      .map((ticket) => SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: Column(children: <Widget>[
                              ListTile(
                                title: Text(
                                  ticket.note ?? 'No Name',
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: TextButton(
                                  child: Text(
                                    'Resume',
                                  ),
                                  onPressed: () async {
                                    await model.resumeOrder(
                                        ticketId: ticket.id);
                                    showSimpleNotification(
                                        Text('Order Restored!'),
                                        background: Colors.green);
                                    ProxyService.nav.back();
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
                      maxLines: 40,
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
                        model.addNoteToSale(
                          note: _controller.text,
                          callback: (callback) {
                            if (callback == 1) {
                              showSimpleNotification(
                                Text('Note added!'),
                                background: Colors.green,
                              );
                              ProxyService.nav.back();
                            }
                          },
                        );
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
