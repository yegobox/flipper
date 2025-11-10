import 'package:flipper_services/proxy.dart';

class TurboTaxService {
  static Future<bool> handleProformaOrTrainingMode() async {
    if (ProxyService.box.isProformaMode() ||
        ProxyService.box.isTrainingMode()) {
      return true;
    }
    return false;
  }
}

extension ResultMsgParser on String {
  String extractMeaningfulMessage() {
    final fieldRegExp =
        RegExp(r"\[\s*'(.+?)'\s*:\s*(.+?)\. rejected value", dotAll: true);
    final match = fieldRegExp.firstMatch(this);

    if (match != null && match.groupCount >= 2) {
      final field = match.group(1)?.trim();
      final message = match.group(2)?.trim();
      return '$field: $message';
    }

    // Fallback to full message if parsing fails
    return this;
  }
}
