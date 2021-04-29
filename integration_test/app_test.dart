// import 'package:flutter/foundation.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';

// import 'package:flipper/main.dart' as app;

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   group('end-to-end test', () {
//     testWidgets('Should load the app and act as real user!',
//         (WidgetTester tester) async {
//       // IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//       app.main();
//       await tester.pumpAndSettle();

// // flutter drive \
// //   --driver=test_driver/integration_test.dart \
// //   --target=integration_test/app_test.dart

// //  should start by showing a loading screen before moving to other screen
//       final loaderView = find.byKey(Key('createAccountButton'));
//       // await tester.pumpAndSettle();
//       // tester.close();
//       expect(
//           find.text('Create Account'), findsOneWidget); //for now fake testing.
//     });
//   });
// }
