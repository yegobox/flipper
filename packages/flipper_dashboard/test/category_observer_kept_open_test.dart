import 'dart:io';

import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_categories.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart' show Category;
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStrategy extends Mock implements DatabaseSyncInterface {}

class _FakeServices extends BranchServices {
  final _MockStrategy mockStrategy = _MockStrategy();

  @override
  DatabaseSyncInterface get strategy => mockStrategy;
}

/// [categoryProvider] is a kept-alive live observer. Restarting it runs the
/// synchronous Ditto observer start on the UI thread again, which is the
/// freeze #947 fixes, so nothing may refresh or invalidate it.
void main() {
  test('creating a category from an SMS keeps the open observer', () async {
    final services = _FakeServices();
    when(
      () => services.mockStrategy.addCategory(
        id: any(named: 'id'),
        name: any(named: 'name'),
        branchId: any(named: 'branchId'),
        active: any(named: 'active'),
        focused: any(named: 'focused'),
        lastTouched: any(named: 'lastTouched'),
        createdAt: any(named: 'createdAt'),
        deletedAt: any(named: 'deletedAt'),
      ),
    ).thenAnswer((_) async {});

    var builds = 0;
    final container = ProviderContainer(
      overrides: [
        branchServicesProvider.overrideWithValue(services),
        categoryProvider.overrideWith((ref) {
          builds++;
          return Stream.value(const <Category>[]);
        }),
      ],
    );
    addTearDown(container.dispose);
    final sub = container.listen(categoryProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(categoryProvider.future);

    final id = await container
        .read(smsCategoryStoreProvider)
        .create('Fuel', 'b1');
    await container.pump();

    expect(id, isNotEmpty);
    expect(builds, 1);
  });

  test('no screen refreshes or invalidates categoryProvider', () {
    final restart = RegExp(r'(refresh|invalidate)\(\s*categoryProvider\b');
    final offenders = <String>[
      for (final file in Directory('lib').listSync(recursive: true))
        if (file is File &&
            file.path.endsWith('.dart') &&
            restart.hasMatch(file.readAsStringSync()))
          file.path,
    ];
    expect(offenders, isEmpty);
  });
}
