import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginCodeProvider = Provider<String>((ref) {
  DateTime now = DateTime.now();
  String loginCode = 'login-' + now.millisecondsSinceEpoch.toString();
  return loginCode.split('-')[1];
});
