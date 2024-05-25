import 'package:flipper_models/RealmApi.dart';
import 'package:test/test.dart';

void main() {
  group('Isar Realm API!', () {
    // late Product product;
    // late Order order;
    RealmAPI realm = RealmAPI();
    setUpAll(() async {
      await realm.configure(
        useInMemoryDb: true,
      );
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