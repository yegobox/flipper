import 'dart:convert';

/// Sync subscriptions that live as long as their Ditto instance, registered
/// once per query and arguments.
///
/// Most call sites register a subscription and drop it: they want the data to
/// keep syncing for the rest of the session. Each call used to register a new
/// one anyway, and none was ever cancelled. A stream rebuilt on every sale or
/// search (the POS cart, customer lookups, reports) piled up hundreds of
/// identical branch-wide subscriptions. Ditto's sync evaluated every one, and
/// each registration is a synchronous call on the UI thread that waits for
/// Ditto. Together they froze the till for minutes (2026-11-09).
///
/// Use [register] wherever the subscription is not kept and cancelled. A call
/// site that cancels its own subscription keeps calling Ditto directly.
abstract final class SharedSyncSubscriptions {
  /// Arguments that move with time. A newer value replaces the subscription
  /// made with the older one instead of adding a second.
  static const Set<String> movingArguments = {'historyWindowStart'};

  static final Expando<Map<String, _Live>> _byDitto = Expando(
    'SharedSyncSubscriptions',
  );

  static int _registrations = 0;

  /// How many times Ditto was actually asked to register (for tests and
  /// diagnostics); a repeat of a live subscription does not count.
  static int get registrations => _registrations;

  /// Live shared subscriptions on [ditto].
  static int liveOn(Object ditto) => _byDitto[ditto]?.length ?? 0;

  /// Makes sure [query] with [arguments] is subscribed on [ditto].
  ///
  /// A no-op when the same subscription is already live. When only a
  /// [movingArguments] value changed, the new one is registered first and the
  /// old one cancelled after, so syncing never pauses.
  static void register(
    dynamic ditto,
    String query, {
    Map<String, dynamic>? arguments,
  }) {
    if (ditto == null) return;
    final args = arguments ?? const <String, dynamic>{};
    final slot = _key(query, args, skipMoving: true);
    final exact = _key(query, args, skipMoving: false);
    final live = _byDitto[ditto] ??= <String, _Live>{};

    final previous = live[slot];
    if (previous != null && previous.exactKey == exact) return;

    final subscription = arguments == null
        ? ditto.sync.registerSubscription(query)
        : ditto.sync.registerSubscription(query, arguments: arguments);
    _registrations++;
    live[slot] = _Live(exact, subscription);
    if (previous != null) {
      try {
        previous.subscription?.cancel();
      } catch (_) {
        // Already gone with its Ditto session.
      }
    }
  }

  static String _key(
    String query,
    Map<String, dynamic> args, {
    required bool skipMoving,
  }) {
    final names = args.keys.toList()..sort();
    final parts = <String>[query];
    for (final name in names) {
      if (skipMoving && movingArguments.contains(name)) continue;
      parts.add('$name=${_canonical(args[name])}');
    }
    return parts.join('\u0000');
  }

  static String _canonical(Object? value) {
    if (value is Map) {
      final keys = value.keys.map((k) => '$k').toList()..sort();
      return '{${keys.map((k) => '$k:${_canonical(value[k])}').join(',')}}';
    }
    if (value is Iterable) return '[${value.map(_canonical).join(',')}]';
    if (value is DateTime) return value.toIso8601String();
    try {
      return jsonEncode(value);
    } catch (_) {
      return '$value';
    }
  }
}

class _Live {
  _Live(this.exactKey, this.subscription);

  final String exactKey;
  final dynamic subscription;
}
