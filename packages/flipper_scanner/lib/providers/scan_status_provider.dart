import 'package:hooks_riverpod/legacy.dart';

enum ScanStatus {
  idle,
  processing,
  waitingForDesktop,
  success,
  failed,
  desktopLoginSuccess,
}

final scanStatusProvider = StateProvider<ScanStatus>((ref) => ScanStatus.idle);
