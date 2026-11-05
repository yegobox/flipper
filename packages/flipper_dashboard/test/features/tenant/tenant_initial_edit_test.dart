import 'dart:async';

import 'package:flipper_dashboard/features/tenant/mixins/tenant_management_mixin.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import '../../test_helpers/mocks.dart';

/// User Management's form logic, with the `accesses` lookup under the
/// test's control.
class _Host extends ConsumerStatefulWidget {
  const _Host({super.key});

  @override
  ConsumerState<_Host> createState() => _HostState();
}

class _HostState extends ConsumerState<_Host> with TenantManagementMixin {
  final lookups = <String, Completer<List<Access>>>{};

  @override
  Future<List<Access>> fetchTenantAccessesForEdit(Tenant tenant) =>
      (lookups[tenant.id] = Completer<List<Access>>()).future;

  void answer(String tenantId) => lookups[tenantId]!.complete(const []);

  @override
  void initState() {
    super.initState();
    initTenantFormListeners();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Form(key: formKey, child: buildUserTypeDropdown()),
  );
}

class _Model extends FlipperBaseModel {
  _Model(this._roster, {this.fresh = true});

  final List<Tenant> _roster;
  final bool fresh;

  @override
  List<Tenant> get tenants => _roster;

  @override
  bool get tenantsFresh => fresh;
}

final _cashier = Tenant(
  id: 't-c',
  name: 'Cashier',
  userId: 'u-c',
  type: 'Cashier',
);
final _owner = Tenant(id: 'u-o', name: 'Owner', userId: 'u-o', type: 'Owner');

void main() {
  late GlobalKey<_HostState> key;

  setUp(() async {
    await getIt.reset();
    final box = MockBox();
    when(() => box.getBusinessId()).thenReturn('biz-1');
    when(() => box.getBranchId()).thenReturn('br-1');
    when(() => box.getUserId()).thenReturn('u-admin');
    getIt.registerSingleton<LocalStorage>(box);
    if (locator.isRegistered<RouterService>()) {
      locator.unregister<RouterService>();
    }
    locator.registerSingleton<RouterService>(MockRouterService());
    key = GlobalKey<_HostState>();
  });

  tearDown(() async {
    if (locator.isRegistered<RouterService>()) {
      locator.unregister<RouterService>();
    }
    await getIt.reset();
  });

  Future<_HostState> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: _Host(key: key),
        ),
      ),
    );
    return key.currentState!;
  }

  test('the owner edits as an Admin; other stored roles stay as stored', () {
    expect(TenantManagementMixin.formUserType('Owner'), 'Admin');
    expect(TenantManagementMixin.formUserType('owner'), 'Admin');
    expect(TenantManagementMixin.formUserType(null), 'Agent');
    expect(TenantManagementMixin.formUserType('Cashier'), 'Cashier');
    expect(TenantManagementMixin.formUserType('Manager'), 'Manager');
  });

  testWidgets('opening the owner shows Admin in the role list', (tester) async {
    final host = await pump(tester);
    final opening = host.openInitialEdit(_Model([_owner]), _owner);
    host.answer('u-o');
    await opening;
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(host.selectedUserType, 'Admin');
    expect(host.nameController.text, 'Owner');
  });

  testWidgets('a legacy role the list lacks does not trip the dropdown', (
    tester,
  ) async {
    final host = await pump(tester);
    final legacy = Tenant(
      id: 't-m',
      name: 'Manager',
      userId: 'u-m',
      type: 'Manager',
    );
    final opening = host.selectTenantForEdit(legacy, _Model([legacy]));
    host.answer('t-m');
    await opening;
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(host.selectedUserType, 'Manager');
  });

  testWidgets('a slower lookup for an earlier pick never wins', (tester) async {
    final host = await pump(tester);
    final model = _Model([_cashier, _owner]);
    final first = host.selectTenantForEdit(_cashier, model);
    final second = host.selectTenantForEdit(_owner, model);
    host.answer('u-o');
    await second;
    host.answer('t-c');
    await first;
    await tester.pump();
    expect(host.nameController.text, 'Owner');
    expect(host.editedTenant, same(_owner));
  });

  testWidgets('Add New during a lookup keeps the form empty', (tester) async {
    final host = await pump(tester);
    final opening = host.selectTenantForEdit(_cashier, _Model([_cashier]));
    host.resetForm();
    host.answer('t-c');
    await opening;
    expect(host.nameController.text, isEmpty);
    expect(host.editMode, isFalse);
  });

  testWidgets('typing while the Edit target loads keeps what was typed', (
    tester,
  ) async {
    final host = await pump(tester);
    final opening = host.openInitialEdit(_Model([_cashier]), _cashier);
    host.nameController.text = 'New person';
    host.answer('t-c');
    await opening;
    await tester.pump();
    expect(host.nameController.text, 'New person');
    expect(host.editMode, isFalse);
    expect(host.selectedTenantUserId, isNull);
  });

  testWidgets('a pick made while the roster loaded is not replaced', (
    tester,
  ) async {
    final host = await pump(tester);
    final model = _Model([_cashier, _owner]);
    final picked = host.selectTenantForEdit(_owner, model);
    host.answer('u-o');
    await picked;
    await host.openInitialEdit(model, _cashier);
    expect(host.lookups.containsKey('t-c'), isFalse);
    expect(host.editedTenant, same(_owner));
  });

  testWidgets('a row with no sign-in account says so instead of a blank form', (
    tester,
  ) async {
    final host = await pump(tester);
    await host.openInitialEdit(
      _Model([_cashier]),
      Tenant(id: 't-x', name: 'Agent King'),
    );
    await tester.pump();
    expect(
      find.text(
        'Agent King has no sign-in account to edit yet. Add them as a new '
        'user to give them one.',
      ),
      findsOneWidget,
    );
    expect(host.editMode, isFalse);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('someone a fresh roster no longer lists is not opened', (
    tester,
  ) async {
    final host = await pump(tester);
    final gone = Tenant(id: 't-g', name: 'Gone', userId: 'u-g');
    await host.openInitialEdit(_Model([_cashier]), gone);
    await tester.pump();
    expect(host.lookups, isEmpty);
    expect(
      find.text("Gone is no longer on this business's staff."),
      findsOneWidget,
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // From the offline copy, which may predate them, they still open.
    final opening = host.openInitialEdit(
      _Model([_cashier], fresh: false),
      gone,
    );
    host.answer('t-g');
    await opening;
    expect(host.editedTenant, same(gone));
  });
}
