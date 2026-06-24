import 'package:flipper_models/providers/provider_perf_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

final class StateObserver extends ProviderObserver {
  final Map<Object, DateTime> _updateStarted = {};

  bool _tracingEnabled(ProviderContainer container) {
    if (!kDebugMode) return false;
    try {
      return container.read(providerPerfTracingEnabledProvider);
    } catch (_) {
      return false;
    }
  }

  String _providerLabel(ProviderBase<Object?> provider) {
    return provider.name ?? provider.runtimeType.toString();
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (!_tracingEnabled(context.container)) return;

    final label = _providerLabel(context.provider);
    if (!providerPerfTraceMatches(label)) return;

    final started = _updateStarted.remove(context.provider);
    final elapsedMs = started != null
        ? DateTime.now().difference(started).inMilliseconds
        : null;

    debugPrint(
      '[RiverpodPerf] update $label'
      '${elapsedMs != null ? ' (${elapsedMs}ms)' : ''}',
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    _updateStarted.remove(context.provider);
  }
}
