// import 'package:flutter_test/flutter_test.dart';
// import 'package:flipper_dashboard/init_app.dart';
// import 'package:flipper_models/isar_models.dart';
// import 'package:flipper_services/proxy.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:stacked/stacked.dart';
// import 'package:flipper_socials/ui/common/ui_helpers.dart';

// void main() {
//   test('Test Flipper Dashboard App', () async {
//     // Create a mock proxy service.
//     final proxyService = MockProxyService();

//     // Create a mock startup view model.
//     final startupViewModel = MockStartupViewModel();

//     // Set up the startup view model.
//     startupViewModel.runStartupLogic.whenComplete(() {
//       expect(ProxyService.box.getBranchId(), isNotNull);
//       expect(ProxyService.box.getBusinessId(), isNotNull);
//       expect(ProxyService.box.getUserId(), isNotNull);
//     });

//     // Build the startup view.
//     final startupView = StartUpView(
//       invokeLogin: false,
//     );

//     // Build the app.
//     final app = MaterialApp(
//       home: startupView,
//     );

//     // Run the app.
//     await runApp(app);

//     // Verify that the startup view model was called.
//     expect(startupViewModel.runStartupLogic.called, true);

//     // Verify that the proxy service was called.
//     expect(proxyService.getBranchId.called, true);
//     expect(proxyService.getBusinessId.called, true);
//     expect(proxyService.getUserId.called, true);
//   });
// }

// class MockProxyService extends Mock implements ProxyService {
//   @override
//   Future<Branch> getBranchId() async {
//     return Branch(id: 1);
//   }

//   @override
//   Future<Business> getBusinessId() async {
//     return Business(id: 2);
//   }

//   @override
//   Future<User> getUserId() async {
//     return User(id: 3);
//   }
// }

// class MockStartupViewModel extends Mock implements StartupViewModel {
//   @override
//   Future<void> runStartupLogic(bool refreshCredentials) async {
//     await Future.delayed(Duration(seconds: 1));
//   }
// }
