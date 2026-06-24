/// Maps a Ditto store [execute] / observer result to typed row maps.
///
/// On web, `.map(...).toList()` infers [List<dynamic>]; use this helper so
/// streams accept [List<Map<String, dynamic>>].
List<Map<String, dynamic>> dittoQueryRows(dynamic queryResult) {
  final items = queryResult.items as Iterable;
  return <Map<String, dynamic>>[
    for (final item in items)
      Map<String, dynamic>.from(item.value as Map),
  ];
}

/// Best-effort cancel for Ditto [Store.registerObserver] handles.
///
/// Riverpod may dispose streams after [Ditto.close] (logout, user switch, or
/// background-sync teardown). Cancel then throws [DittoException] — safe to ignore.
Future<void> cancelDittoStoreObserver(dynamic observer) async {
  if (observer == null) return;
  try {
    await observer.cancel();
  } catch (_) {
    // Ditto instance already closed or observer already torn down.
  }
}
