part of 'hotel_mixin.dart';

TransactionItem? _hotelFindLine(List<TransactionItem> lines, String lineId) {
  for (final line in lines) {
    if (line.id == lineId) return line;
  }
  return null;
}

/// Keys of Ditto sync subscriptions already registered for hotel collections,
/// **per Ditto instance**.
///
/// Store queries/observers only read locally; without these subscriptions a
/// fresh device never replicates hotel documents from the mesh/cloud. A single
/// process-wide set looked safe but was not: subscriptions live on the Ditto
/// instance, so when [DittoService] rebuilds one — a re-login, say — the keys
/// survived, every registration was skipped as already-done, and replication
/// silently stopped. An [Expando] ties the bookkeeping to the instance it
/// actually describes, so a new instance subscribes again.
final Expando<Set<String>> _hotelSyncSubscriptionKeys = Expando(
  'hotelSyncSubscriptionKeys',
);

Set<String> _subscriptionKeysFor(Object ditto) =>
    _hotelSyncSubscriptionKeys[ditto] ??= <String>{};

/// Ditto query results mapped to hotel models. Split out of
/// [CapellaHotelMixin] to keep that file reviewable.
extension _CapellaHotelResultMapping on CapellaHotelMixin {
  List<HotelRoom> _roomsFromResult(dynamic queryResult) {
    final list = <HotelRoom>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        list.add(
          HotelRoom.fromJson(
            Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>),
          ),
        );
      } catch (e) {
        talker.error('hotel_rooms map error: $e');
      }
    }
    return list;
  }

  List<HotelStay> _staysFromResult(dynamic queryResult) {
    final list = <HotelStay>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        list.add(
          HotelStay.fromJson(
            Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>),
          ),
        );
      } catch (e) {
        talker.error('hotel_stays map error: $e');
      }
    }
    return list;
  }

  List<HotelQuotation> _quotationsFromResult(dynamic queryResult) {
    final list = <HotelQuotation>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        list.add(
          HotelQuotation.fromJson(
            Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>),
          ),
        );
      } catch (e) {
        talker.error('hotel_quotations map error: $e');
      }
    }
    return list;
  }

  HotelBranchSettings? _settingsFromResult(dynamic queryResult) {
    try {
      final items = queryResult.items as Iterable<dynamic>;
      if (items.isEmpty) return null;
      final raw = Map<String, dynamic>.from(items.first.value as Map);
      return HotelBranchSettings.fromJson(raw);
    } catch (e) {
      talker.error('hotel_branch_settings map error: $e');
      return null;
    }
  }

  BranchDocumentSettings? _documentSettingsFromResult(dynamic queryResult) {
    try {
      final items = queryResult.items as Iterable<dynamic>;
      if (items.isEmpty) return null;
      final raw = Map<String, dynamic>.from(items.first.value as Map);
      return BranchDocumentSettings.fromJson(raw);
    } catch (e) {
      talker.error('branch_document_settings map error: $e');
      return null;
    }
  }

  List<TransactionItem> _linesFromResult(dynamic queryResult) {
    final lines = <TransactionItem>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        final data = Map<String, dynamic>.from(item.value as Map);
        final line = hotelFolioLineFromDitto(data);
        if (line != null) lines.add(line);
      } catch (e) {
        talker.error('hotelFolioLines map: $e');
      }
    }
    return lines;
  }
}
