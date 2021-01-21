import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SearchViewModel extends BaseViewModel {
  TextEditingController _searchController;
  TextEditingController get searchController {
    return _searchController;
  }
}
