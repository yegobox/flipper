import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

class RemoveNullInMapConvertedListPlugin implements SerializerPlugin {
  Object beforeSerialize(Object object, FullType specifiedType) => object;

  Object afterSerialize(Object object, FullType specifiedType) => object;

  Object beforeDeserialize(Object object, FullType specifiedType) {
    if (specifiedType.root == BuiltMap && object is List) {
      return object.where((v) => v != null).toList();
    }

    return object;
  }

  Object afterDeserialize(Object object, FullType specifiedType) => object;
}
