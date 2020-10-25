
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel{
  int _tab;
  int get tab{
    return _tab;
  }
  // ignore: always_declare_return_types
  switchTab(int tab){
    _tab = tab;
    notifyListeners();
  }
  // ignore: always_declare_return_types
  initTab(){
    _tab = 0;
    notifyListeners();
  }
}