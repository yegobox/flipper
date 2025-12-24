import 'package:ditto_live/ditto_live.dart';

/// Base class that provides core Ditto functionality
class DittoCore {
  /// The Ditto instance, accessible to mixins
  Ditto? _ditto;

  /// Sets the Ditto instance (called from main.dart after initialization)
  void setDitto(Ditto ditto) {
    _ditto = ditto;
  }

  /// Get the Ditto instance (for use by cache implementations)
  Ditto? get dittoInstance => _ditto;

  /// Get the Ditto store for direct access to Ditto operations
  Store? get store => _ditto?.store;

  /// Checks if Ditto is properly initialized and ready to use
  bool isReady() {
    return _ditto != null;
  }
}