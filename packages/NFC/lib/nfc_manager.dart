import 'dart:developer';
import 'dart:io';

import 'package:nfc_manager/nfc_manager.dart';

import 'nfc_session.dart';

class NFC {
  static read() {
    startSession(
      handleTag: ((tag) async {
        log(tag.handle);
        Ndef? ndef = Ndef.from(tag);
        if (ndef != null) {
          NdefMessage message = await ndef.read();
          for (NdefRecord record in message.records) {
            if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
              // This is a well-known text record, so we can extract the text
              // print('Well-known text: $text');
              List<int> payload = record.payload;

              // Convert the payload bytes to a string
              String text = String.fromCharCodes(payload);
              log(text);
            }
          }
        }
        return null;
      }),
    );
  }

  /// To call this function wrap if in while loop and as soon as you get callback with right
  /// expected data exit the loop, this ensure that at the time of taping the nfc card on the phone
  /// the function is probably called,
  static write({required String phoneNumberOrId, required Function callBack}) {
    startSession(
      handleTag: ((tag) async {
        //as soon as we get tag to write on
        // first write the nfc on hard card
        // sleep 10 seconds to have enough time to call the online api
        sleep(const Duration(seconds: 10));
        // call the api to write new card online

        return null;
        //
        // log(tag.handle);
        // Ndef? ndef = Ndef.from(tag);
        // if (ndef != null) {
        //   NdefMessage message = await ndef.read();
        //   for (NdefRecord record in message.records) {
        //     if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
        //       // This is a well-known text record, so we can extract the text
        //       // String text = record.payloadAsString;
        //       // print('Well-known text: $text');
        //       List<int> payload = record.payload;

        //       // Convert the payload bytes to a string
        //       String text = String.fromCharCodes(payload);
        //       log(text);
        //     }
        //   }
        // }
        // return null;
      }),
    );
  }
}
