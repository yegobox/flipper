import 'dart:async';
import 'package:flipper_models/db_model_export.dart';

abstract class CompositeInterface {
  FutureOr<List<Composite>> composites({
    String? productId,
    String? variantId,
  });
}
