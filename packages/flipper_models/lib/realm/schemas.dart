import 'package:realm/realm.dart';
part 'schemas.realm.dart';

/// https://www.mongodb.com/docs/atlas/app-services/sync/data-model/update-schema/#std-label-synced-schema-overview
/// https://www.mongodb.com/docs/atlas/app-services/sync/data-model/update-schema/#std-label-synced-schema-overview
@RealmModel()
class _Branch {
  @PrimaryKey()
  late ObjectId id;
  int? serverId;

  bool? active;

  String? description;
  String? name;
  int? businessId;
  String? longitude;
  String? latitude;

  bool isDefault = false;

  DateTime? lastTouched;

  String? action;

  DateTime? deletedAt;
}

@RealmModel()
class _Business {
  @PrimaryKey()
  late ObjectId id;
  int? serverId;

  String? name;
  String? currency;
  String? categoryId;
  String? latitude;
  String? longitude;
  int? userId;
  String? timeZone;
  // List<String>? channels;
  String? country;
  String? businessUrl;
  String? hexColor;
  String? imageUrl;
  String? type;
  bool? active;
  String? chatUid;
  String? metadata;
  String? role;
  int? lastSeen;
  String? firstName;
  String? lastName;
  String? createdAt;
  String? deviceToken;
  bool? backUpEnabled;
  String? subscriptionPlan;
  String? nextBillingDate;
  String? previousBillingDate;
  bool? isLastSubscriptionPaymentSucceeded;
  String? backupFileId;
  String? email;
  String? lastDbBackup;
  String? fullName;
  int? tinNumber;
  String? bhfId;
  String? dvcSrlNo;
  // address
  String? adrs;
  bool? taxEnabled;
  String? taxServerUrl;
  bool? isDefault;
  int? businessTypeId;

  DateTime? lastTouched;

  String? action;

  DateTime? deletedAt;

  String? encryptionKey;
}

@RealmModel()
class _Category {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;
  bool? active;
  bool focused = false;
  String? name;

  int? branchId;
  DateTime? deletedAt;
  DateTime? lastTouched;
  String? action;
}

@RealmModel()
class _PColor {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;
  late String? name;
  late List<String> colors;
  int? branchId;
  bool active = false;

  DateTime? lastTouched;

  String? action;

  DateTime? deletedAt;
}

@RealmModel()
class _Conversation {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;
  String? userName;
  String? body;
  String? avatar;
  String? channelType;
  String? fromNumber;
  String? toNumber;

  String? createdAt;
  String? messageType;
  String? phoneNumberId;

  String? messageId;
  String? respondedBy;
  String? conversationId;

  /// properties that are here only useful when replying
  String? businessPhoneNumber;
  int? businessId;

  DateTime? scheduledAt;

  bool? delivered;

  DateTime? lastTouched;
  DateTime? deletedAt;
}

@RealmModel()
class _Counter {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  int? businessId;
  int? branchId;
  String? receiptType;
  int? totRcptNo;
  int? curRcptNo;
  int? invcNo;
  DateTime? lastTouched;
  String? action;
}

@RealmModel()
class _Customer {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

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
  String modrNm = "284746303937";

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
}

@RealmModel()
class _Device {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  String? linkingCode;
  String? deviceName;
  String? deviceVersion;
  bool? pubNubPublished;
  String? phone;
  int? branchId;
  int? businessId;
  int? userId;
  String? defaultApp;

  /// for sync

  DateTime? lastTouched;
  DateTime? deletedAt;

  String? action;
}

@RealmModel()
class _Discount {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  late String name;

  /// this is to get ready when there will be option for percentage instead of amount!
  late double? amount;
  late int branchId;
}

@RealmModel()
class _Drawers {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId realmId;

  int? id;

  double? openingBalance;
  double? closingBalance;
  String? openingDateTime;
  String? closingDateTime;
  int? csSaleCount;
  String? tradeName;
  double? totalNsSaleIncome;
  double? totalCsSaleIncome;
  int? nrSaleCount;
  int? nsSaleCount;
  int? trSaleCount;
  int? psSaleCount;
  int? incompleteSale;
  int? otherTransactions;
  String? paymentMode;
  int? cashierId; // the userId owning this drawer
  bool? open;
  DateTime? deletedAt;
  int? businessId;
  int? branchId;
}

@RealmModel()
class _EBM {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  late String bhfId;
  late int tinNumber;
  late String dvcSrlNo;
  late int userId;
  late String? taxServerUrl;
  late int businessId;
  late int branchId;

  DateTime? lastTouched;

  late String action;
}

@RealmModel()
class _Favorite {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  int? favIndex;

  int? productId;
  int? branchId;

  DateTime? lastTouched;

  String? action;

  DateTime? deletedAt;
}

@RealmModel()
class _Product {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  String? name;
  String? description;
  String? taxId;
  String color = "#e74c3c";
  int? businessId;

  int? branchId;
  String? supplierId;
  int? categoryId;
  String? createdAt;
  String? unit;
  String? imageUrl;
  String? expiryDate;

  String? barCode;
  bool nfcEnabled = false;

  int? bindedToTenantId;
  bool isFavorite = false;

  DateTime? lastTouched;

  String? action;
  DateTime? deletedAt;

  /// this is helper to highlight a product when is found in search
  @Ignored()
  bool searchMatch = false;
  String? spplrNm;
  bool? isComposite = false;

  List<_Composite> composites = [];
}

@RealmModel()
class _Receipt {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  String? resultCd;
  String? resultMsg;
  String? resultDt;
  int? rcptNo;
  String? intrlData;
  String? rcptSign;
  int? totRcptNo;
  String? vsdcRcptPbctDate;
  String? sdcId;
  String? mrcNo;
  String? qrCode;
  String? receiptType;
  int? branchId;

  int? transactionId;

  DateTime? lastTouched;
  String? action;
  int? invcNo;
}

@RealmModel()
class _Setting {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  String? email;

  int? userId;
  bool? openReceiptFileOSaleComplete;
  bool? autoPrint;
  bool? sendDailyReport;
  String? defaultLanguage;
  bool? attendnaceDocCreated;
  bool? isAttendanceEnabled;
  String? type;
  bool? enrolledInBot;
  String? deviceToken;
  String? businessPhoneNumber;
  bool? autoRespond;
  String? token;
  bool hasPin = false;
  // @JsonKey(fromJson: _toInt)
  int? businessId;
  String? createdAt;

  DateTime? lastTouched;

  DateTime? deletedAt;
  String? action;
}

@RealmModel()
class _Stock {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  ObjectId? realmId;
  int? tin;
  String? bhfId;

  int? branchId;
  int? variantId;
  double lowStock = 0;
  double currentStock = 0.0;

  bool? canTrackingStock = true;
  bool? showLowStockAlert = true;

  int? productId;
  bool? active;
  // the value of stock is currentStock * retailPrice
  double value = 0.0;
  // RRA fields
  double rsdQty = 0.0;

  double supplyPrice = 0.0;
  double retailPrice = 0.0;

  DateTime? lastTouched;

  String? action;

  DateTime? deletedAt;

  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  bool ebmSynced = false;
}

@RealmModel()
class _Variant {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  DateTime? deletedAt;

  String? name;
  String? color;
  String? sku;

  int? productId;
  String? unit;
  String? productName;
  int? branchId;
  String? taxName = "";
  double taxPercentage = 0.0;

  @deprecated

  /// this field was indicating that the item is excempted but after learning that
  /// if taxTyCd is A then we know it is Exempted
  bool isTaxExempted = false;

  // add RRA fields
  int? itemSeq;
  // insurance code
  String? isrccCd = "";
  // insurance name
  String? isrccNm = "";
  // premium rate
  int? isrcRt = 0;
  // insurance amount
  int? isrcAmt = 0;
  // taxation type code.
  String? taxTyCd = "B";
  // bar code
  String? bcd = "";
  // Item code
  String? itemClsCd;
  // Item type code
  String? itemTyCd;
  // Item standard name
  String? itemStdNm = "";
  // Item origin
  String? orgnNatCd = "";
  // packaging unit code
  String? pkg = "1";
  // item code
  String? itemCd = "";

  String? pkgUnitCd = "CT";

  String? qtyUnitCd = "BX";
  // same as name but for rra happiness
  String? itemNm;
  double qty = 0.0;
  // unit price
  double prc = 0.0;
  // supply amount
  double splyAmt = 0.0;
  int? tin;
  String? bhfId;
  double? dftPrc = 0;
  String? addInfo = "";
  String? isrcAplcbYn = "";
  String? useYn = "";
  String? regrId;
  String? regrNm;
  String? modrId;
  String? modrNm;

  /// property for stock but presented here for easy
  double rsdQty = 0.0;

  DateTime? lastTouched;

  double supplyPrice = 0.0;

  double retailPrice = 0.0;

  String? action;

  /// these fields are empty in normal business when this item is owned by a business
  /// but in case when this item is owned by a supplier then these fields will be filled
  /// this is the case after purchase action is done
  String? spplrItemClsCd;
  String? spplrItemCd;
  String? spplrItemNm;

  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  bool ebmSynced = false;

  /// TODO: delete this as it is duplicate of taxTyCd use taxTyCd instead
  @deprecated
  String taxType = "B";

  /// it can be A for exempted, B, C or D
}

@RealmModel()
class _TransactionItem {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  String? name;

  int? transactionId;
  int? variantId;
  // quantity
  double qty = 0.0;
  double price = 0.0;
  double discount = 0.0;
  String? type;
  double remainingStock = 0.0;
  String? createdAt;
  String? updatedAt;
  bool isTaxExempted = false;
  bool isRefunded = false;

  /// property to help us adding new item to transaction
  bool? doneWithTransaction;
  bool? active;

  // RRA fields
  // discount rate
  double dcRt = 0.0;
  // discount amount
  double dcAmt = 0.0;

  double taxblAmt = 0.0;
  double taxAmt = 0.0;

  double totAmt = 0.0;

  /// properties from respective variants
  /// these properties will be populated when adding a variant to transactionItem from a variant
  /// I believe there can be a smart way to clean this duplicate code
  /// but I want things to work in first place then I can refactor later.
  /// add RRA fields
  int? itemSeq;
  // insurance code
  String? isrccCd;
  // insurance name
  String? isrccNm = "";
  // premium rate
  int? isrcRt = 0;
  // insurance amount
  int? isrcAmt = 0;
  // taxation type code.
  String? taxTyCd;
  // bar code
  String? bcd;
  // Item code
  String? itemClsCd;
  // Item type code
  String? itemTyCd;
  // Item standard name
  String? itemStdNm;
  // Item origin
  String? orgnNatCd;
  // packaging unit code
  String? pkg;
  // item code
  String? itemCd;

  String? pkgUnitCd = "CT";

  String? qtyUnitCd = "BX";
  // same as name but for rra happiness
  String? itemNm;
  // unit price
  // check if prc is saved as same as retailPrice again this property is same as price on this model!
  double prc = 0.0;
  // supply amount
  double splyAmt = 0.0;
  int? tin;
  String? bhfId;
  double? dftPrc;
  String? addInfo;
  String? isrcAplcbYn;
  String? useYn;
  String? regrId;
  String? regrNm;
  String? modrId;
  String? modrNm;

  DateTime? lastTouched;
  DateTime? deletedAt;
  String? action;

  int? branchId;
  bool ebmSynced = false;
  bool partOfComposite = false;
  double compositePrice = 0;
}

@RealmModel()
class _ITransaction {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  String? reference;
  String? categoryId;
  String? transactionNumber;
  @Indexed()
  int? branchId;
  @Indexed()
  String? status;
  @Indexed()
  String? transactionType;
  double subTotal = 0.0;
  String? paymentType;
  double cashReceived = 0.0;
  double customerChangeDue = 0.0;
  @Indexed()
  String? createdAt;
  // add receipt type offerered on this transaction
  /// remember we also have receipt model where each receipt generated is saved.
  String? receiptType;
  String? updatedAt;
  @Indexed()
  int? customerId;
  String? customerType;
  String? note;

  DateTime? lastTouched;

  String? action;

  // int categoryId;

  String? ticketName;
  DateTime? deletedAt;

  // fields when a transaction is created for ordering system
  int? supplierId;

  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  bool ebmSynced = false;

  // Add methods to check type
  bool isIncome = false;

  bool isExpense = false;
  bool isRefunded = false;
}

@RealmModel()
class _IUnit {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  int? branchId;
  String? name;
  String? value;
  bool active = false;

  DateTime? lastTouched;

  String? action;

  String? createdAt;
  DateTime? deletedAt;
}

@RealmModel()
class _Voucher {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;
  int? value;
  int? interval;
  bool? used;
  int? createdAt;
  int? usedAt;
  String? descriptor;
}

@RealmModel()
class _Tenant {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  String? name;
  String? phoneNumber;
  String? email;
  bool nfcEnabled = false;
  int? businessId;
  int? userId;
  String? imageUrl;

  DateTime? lastTouched;
  DateTime? deletedAt;

  int? pin;

  /// [sessionActive] is not comming from server, this is to check which
  /// tenant is currently have active session but the main session will be still active
  bool? sessionActive;

  bool? isDefault;

  ///helper property, these are property that are not peristed
  ///but used in ui to achieve some functionality

  bool isLongPressed = false;
}

@RealmModel()
class _Pin {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  ObjectId? realmId;
  String? userId;
  String? phoneNumber;
  int? pin;
  int? branchId;
  int? businessId;
}

@RealmModel()
class _LPermission {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  ObjectId? realmId;
  String? name;
  int? userId;
}

@RealmModel()
class _Token {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  ObjectId? realmId;

  String? type;
  String? token;
  DateTime? validFrom;
  DateTime? validUntil;
  int? businessId;

  DateTime? lastTouched;
  DateTime? deletedAt;
}

@RealmModel()
class _UserActivity {
  @PrimaryKey()
  late ObjectId id;

  DateTime? timestamp;
  DateTime? lastTouched;
  int? userId;

  late String action;
}

@RealmModel()
class _UnversalProduct {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  String? itemClsCd;
  String? itemClsNm;
  int? itemClsLvl;
  String? taxTyCd;
  String? mjrTgYn;
  String? useYn;

  int? businessId;
  int? branchId;
}

@RealmModel()
class _Configurations {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  String? taxType = "B";
  double? taxPercentage = 18.0;
  int? businessId;
  int? branchId;
}

@RealmModel()
class _AppNotification {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;
  bool completed = false;
  String? type = 'transaction';
  String? message;

  ///if it is a transaction being notified then the identifier will be transaction id;
  int? identifier;
}

@RealmModel()
class _Assets {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  int? branchId;
  int? businessId;
  String? assetName;
  int? productId;
}

/// we have this composite to map out
/// the quantity of item that will be deducted when we sell
/// respective item from composite.

@RealmModel()
class _Composite {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  int? productId;
  int? variantId;
  double? qty = 1.0;
  int? branchId;
  int? businessId;

  /// this hold the actual price of the sum of item on composite
  /// sound like if we have 4 item on a composite, they will all have this column to represent the price
  /// of the whole composite.
  double? actualPrice = 0;
}

/// a note on composite,
/// when a composite item is sold, we don't really care about the variant we should
/// we ripple-effect to the composite's item
/// therefore when scanned on while about selling, we will show the composite items, not the default variant
/// attached to it
///  Product -> Variant (default) not considered
/// Product-> Compostes (a list of item attached) are considered.
@RealmModel()
class _SKU {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  int? sku = 1000;
  int? branchId;
  int? businessId;
  bool? consumed = false;
}

@RealmModel()
class _Report {
  int? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  int? branchId;
  int? businessId;
  String? filename;
  String? s3Url;
  bool? downloaded = false;
}

/// because this model is computed, that is why we ar not mapping _id to realmId
/// and we are using id as primary key, as we will not provide our own id
/// because this computation will happen on atlas server

@RealmModel()
class _Computed {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  int? branchId;
  int? businessId;
  double? grossProfit = 0;
  double? netProfit = 0;
  double? totalStockValue = 0;
  double? totalStockSoldValue = 0;
  double? totalStockItems = 0;
}
