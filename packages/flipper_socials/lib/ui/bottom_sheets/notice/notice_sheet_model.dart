import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class NoticeSheetModel extends BaseViewModel {
  String _message = 'I am interested in your product';
  // set a getter for the message
  String get message => _message;
  set message(String message) {
    _message = message;
    notifyListeners();
  }

  void expressInterest() {
    Social social = Social(
        businessId: ProxyService.box.getBusinessId()!,
        isAccountSet: false,
        message: message,
        socialType: 'whatapp',
        socialUrl:
            'https://ers84w6ehl.execute-api.us-east-1.amazonaws.com/api');
    ProxyService.remoteApi
        .create(collection: social.toJson(), collectionName: 'socials');
  }
}
