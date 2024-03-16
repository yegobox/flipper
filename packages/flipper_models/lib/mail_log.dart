import 'dart:convert';
import 'dart:developer';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:sentry/sentry.dart';

extension RWTaxEmailExtension on RWTax {
  Future<void> sendEmailNotification({required dynamic requestBody,

    required String response}) async {
    final userEmail = 'info@yegobox.com';
    var headers = {'Content-Type': 'application/json'};
    final emailSubject = 'HTTP Request and Response Data';

    var request =
        http.Request('POST', Uri.parse(AppSecrets.apihubProd + '/v2/api/mail'));
    request.body = json.encode({
      "to": userEmail,
      "subject": emailSubject,
      "messageBody": "requestBody: "+requestBody + "Response: " + response,
      "bcc": ProxyService.remoteConfig.bcc()
    });

    request.headers.addAll(headers);

    await request.send();
  }

  Future<bool> sendRequestAndHandleResponse(http.Request request) async {
    try {
      http.StreamedResponse response = await request.send();
      final requestData = request.body.toString();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        log(responseData);

        final sentryId = await Sentry.captureMessage("EBM-JSON");

        final userFeedback = SentryUserFeedback(
          eventId: sentryId,
          comments: requestData,
          email: ProxyService.box.getUserPhone(),
          name: ProxyService.box.getUserPhone(),
        );

        Sentry.captureUserFeedback(userFeedback);

        // await sendEmailNotification(
        //     requestData: requestData, responseData: responseData);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle exceptions or errors here
      return false;
    }
  }
}
