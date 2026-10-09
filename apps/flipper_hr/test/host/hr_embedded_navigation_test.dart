import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_hr/features/billing/application/hr_billing_providers.dart';
import 'package:flipper_hr/features/home/hr_home_shell.dart';
import 'package:flipper_hr/features/leave/data/leave_providers.dart';
import 'package:flipper_hr/features/pay/data/pay_providers.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_identity_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flipper_hr/flipper_hr.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flipper_web/features/login/auth_providers.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';
import '../helpers/fake_hr_account_repository.dart';
import '../helpers/fake_hr_billing_repository.dart';
import '../helpers/fake_hr_session_repository.dart';
import '../helpers/fake_leave_repository.dart';
import '../helpers/fake_pay_repository.dart';

final _business = Business.fromJson({'id': 'biz-1', 'name': 'Demo Shop'});
final _branch = Branch(
  id: 'branch-1',
  description: 'Main',
  name: 'Main',
  longitude: '0',
  latitude: '0',
  businessId: 'biz-1',
  serverId: 1,
);

Future<void> _openHr(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 860);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authStateProvider.overrideWith(
          (ref) => Stream.value(AuthState.authenticated),
        ),
        hrSessionRepositoryProvider.overrideWithValue(
          FakeHrSessionRepository(session: ownerSession()),
        ),
        selectedBusinessProvider.overrideWithValue(_business),
        selectedBranchProvider.overrideWithValue(_branch),
        selectedBusinessRestoreProvider.overrideWith((ref) async {}),
        hrBillingRepositoryProvider.overrideWithValue(
          FakeHrBillingRepository(),
        ),
        employeeRepositoryProvider.overrideWithValue(
          FakeEmployeeRepository(
            seed: [employee(id: 'e-1', firstName: 'Aline', lastName: 'Uwase')],
          ),
        ),
        leaveRepositoryProvider.overrideWithValue(FakeLeaveRepository()),
        payRepositoryProvider.overrideWithValue(FakePayRepository()),
        hrAccountRepositoryProvider.overrideWithValue(
          FakeHrAccountRepository(),
        ),
        currentUserProfileProvider.overrideWith((ref) async => null),
        hrClockProvider.overrideWithValue(() => DateTime(2026, 10, 26)),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (route) => HrEmbeddedApp(
                    onExit: () => Navigator.of(route).pop(),
                    onUpgrade: () {},
                  ),
                ),
              ),
              child: const Text('open HR'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open HR'));
  await tester.pumpAndSettle();
}

Future<void> _openAlinesPay(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('hr-nav-pay')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Aline Uwase').first);
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('hr-person-next-pay')), findsOneWidget);
}

Finder get _headerBack => find.descendant(
  of: find.byKey(const Key('hr-embedded-app-bar')),
  matching: find.byType(AppBarRoundIconButton),
);

void main() {
  group('hrParentPath', () {
    test('a detail page goes up one level', () {
      expect(hrParentPath('/pay/e-1'), '/pay');
    });

    test('a top-level page has no parent', () {
      expect(hrParentPath('/pay'), isNull);
      expect(hrParentPath('/'), isNull);
    });
  });

  testWidgets('inside the mobile app HR wears Flipper\'s header', (
    tester,
  ) async {
    await _openHr(tester);

    final bar = tester.widget<CustomAppBar>(
      find.byKey(const Key('hr-embedded-app-bar')),
    );
    expect(bar.title, 'Home');
    expect(bar.icon, Icons.arrow_back);
  });

  testWidgets('the header back goes up a level, then out to Flipper', (
    tester,
  ) async {
    await _openHr(tester);
    await _openAlinesPay(tester);

    // The page's own text link gives way to the header.
    expect(find.byKey(const Key('hr-pay-back')), findsNothing);

    await tester.tap(_headerBack);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('hr-person-next-pay')), findsNothing);
    expect(find.byKey(const Key('hr-payroll-pay')), findsOneWidget);

    await tester.tap(_headerBack);
    await tester.pumpAndSettle();
    expect(find.text('open HR'), findsOneWidget);
  });

  testWidgets('system back does the same', (tester) async {
    await _openHr(tester);
    await _openAlinesPay(tester);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('hr-payroll-pay')), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('open HR'), findsOneWidget);
  });
}
