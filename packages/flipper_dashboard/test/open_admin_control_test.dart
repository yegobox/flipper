import 'dart:async';

import 'package:flipper_dashboard/AdminControl.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';

class _MockRouterService extends Mock implements RouterService {}

void main() {
  setUpAll(() => registerFallbackValue(AdminControlRoute()));

  test(
    'repeated Settings taps push Admin Control once until it closes',
    () async {
      final router = _MockRouterService();
      var closed = Completer<void>();
      when(() => router.navigateTo(any())).thenAnswer((_) => closed.future);

      final first = openAdminControl(router: router);
      await openAdminControl(router: router);
      await openAdminControl(router: router);
      verify(() => router.navigateTo(any())).called(1);

      closed.complete();
      await first;

      closed = Completer<void>();
      final again = openAdminControl(router: router);
      verify(() => router.navigateTo(any())).called(1);
      closed.complete();
      await again;
    },
  );

  test('a failed push does not lock Admin Control out', () async {
    final router = _MockRouterService();
    when(
      () => router.navigateTo(any()),
    ).thenAnswer((_) => Future<void>.error(StateError('no router')));

    await expectLater(openAdminControl(router: router), throwsStateError);

    when(() => router.navigateTo(any())).thenAnswer((_) async {});
    await openAdminControl(router: router);
    verify(() => router.navigateTo(any())).called(2);
  });
}
