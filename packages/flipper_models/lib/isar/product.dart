library flipper_models;

import 'package:flipper_models/isar/variant.dart';
import 'package:isar/isar.dart';
import 'package:isar_crdt/isar_crdt.dart';

part 'product.g.dart';

@Collection()
class Product extends CrdtBaseModel {
  Id id = Isar.autoIncrement;
  @Index(caseSensitive: true)
  late String name;
  String? picture;
  String? description;
  late bool active;
  String? taxId;
  late bool hasPicture;
  String? table;
  late String color;
  late int businessId;
  @Index()
  late int branchId;
  String? supplierId;
  String? categoryId;
  String? createdAt;
  String? unit;
  @Index(composite: [CompositeIndex('branchId')])
  bool? draft;
  bool? imageLocal;
  bool? currentUpdate;
  String? imageUrl;
  String? expiryDate;
  @Index()
  String? barCode;
  bool? synced;
  bool? nfcEnabled;
  // This is a localID not necessary coming from remote
  @Index()
  int? bindedToTenantId;
  bool? isFavorite;
  final variants = IsarLinks<Variant>();

  // Product(
  //     {required this.name,
  //     required this.active,
  //     required this.color,
  //     required this.businessId,
  //     required this.branchId,
  //     this.picture,
  //     this.description,
  //     this.taxId,
  //     this.hasPicture = false,
  //     this.table,
  //     this.supplierId,
  //     this.categoryId,
  //     this.createdAt,
  //     this.unit,
  //     this.draft,
  //     this.imageLocal,
  //     this.currentUpdate,
  //     this.imageUrl,
  //     this.expiryDate,
  //     this.barCode,
  //     this.synced,
  //     this.nfcEnabled,
  //     this.bindedToTenantId,
  //     this.isFavorite});

  // factory Product.fromRecord(RecordModel record) =>
  //     Product.fromJson(record.toJson());

  // factory Product.fromJson(Map<String, dynamic> json) {
  //   return Product(
  //     name: json['name'],
  //     active: json['active'],
  //     color: json['color'],
  //     businessId: json['businessId'],
  //     branchId: json['branchId'],
  //     picture: json['picture'],
  //     description: json['description'],
  //     taxId: json['taxId'],
  //     hasPicture: json['hasPicture'],
  //     table: json['table'],
  //     supplierId: json['supplierId'],
  //     categoryId: json['categoryId'],
  //     createdAt: json['createdAt'],
  //     unit: json['unit'],
  //     draft: json['draft'],
  //     imageLocal: json['imageLocal'],
  //     currentUpdate: json['currentUpdate'],
  //     imageUrl: json['imageUrl'],
  //     expiryDate: json['expiryDate'],
  //     barCode: json['barCode'],
  //     synced: json['synced'],
  //     nfcEnabled: json['nfcEnabled'],
  //     bindedToTenantId: json['bindedToTenantId'],
  //     isFavorite: json['isFavorite'],
  //   );
  // }

  @override
  Map<String, dynamic> toJson() {
    return {
      // "sid": sid,
      "name": name,
      "active": active,
      "color": color,
      "businessId": businessId,
      "branchId": branchId,
      "picture": picture,
      "description": description,
      "taxId": taxId,
      "hasPicture": hasPicture,
      "table": table,
      "supplierId": supplierId,
      "categoryId": categoryId,
      "createdAt": createdAt,
      "unit": unit,
      "draft": draft,
      "imageLocal": imageLocal,
      "currentUpdate": currentUpdate,
      "imageUrl": imageUrl,
      "expiryDate": expiryDate,
      "barCode": barCode,
      "synced": synced,
      "nfcEnabled": nfcEnabled,
      "bindedToTenantId": bindedToTenantId,
      "isFavorite": isFavorite,
    };
  }
}
