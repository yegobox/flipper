
import 'package:rxdart/rxdart.dart';

class Proxy {
  PublishSubject isBlueToothConnected = PublishSubject(); 

  PublishSubject loading = PublishSubject();


  bool _connected = false;
  
}
final Proxy proxyService = Proxy();