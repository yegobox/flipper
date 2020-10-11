
library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flipper/data/models/serializers/boolean_serializer.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/converters/switcher.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/tax.dart';


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
@SerializersFor([Switcher,Category,Tax,Product])
Serializers serializers = _$serializers;

Serializers standardSerializers = (serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer())
      ..add(BooleanSerializer()))
    .build();