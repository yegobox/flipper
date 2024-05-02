import 'package:flipper_models/RealmApi.dart';
import 'package:test/test.dart';

void main() {
  group('Isar Realm API!', () {
    // late Product product;
    // late Order order;
    RealmAPI realm = RealmAPI();
    setUpAll(() async {
      await realm.configure(
          inTesting: true,
          encryptionKey:
              "255,127,225,47,153,12,216,192,168,83,5,110,69,108,17,239,25,17,228,125,159,97,202,180,199,78,240,210,189,227,24,186,234,72,160,179,190,60,3,213,213,250,250,7,249,96,114,48,59,228,163,153,200,239,102,163,187,244,48,225,156,219,211,253");
    });

    tearDownAll(() {});

    test('Realm API', () async {
      expect(2, 2);
    });
  });
}

// https://stackoverflow.com/questions/49004259/hot-reload-during-unit-testing
// https://www.tobinharris.com/past/2020/6/12/automatically-running-flutter-tests-when-a-file-changes/
// https://docs.page/invertase/spec
// https://medium.com/flutter-community/shortening-flutter-test-feedback-cycle-in-vs-code-890ab15c0b2d


// import 'package:flutter_test/flutter_test.dart';
// import 'package:realm/realm.dart';
// import 'package:realm_unittest/main.dart';

// void main() {
//   test('Test with Realm', () {
//     final realm = Realm(Configuration.inMemory([Counter.schema]));
//     realm.write(() {
//       realm.add(Counter(0));
//     });
//     expect(realm.all<Counter>().first.value, 0);
//   });
// }