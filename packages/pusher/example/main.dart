import 'dart:async';
import 'package:pusher/pusher.dart';

Future<void> main() async {
  Pusher pusher = new Pusher('PUSHER_APP_ID', 'PUSHER_APP_KEY', 'PUSHER_APP_SECRET');
  Map data = {'message': 'Hello world'};
  await pusher.trigger(['test_channel'], 'my_event', data);
}
