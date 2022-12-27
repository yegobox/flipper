import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

Future<void> startSession({
  required BuildContext context,
  required Future<String?> Function(NfcTag) handleTag,
  String alertMessage = 'Hold your device near the item.',
}) async {
  if (!(await NfcManager.instance.isAvailable())) log('nfc unavailable');
  if (Platform.isAndroid) {
    NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          final result = await handleTag(tag);
          if (result == null) return;
          await NfcManager.instance.stopSession();
          // setState(() => _alertMessage = result);
        } catch (e) {
          await NfcManager.instance.stopSession().catchError((_) {/* no op */});
          // setState(() => _errorMessage = '$e');
        }
      },
    ).catchError((e) => log('$e'));
  }

  if (Platform.isIOS) {
    return NfcManager.instance.startSession(
      alertMessage: alertMessage,
      onDiscovered: (tag) async {
        try {
          final result = await handleTag(tag);
          if (result == null) return;
          await NfcManager.instance.stopSession(alertMessage: result);
        } catch (e) {
          await NfcManager.instance.stopSession(errorMessage: '$e');
        }
      },
    );
  }
}
