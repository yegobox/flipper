import 'package:freezed_annotation/freezed_annotation.dart';
part 'ICustomer.g.dart';

@JsonSerializable()
class ICustomer {
  int? id;

  //customer name
  String? custNm;
  String? email;
  // customer phone number
  String? telNo;

  /// address
  String? adrs;
  int? branchId;
  DateTime? updatedAt;
  // Customer Number
  String? custNo;
  //customer tin number
  String? custTin;
  //Registrant Name
  String? regrNm;
  // Registrant ID
  String? regrId;
  //Modifier Name
  String? modrNm;

  //Modifier ID
  String? modrId;

  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  bool ebmSynced = false;
  DateTime? lastTouched;

  String? action;

  DateTime? deletedAt;

  /// this is the tin of the business adding this customer
  int? tin;
  String? bhfId;
  String? useYn;
  String? customerType;

  ICustomer({
    this.id,
    this.custNm,
    this.email,
    this.telNo,
    this.adrs,
    this.branchId,
    this.updatedAt,
    this.custNo,
    this.custTin,
    this.regrNm,
    this.regrId,
    this.modrNm,
    this.modrId,
    this.ebmSynced = false,
    this.lastTouched,
    this.action,
    this.deletedAt,
    this.tin,
    this.bhfId,
    this.useYn,
    this.customerType,
  });

  Map<String, dynamic> toJson() => _$ICustomerToJson(this);
}
