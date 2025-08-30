import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ScanStatus { idle, processing, success, failed, desktopLoginSuccess }

final scanStatusProvider = StateProvider<ScanStatus>((ref) => ScanStatus.idle);
