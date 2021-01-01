library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flipper/data/models/serializers/boolean_serializer.dart';

import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/converters/null_serializer.dart';
import 'package:flipper/model/converters/switcher.dart';
import 'package:flipper/model/fuser.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/pcolor.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/stock.dart';
import 'package:flipper/model/tax.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/model/variation.dart';

import 'int_to_string_serializer.dart';

part 'serializers.g.dart';

/// Example of how to use built_value serialization.
///
/// Declare a top level [Serializers] field called serializers. Annotate it
/// with [SerializersFor] and provide a `const` `List` of types you want to
/// be serializable.
///
/// The built_value code generator will provide the implementation. It will
/// contain serializers for all the types asked for explicitly plus all the
/// types needed transitively via fields.
///
/// You usually only need to do this once per project.
@SerializersFor([
  Switcher,
  Unit,
  Category,
  Stock,
  Tax,
  Product,
  Business,
  Branch,
  Order,
  Variation,
  FUser,
  PColor
])
Serializers serializers = _$serializers;

Serializers standardSerializers = (serializers.toBuilder()
      ..addBuilderFactory(
          // add this builder factory
          const FullType(BuiltList, [FullType(String)]),
          () => ListBuilder<
              String>()) //if I want to return a list of business for example I will add it here like that
      ..addPlugin(
          RemoveNullInMapConvertedListPlugin()) //https://github.com/google/built_value.dart/issues/653
      ..add(StringSerializer()) //convert anything that comes as int to string.
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer())
      ..add(BooleanSerializer()))
    .build();
