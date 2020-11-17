import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  Future<void> setUserLoggedIn({String userId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userId') ? prefs.getString('userId') : null;
  }

  Future<bool> logout()async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove('userId');
  }
  Future<void> setIsAppConstantsInitialized({String userId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAppConstantsInitialized', true);
  }
  Future<bool> isAppConstantsInitialized()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('isAppConstantsInitialized') ? prefs.getBool('isAppConstantsInitialized') : false;
  }
}
