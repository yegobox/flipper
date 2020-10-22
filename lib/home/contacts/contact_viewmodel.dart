
import 'package:flipper/utils/logger.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

// ignore: always_specify_types
class ContactViewModel extends FutureViewModel {
  ContactViewModel();
  final Logger log = Logging.getLogger('Contact view model');



  @override
  Future futureToRun() async {
    // FIXME(richard): this is fix me:
    // final ApiResponse response =
    //     await ProxyService.api.payroll();

    // return response.data;
  }

  void onError(error) {
    // Show dialog here using service if we want to
    log.e('error');
  }
}
