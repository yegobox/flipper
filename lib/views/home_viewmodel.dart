import 'package:flipper/locator.dart';
import 'package:flipper/services/shared_state_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends ReactiveViewModel {

  final _sharedStateService = locator<SharedStateService>();

  int _tab;
  int get tab {
    return _tab;
  }

  int _items;
  int get items {
    return _items;
  }

  // ignore: always_declare_return_types
  switchTab(int tab) {
    setBusy(true);
    _tab = tab;
    notifyListeners();
    setBusy(false);
    _items = tab;
    // print(_tab);
  }

  // ignore: always_declare_return_types
  initTab() {
    _tab = 0;
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedStateService];
}
