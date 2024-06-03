import 'package:flutter_riverpod/flutter_riverpod.dart';

void invalidateAllProviders(
    ProviderContainer container, List<ProviderBase> providers) {
  for (final provider in providers) {
    container.invalidate(provider);
  }
}
