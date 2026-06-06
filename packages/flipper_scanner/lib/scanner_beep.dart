import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Short feedback when a barcode is scanned. Android/iOS only; no-op elsewhere.
class ScannerBeep {
  ScannerBeep._();

  static Future<void> playSuccess() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        try {
          await SystemSound.play(SystemSoundType.click);
        } catch (_) {
          // Ignore if the platform cannot play the sound.
        }
      default:
        break;
    }
  }
}
