import 'dart:async';

/// Coalesces a burst of values into at most one delivery per [window].
///
/// The first value goes straight to [deliver], so a quiet stream reacts at
/// once. Values that arrive while the window is open replace one another,
/// and only the newest is delivered when it closes (which opens the next
/// window). A sync burst that changes forty stock rows in a second therefore
/// costs the UI a few decodes and rebuilds instead of forty.
class LatestThrottle<T> {
  LatestThrottle(this.window, this.deliver);

  final Duration window;
  final void Function(T value) deliver;

  Timer? _timer;
  T? _pending;
  bool _hasPending = false;
  bool _closed = false;

  void add(T value) {
    if (_closed) return;
    if (_timer == null) {
      deliver(value);
      _openWindow();
      return;
    }
    _pending = value;
    _hasPending = true;
  }

  void _openWindow() {
    _timer = Timer(window, () {
      _timer = null;
      if (!_hasPending || _closed) return;
      final value = _pending as T;
      _pending = null;
      _hasPending = false;
      deliver(value);
      _openWindow();
    });
  }

  /// Drops anything pending; nothing is delivered after this.
  void close() {
    _closed = true;
    _timer?.cancel();
    _timer = null;
    _pending = null;
    _hasPending = false;
  }
}
