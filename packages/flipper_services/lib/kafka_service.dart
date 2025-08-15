import 'dart:async';
import 'dart:developer' as developer show log;

class KafkaService {
  static final KafkaService _instance = KafkaService._internal();
  factory KafkaService() => _instance;

  KafkaService._internal();

  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messages => _messageController.stream;

  // In a real application, you would initialize Kafka producer/consumer here.
  // For this example, we'll just simulate sending/receiving.
  // FKafka client setup would go here.

  void sendMessage(String message) {
    // In a real Kafka integration, you would publish to a Kafka topic here.
    // For now, we'll just add it to our stream for local consumption.
    if (!_messageController.isClosed) {
      _messageController.add(message);
      // Mask or truncate message for logging to avoid exposing PII
      final masked =
          message.length > 20 ? message.substring(0, 20) + '...' : message;
      developer.log('Kafka message sent: $masked', name: 'KafkaService');
    } else {
      developer.log('Attempted to send message to closed controller',
          name: 'KafkaService', level: 900);
    }
  }

  void dispose() {
    _messageController.close();
  }
}
