import 'package:flipper_models/mixins/EBMHandler.dart';
import 'package:realm/realm.dart';
import 'package:talker_flutter/talker_flutter.dart';

extension RealmExtension on Realm {
  T put<T extends RealmObject>(
    T object, {
    Function(T)? onAdd,
  }) {
    final addedObject = write(() {
      final talker = TalkerFlutter.init();
      add(object);
      talker.warning("Saved using the Put, I fill like I am flying :) ");
      EBMHandler(object: object).handleReceipt();
    });
    onAdd?.call(addedObject);
    return addedObject;
  }
}
