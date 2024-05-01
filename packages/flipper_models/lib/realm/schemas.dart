import 'package:realm/realm.dart';
part 'schemas.realm.dart';

@RealmModel()
class _Branch {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
  bool? active;

  String? description;
  String? name;
  int? businessId;
  String? longitude;
  String? latitude;

  late bool isDefault;

  DateTime? lastTouched;

  late String action;

  DateTime? deletedAt;
}

@RealmModel()
class _Business {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
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

  late String action;

  DateTime? deletedAt;

  late String encryptionKey;
}

@RealmModel()
class _Category {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
  late bool active;
  late bool focused;
  late String name;

  late int branchId;
  @override
  DateTime? deletedAt;
  DateTime? lastTouched;
}

@RealmModel()
class _PColor {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
  late String? name;
  // List<String>? colors;
  late int? branchId;
  late bool active;

  DateTime? lastTouched;

  late String action;

  DateTime? deletedAt;
}

@RealmModel()
class _Conversation {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
  late String userName;
  late String body;
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
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late int businessId;
  late int branchId;
  late String receiptType;
  late int totRcptNo;
  late int curRcptNo;
  DateTime? lastTouched;
  late String action;
}

@RealmModel()
class _Customer {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

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
  late bool ebmSynced;
  DateTime? lastTouched;

  late String action;

  DateTime? deletedAt;

  /// this is the tin of the business adding this customer
  late String tin;
  late String bhfId;
  late String useYn;
  late String customerType;
}

@RealmModel()
class _Device {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late String linkingCode;
  late String deviceName;
  late String deviceVersion;
  late bool pubNubPublished;
  late String phone;
  late int branchId;
  late int businessId;
  late int userId;
  late String defaultApp;

  /// for sync

  DateTime? lastTouched;

  late String action;
}

@RealmModel()
class _Discount {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late String name;

  /// this is to get ready when there will be option for percentage instead of amount!
  late double? amount;
  late int branchId;
}

@RealmModel()
class _Drawers {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late double openingBalance;
  late double closingBalance;
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
  late int cashierId;
  // @Index(composite:  ['cashierId'])
  late bool open;
}

@RealmModel()
class _EBM {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

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
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  int? favIndex;

  int? productId;
  int? branchId;

  DateTime? lastTouched;

  late String action;

  DateTime? deletedAt;
}

@RealmModel()
class _Product {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late String name;
  String? description;
  String? taxId;
  late String color;
  late int businessId;

  late int branchId;
  String? supplierId;
  int? categoryId;
  String? createdAt;
  String? unit;
  String? imageUrl;
  String? expiryDate;

  String? barCode;
  bool? nfcEnabled;

  int? bindedToTenantId;
  bool? isFavorite;
}

@RealmModel()
class _Receipt {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late String resultCd;
  late String resultMsg;
  late String resultDt;
  late int rcptNo;
  late String intrlData;
  late String rcptSign;
  late int totRcptNo;
  late String vsdcRcptPbctDate;
  late String sdcId;
  late String mrcNo;
  late String qrCode;
  late String receiptType;
  late int branchId;

  late int transactionId;

  DateTime? lastTouched;
  late String action;
}

@RealmModel()
class _Setting {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

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

  // @JsonKey(fromJson: _toInt)
  int? businessId;
  String? createdAt;

  DateTime? lastTouched;

  DateTime? deletedAt;
}

@RealmModel()
class _Stock {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late int branchId;
  late int variantId;
  double? lowStock;
  late double currentStock;

  bool? canTrackingStock;
  bool? showLowStockAlert;

  late int productId;
  bool? active;
  // the value of stock is currentStock * retailPrice
  double? value;
  // RRA fields
  double? rsdQty;

  double? supplyPrice;
  double? retailPrice;

  DateTime? lastTouched;

  late String action;

  DateTime? deletedAt;

  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  late bool ebmSynced;
}

@RealmModel()
class _Variant {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  DateTime? deletedAt;

  late String name;
  late String color;
  late String sku;

  late int productId;
  late String unit;
  late String productName;
  late int branchId;
  late String? taxName;
  double? taxPercentage;

  late bool isTaxExempted;

  // add RRA fields
  String? itemSeq;
  // insurance code
  String? isrccCd;
  // insurance name
  String? isrccNm;
  // premium rate
  String? isrcRt;
  // insurance amount
  String? isrcAmt;
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
  // packacking unit these are mainly AM
  ///Certainly! Here are the codes along with their explanations:

// AM: Ampoule Ampoule
// BA: Barrel Barrel
// BC: Bottlecrate Bottlecrate
// BE: Bundle Bundle
// BF: Balloon, non-protected Balloon, non-protected
// BG: Bag Bag
// BJ: Bucket Bucket
// BK: Basket Basket
// BL: Bale Bale
// BQ: Bottle, protected cylindrical Bottle, protected cylindrical
// BR: Bar Bar
// BV: Bottle, bulbous Bottle, bulbous
// BZ: Bag Bag
// CA: Can Can
// CH: Chest Chest
// CJ: Coffin Coffin
// CL: Coil Coil
// CR: Wooden Box, Wooden Case Wooden Box, Wooden Case

  String? pkgUnitCd;

  String? qtyUnitCd;
  // same as name but for rra happiness
  String? itemNm;
  double? qty;
  // unit price
  double? prc;
  // supply amount
  double? splyAmt;
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

  /// property for stock but presented here for easy
  double? rsdQty;

  DateTime? lastTouched;

  late double supplyPrice;

  late double retailPrice;

  late String action;

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
  late bool ebmSynced;
}

@RealmModel()
class _TransactionItem {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late String name;

  late int transactionId;
  late int variantId;
  // quantity
  late double qty;
  late double price;
  double? discount;
  String? type;
  late double remainingStock;
  late String createdAt;
  late String updatedAt;
  late bool isTaxExempted;
  bool? isRefunded;

  /// property to help us adding new item to transaction
  bool? doneWithTransaction;
  bool? active;

  // RRA fields
  // discount rate
  double? dcRt;
  // discount amount
  double? dcAmt;

  double? taxblAmt;
  double? taxAmt;

  double? totAmt;

  /// properties from respective variants
  /// these properties will be populated when adding a variant to transactionItem from a variant
  /// I believe there can be a smart way to clean this duplicate code
  /// but I want things to work in first place then I can refactor later.
  /// add RRA fields
  String? itemSeq;
  // insurance code
  String? isrccCd;
  // insurance name
  String? isrccNm;
  // premium rate
  String? isrcRt;
  // insurance amount
  String? isrcAmt;
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

  String? pkgUnitCd;

  String? qtyUnitCd;
  // same as name but for rra happiness
  String? itemNm;
  // unit price
  // check if prc is saved as same as retailPrice again this property is same as price on this model!
  late double prc;
  // supply amount
  double? splyAmt;
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
  late String action;

  late int branchId;
}

@RealmModel()
class _ITransaction {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late String reference;
  String? categoryId;
  late String transactionNumber;
  late int branchId;
  late String status;
  late String transactionType;
  late double subTotal;
  late String paymentType;
  late double cashReceived;
  late double customerChangeDue;
  late String createdAt;
  // add receipt type offerered on this transaction
  /// remember we also have receipt model where each receipt generated is saved.
  String? receiptType;
  String? updatedAt;

  int? customerId;
  String? customerType;
  String? note;

  DateTime? lastTouched;

  late String action;

  // int categoryId;

  String? ticketName;
  DateTime? deletedAt;

  // fields when a transaction is created for ordering system
  int? supplierId;

  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  late bool ebmSynced;

  // Add methods to check type
  late bool isIncome;

  late bool isExpense;
  // bool isIncome() {
  //   return this.transactionType == "cashIn" ||
  //       this == "sale" ||
  //       this == "onlineSale";
  // }

  // bool isExpense() {
  //   return this.transactionType == "cashOut";
  // }
}

@RealmModel()
class _IUnit {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late int branchId;
  late String name;
  late String value;
  late bool active;

  DateTime? lastTouched;

  late String action;
}

@RealmModel()
class _ITenant {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late String name;
  late String phoneNumber;
  String? email;
  late bool nfcEnabled;
  late int businessId;
  late int userId;
  String? imageUrl;

  DateTime? lastTouched;
  DateTime? deletedAt;

  int? pin;

  /// [sessionActive] is not comming from server, this is to check which
  /// tenant is currently have active session but the main session will be still active
  bool? sessionActive;

  late bool isDefault;

  ///helper property, these are property that are not peristed
  ///but used in ui to achieve some functionality

  bool? isLongPressed;
}

@RealmModel()
class _Voucher {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
  int? value;
  int? interval;
  bool? used;
  int? createdAt;
  int? usedAt;
  String? descriptor;
}

@RealmModel()
class _Tenant {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late String name;
  late String phoneNumber;
  String? email; // Make email nullable
  // List<Permission> permissions;
  // List<Branch> branches;
  // List<Business> businesses;
  late int businessId;
  late bool nfcEnabled;

  late int userId;

  int? pin;

  late bool isDefault;

  ///helper property, these are property that are not peristed
  ///but used in ui to achieve some functionality

  bool? isLongPressed;
}
