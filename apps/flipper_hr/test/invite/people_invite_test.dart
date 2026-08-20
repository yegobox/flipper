import 'package:flipper_hr/features/invite/data/hr_invite.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/employee_repository.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/people/people_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';
import '../helpers/fake_hr_invite_repository.dart';

final _today = DateTime(2026, 8, 18);

ProviderContainer _container({
  required FakeEmployeeRepository people,
  required FakeHrInviteRepository invites,
}) {
  final container = ProviderContainer(
    overrides: [
      employeeRepositoryProvider.overrideWithValue(people),
      hrInviteRepositoryProvider.overrideWithValue(invites),
      hrClockProvider.overrideWithValue(() => _today),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> _pumpPeople(
  WidgetTester tester, {
  required FakeEmployeeRepository people,
  required FakeHrInviteRepository invites,
}) async {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        employeeRepositoryProvider.overrideWithValue(people),
        hrInviteRepositoryProvider.overrideWithValue(invites),
        hrClockProvider.overrideWithValue(() => _today),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: PeoplePage(
            businessId: 'biz-1',
            branchId: 'branch-1',
            branchName: 'Kigali Main',
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('PeopleActions.invite', () {
    test('sends the record\'s phone, name and scope', () async {
      final invites = FakeHrInviteRepository();
      final container = _container(
        people: FakeEmployeeRepository(
          seed: [
            employee(
              id: 'e-1',
              firstName: 'Aline',
              lastName: 'Uwase',
              phone: '0788123456',
            ),
          ],
        ),
        invites: invites,
      );

      await container.read(peopleActionsProvider).invite(
        employee: (await container.read(rosterProvider('branch-1').future))
            .single,
        role: HrRole.staff,
      );

      expect(invites.calls.single.contact, '0788123456');
      expect(invites.calls.single.name, 'Aline Uwase');
      expect(invites.calls.single.businessId, 'biz-1');
      expect(invites.calls.single.branchId, 'branch-1');
      expect(invites.calls.single.role, HrRole.staff);
    });

    test('falls back to the email when there is no phone', () async {
      final invites = FakeHrInviteRepository();
      final container = _container(
        people: FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1', phone: '', email: 'aline@example.com'),
          ],
        ),
        invites: invites,
      );

      await container.read(peopleActionsProvider).invite(
        employee: (await container.read(rosterProvider('branch-1').future))
            .single,
        role: HrRole.staff,
      );

      expect(invites.calls.single.contact, 'aline@example.com');
    });

    test('links the account onto the record, which is what leave resolves through',
        () async {
      final people = FakeEmployeeRepository(seed: [employee(id: 'e-1')]);
      final container = _container(
        people: people,
        invites: FakeHrInviteRepository(),
      );

      final invite = await container.read(peopleActionsProvider).invite(
        employee: people.people.single,
        role: HrRole.staff,
      );

      expect(invite.userId, 'user-new');
      expect(people.people.single.userId, 'user-new');
      expect(people.people.single.hasFlipperAccount, isTrue);
    });

    test('refreshes the roster so the row shows the new account', () async {
      final people = FakeEmployeeRepository(seed: [employee(id: 'e-1')]);
      final container = _container(
        people: people,
        invites: FakeHrInviteRepository(),
      );
      final before = await container.read(rosterProvider('branch-1').future);
      expect(before.single.hasFlipperAccount, isFalse);

      await container.read(peopleActionsProvider).invite(
        employee: before.single,
        role: HrRole.manager,
      );

      final after = await container.read(rosterProvider('branch-1').future);
      expect(after.single.userId, 'user-new');
    });

    test('a pipeline failure propagates with its step', () async {
      final container = _container(
        people: FakeEmployeeRepository(seed: [employee(id: 'e-1')]),
        invites: FakeHrInviteRepository(
          failWith: HrInviteException(
            'apihub said no',
            step: HrInviteStep.issuePin,
          ),
        ),
      );

      await expectLater(
        container.read(peopleActionsProvider).invite(
          employee: (await container.read(rosterProvider('branch-1').future))
              .single,
          role: HrRole.staff,
        ),
        throwsA(
          isA<HrInviteException>().having(
            (e) => e.step,
            'step',
            HrInviteStep.issuePin,
          ),
        ),
      );
    });

    test('a failed link is reported as linkEmployee, not as a failed invite',
        () async {
      // The distinction matters to whoever reads the message: the account and the
      // PIN are real by then, so "try again" is wrong advice.
      final people = FakeEmployeeRepository(seed: [employee(id: 'e-1')]);
      final container = _container(
        people: people,
        invites: FakeHrInviteRepository(),
      );
      final employeeRow = people.people.single;
      people.failWith = EmployeeRepositoryException('row-level security');

      await expectLater(
        container.read(peopleActionsProvider).invite(
          employee: employeeRow,
          role: HrRole.staff,
        ),
        throwsA(
          isA<HrInviteException>()
              .having((e) => e.step, 'step', HrInviteStep.linkEmployee)
              .having((e) => e.message, 'message', contains('row-level')),
        ),
      );
    });
  });

  group('the roster row', () {
    testWidgets('offers an invite for someone with no account yet',
        (tester) async {
      await _pumpPeople(
        tester,
        people: FakeEmployeeRepository(seed: [employee(id: 'e-1')]),
        invites: FakeHrInviteRepository(),
      );

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();

      expect(find.text('Invite to HR'), findsOneWidget);
    });

    testWidgets('offers a re-send once they have one', (tester) async {
      await _pumpPeople(
        tester,
        people: FakeEmployeeRepository(
          seed: [employee(id: 'e-1', userId: 'user-1')],
        ),
        invites: FakeHrInviteRepository(),
      );

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();

      expect(find.text('Re-send HR invite'), findsOneWidget);
    });

    testWidgets('does not offer one to someone who has left', (tester) async {
      await _pumpPeople(
        tester,
        people: FakeEmployeeRepository(
          seed: [
            employee(
              id: 'e-1',
              status: EmploymentStatus.terminated,
              endDate: DateTime(2026, 7, 1),
            ),
          ],
        ),
        invites: FakeHrInviteRepository(),
      );
      // Terminated people are filtered out by default.
      await tester.tap(find.byKey(const Key('people-status-filter')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terminated').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('people-menu-invite')), findsNothing);
    });
  });

  group('inviting from the roster', () {
    testWidgets('asks for a role, then shows the PIN', (tester) async {
      final invites = FakeHrInviteRepository(pin: '246810');
      await _pumpPeople(
        tester,
        people: FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1', firstName: 'Aline', lastName: 'Uwase'),
          ],
        ),
        invites: invites,
      );

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invite to HR'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('invite-role-dialog')), findsOneWidget);
      expect(find.text('Invite Aline Uwase to HR'), findsOneWidget);

      await tester.tap(find.byKey(const Key('invite-confirm')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('invite-pin-dialog')), findsOneWidget);
      expect(find.text('246810'), findsOneWidget);
      expect(invites.calls.single.role, HrRole.staff);
    });

    testWidgets('a manager invite sends the manager role', (tester) async {
      final invites = FakeHrInviteRepository();
      await _pumpPeople(
        tester,
        people: FakeEmployeeRepository(seed: [employee(id: 'e-1')]),
        invites: invites,
      );

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invite to HR'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('invite-role-manager')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('invite-confirm')));
      await tester.pumpAndSettle();

      expect(invites.calls.single.role, HrRole.manager);
    });

    testWidgets('cancelling sends nothing', (tester) async {
      final invites = FakeHrInviteRepository();
      await _pumpPeople(
        tester,
        people: FakeEmployeeRepository(seed: [employee(id: 'e-1')]),
        invites: invites,
      );

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invite to HR'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(invites.calls, isEmpty);
      expect(find.byKey(const Key('invite-pin-dialog')), findsNothing);
    });

    testWidgets('a record with no contact cannot be invited', (tester) async {
      final invites = FakeHrInviteRepository();
      await _pumpPeople(
        tester,
        people: FakeEmployeeRepository(
          seed: [employee(id: 'e-1', phone: '', email: '')],
        ),
        invites: invites,
      );

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invite to HR'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('nowhere to send an invite'),
        findsOneWidget,
      );
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('invite-confirm')))
            .onPressed,
        isNull,
      );
    });

    testWidgets('an email-only record warns that sign-in needs SMS',
        (tester) async {
      await _pumpPeople(
        tester,
        people: FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1', phone: '', email: 'aline@example.com'),
          ],
        ),
        invites: FakeHrInviteRepository(),
      );

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invite to HR'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('add a phone number before inviting'),
        findsOneWidget,
      );
    });

    testWidgets('a failure shows the message and no PIN', (tester) async {
      await _pumpPeople(
        tester,
        people: FakeEmployeeRepository(seed: [employee(id: 'e-1')]),
        invites: FakeHrInviteRepository(
          failWith: HrInviteException(
            'Branch does not belong to business',
            step: HrInviteStep.grantMembership,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invite to HR'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('invite-confirm')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('invite-pin-dialog')), findsNothing);
      expect(
        find.text('Branch does not belong to business'),
        findsOneWidget,
      );
    });

    testWidgets('a link failure says the invite was sent', (tester) async {
      final people = FakeEmployeeRepository(seed: [employee(id: 'e-1')]);
      await _pumpPeople(
        tester,
        people: people,
        invites: FakeHrInviteRepository(),
      );
      people.failWith = EmployeeRepositoryException('row-level security');

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invite to HR'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('invite-confirm')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Invite sent, but not linked'),
        findsOneWidget,
      );
    });
  });
}
