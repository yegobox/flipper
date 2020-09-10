
import 'package:rxdart/rxdart.dart';

class ProxyService{
  // ignore: always_specify_types
  PublishSubject loading = PublishSubject();
}
final ProxyService proxyService = ProxyService();