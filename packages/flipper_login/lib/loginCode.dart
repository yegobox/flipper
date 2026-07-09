/// Fresh QR channel id for each desktop login screen visit.
String newDesktopLoginCode() =>
    'login-${DateTime.now().millisecondsSinceEpoch}';
