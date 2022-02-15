import 'package:flipper_models/models/models.dart';

Voucher voucherMock = Voucher(
  id: DateTime.now().millisecondsSinceEpoch,
  value: 1,
  interval: 1,
  used: false,
  createdAt: 111,
  usedAt: 111,
  descriptor: "Daily",
);
