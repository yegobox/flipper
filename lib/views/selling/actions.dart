import 'package:flipper/model/total.dart';
import 'package:flutter/material.dart';

@immutable
class OnSellingVariant {
  final String variantId;

  const OnSellingVariant({@required this.variantId});
}

class OnNewTotal {
  final Total total;

  const OnNewTotal({@required this.total});
}
