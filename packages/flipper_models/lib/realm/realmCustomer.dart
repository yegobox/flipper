import 'package:realm/realm.dart';

part 'realmCustomer.realm.dart';

@RealmModel()
class _RealmCustomer {
  late int id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;
  String? custNm;
  String? email;
  String? telNo;
  String? adrs;
  int? branchId;
  DateTime? updatedAt;
  String? custNo;
  String? custTin;
  String? regrNm;
  String? regrId;
  String? modrNm;
  String? modrId;
  bool ebmSynced = false;
  DateTime? lastTouched;
  String? action;
  DateTime? deletedAt;
  String? tin;
  String? bhfId;
  String? useYn;
  String? customerType; // this will be either business or individual
  void updateProperties(RealmCustomer other) {
    custNm = other.custNm;
    email = other.email;
    telNo = other.telNo;
    adrs = other.adrs;
    branchId = other.branchId;
    updatedAt = other.updatedAt;
    custNo = other.custNo;
    custTin = other.custTin;
    regrNm = other.regrNm;
    regrId = other.regrId;
    modrNm = other.modrNm;
    modrId = other.modrId;
    ebmSynced = other.ebmSynced;
    lastTouched = other.lastTouched;
    action = other.action;
    deletedAt = other.deletedAt;
    tin = other.tin;
    bhfId = other.bhfId;
    useYn = other.useYn;
    customerType = other.customerType;
  }
}
