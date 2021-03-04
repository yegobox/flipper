library flipper_services;

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/services.dart';
import 'package:pusher_websocket_flutter/pusher.dart' as p;
import 'package:observable_ish/observable_ish.dart';
// import 'package:pusher_beams/pusher_beams.dart';

class AppService {
  final RxValue<p.Event> pay = RxValue<p.Event>(initial: null);


  //do heavy computation here
}
