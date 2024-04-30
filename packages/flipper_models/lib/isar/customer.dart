import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flipper_models/sync_service.dart';
part 'customer.g.dart';

enum CUSTOMER_TYPE { BUSINESS, INDIVIDUAL }

@JsonSerializable()
@Collection()
class Customer extends IJsonSerializable {
  Id? id;
  //customer name
  late String custNm;
  late String email;
  // customer phone number
  late String telNo;

  /// address
  String? adrs;
  late int branchId;
  DateTime? updatedAt;
  // Customer Number
  late String custNo;
  //customer tin number
  late String custTin;
  //Registrant Name
  late String regrNm;
  // Registrant ID
  late String regrId;
  //Modifier Name
  late String modrNm;

  //Modifier ID
  late String modrId;

  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  bool ebmSynced;
  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;

  @Index()
  DateTime? deletedAt;

  /// this is the tin of the business adding this customer
  late String tin;
  late String bhfId;
  late String useYn;
  late String customerType; // this will be either business or individual
  Customer({
    required this.custNm,
    required this.email,
    required this.telNo,
    this.adrs,
    required this.branchId,
    this.updatedAt,
    required this.custNo,
    required this.custTin,
    required this.regrNm,
    required this.regrId,
    required this.modrNm,
    required this.modrId,
    this.ebmSynced = false,
    required this.id,
    required this.action,
    this.lastTouched,
    this.deletedAt,
    required this.tin,
    required this.bhfId,
    required this.useYn,
    required this.customerType,
  });

  factory Customer.fromRecord(RecordModel record) =>
      Customer.fromJson(record.toJson());
  factory Customer.fromJson(Map<String, dynamic> json) {
    return _$CustomerFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
