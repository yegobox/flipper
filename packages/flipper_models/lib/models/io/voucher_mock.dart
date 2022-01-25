import 'package:flipper_models/models/models.dart';

Voucher voucherMock = new Voucher(
    id: DateTime.now().millisecondsSinceEpoch,
    value: 1,
    interval: 1,
    used: false,
    createdAt: 111,
    usedAt: 111,
    features: [Feature(name: 'inventory', id: 2)],
    descriptor: "Daily");
