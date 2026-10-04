import 'dart:async';

/// Keeps one live subscription to the active business's `business_features`
/// Ditto doc (branch capabilities such as INVENTORY / ORDERING) and moves it
/// whenever the Ditto instance changes.
///
/// [AppService.loadFeatures] used to subscribe exactly once, and only if Ditto
/// happened to be ready on the next tick. On the cached-session / PIN-login
/// path Ditto starts unawaited, so that check usually failed (or caught the
/// short-lived login instance) and nothing ever retried: features stayed empty
/// for the whole session and every capability-gated app (Purchases, Branch
/// Orders, Transfers Report, Stock Recount, Daily Reports, Production) was
/// hidden, no matter what the business type said.
///
/// Generic over the Ditto type so the bookkeeping is testable without a real
/// Ditto instance.
class BusinessFeaturesLoader<D extends Object> {
  BusinessFeaturesLoader({
    required this.addDittoListener,
    required this.removeDittoListener,
    required this.currentDitto,
    required this.businessId,
    required this.featureStream,
    required this.onFeatures,
    bool Function(D ditto)? isUsableDitto,
    this.retryDelays = defaultRetryDelays,
  }) : isUsableDitto = isUsableDitto ?? _always;

  /// Registers a listener that is called with the current instance right away
  /// and again on every instance change (`null` when Ditto is torn down).
  final void Function(void Function(D?) listener) addDittoListener;
  final void Function(void Function(D?) listener) removeDittoListener;
  final D? Function() currentDitto;
  final String? Function() businessId;

  /// Emits the doc's feature list, or `null` when there is no doc.
  final Stream<List<String>?> Function(String businessId) featureStream;
  final void Function(List<String> features) onFeatures;

  /// Instances that must not be subscribed on (e.g. the QR-login instance,
  /// which has no permissions on the business's collections).
  final bool Function(D ditto) isUsableDitto;

  /// Backoff before each re-subscribe after the feature stream errors or
  /// closes on its own (Ditto registration failure closes it). Bounded, so a
  /// permanently broken stream stops retrying; reset once data arrives.
  final List<Duration> retryDelays;

  static const defaultRetryDelays = [
    Duration(seconds: 2),
    Duration(seconds: 5),
    Duration(seconds: 15),
    Duration(seconds: 30),
    Duration(seconds: 60),
  ];

  // The live subscription and the (instance, business) pair it serves.
  StreamSubscription<List<String>?>? _subscription;
  D? _subscribedDitto;
  String? _subscribedBusinessId;

  /// Business whose capabilities [onFeatures] currently reflects.
  String? _shownBusinessId;

  // Retry budget, scoped to one (instance, business) pair.
  D? _retryDitto;
  Timer? _retryTimer;
  int _retryAttempt = 0;

  static bool _always(Object _) => true;

  /// Subscribe for the current business, now or as soon as Ditto is ready.
  /// Safe to call repeatedly (login, app init, business switch).
  void load() {
    // Remove-then-add keeps exactly one registration, and re-registers after
    // DittoService.dispose() clears every listener on logout.
    removeDittoListener(_onDittoChanged);
    addDittoListener(_onDittoChanged);
    _subscribe(currentDitto());
  }

  void _onDittoChanged(D? ditto) => _subscribe(ditto);

  void _subscribe(D? ditto) {
    final id = ditto == null || !isUsableDitto(ditto) ? null : businessId();
    if (ditto == null || id == null) {
      _reset();
      return;
    }

    if (_subscription != null &&
        identical(_subscribedDitto, ditto) &&
        _subscribedBusinessId == id) {
      return;
    }

    // Never let the previous business's capabilities (and the apps they
    // unlock) linger while the new business's doc loads. A Ditto instance
    // swap for the same business keeps them, so the menu doesn't flicker.
    if (id != _shownBusinessId) {
      _shownBusinessId = id;
      _retryAttempt = 0;
      onFeatures(const []);
    }
    if (!identical(ditto, _retryDitto)) {
      _retryDitto = ditto;
      _retryAttempt = 0;
    }

    _cancel();
    _subscribedDitto = ditto;
    _subscribedBusinessId = id;
    _subscription = featureStream(id).listen(
      (features) {
        _retryAttempt = 0;
        onFeatures(features ?? const []);
      },
      onError: (Object error) {
        print('Error in businessFeatureStream: $error');
        _onStreamFailed();
      },
      onDone: _onStreamFailed,
    );
  }

  void _onStreamFailed() {
    _cancel();
    onFeatures(const []);
    if (_retryAttempt >= retryDelays.length) {
      print('businessFeatureStream: giving up after $_retryAttempt retries');
      return;
    }
    _retryTimer = Timer(retryDelays[_retryAttempt++], () {
      _retryTimer = null;
      _subscribe(currentDitto());
    });
  }

  /// No usable Ditto or no active business: drop everything.
  void _reset() {
    _cancel();
    _shownBusinessId = null;
    _retryDitto = null;
    _retryAttempt = 0;
    onFeatures(const []);
  }

  /// Stops the live subscription and any pending retry.
  void _cancel() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _subscribedDitto = null;
    _subscribedBusinessId = null;
  }
}
