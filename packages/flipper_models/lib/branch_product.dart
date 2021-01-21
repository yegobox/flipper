library flipper_models;

import 'package:built_value/built_value.dart';

part 'branch_product.g.dart';

abstract class BranchProduct
    implements Built<BranchProduct, BranchProductBuilder> {
  int get productId;
  int get branchId;

  BranchProduct._();
  factory BranchProduct([void Function(BranchProductBuilder) updates]) =
      _$BranchProduct;
}
