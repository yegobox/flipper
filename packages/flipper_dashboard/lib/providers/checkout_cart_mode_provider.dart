import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_models/brick/models/branch.model.dart';

/// Cart panel mode in QuickSellingView — independent of warehouse [isOrdering].
enum CheckoutCartMode { sale, transfer }

final checkoutCartModeProvider = StateProvider<CheckoutCartMode>(
  (ref) => CheckoutCartMode.sale,
);

/// Destination branch for outgoing POS transfer (Sale → Transfer).
final transferDestinationBranchProvider = StateProvider<Branch?>(
  (ref) => null,
);
