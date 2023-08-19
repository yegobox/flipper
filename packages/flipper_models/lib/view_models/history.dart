class NavigationHistory {
  final List<String> _history = [];

  void add(String page) {
    _history.add(page);
  }

  bool hasRecentlyVisited(String page) {
    return _history.contains(page);
  }
}
