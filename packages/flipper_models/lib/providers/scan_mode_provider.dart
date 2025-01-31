import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_mode_provider.g.dart';

@riverpod
class ScanningMode extends _$ScanningMode {
  @override
  bool build() {
    // Initial state: scanning mode is disabled (false)
    return false;
  }

  // Method to toggle scanning mode
  void toggleScanningMode() {
    state = !state; // Toggle the state between true and false
  }

  // Method to enable scanning mode
  void enableScanningMode() {
    state = true;
  }

  // Method to disable scanning mode
  void disableScanningMode() {
    state = false;
  }
}

@riverpod
class SearchString extends _$SearchString {
  @override
  String build() {
    // Initial state: empty search string
    return '';
  }

  // Method to update the search string
  void emitString({required String value}) {
    state = value;
  }

  // Method to clear the search string
  void clearSearchString() {
    state = '';
  }
}
