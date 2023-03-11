library flipper_models;

import 'package:flipper_models/isar/variant.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:pocketbase/pocketbase.dart';
part 'product.g.dart';

@Collection()
class Product extends JsonSerializable {
  Id? id = null;

  /// because later on we need localId to have logic
  /// to receive remote product, we need ability to either use auto-increment
  /// or use custom ID, this will help when receiving data
  /// as we will first check if they exist locally using localId
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

  /// as multiple devices can touch the same product, we need to track the device
  /// the onlne generated ID will be the ID other device need to use in updating so
  /// the ID of the product in all devices should be similar and other IDs.
  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  final variants = IsarLinks<Variant>();

  Product(
      {required this.name,
      required this.active,
      required this.color,
      required this.businessId,
      required this.branchId,
      this.id,
      this.picture,
      this.description,
      this.taxId,
      this.hasPicture = false,
      this.table,
      this.supplierId,
      this.categoryId,
      this.createdAt,
      this.unit,
      this.draft,
      this.imageLocal,
      this.currentUpdate,
      this.imageUrl,
      this.expiryDate,
      this.barCode,
      this.synced,
      this.nfcEnabled,
      this.bindedToTenantId,
      this.isFavorite,
      this.lastTouched,
      this.remoteID});

  factory Product.fromRecord(RecordModel record) =>
      Product.fromJson(record.toJson());

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        name: json['name'],
        active: json['active'],
        color: json['color'],
        businessId: json['businessId'],
        branchId: json['branchId'],
        picture: json['picture'],
        description: json['description'],
        taxId: json['taxId'],
        hasPicture: json['hasPicture'],
        table: json['table'],
        supplierId: json['supplierId'],
        categoryId: json['categoryId'],
        createdAt: json['createdAt'],
        unit: json['unit'],
        draft: json['draft'],
        imageLocal: json['imageLocal'],
        currentUpdate: json['currentUpdate'],
        imageUrl: json['imageUrl'],
        expiryDate: json['expiryDate'],
        barCode: json['barCode'],
        synced: json['synced'],
        nfcEnabled: json['nfcEnabled'],
        bindedToTenantId: json['bindedToTenantId'],
        isFavorite: json['isFavorite'],
        lastTouched: json['lastTouched'],
        remoteID: json['remoteID']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
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
      "barCode": barCode ?? null,
      "synced": synced,
      "nfcEnabled": nfcEnabled,
      "bindedToTenantId": bindedToTenantId,
      "isFavorite": isFavorite,
    };
  }
}
