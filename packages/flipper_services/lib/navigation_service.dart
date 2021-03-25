library flipper_services;

import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

class InAppNavigationService with ReactiveServiceMixin {
  final RxValue<String> navigation = RxValue<String>(initial: null);
  void navigateTo({String path}) {
    navigation.value =
        null; //can publish the save value twice, that's why we null it first
    navigation.value = path;
  }

  final RxValue<Map> nav = RxValue<Map>(initial: null);

  void navigateToPath(Map data) {
    // print(data['channels'].runtimeType);
    nav.value = null;
    nav.value = data;
  }
}
