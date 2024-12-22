//
// part 'schemas.realm.dart';

// @RealmModel()
// class _Branch {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;
//   int? serverId;

//   bool? active;

//   String? description;
//   String? name;
//   int? businessId;
//   String? longitude;
//   String? latitude;
//   String? location;

//   bool isDefault = false;

//   DateTime? lastTouched;

//   DateTime? deletedAt;
//   bool? isOnline = false;
// }

// @RealmModel()
// class _Location {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;
//   int? serverId;

//   bool? active;

//   String? description;
//   String? name;
//   int? businessId;
//   String? longitude;
//   String? latitude;
//   String? location;

//   bool isDefault = false;

//   DateTime? lastTouched;

//   DateTime? deletedAt;
//   bool? isOnline = false;
// }

// @RealmModel()
// class _Business {
//   @PrimaryKey()
//   late ObjectId id;
//   int? serverId;

//   String? name;
//   String? currency;
//   String? categoryId;
//   String? latitude;
//   String? longitude;
//   int? userId;
//   String? timeZone;

//   String? country;
//   String? businessUrl;
//   String? hexColor;
//   String? imageUrl;
//   String? type;
//   bool? active;
//   String? chatUid;
//   String? metadata;
//   String? role;
//   int? lastSeen;
//   String? firstName;
//   String? lastName;
//   String? createdAt;
//   String? deviceToken;
//   bool? backUpEnabled;
//   String? subscriptionPlan;
//   String? nextBillingDate;
//   String? previousBillingDate;
//   bool? isLastSubscriptionPaymentSucceeded;
//   String? backupFileId;
//   String? email;
//   String? lastDbBackup;
//   String? fullName;
//   int? tinNumber;
//   String? bhfId;
//   String? dvcSrlNo;

//   String? adrs;
//   bool? taxEnabled;
//   String? taxServerUrl;
//   bool? isDefault;
//   int? businessTypeId;

//   DateTime? lastTouched;

//   DateTime? deletedAt;

//   String? encryptionKey;
// }

// @RealmModel()
// class _Category {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;
//   bool? active;
//   bool focused = false;
//   String? name;

//   int? branchId;
//   DateTime? deletedAt;
//   DateTime? lastTouched;
// }

// @RealmModel()
// class _PColor {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;
//   late String? name;
//   late List<String> colors;
//   int? branchId;
//   bool active = false;

//   DateTime? lastTouched;

//   DateTime? deletedAt;
// }

// @RealmModel()
// class _Conversation {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;
  // String? userName;
  // String? body;
  // String? avatar;
  // String? channelType;
  // String? fromNumber;
  // String? toNumber;

  // String? createdAt;
  // String? messageType;
  // String? phoneNumberId;

  // String? messageId;
  // String? respondedBy;
  // String? conversationId;

  // String? businessPhoneNumber;
  // int? businessId;

  // DateTime? scheduledAt;

  // bool? delivered;

  // DateTime? lastTouched;
  // DateTime? deletedAt;
// }

// @RealmModel()
// class _Counter {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   int? businessId;
//   int? branchId;
//   String? receiptType;
//   int? totRcptNo;
//   int? curRcptNo;
//   int? invcNo;
//   DateTime? lastTouched;
// }

// @RealmModel()
// class _Customer {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   String? custNm;
//   String? email;

//   String? telNo;

//   String? adrs;
//   int? branchId;
//   DateTime? updatedAt;

//   String? custNo;

//   String? custTin;

//   String? regrNm;

//   String? regrId;

//   String modrNm = "284746303937";

//   String? modrId;

//   bool ebmSynced = false;
//   DateTime? lastTouched;

//   DateTime? deletedAt;

//   int? tin;
//   String? bhfId;
//   String? useYn;
//   String? customerType;
// }

// @RealmModel()
// class _Device {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   String? linkingCode;
//   String? deviceName;
//   String? deviceVersion;
//   bool? pubNubPublished;
//   String? phone;
//   int? branchId;
//   int? businessId;
//   int? userId;
//   String? defaultApp;

//   DateTime? lastTouched;
//   DateTime? deletedAt;
// }

// @RealmModel()
// class _Discount {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   late String name;

//   late double? amount;
//   late int branchId;
// }

// @RealmModel()
// class _Drawers {
//   @PrimaryKey()
//   @MapTo("_id")
//   late ObjectId realmId;

//   int? id;

//   double? openingBalance;
//   double? closingBalance;
//   String? openingDateTime;
//   String? closingDateTime;
//   int? csSaleCount;
//   String? tradeName;
//   double? totalNsSaleIncome;
//   double? totalCsSaleIncome;
//   int? nrSaleCount;
//   int? nsSaleCount;
//   int? trSaleCount;
//   int? psSaleCount;
//   int? incompleteSale;
//   int? otherTransactions;
//   String? paymentMode;
//   int? cashierId;
//   bool? open;
//   DateTime? deletedAt;
//   int? businessId;
//   int? branchId;
// }

// @RealmModel()
// class _EBM {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   late String bhfId;
//   late int tinNumber;
//   late String dvcSrlNo;
//   late int userId;
//   late String? taxServerUrl;
//   late int businessId;
//   late int branchId;

//   DateTime? lastTouched;

//   late String action;
// }

// @RealmModel()
// class _Favorite {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   int? favIndex;

//   int? productId;
//   int? branchId;

//   DateTime? lastTouched;

//   DateTime? deletedAt;
// }

// @RealmModel()
// class _Product {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   String? name;
//   String? description;
//   String? taxId;
//   String color = "#e74c3c";
//   int? businessId;

//   int? branchId;
//   String? supplierId;
//   int? categoryId;
//   String? createdAt;
//   String? unit;
//   String? imageUrl;
//   String? expiryDate;

//   String? barCode;
//   bool nfcEnabled = false;

//   int? bindedToTenantId;
//   bool isFavorite = false;

//   DateTime? lastTouched;

//   DateTime? deletedAt;

//   @Ignored()
//   bool searchMatch = false;
//   String? spplrNm;
//   bool? isComposite = false;

//   List<_Composite> composites = [];
// }

// @RealmModel()
// class _Receipt {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   String? resultCd;
//   String? resultMsg;
//   String? resultDt;
//   int? rcptNo;
//   String? intrlData;
//   String? rcptSign;
//   int? totRcptNo;
//   String? vsdcRcptPbctDate;
//   String? sdcId;
//   String? mrcNo;
//   String? qrCode;
//   String? receiptType;
//   int? branchId;

//   int? transactionId;

//   DateTime? lastTouched;

//   int? invcNo;
//   DateTime? whenCreated;
//   int? invoiceNumber;
// }

// @RealmModel()
// class _Setting {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   String? email;

//   int? userId;
//   bool? openReceiptFileOSaleComplete;
//   bool? autoPrint;
//   bool? sendDailyReport;
//   String? defaultLanguage;
//   bool? attendnaceDocCreated;
//   bool? isAttendanceEnabled;
//   String? type;
//   bool? enrolledInBot;
//   String? deviceToken;
//   String? businessPhoneNumber;
//   bool? autoRespond;
//   String? token;
//   bool hasPin = false;
//   int? businessId;
//   String? createdAt;

//   DateTime? lastTouched;

//   DateTime? deletedAt;
// }

// @RealmModel()
// class _Stock {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   ObjectId? realmId;
//   int? tin;
//   String? bhfId;

//   int? branchId;
//   int? variantId;
//   double currentStock = 0.0;
//   double lowStock = 0;

//   bool? canTrackingStock = true;
//   bool? showLowStockAlert = true;

//   int? productId;
//   bool? active;

//   double value = 0.0;

//   double rsdQty = 0.0;

//   DateTime? lastTouched;

//   DateTime? deletedAt;

//   bool ebmSynced = false;

//   bool cloudSynced = true;

//   late _Variant? variant;
//   double? initialStock;
// }

// @RealmModel()
// class _Variant {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   DateTime? deletedAt;

//   String? name;
//   String? color;
//   String? sku;

//   int? productId;
//   String? unit;
//   String? productName;
//   int? branchId;
//   String? taxName = "";
//   double taxPercentage = 0.0;

//   @deprecated
//   bool isTaxExempted = false;

//   int? itemSeq;

//   String? isrccCd = "";

//   String? isrccNm = "";

//   int? isrcRt = 0;

//   int? isrcAmt = 0;

//   String? taxTyCd = "B";

//   String? bcd = "";

//   String? itemClsCd;

//   String? itemTyCd;

//   String? itemStdNm = "";

//   String? orgnNatCd = "";

//   String? pkg = "1";

//   String? itemCd = "";

//   String? pkgUnitCd = "CT";

//   String? qtyUnitCd = "BX";

//   String? itemNm;
//   double qty = 0.0;

//   double prc = 0.0;

//   double splyAmt = 0.0;
//   int? tin;
//   String? bhfId;
//   double? dftPrc = 0;
//   String? addInfo = "";
//   String? isrcAplcbYn = "";
//   String? useYn = "";
//   String? regrId;
//   String? regrNm;
//   String? modrId;
//   String? modrNm;

//   DateTime? lastTouched;

//   double supplyPrice = 0.0;

//   double retailPrice = 0.0;

//   String? spplrItemClsCd;
//   String? spplrItemCd;
//   String? spplrItemNm;

//   bool ebmSynced = false;

//   @deprecated
//   String taxType = "B";

//   late List<int> branchIds;
//   late _Stock? stock;

//   double dcRt = 0.0;
//   DateTime? expirationDate;
// }

// @RealmModel()
// class _StockRequest {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;
//   int? mainBranchId;
//   int? subBranchId;
//   DateTime? createdAt;

//   String? status;
//   DateTime? deliveryDate;
//   String? deliveryNote;
//   String? orderNote;
//   bool? customerReceivedOrder = false;
//   bool? driverRequestDeliveryConfirmation = false;
//   int? driverId;
//   late List<_TransactionItem> items;
//   DateTime? updatedAt;
// }

// @RealmModel()
// class _TransactionItem {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   String? name;
//   int? quantityRequested;
//   int? quantityApproved;
//   int? quantityShipped;
//   int? transactionId;
//   int? variantId;

//   double qty = 0.0;
//   double price = 0.0;
//   double discount = 0.0;
//   String? type;
//   double remainingStock = 0.0;
//   String? createdAt;
//   String? updatedAt;
//   bool isTaxExempted = false;
//   bool isRefunded = false;

//   bool? doneWithTransaction;
//   bool? active;

//   double dcRt = 0.0;

//   double dcAmt = 0.0;

//   double taxblAmt = 0.0;
//   double taxAmt = 0.0;

//   double totAmt = 0.0;

//   int? itemSeq;

//   String? isrccCd;

//   String? isrccNm = "";

//   int? isrcRt = 0;

//   int? isrcAmt = 0;

//   String? taxTyCd;

//   String? bcd;

//   String? itemClsCd;

//   String? itemTyCd;

//   String? itemStdNm;

//   String? orgnNatCd;

//   String? pkg;

//   String? itemCd;

//   String? pkgUnitCd = "CT";

//   String? qtyUnitCd = "BX";

//   String? itemNm;

//   double prc = 0.0;

//   double splyAmt = 0.0;
//   int? tin;
//   String? bhfId;
//   double? dftPrc;
//   String? addInfo;
//   String? isrcAplcbYn;
//   String? useYn;
//   String? regrId;
//   String? regrNm;
//   String? modrId;
//   String? modrNm;

//   DateTime? lastTouched;
//   DateTime? deletedAt;

//   int? branchId;
//   bool ebmSynced = false;
//   bool partOfComposite = false;
//   double compositePrice = 0;
// }

// @RealmModel()
// class _ITransaction {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   String? reference;
//   String? categoryId;
//   String? transactionNumber;
//   @Indexed()
//   int? branchId;
//   @Indexed()
//   String? status;
//   @Indexed()
//   String? transactionType;
//   double subTotal = 0.0;
//   String? paymentType;
//   double cashReceived = 0.0;
//   double customerChangeDue = 0.0;
//   @Indexed()
//   String? createdAt;

//   String? receiptType;
//   String? updatedAt;
//   @Indexed()
//   int? customerId;
//   String? customerType;
//   String? note;

//   DateTime? lastTouched;

//   String? ticketName;
//   DateTime? deletedAt;

//   int? supplierId;

//   bool ebmSynced = false;

//   bool isIncome = false;

//   bool isExpense = false;
//   bool isRefunded = false;
//   String? customerName;
//   String? customerTin;
//   String? remark;
//   String? customerBhfId;
//   String? sarTyCd;
//   int? receiptNumber;
//   int? totalReceiptNumber;
//   int? invoiceNumber;
// }

// @RealmModel()
// class _IUnit {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   int? branchId;
//   String? name;
//   String? value;
//   bool active = false;

//   DateTime? lastTouched;

//   String? createdAt;
//   DateTime? deletedAt;
// }

// @RealmModel()
// class _Voucher {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;
//   int? value;
//   int? interval;
//   bool? used;
//   int? createdAt;
//   int? usedAt;
//   String? descriptor;
// }

// @RealmModel()
// class _Tenant {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   String? name;
//   String? phoneNumber;
//   String? email;
//   bool nfcEnabled = false;
//   int? businessId;
//   int? userId;
//   String? imageUrl;

//   DateTime? lastTouched;
//   DateTime? deletedAt;

//   int? pin;

//   bool? sessionActive;

//   bool? isDefault;

//   bool isLongPressed = false;
//   String type = "Agent";
// }

// @RealmModel()
// class _Pin {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   ObjectId? realmId;
//   int? userId;
//   String? phoneNumber;
//   int? pin;
//   int? branchId;
//   int? businessId;
//   String? ownerName;
//   String? tokenUid;
//   String? uid;
// }

// @RealmModel()
// class _LPermission {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   ObjectId? realmId;
//   String? name;
//   int? userId;
// }

// @RealmModel()
// class _Token {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   ObjectId? realmId;

//   String? type;
//   String? token;
//   DateTime? validFrom;
//   DateTime? validUntil;
//   int? businessId;

//   DateTime? lastTouched;
//   DateTime? deletedAt;
// }

// @RealmModel()
// class _Activity {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   DateTime? timestamp;
//   DateTime? lastTouched;
//   int? userId;
//   String? event;

//   late RealmValue details;
//   late String action;
// }

// @RealmModel()
// class _UnversalProduct {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   String? itemClsCd;
//   String? itemClsNm;
//   int? itemClsLvl;
//   String? taxTyCd;
//   String? mjrTgYn;
//   String? useYn;

//   int? businessId;
//   int? branchId;
// }

// @RealmModel()
// class _Configurations {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   String? taxType = "B";
//   double? taxPercentage = 18.0;
//   int? businessId;
//   int? branchId;
// }

// @RealmModel()
// class _AppNotification {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;
//   bool completed = false;
//   String? type = 'transaction';
//   String? message;

//   int? identifier;
// }

// @RealmModel()
// class _Assets {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   int? branchId;
//   int? businessId;
//   String? assetName;
//   int? productId;
// }

// @RealmModel()
// class _Composite {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   int? productId;
//   int? variantId;
//   double? qty = 1.0;
//   int? branchId;
//   int? businessId;

//   double? actualPrice = 0;
// }

// @RealmModel()
// class _SKU {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   int? sku = 1000;
//   int? branchId;
//   int? businessId;
//   bool? consumed = false;
// }

// @RealmModel()
// class _Report {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   int? branchId;
//   int? businessId;
//   String? filename;
//   String? s3Url;
//   bool? downloaded = false;
// }

// @RealmModel()
// class _Access {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   int? branchId;
//   int? businessId;
//   int? userId;
//   String? featureName;
//   String? userType;
//   String? accessLevel;
//   DateTime? createdAt;
//   DateTime? expiresAt;
//   String? status;
// }

// @RealmModel()
// class _PaymentPlan {
//   int? id;

//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   int? businessId;

//   String? selectedPlan;
//   int? additionalDevices;
//   bool? isYearlyPlan;
//   double? totalPrice;
//   DateTime? createdAt;
//   bool? paymentCompletedByUser = false;
//   int? payStackCustomerId;

//   String? rule;
//   String? paymentMethod;
//   String? customerCode;
//   String? payStackPlanId;
// }

// @RealmModel()
// class _FlipperSaleCompaign {
//   int? id;

//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   int? compaignId;
//   int? discountRate;
//   DateTime? createdAt;
//   String? couponCode;
// }

// @RealmModel()
// class _TransactionPaymentRecord {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;
//   int? transactionId;
//   double? amount = 0.0;
//   String? paymentMethod;
//   DateTime? createdAt;
// }

// @RealmModel()
// class _DeletedObject {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   int? branchId;
//   int? businessId;
//   String? objectName;
//   String? objectId;

//   int? deviceCount;

//   int? expectedDeviceCount;
// }

// @RealmModel()
// class _DataMapper {
//   int? id;
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId realmId;

//   String? tableName;
//   String? objectId;
//   String? deviceIdentifier;
//   int? syncDevices;
//   int? deviceDownloadedObject;
// }
