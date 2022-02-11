import 'package:flipper_models/models/models.dart';

final reports = <OrderItemSync>[
  OrderItemSync(
    name: "mango",
    fvariantId: 1,
    count: 10,
    price: 200,
    forderId: 1,
    discount: 10,
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
  )
];
