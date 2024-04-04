import 'package:realm/realm.dart';

part 'realmCounter.realm.dart';

@RealmModel()
class _RealmCounter {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;
  int? businessId;
  int? branchId;
  String? receiptType;
  int? totRcptNo;
  int? curRcptNo;
  DateTime? lastTouched;
  void updateProperties(RealmCounter other) {
    id = other.id;
    businessId = other.businessId;
    branchId = other.branchId;
    receiptType = other.receiptType;
    totRcptNo = other.totRcptNo;
    curRcptNo = other.curRcptNo;
    lastTouched = other.lastTouched;
  }
}
