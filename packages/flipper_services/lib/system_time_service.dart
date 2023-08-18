import 'package:stacked/stacked.dart';

import 'abstractions/system_time.dart';

class UnSupportedSystemTime
    with ReactiveServiceMixin
    implements SystemTimeService {
  @override
  Future<bool> isSystemTime() async {
    return true;
  }
}

class SystemTimeService with ReactiveServiceMixin implements SystemTime {
  @override
  Future<bool> isSystemTime() async {
    // bool isSystemTime;

    // isSystemTime = await SystemTimeCheck.isSystemTimeAutomatic ?? false;

    // return isSystemTime;
    return true;
  }
}
