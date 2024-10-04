import 'package:flipper_models/CloudSync.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/power_sync/schema.dart';

import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PullChange {
  void start(
      {required FirebaseFirestore firestore, required Realm localRealm}) {
    /// delete all product from firestore where brnach_id ==1

    CloudSync(firestore, localRealm).watchTable<Product>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'products',
      idField: 'product_id',
      createRealmObject: (data) {
        return Product(
          ObjectId(),
          id: data['product_id'] == null ? randomNumber() : data['product_id'],
          name: data['name'] == null ? "" : data['name'],
          description: data['description'],
          taxId: data['tax_id'],
          color: data['color'] ?? "#e74c3c",
          businessId: data['business_id'] == null
              ? ProxyService.box.getBusinessId()
              : data['business_id'],
          branchId: data['branch_id'] == null
              ? ProxyService.box.getBranchId()
              : data['branch_id'],
          supplierId: data['supplier_id'] == null ? "" : data['supplier_id'],
          categoryId: data['category_id'] == null ? 0 : data['category_id'],
          createdAt: data['created_at'] == null
              ? DateTime.now().toIso8601String()
              : data['created_at'],
          unit: data['unit'] == null ? "" : data['unit'],
          imageUrl: data['image_url'] == null ? "" : data['image_url'],
          expiryDate: data['expiry_date'] == null ? "" : data['expiry_date'],
          barCode: data['bar_code'],
          nfcEnabled: data['nfc_enabled'] ?? false,
          bindedToTenantId: data['binded_to_tenant_id'] == null
              ? 0
              : data['binded_to_tenant_id'],
          isFavorite: data['is_favorite'] ?? false,
          lastTouched: data['last_touched'] == null
              ? DateTime.now()
              : DateTime.parse(data['last_touched']),
          action: data['action'] == null ? "" : data['action'],
          deletedAt:
              data['deleted_at'] == null ? DateTime.now() : data['deleted_at'],
          spplrNm: data['spplr_nm'] == null ? "" : data['spplr_nm'],
        );
      },
      updateRealmObject: (_product, data) {
        Product? product = localRealm
            .query<Product>(r'id == $0', [data['product_id']]).firstOrNull;

        if (product != null) {
          localRealm.write(() {
            product.name = data['name'] ?? product.name;
            product.description = data['description'] ?? product.description;
            product.taxId = data['tax_id'] ?? product.taxId;
            product.color = data['color'] ?? product.color;
            product.businessId = data['business_id'] == null
                ? ProxyService.box.getBusinessId()
                : data['business_id'];
            product.branchId = data['branch_id'] == null
                ? ProxyService.box.getBranchId()
                : data['branch_id'];

            product.supplierId = data['supplier_id'] ?? product.supplierId;
            product.categoryId =
                data['category_id'] == null ? 0 : data['category_id'];
            product.createdAt = data['created_at'] == null
                ? DateTime.now().toIso8601String()
                : data['created_at'];

            product.unit = data['unit'] ?? product.unit;
            product.imageUrl = data['image_url'] ?? product.imageUrl;
            product.expiryDate = data['expiry_date'] ?? product.expiryDate;
            product.barCode = data['bar_code'] ?? product.barCode;
            product.nfcEnabled = data['nfc_enabled'] ?? product.nfcEnabled;
            product.bindedToTenantId = data['binded_to_tenant_id'] == null
                ? 0
                : data['binded_to_tenant_id'];
            product.isFavorite = data['is_favorite'] ?? product.isFavorite;
            product.lastTouched = data['last_touched'] == null
                ? DateTime.now()
                : DateTime.parse(data['last_touched']);
            product.action = data['action'] ?? product.action;
            product.deletedAt = data['deleted_at'] == null
                ? DateTime.now()
                : DateTime.parse(data['deleted_at']);
            product.searchMatch = data['search_match'] ?? product.searchMatch;
            product.spplrNm = data['spplr_nm'] ?? product.spplrNm;
            product.isComposite = data['is_composite'] ?? product.isComposite;
          });
        }
      },
    );

    CloudSync(firestore, localRealm).watchTable<Variant>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'variants',
      idField: 'variant_id',
      createRealmObject: (data) {
        return Variant(
          ObjectId(),
          id: data['variant_id'] == null ? 0 : data['variant_id'],
          branchId: data['branch_id'] == null
              ? ProxyService.box.getBranchId()
              : data['branch_id'],
          lastTouched: data['last_touched'] == null
              ? DateTime.now()
              : DateTime.parse(data['last_touched']),
          name: data['name'] == null ? "" : data['name'],
          color: data['color'] == null ? "#e74c3c" : data['color'],
          sku: data['sku'] == null ? "" : data['sku'],
          productId: data['product_id'] == null ? 0 : data['product_id'],
          unit: data['unit'] == null ? "" : data['unit'],
          productName: data['product_name'] == null ? "" : data['product_name'],
          taxName: data['tax_name'] == null ? "" : data['tax_name'],
          taxPercentage:
              data['tax_percentage'] == null ? 0.0 : data['tax_percentage'],
          isTaxExempted: data['is_tax_exempted'] ?? false,
          itemSeq: data['item_seq'] == null ? 0 : data['item_seq'],
          isrccCd: data['isrcc_cd'] == null ? "" : data['isrcc_cd'],
          isrccNm: data['isrcc_nm'] == null ? "" : data['isrcc_nm'],
          isrcRt: data['isrc_rt'] == null ? 0 : data['isrc_rt'],
          isrcAmt: data['isrc_amt'] == null ? 0 : data['isrc_amt'],
          taxTyCd: data['tax_ty_cd'] == null ? "" : data['tax_ty_cd'],
          bcd: data['bcd'] == null ? "" : data['bcd'],
          itemClsCd: data['item_cls_cd'] == null ? "" : data['item_cls_cd'],
          itemTyCd: data['item_ty_cd'] == null ? "" : data['item_ty_cd'],
          itemStdNm: data['item_std_nm'] == null ? "" : data['item_std_nm'],
          orgnNatCd: data['orgn_nat_cd'] == null ? "" : data['orgn_nat_cd'],
          pkg: data['pkg'] == null ? "" : data['pkg'],
          itemCd: data['item_cd'] == null ? "" : data['item_cd'],
          pkgUnitCd: data['pkg_unit_cd'] == null ? "" : data['pkg_unit_cd'],
          qtyUnitCd: data['qty_unit_cd'] == null ? "" : data['qty_unit_cd'],
          itemNm: data['item_nm'],
          qty: data['qty'] == null ? 0.0 : data['qty'],
          prc: data['prc'] == null ? 0.0 : data['prc'],
          splyAmt: data['sply_amt'] == null ? 0.0 : data['sply_amt'],
          tin: data['tin'] == null ? 0 : data['tin'],
          bhfId: data['bhf_id'] == null ? "" : data['bhf_id'],
          dftPrc: data['dft_prc'] == null ? 0.0 : data['dft_prc'],
          addInfo: data['add_info'] == null ? "" : data['add_info'],
          isrcAplcbYn:
              data['isrc_aplcby_yn'] == null ? "" : data['isrc_aplcby_yn'],
          useYn: data['use_yn'] == null ? "" : data['use_yn'],
          regrId: data['regr_id'] == null ? "" : data['regr_id'],
          regrNm: data['regr_nm'] == null ? "" : data['regr_nm'],
          modrId: data['modr_id'] == null ? "" : data['modr_id'],
          modrNm: data['modr_nm'] == null ? "" : data['modr_nm'],
          rsdQty: data['rsd_qty'] == null ? 0.0 : data['rsd_qty'],
          supplyPrice:
              data['supply_price'] == null ? 0.0 : data['supply_price'],
          retailPrice:
              data['retail_price'] == null ? 0.0 : data['retail_price'],
          spplrItemClsCd: data['spplr_item_cls_cd'] == null
              ? ""
              : data['spplr_item_cls_cd'],
          spplrItemCd:
              data['spplr_item_cd'] == null ? "" : data['spplr_item_cd'],
          spplrItemNm:
              data['spplr_item_nm'] == null ? "" : data['spplr_item_nm'],
          ebmSynced: data['ebm_synced'] ?? false,
          taxType: data['tax_type'] == null ? "" : data['tax_type'],
        );
      },
      updateRealmObject: (_variant, data) {
        // Find related variant
        Variant? variant = localRealm
            .query<Variant>(r'id == $0', [data['variant_id']]).firstOrNull;

        if (variant != null) {
          localRealm.write(() {
            variant.lastTouched = data['last_touched'] is DateTime
                ? data['last_touched']
                : DateTime.tryParse(data['last_touched']) ??
                    variant.lastTouched;
            variant.name = data['name'];
            variant.branchId = data['branch_id'] is int
                ? data['branch_id']
                : int.tryParse(data['branch_id']) ?? variant.branchId;
            variant.color = data['color'];
            variant.sku = data['sku'];
            variant.productId = data['product_id'] is int
                ? data['product_id']
                : int.tryParse(data['product_id']) ?? variant.productId;
            variant.unit = data['unit'];
            // ... add other properties here ...
            variant.productName = data['product_name'];
            variant.taxName = data['tax_name'];
            variant.taxPercentage = data['tax_percentage'] is double
                ? data['tax_percentage']
                : double.tryParse(data['tax_percentage']) ??
                    variant.taxPercentage;
            variant.isTaxExempted =
                data['is_tax_exempted'] ?? variant.isTaxExempted;
            variant.itemSeq = data['item_seq'] is int
                ? data['item_seq']
                : int.tryParse(data['item_seq']) ?? variant.itemSeq;
            variant.isrccCd = data['isrcc_cd'] ?? variant.isrccCd;
            variant.isrccNm = data['isrcc_nm'] ?? variant.isrccNm;
            variant.isrcRt = data['isrc_rt'] is int
                ? data['isrc_rt']
                : int.tryParse(data['isrc_rt']) ?? variant.isrcRt;
            variant.isrcAmt = data['isrc_amt'] == null ? 0 : data['isrc_amt'];
            variant.taxTyCd = data['tax_ty_cd'] ?? variant.taxTyCd;
            variant.bcd = data['bcd'] ?? variant.bcd;
            variant.itemClsCd = data['item_cls_cd'] ?? variant.itemClsCd;
            variant.itemTyCd = data['item_ty_cd'] ?? variant.itemTyCd;
            variant.itemStdNm = data['item_std_nm'] ?? variant.itemStdNm;
            variant.orgnNatCd = data['orgn_nat_cd'] ?? variant.orgnNatCd;
            variant.pkg = data['pkg'] ?? variant.pkg;
            variant.itemCd = data['item_cd'] ?? variant.itemCd;
            variant.pkgUnitCd = data['pkg_unit_cd'] ?? variant.pkgUnitCd;
            variant.qtyUnitCd = data['qty_unit_cd'] ?? variant.qtyUnitCd;
            variant.itemNm = data['item_nm'] ?? variant.itemNm;
            variant.qty = data['qty'] is double
                ? data['qty']
                : double.tryParse(data['qty']) ?? variant.qty;
            variant.prc = data['prc'] is double
                ? data['prc']
                : double.tryParse(data['prc']) ?? variant.prc;
            variant.splyAmt = data['sply_amt'] is double
                ? data['sply_amt']
                : double.tryParse(data['sply_amt']) ?? variant.splyAmt;
            variant.tin = data['tin'] is int
                ? data['tin']
                : int.tryParse(data['tin']) ?? variant.tin;
            variant.bhfId = data['bhf_id'] ?? variant.bhfId;
            variant.dftPrc = data['dft_prc'] is double
                ? data['dft_prc']
                : double.tryParse(data['dft_prc']) ?? variant.dftPrc;
            variant.addInfo = data['add_info'] ?? variant.addInfo;
            variant.isrcAplcbYn = data['isrc_aplcby_yn'] ?? variant.isrcAplcbYn;
            variant.useYn = data['use_yn'] ?? variant.useYn;
            variant.regrId = data['regr_id'] ?? variant.regrId;
            variant.regrNm = data['regr_nm'] ?? variant.regrNm;
            variant.modrId = data['modr_id'] ?? variant.modrId;
            variant.modrNm = data['modr_nm'] ?? variant.modrNm;
            variant.rsdQty = data['rsd_qty'] is double
                ? data['rsd_qty']
                : double.tryParse(data['rsd_qty']) ?? variant.rsdQty;
            variant.supplyPrice = data['supply_price'] is double
                ? data['supply_price']
                : double.tryParse(data['supply_price']) ?? variant.supplyPrice;
            variant.retailPrice = data['retail_price'] is double
                ? data['retail_price']
                : double.tryParse(data['retail_price']) ?? variant.retailPrice;
            variant.action = data['action'] ?? variant.action;
            variant.spplrItemClsCd =
                data['spplr_item_cls_cd'] ?? variant.spplrItemClsCd;
            variant.spplrItemCd = data['spplr_item_cd'] ?? variant.spplrItemCd;
            variant.spplrItemNm = data['spplr_item_nm'] ?? variant.spplrItemNm;
            variant.ebmSynced = data['ebm_synced'] ?? variant.ebmSynced;
            variant.taxType = data['tax_type'] ?? variant.taxType;
          });
        }
      },
    );

    CloudSync(firestore, localRealm).watchTable<Pin>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: pinsTable,
      idField: pinsTable.singularize() + "_id",
      createRealmObject: (data) {
        return Pin(
          ObjectId(),
          id: data['user_id'] == null ? 0 : int.parse(data['user_id']),
          userId: data['user_id'],
          branchId: data['branch_id'],
          businessId: data['business_id'],
          ownerName: data['owner_name'],
          tokenUid: data['token_uid'],
          phoneNumber: data['phone_number'],
        );
      },
      updateRealmObject: (_pin, data) {
        Pin? pin = localRealm
            .query<Pin>(r'userId == $0', [data['user_id']]).firstOrNull;

        if (pin != null) {
          localRealm.write(() {
            pin.tokenUid = data['token_uid'];
          });
        }
      },
    );
    CloudSync(firestore, localRealm).watchTable<ITransaction>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: iTransactionsTable,
      idField: iTransactionsTable.singularize() + "_id",
      createRealmObject: (data) {
        return ITransaction(
          ObjectId(),
          id: data['asset_id'] == null ? randomNumber() : data['asset_id'],
          branchId: data['branch_id'] == null
              ? ProxyService.box.getBranchId()
              : data['branch_id'],
          receiptType: data['receipt_type'] == null ? "" : data['receipt_type'],
          status: data['status'] == null ? "" : data['status'],
          transactionType:
              data['transaction_type'] == null ? "" : data['transaction_type'],
          subTotal: data['sub_total'] == null ? 0.0 : data['sub_total'],
          paymentType: data['payment_type'] == null ? "" : data['payment_type'],
          cashReceived:
              data['cash_received'] == null ? 0.0 : data['cash_received'],
          customerChangeDue: data['customer_change_due'] == null
              ? 0.0
              : data['customer_change_due'],
          createdAt:
              data['created_at'] == null ? DateTime.now() : data['created_at'],
          updatedAt:
              data['updated_at'] == null ? DateTime.now() : data['updated_at'],
          customerId: data['customer_id'] == null ? 0 : data['customer_id'],
          customerType:
              data['customer_type'] == null ? "" : data['customer_type'],
          note: data['note'] == null ? "" : data['note'],
          lastTouched: data['last_touched'] == null
              ? DateTime.now()
              : DateTime.tryParse(data['last_touched']),
          action: data['action'] == null ? "" : data['action'],
          ticketName: data['ticket_name'] == null ? "" : data['ticket_name'],
          deletedAt: data['deleted_at'] == null
              ? DateTime.now()
              : DateTime.parse(data['deleted_at']),
          supplierId: data['supplier_id'] == null ? 0 : data['supplier_id'],
          ebmSynced: data['ebm_synced'] == null ? false : data['ebm_synced'],
          isIncome: data['is_income'] == null ? false : data['is_income'],
          isExpense: data['is_expense'] == null ? false : data['is_expense'],
          isRefunded: data['is_refunded'] == null ? false : data['is_refunded'],
        );
      },
      updateRealmObject: (_transaction, data) {
        ITransaction? transaction = localRealm.query<ITransaction>(r'id == $0',
            [data[iTransactionsTable.singularize() + "_id"]]).firstOrNull;

        if (transaction != null) {
          localRealm.write(() {
            transaction.lastTouched = data['last_touched'] == null
                ? DateTime.now()
                : DateTime.parse(data['last_touched']);
            transaction.status = data['status'] == null ? "" : data['status'];
            transaction.transactionType = data['transaction_type'] == null
                ? ""
                : data['transaction_type'];
            transaction.subTotal =
                data['sub_total'] == null ? 0.0 : data['sub_total'];
            transaction.paymentType =
                data['payment_type'] == null ? "" : data['payment_type'];
            transaction.cashReceived = data['cash_received'] == null
                ? 0.0
                : double.parse(data['cash_received']);
            transaction.customerChangeDue = data['customer_change_due'] == null
                ? 0.0
                : data['customer_change_due'];
            transaction.createdAt = data['created_at'] == null
                ? DateTime.now().toIso8601String()
                : data['created_at'];
            transaction.updatedAt = data['updated_at'] == null
                ? DateTime.now().toIso8601String()
                : data['updated_at'];
            transaction.customerId =
                data['customer_id'] == null ? 0 : data['customer_id'];
            transaction.customerType =
                data['customer_type'] == null ? "" : data['customer_type'];
            transaction.note = data['note'] == null ? "" : data['note'];
            transaction.ticketName =
                data['ticket_name'] == null ? "" : data['ticket_name'];
            transaction.deletedAt = data['deleted_at'] == null
                ? DateTime.now()
                : DateTime.parse(data['deleted_at']);
            transaction.supplierId =
                data['supplier_id'] == null ? 0 : data['supplier_id'];
            transaction.ebmSynced =
                data['ebm_synced'] == null ? false : data['ebm_synced'];
            transaction.isIncome =
                data['is_income'] == null ? false : data['is_income'];
            transaction.isExpense =
                data['is_expense'] == null ? false : data['is_expense'];
            transaction.isRefunded =
                data['is_refunded'] == null ? false : data['is_refunded'];
          });
        }
      },
    );
    CloudSync(firestore, localRealm).watchTable<Assets>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'assets',
      idField: 'asset_id',
      createRealmObject: (data) {
        return Assets(
          ObjectId(),
          id: data['asset_id'] == null ? 0 : data['asset_id'],
          branchId: data['branch_id'] == null ? 0 : data['branch_id'],
          businessId: data['business_id'] == null ? 0 : data['business_id'],
          assetName: data['asset_name'] == null ? "" : data['asset_name'],
          productId: data['product_id'] == null ? 0 : data['product_id'],
        );
      },
      updateRealmObject: (_asset, data) {
        // Find related Assets
        Assets? asset = localRealm
            .query<Assets>(r'id == $0', [data['asset_id']]).firstOrNull;

        if (asset != null) {
          localRealm.write(() {
            asset.assetName =
                data['asset_name'] == null ? "" : data['asset_name'];
            asset.productId =
                data['product_id'] == null ? 0 : data['product_id'];
          });
        }
      },
    );
    CloudSync(firestore, localRealm).watchTable<Setting>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'settings',
      idField: 'setting_id',
      createRealmObject: (data) {
        return Setting(
          ObjectId(),
          id: data['setting_id'] is int
              ? data['setting_id']
              : int.tryParse(data['setting_id']) ?? 0,
          email: data['email'],
          userId: data['user_id'] is int
              ? data['user_id']
              : int.tryParse(data['user_id']) ?? 0,
          openReceiptFileOSaleComplete:
              data['open_receipt_file_on_sale_complete'] ?? false,
          autoPrint: data['auto_print'] ?? false,
          sendDailyReport: data['send_daily_report'] ?? false,
          defaultLanguage: data['default_language'],
          attendnaceDocCreated: data['attendnace_doc_created'] ?? false,
          isAttendanceEnabled: data['is_attendance_enabled'] ?? false,
          type: data['type'],
          enrolledInBot: data['enrolled_in_bot'] ?? false,
          deviceToken: data['device_token'],
          businessPhoneNumber: data['business_phone_number'],
          autoRespond: data['auto_respond'] ?? false,
          token: data['token'],
          hasPin: data['has_pin'] ?? false,
          businessId: data['business_id'] is int
              ? data['business_id']
              : int.tryParse(data['business_id']) ?? 0,
          createdAt: data['created_at'],
          lastTouched: data['last_touched'] is DateTime
              ? data['last_touched']
              : DateTime.tryParse(data['last_touched']),
          deletedAt: data['deleted_at'] is DateTime
              ? data['deleted_at']
              : DateTime.tryParse(data['deleted_at']),
          action: data['action'],
        );
      },
      updateRealmObject: (_stock, data) {
        // Find related Setting
        Setting? setting = localRealm
            .query<Setting>(r'id == $0', [data['setting_id']]).firstOrNull;

        if (setting != null) {
          localRealm.write(() {
            setting.email = data['email'] ?? setting.email;
            setting.userId = data['user_id'] is int
                ? data['user_id']
                : int.tryParse(data['user_id']) ?? setting.userId;
            setting.openReceiptFileOSaleComplete =
                data['open_receipt_file_on_sale_complete'] ??
                    setting.openReceiptFileOSaleComplete;
            setting.autoPrint = data['auto_print'] ?? setting.autoPrint;
            setting.sendDailyReport =
                data['send_daily_report'] ?? setting.sendDailyReport;
            setting.defaultLanguage =
                data['default_language'] ?? setting.defaultLanguage;
            setting.attendnaceDocCreated =
                data['attendnace_doc_created'] ?? setting.attendnaceDocCreated;
            setting.isAttendanceEnabled =
                data['is_attendance_enabled'] ?? setting.isAttendanceEnabled;
            setting.type = data['type'] ?? setting.type;
            setting.enrolledInBot =
                data['enrolled_in_bot'] ?? setting.enrolledInBot;
            setting.deviceToken = data['device_token'] ?? setting.deviceToken;
            setting.businessPhoneNumber =
                data['business_phone_number'] ?? setting.businessPhoneNumber;
            setting.autoRespond = data['auto_respond'] ?? setting.autoRespond;
            setting.token = data['token'] ?? setting.token;
            setting.hasPin = data['has_pin'] ?? setting.hasPin;
            setting.businessId = data['business_id'] is int
                ? data['business_id']
                : int.tryParse(data['business_id']) ?? setting.businessId;
            setting.createdAt = data['created_at'] ?? setting.createdAt;
            setting.lastTouched = data['last_touched'] is DateTime
                ? data['last_touched']
                : DateTime.tryParse(data['last_touched']) ??
                    setting.lastTouched;
            setting.deletedAt = data['deleted_at'] is DateTime
                ? data['deleted_at']
                : DateTime.tryParse(data['deleted_at']) ?? setting.deletedAt;
            setting.action = data['action'] ?? setting.action;
          });
        }
      },
    );
    CloudSync(firestore, localRealm).watchTable<TransactionPaymentRecord>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'transaction_payment_records',
      idField: 'transaction_payment_record_id',
      createRealmObject: (data) {
        return TransactionPaymentRecord(
          ObjectId(),
          id: data['transaction_payment_record_id'] is int
              ? data['transaction_payment_record_id']
              : int.tryParse(data['transaction_payment_record_id']) ??
                  randomNumber(),
          transactionId: data['transaction_id'] is int
              ? data['transaction_id']
              : int.tryParse(data['transaction_id']) ?? 0,
          amount: data['amount'] is double
              ? data['amount']
              : double.tryParse(data['amount']) ?? 0.0,
          paymentMethod: data['payment_method'],
          createdAt: data['created_at'] is DateTime
              ? data['created_at']
              : DateTime.tryParse(data['created_at']),
        );
      },
      updateRealmObject: (_stock, data) {
        TransactionPaymentRecord? record = localRealm
            .query<TransactionPaymentRecord>(r'id == $0',
                [data['transaction_payment_record_id']]).firstOrNull;

        if (record != null) {
          localRealm.write(() {
            record.transactionId = data['transaction_id'] is int
                ? data['transaction_id']
                : int.tryParse(data['transaction_id']) ?? record.transactionId;
            record.amount = data['amount'] is double
                ? data['amount']
                : double.tryParse(data['amount']) ?? record.amount;
            record.paymentMethod =
                data['payment_method'] ?? record.paymentMethod;
            record.createdAt = data['created_at'] is DateTime
                ? data['created_at']
                : DateTime.tryParse(data['created_at']) ?? record.createdAt;
          });
        }
      },
    );
    CloudSync(firestore, localRealm).watchTable<FlipperSaleCompaign>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'flipper_sale_compaigns',
      idField: 'flipper_sale_compaign_id',
      createRealmObject: (data) {
        return FlipperSaleCompaign(
          ObjectId(),
          id: data['flipper_sale_compaign_id'] is int
              ? data['flipper_sale_compaign_id']
              : int.tryParse(data['flipper_sale_compaign_id']) ??
                  randomNumber(),
          compaignId: data['compaign_id'] is int
              ? data['compaign_id']
              : int.tryParse(data['compaign_id']) ?? 0,
          discountRate: data['discount_rate'] is int
              ? data['discount_rate']
              : int.tryParse(data['discount_rate']) ?? 0,
          createdAt: data['created_at'] is DateTime
              ? data['created_at']
              : DateTime.tryParse(data['created_at']),
          couponCode: data['coupon_code'],
        );
      },
      updateRealmObject: (_stock, data) {
        FlipperSaleCompaign? compaign = localRealm.query<FlipperSaleCompaign>(
            r'id == $0', [data['flipper_sale_compaign_id']]).firstOrNull;

        if (compaign != null) {
          localRealm.write(() {
            compaign.compaignId = data['compaign_id'] is int
                ? data['compaign_id']
                : int.tryParse(data['compaign_id']) ?? compaign.compaignId;
            compaign.discountRate = data['discount_rate'] is int
                ? data['discount_rate']
                : int.tryParse(data['discount_rate']) ?? compaign.discountRate;
            compaign.createdAt = data['created_at'] is DateTime
                ? data['created_at']
                : DateTime.tryParse(data['created_at']) ?? compaign.createdAt;
            compaign.couponCode = data['coupon_code'] ?? compaign.couponCode;
          });
        }
      },
    );
    CloudSync(firestore, localRealm).watchTable<PaymentPlan>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'payment_plans',
      idField: 'payment_plan_id',
      createRealmObject: (data) {
        return PaymentPlan(
          ObjectId(),
          id: data['payment_plan_id'] is int
              ? data['payment_plan_id']
              : int.tryParse(data['payment_plan_id']) ?? randomNumber(),
          businessId: data['business_id'] is int
              ? data['business_id']
              : int.tryParse(data['business_id']) ?? 0,
          selectedPlan: data['selected_plan'],
          additionalDevices: data['additional_devices'] is int
              ? data['additional_devices']
              : int.tryParse(data['additional_devices']) ?? 0,
          isYearlyPlan: data['is_yearly_plan'] ?? false,
          totalPrice: data['total_price'] is double
              ? data['total_price']
              : double.tryParse(data['total_price']) ?? 0.0,
          createdAt: data['created_at'] is DateTime
              ? data['created_at']
              : DateTime.tryParse(data['created_at']),
          paymentCompletedByUser: data['payment_completed_by_user'] ?? false,
          payStackCustomerId: data['paystack_customer_id'] is int
              ? data['paystack_customer_id']
              : int.tryParse(data['paystack_customer_id']) ?? 0,
          rule: data['rule'],
          paymentMethod: data['payment_method'],
          customerCode: data['customer_code'],
          payStackPlanId: data['paystack_plan_id'],
        );
      },
      updateRealmObject: (_stock, data) {
        PaymentPlan? paymentPlan = localRealm.query<PaymentPlan>(
            r'id == $0', [data['payment_plan_id']]).firstOrNull;

        if (paymentPlan != null) {
          localRealm.write(() {
            paymentPlan.businessId = data['business_id'] is int
                ? data['business_id']
                : int.tryParse(data['business_id']) ?? paymentPlan.businessId;
            paymentPlan.selectedPlan =
                data['selected_plan'] ?? paymentPlan.selectedPlan;
            paymentPlan.additionalDevices = data['additional_devices'] is int
                ? data['additional_devices']
                : int.tryParse(data['additional_devices']) ??
                    paymentPlan.additionalDevices;
            paymentPlan.isYearlyPlan =
                data['is_yearly_plan'] ?? paymentPlan.isYearlyPlan;
            paymentPlan.totalPrice = data['total_price'] is double
                ? data['total_price']
                : double.tryParse(data['total_price']) ??
                    paymentPlan.totalPrice;
            paymentPlan.createdAt = data['created_at'] is DateTime
                ? data['created_at']
                : DateTime.tryParse(data['created_at']) ??
                    paymentPlan.createdAt;
            paymentPlan.paymentCompletedByUser =
                data['payment_completed_by_user'] ??
                    paymentPlan.paymentCompletedByUser;
            paymentPlan.payStackCustomerId = data['paystack_customer_id'] is int
                ? data['paystack_customer_id']
                : int.tryParse(data['paystack_customer_id']) ??
                    paymentPlan.payStackCustomerId;
            paymentPlan.rule = data['rule'] ?? paymentPlan.rule;
            paymentPlan.paymentMethod =
                data['payment_method'] ?? paymentPlan.paymentMethod;
            paymentPlan.customerCode =
                data['customer_code'] ?? paymentPlan.customerCode;
            paymentPlan.payStackPlanId =
                data['paystack_plan_id'] ?? paymentPlan.payStackPlanId;
          });
        }
      },
    );
    CloudSync(firestore, localRealm).watchTable<Access>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'accesses',
      idField: 'access_id',
      createRealmObject: (data) {
        return Access(
          ObjectId(),
          id: data['access_id'] is int
              ? data['access_id']
              : int.tryParse(data['access_id']) ?? randomNumber(),
          branchId: data['branch_id'] is int
              ? data['branch_id']
              : int.tryParse(data['branch_id']) ?? 0,
          businessId: data['business_id'] is int
              ? data['business_id']
              : int.tryParse(data['business_id']) ?? 0,
          userId: data['user_id'] is int
              ? data['user_id']
              : int.tryParse(data['user_id']) ?? 0,
          featureName: data['feature_name'],
          userType: data['user_type'],
          accessLevel: data['access_level'],
          createdAt:
              data['expires_at'] == null ? DateTime.now() : data['expires_at'],
          expiresAt: data['expires_at'] == null
              ? DateTime.now()
              : DateTime.parse(data['expires_at']),
          status: data['status'],
        );
      },
      updateRealmObject: (_stock, data) {
        Access? access = localRealm
            .query<Access>(r'id == $0', [data['access_id']]).firstOrNull;

        if (access != null) {
          localRealm.write(() {
            access.branchId = data['branch_id'] is int
                ? data['branch_id']
                : int.tryParse(data['branch_id']) ?? access.branchId;
            access.businessId = data['business_id'] is int
                ? data['business_id']
                : int.tryParse(data['business_id']) ?? access.businessId;
            access.userId = data['user_id'] == null
                ? ProxyService.box.getUserId()
                : data['user_id'];
            access.featureName = data['feature_name'] ?? access.featureName;
            access.userType = data['user_type'] ?? access.userType;
            access.accessLevel = data['access_level'] ?? access.accessLevel;
            access.createdAt = data['created_at'] == null
                ? DateTime.now()
                : DateTime.parse(data['created_at']);
            access.expiresAt = data['expires_at'] == null
                ? DateTime.now()
                : DateTime.parse(data['expires_at']);
            access.status = data['status'] ?? access.status;
          });
        }
      },
    );
    CloudSync(firestore, localRealm).watchTable<SKU>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'skus',
      idField: 'sku_id',
      createRealmObject: (data) {
        return SKU(
          ObjectId(),
          id: data['sku_id'] is int
              ? data['sku_id']
              : int.tryParse(data['sku_id']) ?? randomNumber(),
          sku: data['sku'] is int
              ? data['sku']
              : int.tryParse(data['sku']) ?? 100,
          branchId: data['branch_id'] is int
              ? data['branch_id']
              : int.tryParse(data['branch_id']) ?? 0,
          businessId: data['business_id'] is int
              ? data['business_id']
              : int.tryParse(data['business_id']) ?? 0,
          consumed: data['consumed'] ?? false,
        );
      },
      updateRealmObject: (_stock, data) {
        SKU? sku =
            localRealm.query<SKU>(r'id == $0', [data['sku_id']]).firstOrNull;

        if (sku != null) {
          localRealm.write(() {
            sku.sku = data['sku'] is int
                ? data['sku']
                : int.tryParse(data['sku']) ?? sku.sku;
            sku.branchId = data['branch_id'] is int
                ? data['branch_id']
                : int.tryParse(data['branch_id']) ?? sku.branchId;
            sku.businessId = data['business_id'] is int
                ? data['business_id']
                : int.tryParse(data['business_id']) ?? sku.businessId;
            sku.consumed = data['consumed'] ?? sku.consumed;
          });
        }
      },
    );

    CloudSync(firestore, localRealm).watchTable<Composite>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'composites',
      idField: 'composite_id',
      createRealmObject: (data) {
        return Composite(
          ObjectId(),
          id: data['composite_id'] is int
              ? data['composite_id']
              : int.tryParse(data['composite_id']) ?? randomNumber(),
          productId: data['product_id'] is int
              ? data['product_id']
              : int.tryParse(data['product_id']) ?? 0,
          variantId: data['variant_id'] is int
              ? data['variant_id']
              : int.tryParse(data['variant_id']) ?? 0,
          qty: data['qty'] is double
              ? data['qty']
              : double.tryParse(data['qty']) ?? 0.0,
          branchId: data['branch_id'] is int
              ? data['branch_id']
              : int.tryParse(data['branch_id']) ?? 0,
          businessId: data['business_id'] is int
              ? data['business_id']
              : int.tryParse(data['business_id']) ?? 0,
          actualPrice: data['actual_price'] is double
              ? data['actual_price']
              : double.tryParse(data['actual_price']) ?? 0.0,
        );
      },
      updateRealmObject: (_stock, data) {
        // Find related Composite
        Composite? composite = localRealm
            .query<Composite>(r'id == $0', [data['composite_id']]).firstOrNull;

        if (composite != null) {
          localRealm.write(() {
            composite.productId = data['product_id'] is int
                ? data['product_id']
                : int.tryParse(data['product_id']) ?? composite.productId;
            composite.variantId = data['variant_id'] is int
                ? data['variant_id']
                : int.tryParse(data['variant_id']) ?? composite.variantId;
            composite.qty = data['qty'] is double
                ? data['qty']
                : double.tryParse(data['qty']) ?? composite.qty;
            composite.branchId = data['branch_id'] is int
                ? data['branch_id']
                : int.tryParse(data['branch_id']) ?? composite.branchId;
            composite.businessId = data['business_id'] is int
                ? data['business_id']
                : int.tryParse(data['business_id']) ?? composite.businessId;
            composite.actualPrice = data['actual_price'] is double
                ? data['actual_price']
                : double.tryParse(data['actual_price']) ??
                    composite.actualPrice;
          });
        }
      },
    );

    CloudSync(firestore, localRealm).watchTable<Counter>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'counters',
      idField: 'counter_id',
      createRealmObject: (data) {
        return Counter(
          ObjectId(),
          id: data['counter_id'] is int
              ? data['counter_id']
              : int.tryParse(data['counter_id']) ?? randomNumber(),
          businessId: data['business_id'] is int
              ? data['business_id']
              : int.tryParse(data['business_id']) ?? 0,
          branchId: data['branch_id'] is int
              ? data['branch_id']
              : int.tryParse(data['branch_id']) ?? 0,
          receiptType: data['receipt_type'] ?? '',
          totRcptNo: data['tot_rcpt_no'] is int
              ? data['tot_rcpt_no']
              : int.tryParse(data['tot_rcpt_no']) ?? 0,
          curRcptNo: data['cur_rcpt_no'] is int
              ? data['cur_rcpt_no']
              : int.tryParse(data['cur_rcpt_no']) ?? 0,
          invcNo: data['invc_no'] is int
              ? data['invc_no']
              : int.tryParse(data['invc_no']) ?? 0,
          lastTouched: data['last_touched'] == null
              ? DateTime.now()
              : DateTime.parse(data['last_touched']),
        );
      },
      updateRealmObject: (_stock, data) {
        Counter? counter = localRealm
            .query<Counter>(r'id == $0', [data['counter_id']]).firstOrNull;

        if (counter != null) {
          localRealm.write(() {
            try {
              counter.businessId = data['business_id'] is int
                  ? data['business_id']
                  : int.tryParse(data['business_id']) ?? counter.businessId;

              counter.branchId = data['branch_id'] is int
                  ? data['branch_id']
                  : int.tryParse(data['branch_id']) ?? counter.branchId;

              counter.receiptType = data['receipt_type'] ?? counter.receiptType;

              counter.totRcptNo = data['tot_rcpt_no'] is int
                  ? data['tot_rcpt_no']
                  : int.tryParse(data['tot_rcpt_no']) ?? counter.totRcptNo;

              counter.curRcptNo = data['cur_rcpt_no'] is int
                  ? data['cur_rcpt_no']
                  : int.tryParse(data['cur_rcpt_no']) ?? counter.curRcptNo;

              counter.invcNo = data['invc_no'] is int
                  ? data['invc_no']
                  : int.tryParse(data['invc_no']) ?? counter.invcNo;

              counter.lastTouched = data['last_touched'] is DateTime
                  ? data['last_touched']
                  : DateTime.tryParse(data['last_touched'].toString()) ??
                      counter.lastTouched;
            } catch (e, s) {
              talker.error(e);
              talker.error(s);
            }
          });
        }
      },
    );
    CloudSync(firestore, localRealm).watchTable<Stock>(
      syncProvider: SyncProvider.FIRESTORE,
      tableName: 'stocks',
      idField: 'stock_id',
      createRealmObject: (data) {
        return Stock(
          ObjectId(),
          id: data['stock_id'] is int
              ? data['stock_id']
              : int.tryParse(data['stock_id']) ?? randomNumber(),
          currentStock:
              data['current_stock'] is int || data['current_stock'] is double
                  ? data['current_stock'].toDouble()
                  : double.tryParse(data['current_stock']) ?? 0.0,
          sold: data['sold'] is int || data['sold'] is double
              ? data['sold'].toDouble()
              : double.tryParse(data['sold']) ?? 0.0,
          lowStock: data['low_stock'] is int || data['low_stock'] is double
              ? data['low_stock'].toDouble()
              : double.tryParse(data['low_stock']) ?? 0.0,
          canTrackingStock: data['can_tracking_stock'] ?? false,
          showLowStockAlert: data['show_low_stock_alert'] ?? false,
          productId: data['product_id'] is int
              ? data['product_id']
              : int.tryParse(data['product_id']) ?? 0,
          active: data['active'] ?? false,
          value: data['value'] == null ? 0 : data['value'],
          rsdQty: data['rsd_qty'] is int || data['rsd_qty'] is double
              ? data['rsd_qty'].toDouble()
              : double.tryParse(data['rsd_qty']) ?? 0.0,
          supplyPrice:
              data['supply_price'] is int || data['supply_price'] is double
                  ? data['supply_price'].toDouble()
                  : double.tryParse(data['supplyPrice']) ?? 0.0,
          retailPrice: data['retail_price'] is int ||
                  data['retail_price'] is double && data['retail_price'] != null
              ? data['retail_price'].toDouble()
              : double.tryParse(data['retail_price']) ?? 0.0,
          lastTouched: data['last_touched'] is DateTime
              ? data['last_touched']
              : DateTime.tryParse(data['last_touched']) ?? DateTime.now(),
          branchId: data['branch_id'] is int
              ? data['branch_id']
              : int.tryParse(data['branch_id']) ?? 0,
          variantId: data['variant_id'] is int
              ? data['variant_id']
              : int.tryParse(data['variant_id']) ?? 0,
          action: data['action'],
          deletedAt: data['deleted_at'] is DateTime ? data['deleted_at'] : null,
          ebmSynced: data['ebm_synced'] ?? false,
        );
      },
      updateRealmObject: (_stock, data) {
        final Stock? stock = localRealm.query<Stock>(
            r'variantId ==$0 && branchId == $1',
            [data['variant_id'], data['branch_id']]).firstOrNull;
        final Variant? variant = localRealm
            .query<Variant>(r'id == $0', [data['variant_id']]).firstOrNull;
        if (variant != null && stock != null) {
          localRealm.write(() {
            final finalStock = data['current_stock'] is int ||
                    data['current_stock'] is double
                ? data['current_stock'].toDouble()
                : double.tryParse(data['current_stock']) ?? stock.currentStock;
            stock.currentStock = finalStock;
            stock.rsdQty = finalStock;
            stock.lastTouched = data['last_touched'] is DateTime
                ? data['last_touched']
                : DateTime.tryParse(data['last_touched'].toString()) ??
                    stock.lastTouched;

            variant.qty = finalStock;
            variant.rsdQty = finalStock;
            variant.ebmSynced = false;
          });
        }
      },
    );
  }
}
