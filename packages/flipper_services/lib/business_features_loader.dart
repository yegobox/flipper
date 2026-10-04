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

  StreamSubscription<List<String>?>? _subscription;
  D? _subscribedDitto;
  String? _subscribedBusinessId;

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
    if (ditto == null || !isUsableDitto(ditto)) {
      _cancel();
      onFeatures(const []);
      return;
    }

    final id = businessId();
    if (id == null) return;

    if (_subscription != null &&
        identical(_subscribedDitto, ditto) &&
        _subscribedBusinessId == id) {
      return;
    }

    _cancel();
    _subscribedDitto = ditto;
    _subscribedBusinessId = id;
    _subscription = featureStream(id).listen(
      (features) => onFeatures(features ?? const []),
      onError: (Object error) {
        print('Error in businessFeatureStream: $error');
        // Forget the pairing so the next load() or instance change retries.
        _cancel();
        onFeatures(const []);
      },
    );
  }

  void _cancel() {
    _subscription?.cancel();
    _subscription = null;
    _subscribedDitto = null;
    _subscribedBusinessId = null;
  }
}
