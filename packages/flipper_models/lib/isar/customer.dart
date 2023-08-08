import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flipper_models/sync_service.dart';
part 'customer.g.dart';

@JsonSerializable()
@Collection()
class Customer extends IJsonSerializable {
  late String id;
  late String name;
  late String email;
  late String phone;
  String? address;
  late int branchId;
  DateTime? updatedAt;
  String? tinNumber;
  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.action,
    this.address,
    required this.branchId,
    this.updatedAt,
    this.tinNumber,
  });

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;

  @Index()
  DateTime? deletedAt;

  factory Customer.fromRecord(RecordModel record) =>
      Customer.fromJson(record.toJson());
  factory Customer.fromJson(Map<String, dynamic> json) {
    return _$CustomerFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$CustomerToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }
}
