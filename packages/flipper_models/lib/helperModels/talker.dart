import 'package:flipper_services/proxy.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = Talker(observer: ProxyService.crash as TalkerObserver?);
