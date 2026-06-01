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
