import 'dart:io' show Platform;

bool get isAndroid => Platform.isAndroid;
bool get isMobile => Platform.isAndroid || Platform.isIOS;
