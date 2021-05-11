// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_money_formatter/flutter_money_formatter.dart';

// void main() {
//   const MethodChannel channel = MethodChannel('flutter_money_formatter');

//   TestWidgetsFlutterBinding.ensureInitialized();

//   setUp(() {
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       return '42';
//     });
//   });

//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });

//   test('getPlatformVersion', () async {
//     expect(await FlutterMoneyFormatter.platformVersion, '42');
//   });
// }
