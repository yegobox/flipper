import 'package:flipper_models/mixins/EBMHandler.dart';
import 'package:realm/realm.dart';
import 'package:talker_flutter/talker_flutter.dart';

extension RealmExtension on Realm {
  void put<T extends RealmObject>(
    T object, {
    Function(T)? onAdd,
  }) {
    write(() {
      final talker = TalkerFlutter.init();
      add(object);
      talker.warning(
          "Saved using standart non async on realm extension :) ${object.toEJson()}");
      EBMHandler(object: object).handleReceipt();
    });
  }

  Future<void> putAsync<T extends RealmObject>(T object) async {
    await writeAsync(() async {
      final talker = TalkerFlutter.init();
      add(object);
      talker.warning(
          "Saved using async on realm Extension:) ${object.toEJson()}");
      EBMHandler(object: object).handleReceipt();
    });
  }
}
