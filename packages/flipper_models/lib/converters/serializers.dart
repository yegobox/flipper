library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flipper_models/fuser.dart';
// import 'package:flipper_models/business_history.dart';
// import 'package:flipper_models/customer.dart';

// import '../branch.dart';
// import '../business.dart';
// import '../category.dart';
// import '../chat.dart';
// import '../fcontact.dart';
// import '../fuser.dart';
// import '../order.dart';
// import '../order_detail.dart';
// import '../pcolor.dart';
// import '../product.dart';
// import '../stock.dart';
// import '../tax.dart';
// import '../ticket.dart';
// import '../unit.dart';
// import '../variant_stock.dart';
// import '../variation.dart';
// import 'boolean_serializer.dart';
import 'boolean_serializer.dart';
import 'null_serializer.dart';

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
  // BusinessHistory,
  // Unit,
  // Category,
  // Stock,
  // Tax,
  // Product,
  // Business,
  // Branch,
  // Order,
  // Variation,
  FUser,
  // PColor,
  // VariantStock,
  // OrderDetail,
  // FContact,
  // Chat,
  // Ticket,
  // Customer,
])
Serializers serializers = _$serializers;

Serializers standardSerializers = (serializers.toBuilder()
      ..addBuilderFactory(
          // add this builder factory
          const FullType(BuiltList, [FullType(String)]),
          () => ListBuilder<String>())
      // ..addBuilderFactory(
      //     // add this builder factory
      //     const FullType(BuiltList, [FullType(Unit)]),
      //     () => ListBuilder<Unit>())
      ..addPlugin(
          RemoveNullInMapConvertedListPlugin()) //https://github.com/google/built_value.dart/issues/653
      // ..add(StringSerializer()) //convert anything that comes as int to string.
      // ..add(ConvertIntToDouble())
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer())
      ..add(BooleanSerializer()))
    .build();
