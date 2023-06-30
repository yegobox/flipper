import 'package:flutter/foundation.dart';

/// Handle platform errors not caught by Flutter.
///
/// This is useful for errors that happen outside of the Flutter context, such as
/// errors in the platform, or plugins.
void initializePlatformErrorHandler() {
  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };
}
