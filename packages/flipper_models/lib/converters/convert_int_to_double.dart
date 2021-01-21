// Copyright (c) 2018, yegobox ltd. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

class ConvertIntToDouble implements PrimitiveSerializer<double> {
  final bool structured = false;
  @override
  final Iterable<Type> types = BuiltList<Type>([int]);
  @override
  final String wireName = 'int';
  @override
  Object serialize(Serializers serializers, double intdata,
      {FullType specifiedType = FullType.unspecified}) {
    return intdata.toDouble();
  }

  @override
  double deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    if (serialized is int) {
      return serialized.toDouble();
    } else if (serialized is double) {
      return serialized;
    }
    throw ArgumentError.value(
        serialized, 'serialized', 'My int selializer not working');
  }
}
