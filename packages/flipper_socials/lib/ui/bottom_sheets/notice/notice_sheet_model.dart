import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar/utils.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/hlc.dart';

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
        businessId: ProxyService.box.getBusinessId()!,
        isAccountSet: false,
        message: message,
        localId: syncIdInt(),
        lastTouched: removeTrailingDash(Hlc.fromDate(
                DateTime.now(), ProxyService.box.getBranchId()!.toString())
            .toString()),
        socialType: 'whatapp',
        socialUrl:
            'https://ers84w6ehl.execute-api.us-east-1.amazonaws.com/api');
    await ProxyService.remoteApi
        .create(collection: social.toJson(), collectionName: 'socials');
  }
}
