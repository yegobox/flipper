import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum ShiftHistoryStatusSegment { all, open, closed }

enum ShiftHistorySortOrder {
  newestFirst,
  oldestFirst,
  cashSalesHighToLow,
  cashSalesLowToHigh,
}

/// Display name from Supabase `users` (column `name`).
class ShiftHistoryViewModel extends StreamViewModel<List<Shift>> {
  ShiftHistoryViewModel({required this.businessId});

  final String businessId;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final Map<String, String?> _userNamesById = {};
  final Set<String> _inFlightUserIds = {};
  Timer? _userFetchDebounce;

  void _onSearchTextChanged() => notifyListeners();

  ShiftHistoryStatusSegment _statusSegment = ShiftHistoryStatusSegment.all;
  ShiftHistorySortOrder _sortOrder = ShiftHistorySortOrder.newestFirst;
  DateTime? _startDate;
  DateTime? _endDate;
  num? _minCashSales;
  num? _maxCashSales;

  ShiftHistoryStatusSegment get statusSegment => _statusSegment;

  ShiftHistorySortOrder get sortOrder => _sortOrder;

  DateTime? get startDate => _startDate;

  DateTime? get endDate => _endDate;

  num? get minCashSales => _minCashSales;

  num? get maxCashSales => _maxCashSales;

  String get searchQuery => searchController.text;

  bool get hasActiveFilters =>
      searchQuery.trim().isNotEmpty ||
      _statusSegment != ShiftHistoryStatusSegment.all ||
      _startDate != null ||
      _endDate != null ||
      _minCashSales != null ||
      _maxCashSales != null;

  @override
  Stream<List<Shift>> get stream =>
      ProxyService.strategy.getShifts(businessId: businessId);

  @override
  void onSubscribed() {
    searchController.addListener(_onSearchTextChanged);
    super.onSubscribed();
  }

  @override
  void onData(List<Shift>? data) {
    super.onData(data);
    _scheduleUserFetch(data);
  }

  void _scheduleUserFetch(List<Shift>? shifts) {
    _userFetchDebounce?.cancel();
    _userFetchDebounce = Timer(const Duration(milliseconds: 120), () {
      unawaited(_loadUserNamesForShifts(shifts));
    });
  }

  Future<void> _loadUserNamesForShifts(List<Shift>? shifts) async {
    if (shifts == null || shifts.isEmpty) return;
    final ids = shifts.map((s) => s.userId).toSet();
    final missing = ids
        .where((id) =>
            !_userNamesById.containsKey(id) && !_inFlightUserIds.contains(id))
        .toList();
    if (missing.isEmpty) return;

    _inFlightUserIds.addAll(missing);
    try {
      const chunk = 80;
      for (var i = 0; i < missing.length; i += chunk) {
        final slice = missing.sublist(i, i + chunk > missing.length ? missing.length : i + chunk);
        final rows = await Supabase.instance.client
            .from('users')
            .select('id, name')
            .inFilter('id', slice) as List<dynamic>;
        for (final raw in rows) {
          final map = Map<String, dynamic>.from(raw as Map);
          final id = map['id'] as String?;
          if (id == null) continue;
          final name = map['name'];
          _userNamesById[id] = name is String && name.trim().isNotEmpty
              ? name.trim()
              : null;
        }
      }
      for (final id in missing) {
        _userNamesById.putIfAbsent(id, () => null);
      }
    } catch (_) {
      for (final id in missing) {
        _userNamesById.putIfAbsent(id, () => null);
      }
    } finally {
      _inFlightUserIds.removeAll(missing);
      notifyListeners();
    }
  }

  String? userDisplayName(String userId) => _userNamesById[userId];

  List<Shift> get filteredShifts {
    if (data == null) return [];

    var shifts = List<Shift>.from(data!);
    final query = searchQuery.trim().toLowerCase();

    if (query.isNotEmpty) {
      shifts = shifts.where((shift) {
        if (shift.userId.toLowerCase().contains(query)) return true;
        final name = _userNamesById[shift.userId]?.toLowerCase();
        if (name != null && name.contains(query)) return true;
        if (shift.note?.toLowerCase().contains(query) ?? false) return true;
        if (shift.status.name.toLowerCase().contains(query)) return true;
        if (_matchesDateSearch(shift, query)) return true;
        return false;
      }).toList();
    }

    switch (_statusSegment) {
      case ShiftHistoryStatusSegment.all:
        break;
      case ShiftHistoryStatusSegment.open:
        shifts = shifts.where((s) => s.status == ShiftStatus.Open).toList();
        break;
      case ShiftHistoryStatusSegment.closed:
        shifts = shifts.where((s) => s.status == ShiftStatus.Closed).toList();
        break;
    }

    if (_startDate != null) {
      final from = _calendarDay(_startDate!);
      shifts = shifts
          .where((s) => !_calendarDay(s.startAt).isBefore(from))
          .toList();
    }
    if (_endDate != null) {
      final to = _calendarDay(_endDate!);
      shifts = shifts
          .where((s) => !_calendarDay(s.startAt).isAfter(to))
          .toList();
    }

    if (_minCashSales != null) {
      shifts = shifts
          .where((s) => (s.cashSales ?? 0) >= _minCashSales!)
          .toList();
    }
    if (_maxCashSales != null) {
      shifts = shifts
          .where((s) => (s.cashSales ?? 0) <= _maxCashSales!)
          .toList();
    }

    _sortFiltered(shifts);

    return shifts;
  }

  static DateTime _calendarDay(DateTime utcOrLocal) {
    final l = utcOrLocal.toLocal();
    return DateTime(l.year, l.month, l.day);
  }

  void _sortFiltered(List<Shift> shifts) {
    int byStart(Shift a, Shift b) => a.startAt.compareTo(b.startAt);
    int byCash(Shift a, Shift b) =>
        (a.cashSales ?? 0).compareTo(b.cashSales ?? 0);

    switch (_sortOrder) {
      case ShiftHistorySortOrder.newestFirst:
        shifts.sort((a, b) => -byStart(a, b));
        break;
      case ShiftHistorySortOrder.oldestFirst:
        shifts.sort(byStart);
        break;
      case ShiftHistorySortOrder.cashSalesHighToLow:
        shifts.sort((a, b) {
          final c = -byCash(a, b);
          if (c != 0) return c;
          return -byStart(a, b);
        });
        break;
      case ShiftHistorySortOrder.cashSalesLowToHigh:
        shifts.sort((a, b) {
          final c = byCash(a, b);
          if (c != 0) return c;
          return -byStart(a, b);
        });
        break;
    }
  }

  bool _matchesDateSearch(Shift shift, String q) {
    final local = shift.startAt.toLocal();
    final patterns = <String>[
      '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}',
      '${local.day}/${local.month}/${local.year}',
      '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}',
      DateFormat('MMM dd, yyyy', 'en_US').format(local),
      DateFormat('MMM d, yyyy', 'en_US').format(local),
    ];
    return patterns.any((p) => p.toLowerCase().contains(q));
  }

  int get filteredOpenCount =>
      filteredShifts.where((s) => s.status == ShiftStatus.Open).length;

  int get filteredClosedCount =>
      filteredShifts.where((s) => s.status == ShiftStatus.Closed).length;

  num get filteredTotalCashSales => filteredShifts.fold<num>(
        0,
        (sum, s) => sum + (s.cashSales ?? 0),
      );

  void setSearchQuery(String query) {
    notifyListeners();
  }

  void setStatusSegment(ShiftHistoryStatusSegment segment) {
    _statusSegment = segment;
    notifyListeners();
  }

  void setSortOrder(ShiftHistorySortOrder order) {
    _sortOrder = order;
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

  void setMinCashSales(num? value) {
    _minCashSales = value;
    notifyListeners();
  }

  void setMaxCashSales(num? value) {
    _maxCashSales = value;
    notifyListeners();
  }

  void applySheetFilters({
    DateTime? startDate,
    DateTime? endDate,
    required ShiftHistoryStatusSegment status,
    num? minCash,
    num? maxCash,
    required ShiftHistorySortOrder sort,
  }) {
    _startDate = startDate;
    _endDate = endDate;
    _statusSegment = status;
    _minCashSales = minCash;
    _maxCashSales = maxCash;
    _sortOrder = sort;
    notifyListeners();
  }

  void clearFilters() {
    searchController.clear();
    _statusSegment = ShiftHistoryStatusSegment.all;
    _startDate = null;
    _endDate = null;
    _minCashSales = null;
    _maxCashSales = null;
    _sortOrder = ShiftHistorySortOrder.newestFirst;
    notifyListeners();
  }

  @override
  void onCancel() {
    _userFetchDebounce?.cancel();
    searchController.removeListener(_onSearchTextChanged);
    searchController.dispose();
    searchFocusNode.dispose();
    super.onCancel();
  }
}
