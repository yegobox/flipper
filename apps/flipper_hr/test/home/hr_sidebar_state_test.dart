import 'package:flipper_hr/features/home/hr_sidebar_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer container() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  test('the sidebar starts collapsed', () async {
    SharedPreferences.setMockInitialValues({});
    final c = container();

    // Synchronously, on the first frame — restoring a width a frame late is a
    // visible jump.
    expect(c.read(hrSidebarCollapsedProvider), isTrue);
  });

  test('a stored preference is restored', () async {
    SharedPreferences.setMockInitialValues({
      HrSidebarCollapsed.prefKey: false,
    });
    final c = container();

    expect(c.read(hrSidebarCollapsedProvider), isTrue);
    await Future<void>.delayed(Duration.zero);
    expect(c.read(hrSidebarCollapsedProvider), isFalse);
  });

  test('toggling expands it and remembers', () async {
    SharedPreferences.setMockInitialValues({});
    final c = container();
    await Future<void>.delayed(Duration.zero);

    c.read(hrSidebarCollapsedProvider.notifier).toggle();
    expect(c.read(hrSidebarCollapsedProvider), isFalse);

    await Future<void>.delayed(Duration.zero);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(HrSidebarCollapsed.prefKey), isFalse);
  });

  test('storage with nothing stored leaves the default standing', () async {
    SharedPreferences.setMockInitialValues({'something_else': true});
    final c = container();

    expect(c.read(hrSidebarCollapsedProvider), isTrue);
    await Future<void>.delayed(Duration.zero);
    expect(c.read(hrSidebarCollapsedProvider), isTrue);
  });
}
