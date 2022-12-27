import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'nfc_session.dart';

class NFCManager extends StatefulWidget {
  const NFCManager({super.key});

  @override
  State<NFCManager> createState() => _NFCManagerState();
}

class _NFCManagerState extends State<NFCManager> {
  @override
  void initState() {
    startSession(
      context: context,
      handleTag: ((tag) async {
        log(tag.handle);
        Ndef? ndef = Ndef.from(tag);
        if (ndef != null) {
          NdefMessage message = await ndef.read();
          for (NdefRecord record in message.records) {
            if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
              // This is a well-known text record, so we can extract the text
              // String text = record.payloadAsString;
              // print('Well-known text: $text');
              List<int> payload = record.payload;

              // Convert the payload bytes to a string
              String text = String.fromCharCodes(payload);
              log(text);
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tag.handle),
          ),
        );
        return null;
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Hello world")),
    );
  }
}
