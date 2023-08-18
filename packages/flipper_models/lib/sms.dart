abstract class SMS {
  Future<int> sendSMS({required String message, required List<String> numbers});
}
