import 'platform.dart';

String getPlatformName() {
  if (isAndroid) return 'Android';
  if (isIOS) return 'iOS';
  if (isWeb) return 'Web';
  if (isWindows) return 'Windows';
  if (isMacOS) return 'macOS';
  if (isLinux) return 'Linux';
  return 'Unknown';
}
