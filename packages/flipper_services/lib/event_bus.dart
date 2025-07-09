import 'dart:async';
import 'package:supabase_models/brick/models/customer.model.dart';

class CustomerUpserted {
  final Customer customer;
  CustomerUpserted(this.customer);
}

class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final _streamController = StreamController<dynamic>.broadcast();

  Stream<T> on<T>() {
    return _streamController.stream.where((event) => event is T).cast<T>();
  }

  void fire(event) {
    _streamController.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}