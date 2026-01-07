import 'package:flutter_riverpod/flutter_riverpod.dart';

final class StateObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderObserverContext context,
    Object? value,
  ) {
    // debugPrint('Provider ${context.provider} initialized with $value');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    // debugPrint(
    //   'Provider ${context.provider} updated from $previousValue to $newValue',
    // );
  }

  @override
  void didDisposeProvider(
    ProviderObserverContext context,
  ) {
    // debugPrint('Provider ${context.provider} disposed');
  }
}
