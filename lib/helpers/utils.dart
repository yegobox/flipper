/// Take the passed [address] or serverAddress from Settings
/// and sanitize it, making sure it includes an http schema
String? getServerAddress({String? address}) {
  String serverAddress = address ?? "https://flipper.yegobox.com";

  String sanitized =
      serverAddress.replaceAll("https://", "").replaceAll("http://", "").trim();
  if (sanitized.isEmpty) return null;

  Uri? uri = Uri.tryParse(serverAddress);
  print("uri: $uri");
  if (uri?.scheme.isEmpty ?? true) {
    if (serverAddress.contains("ngrok.io")) {
      serverAddress = "https://$serverAddress";
    } else {
      serverAddress = "https://$serverAddress";
    }
  }

  return serverAddress;
}
