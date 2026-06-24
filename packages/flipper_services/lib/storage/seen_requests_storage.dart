import 'package:shared_preferences/shared_preferences.dart';

class SeenRequestsStorage {
  static const String _key = 'seen_inventory_requests';
  
  static Future<void> markAsSeen(String requestId) async {
    final prefs = await SharedPreferences.getInstance();
    final seenRequests = await getSeenRequests();
    seenRequests.add(requestId);
    await prefs.setStringList(_key, seenRequests.toList());
  }
  
  static Future<Set<String>> getSeenRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final seenRequests = prefs.getStringList(_key) ?? [];
    return seenRequests.toSet();
  }
  
  static Future<void> clearSeenRequests() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
  
  static Future<void> markAsUnseen(String requestId) async {
    final prefs = await SharedPreferences.getInstance();
    final seenRequests = await getSeenRequests();
    seenRequests.remove(requestId);
    await prefs.setStringList(_key, seenRequests.toList());
  }
}