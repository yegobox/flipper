import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider for tracking upload progress
final uploadProgressProvider = StateProvider<double>((ref) => 0.0);
