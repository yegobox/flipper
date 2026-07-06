import 'package:uuid/uuid.dart';

/// Floor-plan table for Bar Mode (Ditto `bar_tables` collection).
class BarTable {
  const BarTable({
    required this.id,
    required this.branchId,
    required this.zoneId,
    required this.zoneName,
    required this.name,
    required this.seats,
    this.ordinal = 0,
  });

  final String id;
  final String branchId;
  final String zoneId;
  final String zoneName;
  final String name;
  final int seats;
  final int ordinal;

  BarTable copyWith({
    String? id,
    String? branchId,
    String? zoneId,
    String? zoneName,
    String? name,
    int? seats,
    int? ordinal,
  }) {
    return BarTable(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      zoneId: zoneId ?? this.zoneId,
      zoneName: zoneName ?? this.zoneName,
      name: name ?? this.name,
      seats: seats ?? this.seats,
      ordinal: ordinal ?? this.ordinal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'branchId': branchId,
      'zoneId': zoneId,
      'zoneName': zoneName,
      'name': name,
      'seats': seats,
      'ordinal': ordinal,
    };
  }

  static BarTable fromJson(Map<String, dynamic> raw) {
    int toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    return BarTable(
      id: (raw['id'] ?? raw['_id'] ?? const Uuid().v4()).toString(),
      branchId: (raw['branchId'] ?? '').toString(),
      zoneId: (raw['zoneId'] ?? '').toString(),
      zoneName: (raw['zoneName'] ?? '').toString(),
      name: (raw['name'] ?? '').toString(),
      seats: toInt(raw['seats']),
      ordinal: toInt(raw['ordinal']),
    );
  }
}

/// Default floor plan from the Bar Mode handover.
List<BarTable> defaultBarFloorPlan({required String branchId}) {
  final tables = <BarTable>[];
  var ordinal = 0;

  void addZone(String zoneId, String zoneName, List<(String name, int seats)> defs) {
    for (final def in defs) {
      tables.add(
        BarTable(
          id: '${branchId}_${zoneId}_${def.$1}',
          branchId: branchId,
          zoneId: zoneId,
          zoneName: zoneName,
          name: def.$1,
          seats: def.$2,
          ordinal: ordinal++,
        ),
      );
    }
  }

  addZone('main_bar', 'Main Bar', [
    ('B1', 2),
    ('B2', 2),
    ('B3', 2),
    ('B4', 2),
    ('B5', 2),
    ('B6', 2),
  ]);
  addZone('terrace', 'Terrace', [
    ('T1', 4),
    ('T2', 4),
    ('T3', 4),
    ('T4', 4),
    ('T5', 4),
    ('T6', 6),
    ('T7', 6),
    ('T8', 8),
  ]);
  addZone('vip', 'VIP Lounge', [
    ('V1', 6),
    ('V2', 6),
    ('V3', 10),
  ]);

  return tables;
}
