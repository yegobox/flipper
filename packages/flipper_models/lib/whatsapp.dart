abstract class WhatsApp {
  Future<int> sendWhatsAppMessages(
      {required String message, required List<String> numbers});
  Future optIn();
}
