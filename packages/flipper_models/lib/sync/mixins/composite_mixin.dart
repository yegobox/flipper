import 'package:flipper_models/sync/utils/composite_ditto.dart';
import 'dart:async';
import 'package:flipper_models/sync/interfaces/composite_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin CompositeMixin implements CompositeInterface {
  Repository get repository;

  @override
  FutureOr<List<Composite>> composites({
    String? productId,
    String? variantId,
    bool localOnly = false,
  }) async {
    return await repository.get<Composite>(
      policy: compositesGetPolicy(localOnly: localOnly),
      query: Query(
        where: [
          if (productId != null) Where('productId').isExactly(productId),
          if (variantId != null) Where('variantId').isExactly(variantId),
        ],
      ),
    );
  }
}
