import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helper_models.dart';
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

  Future<void> expressInterest() async {
    Social social = Social(
        id: randomNumber(),
        branchId: ProxyService.box.getBranchId()!,
        isAccountSet: false,
        message: message,
        lastTouched: DateTime.now().toUtc(),
        socialType: 'whatapp',
        socialUrl:
            'https://ers84w6ehl.execute-api.us-east-1.amazonaws.com/api');

    // await ProxyService.remote
    //     .create(collection: social.toJson(), collectionName: 'socials');
  }
}
