
import 'package:flipper/viewmodels/base_model.dart';


class HomeViewModel extends BaseModel{
  int _tab;
  int get tab{
    return _tab;
  }
  // ignore: always_declare_return_types
  switchTab(int tab){
    setBusy(true);
    _tab = tab;
    notifyListeners();
    setBusy(false);
  }
  // ignore: always_declare_return_types
  initTab(){
    _tab = 0;
    notifyListeners();
  }
}