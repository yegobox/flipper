import 'dart:convert';
import 'dart:developer';

import 'package:flipper_models/sms.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'isar_models.dart';
import 'whatsapp.dart';

class Marketing implements WhatsApp, SMS {
  @override
  Future<int> sendSMS(
      {required String message, required List<String> numbers}) {
    // TODO: implement sendSMS
    throw UnimplementedError();
  }

  @override
  Future<int> sendWhatsAppMessages(
      {required String message, required List<String> numbers}) async {
    Token? token = await ProxyService.isarApi.whatsAppToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token!.token}'
    };
    // https://developers.facebook.com/docs/whatsapp/on-premises/reference/messages
    var request = http.Request('POST',
        Uri.parse('https://graph.facebook.com/v13.0/104559025664071/messages'));
    request.body = json.encode({
      "messaging_product": "whatsapp",
      "to": "250783054874",
      "type": "text",
      "text": {"body": "$message"}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
      return 200;
    } else {
      return response.statusCode;
    }
  }
}
