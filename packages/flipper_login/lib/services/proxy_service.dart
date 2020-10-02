
import 'package:rxdart/rxdart.dart';

class ProxyService {
  PublishSubject isBlueToothConnected = PublishSubject(); 

  PublishSubject loading = PublishSubject();


  bool _connected = false;
  
}
final ProxyService proxyService = ProxyService();