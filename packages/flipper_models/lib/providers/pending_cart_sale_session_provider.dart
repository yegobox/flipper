import 'package:flutter_riverpod/legacy.dart' show StateProvider;

/// Increments whenever the active POS sale cart is marked complete/settled.
///
/// Debounced search auto-add, scanner delays, and in-flight [addItemToTransaction]
/// calls can compare against this to avoid persisting lines into the wrong cart
/// after checkout.
final pendingCartSaleSessionProvider = StateProvider<int>((ref) => 0);
