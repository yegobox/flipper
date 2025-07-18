import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class ShiftHistoryViewModel extends StreamViewModel<List<Shift>> {
  final int businessId;

  String _searchQuery = '';
  ShiftStatus? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;

  ShiftHistoryViewModel({
    required this.businessId,
  });

  @override
  Stream<List<Shift>> get stream => ProxyService.strategy.getShifts(
        businessId: businessId,
      );

  List<Shift> get filteredShifts {
    if (data == null) return [];

    List<Shift> shifts = data!;

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      shifts = shifts.where((shift) {
        final query = _searchQuery.toLowerCase();
        final userIdMatch = shift.userId.toString().contains(query);
        final noteMatch = shift.note?.toLowerCase().contains(query) ?? false;
        final statusMatch = shift.status.name.toLowerCase().contains(query);
        return userIdMatch || noteMatch || statusMatch;
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != null) {
      shifts = shifts
          .where((shift) => shift.status == _selectedStatus)
          .toList();
    }

    // Apply date range filter
    if (_startDate != null) {
      shifts = shifts
          .where((shift) =>
              shift.startAt.isAfter(_startDate!) ||
              shift.startAt.isAtSameMomentAs(_startDate!))
          .toList();
    }
    if (_endDate != null) {
      shifts = shifts
          .where((shift) =>
              shift.startAt.isBefore(_endDate!) ||
              shift.startAt.isAtSameMomentAs(_endDate!))
          .toList();
    }

    return shifts;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedStatus(ShiftStatus? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setStartDate(DateTime? date) {
    _startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime? date) {
    _endDate = date;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedStatus = null;
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  ShiftStatus? get selectedStatus => _selectedStatus;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get searchQuery => _searchQuery;
}