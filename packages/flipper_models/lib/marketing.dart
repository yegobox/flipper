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
    // ignore: todo
    // TODO: implement sendSMS
    throw UnimplementedError();
  }

  @override
  Future optIn() async {
    String phoneNumber = ProxyService.box.getUserPhone()!;
    SocialToken? token = await ProxyService.isar.loginOnSocial(
        password: phoneNumber.replaceAll("+", ""),
        phoneNumberOrEmail: phoneNumber.replaceAll("+", ""));
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token?.body.token}'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://ers84w6ehl.execute-api.us-east-1.amazonaws.com/api/templates'));
    request.body = json.encode({
      "to": phoneNumber,
      "templateName": "introduction",
      "businessId": "1642641",
      "imageUrl": "https://yegobox-flipper.s3.eu-west-2.amazonaws.com/logo.jpg",
      "message": "Thank you for using YEGOBOX services",
      "footer": "Thank you for using YEGOBOX services",
      "phone_number_id": "101514826127381"
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
