import 'package:flutter_riverpod/legacy.dart';

// Navigation state providers
final selectedMenuItemProvider = StateProvider<int>(
  (ref) => -1,
); // -1 represents the Apps screen
final defaultAppProvider = StateProvider<String?>((ref) => null);
final isDefaultAppLoadedProvider = StateProvider<bool>((ref) => false);
