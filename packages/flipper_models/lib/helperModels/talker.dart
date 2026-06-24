import 'package:flipper_services/composite_talker_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Global Talker: console + Crashlytics + local [Log] DB (via [CompositeTalkerObserver]).
final talker = Talker(observer: CompositeTalkerObserver());
