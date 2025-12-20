import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

void invalidateAllProviders(
  ProviderContainer container,
  List<ProviderBase> providers,
) {
  for (final provider in providers) {
    container.refresh(provider);
  }
}
