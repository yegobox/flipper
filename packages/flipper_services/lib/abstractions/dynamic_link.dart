import 'package:flutter/cupertino.dart';

abstract class DynamicLink {
  Future handleDynamicLink(BuildContext buildContext);
  //ShortDynamicLink? was return type
  Future<String> createDynamicLink();
}
