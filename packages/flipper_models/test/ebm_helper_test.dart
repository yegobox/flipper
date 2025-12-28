import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/business.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class MockBox extends Mock implements LocalStorage {}

class ObjWithStringTin {
  final String tinNumber;
  ObjWithStringTin(this.tinNumber);
}

void main() {
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    // Ensure we don't attempt to read Ebm via strategy.ebm() by
    // making getBranchId return null in these unit tests.
    when(() => mockBox.getBranchId()).thenReturn(null);
    when(() => mockBox.tin()).thenReturn(9999);

    ProxyService.box = mockBox;
  });

  test('returns tin from Business model', () async {
    final biz = Business(
      id: '1',
      name: 'Test',
      serverId: 1,
      longitude: '0',
      latitude: '0',
      userId: "1",
      tinNumber: 12345,
      encryptionKey: 'k',
    );

    final res = await effectiveTin(business: biz);
    expect(res, equals(12345));
  });

  test('returns tin from Map with int value', () async {
    final res = await effectiveTin(business: {'tinNumber': 2222});
    expect(res, equals(2222));
  });

  test('returns tin from Map with string value', () async {
    final res = await effectiveTin(business: {'tin': '3333'});
    expect(res, equals(3333));
  });

  test('returns parsed tin from object with string tinNumber', () async {
    final obj = ObjWithStringTin('4444');
    // dynamic property access should pick up `tinNumber` and parse it
    final res = await effectiveTin(business: obj);
    expect(res, equals(4444));
  });

  test('falls back to ProxyService.box.tin() when business is null', () async {
    final res = await effectiveTin(business: null);
    expect(res, equals(9999));
  });
}
