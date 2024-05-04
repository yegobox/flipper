import 'package:flipper_models/mixins/EBMHandler.dart';
import 'package:realm/realm.dart';

extension RealmExtension on Realm {
  T put<T extends RealmObject>(
    T object, {
    Function(T)? onAdd,
  }) {
    final addedObject = write(() {
      add(object);
      EBMHandler(object: object).handleReceipt();
    });
    onAdd?.call(addedObject);
    return addedObject;
  }
}
