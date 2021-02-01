library flipper_services;

import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

class InAppNavigationService with ReactiveServiceMixin {
  final RxValue<String> navigation = RxValue<String>(initial: null);
  final RxValue<Map> navToChat = RxValue<Map>(initial: null);

  void navigateToChat(Map data) {
    // print(data['channels'].runtimeType);
    navToChat.value = null;
    navToChat.value = data;
  }

  void navigateTo({String path}) {
    navigation.value =
        null; //can publish the save value twice, that's why we null it first
    navigation.value = path;
  }
}
