

import 'package:flipper/routes/router.gr.dart';



Future<bool> onWillPop() async {
  Routing.navigator.pop(true);
  return true;
}

