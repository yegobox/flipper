import 'package:flipper_services/payment_methods.dart';

export 'package:flipper_dashboard/utils/split_tender.dart';

/// Bar mode's own cash spelling; [canonicalPaymentMethod] keeps it as is.
const String kBarCash = 'Cash';

/// The card tender, spelled as the POS picker stores it (RRA `05`).
const String kBarCard = 'DEBIT&CREDIT CARD';

/// The tenders a table can be settled with, in picker order.
const List<String> barSettleMethods = [kBarCash, kMobileMoney, kBarCard];
