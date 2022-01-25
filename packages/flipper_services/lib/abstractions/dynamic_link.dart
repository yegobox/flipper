// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

abstract class DynamicLink {
  Future handleDynamicLink();
  //ShortDynamicLink? was return type
  Future<String> createDynamicLink();
}
