// ignore: unused_import
import 'dart:async';
import 'dart:io';
import 'package:flipper_models/Subcriptions.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helper_models.dart' as extensions;
import 'package:flipper_models/realm_model_export.dart';
import 'package:path/path.dart' as p;
import 'package:flipper_models/realmInterface.dart';
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import 'package:talker_flutter/talker_flutter.dart';

// This issue describe how I can mark something for completion later
// https://github.com/realm/realm-dart/issues/1203

class RealmAPI<M extends IJsonSerializable>
    with Subscriptions
    implements SyncReaml<M>, DataMigratorToLocal {
  @override
  Realm? oldRealm;
  final talker = TalkerFlutter.init();

  late String commApi;

  /// when opening db we carefully fail gracefuly when especially on startup we use in memory db
  /// then when user login the real db is used
  /// it is very important to avoid issue where we are saving in memory thinking that we using synced db hence why we call init on startupview model
  /// to re-configure the db now for this time not using the in-memory db.
  ///
  /// @override
  Future<void> forceSubs(
      {int? businessId, Realm? localRealm, int? branchId, int? userId}) async {}

  @override
  List<String> activeRealmSubscriptions() {
    final existingSubscriptions = <String>[];
    // for (Subscription sub in oldRealm!.subscriptions) {
    //   existingSubscriptions.add(sub.name!);
    // }
    return existingSubscriptions;
  }

  @override
  DataMigratorToLocal instance() {
    return this;
  }

  /// because both non-synced and synced should be in one dir
  /// I avoided assigning businessId or branchId to the directory
  /// because it assumed that realm will upload data if they exist and they are not synced
  @override
  Future<String> dbPath({required String path, int? folder}) async {
    const isTest =
        const bool.fromEnvironment('FLUTTER_TEST_ENV', defaultValue: false);
    if (!isTest) {
      try {
        Directory appSupportDirectory;

        // Determine the appropriate directory based on the platform
        if (Platform.isWindows) {
          appSupportDirectory = await getApplicationSupportDirectory();
        } else {
          appSupportDirectory = await getApplicationDocumentsDirectory();
        }

        // Construct the specific directory path
        /// the 1 appended is incremented everytime there is a breaking change on a client.
        final realmDirectory =
            p.join(appSupportDirectory.path, '${folder ?? ""}4');

        // Create the directory if it doesn't exist
        final directory = Directory(realmDirectory);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Construct the full path to the database file
        final String fileName = '$path.realm';
        return p.join(realmDirectory, fileName);
      } catch (e) {
        // Handle any exceptions that might occur
        print('Error creating db path: $e');
        rethrow;
      }
    } else {
      return "";
    }
  }

  @override
  Future<DataMigratorToLocal> configure(
      {required bool useInMemoryDb,
      bool useFallBack = false,
      String? encryptionKey,
      int? businessId,
      Realm? localRealm,
      int? branchId,
      int? userId}) async {
    const isTest =
        const bool.fromEnvironment('FLUTTER_TEST_ENV', defaultValue: false);

    const usetestDB =
        const bool.fromEnvironment('TEST_DB', defaultValue: false);

    talker.warning("Using test db: $usetestDB");

    // foundation.kDebugMode ? AppSecrets.appIdDebug :
    // foundation.kDebugMode
    // ? AppSecrets.mongoApiSecretDebug
    // :
    try {
      // final app = App(AppConfiguration(AppSecrets.appId,
      //     baseUrl: Uri.parse("https://services.cloud.mongodb.com")));

      /// When this login does not execute or take too long user will not be able
      /// to proceed and use the app,!
      /// https://github.com/realm/realm-dart/issues/1205 support using firebase credentials
      /// this will help in avoiding sharing api key!
      /// https://github.com/realm/realm-dart/issues/1205#issuecomment-1465778841
      // User user = app.currentUser ??
      //     await app.logIn(Credentials.apiKey(AppSecrets.mongoApiSecret));
      if (useInMemoryDb ||
          encryptionKey == null ||
          encryptionKey.isEmpty ||
          isTest) {
        talker.warning("Using in Memory db");
        oldRealm?.close();
        _configureInMemory();
        return this;
      } else {
        if (businessId == null) {
          talker.error("There is no business found");
          // throw Exception("here is no business found");
          oldRealm?.close();
          _configureInMemory();
          return this;
        }
        oldRealm?.close();
        String path = await dbPath(path: 'synced', folder: businessId);
        // await _configurePersistent(
        //     user: user,
        //     path: path,
        //     businessId: businessId,
        //     branchId: branchId!,
        //     userId: userId!,
        //     app: app,
        //     encryptions: encryptionKey.toIntList(),
        //     localRealm: localRealm);
        return this;
      }
    } catch (e, s) {
      /// after a lof of thinking a fallback should use in memory because
      /// we can not think of Ream(config) will be totally different from Realm.open()
      /// hence I can not provide different encryption key on either
      talker.error(s);
      rethrow;
    }
  }

  void _configureInMemory() {
    Configuration config = Configuration.inMemory(realmModels);
    oldRealm = Realm(config);
    talker.info("Opened in-memory realm.");
  }

  // Future<void> _configurePersistent(
  //     {required User user,
  //     required String path,
  //     required int businessId,
  //     required int branchId,
  //     required int userId,
  //     required List<int> encryptions,
  //     Realm? localRealm,
  //     required App app}) async {
  //   CancellationToken token = CancellationToken();
  //   Future<void>.delayed(
  //       const Duration(seconds: 30),
  //       () => token.cancel(CancelledException(
  //           cancellationReason: "Realm took too long to open")));
  //   talker.warning("opening persistent");
  //   // Sentry.captureMessage("opening persistent");
  //   // Configuration? config =
  //   //     await _createPersistentConfig(user, path, encryptions: encryptions);
  //   // if (config == null) {
  //   //   throw Exception();
  //   // }
  //   // if (oldRealm == null) {
  //   //   oldRealm = await _openRealm(config: config, user: user, app: app);
  //   // } else {
  //   //   oldRealm!.close();
  //   //   oldRealm = await _openRealm(config: config, user: user, app: app);
  //   // }
  //   updateSubscription(
  //     localRealm: localRealm,
  //     userId: userId,
  //     realm: oldRealm,
  //     branchId: branchId,
  //     businessId: businessId,
  //   );
  // }

  // void handleCompensatingWrite(CompensatingWriteError compensatingWriteError) {
  //   final writeReason = compensatingWriteError.compensatingWrites!.first;
  //   print("Error message: " + writeReason.reason);

  //   // ... handle compensating write error as needed.
  // }

  ///https://www.mongodb.com/docs/atlas/device-sdks/sdk/flutter/sync/handle-sync-errors/import 'dart:io';
  // Future<Configuration?> _createPersistentConfig(User user, String path,
  //     {required List<int> encryptions}) async {
  //   try {
  //     return Configuration.flexibleSync(
  //       user,
  //       realmModels,
  //       encryptionKey: encryptions,
  //       path: path,
  //       shouldCompactCallback: (totalSize, usedSize) {
  //         const tenMB = 10 * 1048576;
  //         return (totalSize > tenMB) &&
  //             (usedSize.toDouble() / totalSize.toDouble()) < 0.5;
  //       },
  //       syncErrorHandler: (syncError) {
  //         if (syncError is CompensatingWriteError) {
  //           handleCompensatingWrite(syncError);
  //         }
  //       },
  //       clientResetHandler: ManualRecoveryHandler((clientResetError) async {
  //         // 4. Iterate and Update (Handle Conflicts)
  //         try {
  //           ProxyService.cron.isolateKill();
  //           final path = oldRealm!.config.path;
  //           // You must close a realm before deleting it
  //           if (oldRealm != null) {
  //             oldRealm!.syncSession.pause();
  //             oldRealm!.close();
  //           }

  //           // Delete the realm
  //           Realm.deleteRealm(path);
  //           // 1. Open the Backup Realm
  //           final backupRealm = await Realm.open(
  //             Configuration.flexibleSync(
  //               user,
  //               realmModels,
  //               path: clientResetError.backupFilePath,
  //               encryptionKey: ProxyService.box.encryptionKey().toIntList(),
  //             ),
  //           );

  //           // 2. Open the Original Realm
  //           final originalRealm = await Realm.open(
  //             Configuration.flexibleSync(
  //               user,
  //               realmModels,
  //               path: clientResetError.originalFilePath,
  //               encryptionKey: ProxyService.box.encryptionKey().toIntList(),
  //             ),
  //           );

  //           // 3. Retrieve Backup Objects
  //           final backupObjects = backupRealm.all(); // Get all objects
  //           for (final backupObject in backupObjects) {
  //             await originalRealm.write(() async {
  //               // Resolve Conflicts:
  //               originalRealm.add(backupObject, update: true);
  //             });
  //           }
  //           // 5. Ensure Realms are Closed
  //           backupRealm.close();
  //           originalRealm.close();

  //           // 6. Resume Synchronization
  //           originalRealm.syncSession.resume();
  //           await originalRealm.subscriptions.waitForSynchronization();

  //           /// re-configure the realm with same information required to re-init realm
  //           configure(
  //               useInMemoryDb: false,
  //               branchId: ProxyService.box.getBranchId(),
  //               businessId: ProxyService.box.getBusinessId(),
  //               encryptionKey: ProxyService.box.encryptionKey(),
  //               userId: ProxyService.box.getUserId(),
  //               localRealm: ProxyService.local.realm);
  //         } catch (e) {
  //           talker.error('Error during manual recovery: $e');
  //         } finally {
  //           print('Realms closed after recovery process.');
  //         }
  //       }),
  //     );
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<Realm> _openRealm({
  //   required Configuration config,
  //   required User user,
  //   required App app,
  // }) async {
  //   try {
  //     CancellationToken token = CancellationToken();
  //     Future<void>.delayed(
  //       const Duration(seconds: 30),
  //       () => token.cancel(CancelledException(
  //         cancellationReason: "Realm took too long to open",
  //       )),
  //     );

  //     // Attempt to open the Realm
  //     return Realm(config);
  //   } on RealmException catch (e) {
  //     talker.warning("ErorCode: ${e.hashCode}");
  //     rethrow;
  //   } on CancelledException catch (_) {
  //     talker.warning('Realm opening timed out. Retrying...');
  //     rethrow;
  //   } catch (e, s) {
  //     talker.error('Error opening Realm: $e');
  //     talker.error(s);
  //     rethrow;
  //   }
  // }

  @override
  void close() {
    if (oldRealm == null) return null;
    oldRealm!.close();
    oldRealm = null;
  }

  @override
  T? findObject<T extends RealmObject>(String query, List<dynamic> arguments) {
    if (oldRealm == null) return null;
    final results = oldRealm!.query<T>(query, arguments);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  @override
  void copyRemoteDataToLocalDb() {
    if (ProxyService.box.doneMigrateToLocal()) {
      /// we no longer need sync so pause it for now for future removal.
    }
    if (!ProxyService.box.doneMigrateToLocal()) {
      try {
        // Copy Product objects first in a separate transaction
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Product>().toList());
        });

        // Copy Variant objects in a new transaction
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Variant>().toList());
        });

        List<Variant> variants = ProxyService.local.realm!.query<Variant>(
            r'branchId == $0', [ProxyService.box.getBranchId()]).toList();
        for (Variant variant in variants) {
          ProxyService.local.saveStock(variant: variant);
        }
        // Copy Stock and Composite objects together in one transaction
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Composite>().toList());
        });

        // Copy StockRequest and TransactionItem objects in one transaction
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<StockRequest>().toList());
          copyObjects(oldRealm!.all<TransactionItem>().toList());
        });

        // Continue this pattern for the remaining object types
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Tenant>().toList());
          copyObjects(oldRealm!.all<EBM>().toList());
        });

        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Configurations>().toList());
          copyObjects(oldRealm!.all<Category>().toList());
        });

        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<PColor>().toList());
          copyObjects(oldRealm!.all<Counter>().toList());
        });

        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Customer>().toList());
        });

        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Device>().toList());
        });

        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Drawers>().toList());
        });

        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Favorite>().toList());
        });

        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Receipt>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Setting>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<ITransaction>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<IUnit>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Voucher>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Pin>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<LPermission>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Token>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Activity>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Assets>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<SKU>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Report>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Computed>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<Access>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<PaymentPlan>().toList());
        });
        ProxyService.local.realm!.write(() {
          copyObjects(oldRealm!.all<FlipperSaleCompaign>().toList());
        });

        ProxyService.box.writeBool(key: 'doneMigrateToLocal', value: true);
      } catch (e, s) {
        // Handle errors and log them
        talker.warning(e);
        talker.error(s);
      }
    }
  }

// Helper function to copy the objects
  void copyObjects<T extends RealmObject>(List<T> sourceObjects) {
    for (var obj in sourceObjects) {
      var detachedObject = detachObject(obj);
      ProxyService.local.realm!.add<T>(detachedObject, update: true);
    }
  }

  T detachObject<T extends RealmObject>(T obj) {
    // Convert a managed Realm object into a plain, unmanaged object.
    // You'll need to manually copy all the fields here.
    if (obj is Product) {
      return Product(
        obj.realmId,
        id: obj.id,
        name: obj.name,
        description: obj.description,
        taxId: obj.taxId,
        color: obj.color,
        branchId: obj.branchId,
        supplierId: obj.supplierId,
        categoryId: obj.categoryId,
        createdAt: obj.createdAt,
        unit: obj.unit,
        imageUrl: obj.imageUrl,
        expiryDate: obj.expiryDate,
        barCode: obj.barCode,
        nfcEnabled: obj.nfcEnabled,
        bindedToTenantId: obj.bindedToTenantId,
        isComposite: obj.isComposite,
        isFavorite: obj.isFavorite,
        lastTouched: obj.lastTouched,
        deletedAt: obj.deletedAt,
        spplrNm: obj.spplrNm,
        composites: obj.composites
            .map((e) => Composite(
                  e.realmId,
                  productId: e.productId,
                  variantId: e.variantId,
                  qty: e.qty,
                  branchId: e.branchId,
                  businessId: e.businessId,
                  actualPrice: e.actualPrice,
                ))
            .toList(),
      ) as T;
    } else if (obj is Variant) {
      return Variant(
        obj.realmId, // ObjectId
        id: obj.id ?? randomNumber(),
        deletedAt: obj.deletedAt,
        name: obj.name,
        color: obj.color,
        sku: obj.sku,
        productId: obj.productId,
        unit: obj.unit,
        productName: obj.productName,
        branchId: obj.branchId,
        taxName: obj.taxName,
        taxPercentage: obj.taxPercentage,
        isTaxExempted: obj.isTaxExempted,
        itemSeq: obj.itemSeq,
        isrccCd: obj.isrccCd,
        isrccNm: obj.isrccNm,
        isrcRt: obj.isrcRt,
        isrcAmt: obj.isrcAmt,
        taxTyCd: obj.taxTyCd,
        bcd: obj.bcd,
        itemClsCd: obj.itemClsCd,
        itemTyCd: obj.itemTyCd,
        itemStdNm: obj.itemStdNm,
        orgnNatCd: obj.orgnNatCd,
        pkg: obj.pkg,
        itemCd: obj.itemCd,
        pkgUnitCd: obj.pkgUnitCd,
        qtyUnitCd: obj.qtyUnitCd,
        itemNm: obj.itemNm,
        qty: obj.qty,
        prc: obj.prc,
        splyAmt: obj.splyAmt,
        tin: obj.tin,
        bhfId: obj.bhfId,
        dftPrc: obj.dftPrc,
        addInfo: obj.addInfo,
        isrcAplcbYn: obj.isrcAplcbYn,
        useYn: obj.useYn,
        regrId: obj.regrId,
        regrNm: obj.regrNm,
        modrId: obj.modrId,
        modrNm: obj.modrNm,
        rsdQty: obj.rsdQty,
        lastTouched: obj.lastTouched,
        supplyPrice: obj.supplyPrice,
        retailPrice: obj.retailPrice,
        action: obj.action,
        spplrItemClsCd: obj.spplrItemClsCd,
        spplrItemCd: obj.spplrItemCd,
        spplrItemNm: obj.spplrItemNm,
        ebmSynced: obj.ebmSynced,
        taxType: obj.taxType,
        branchIds: obj.branchIds.map((e) => e).toList(),
      ) as T;
    } else if (obj is Stock) {
      return Stock(
        obj.realmId, // ObjectId
        id: obj.id,
        tin: obj.tin,
        bhfId: obj.bhfId,
        branchId: obj.branchId,
        variantId: obj.variantId,
        currentStock: obj.currentStock,
        sold: obj.sold,
        lowStock: obj.lowStock,
        canTrackingStock: obj.canTrackingStock,
        showLowStockAlert: obj.showLowStockAlert,
        productId: obj.productId,
        active: obj.active,
        value: obj.value,
        rsdQty: obj.rsdQty,
        supplyPrice: obj.supplyPrice,
        retailPrice: obj.retailPrice,
        lastTouched: obj.lastTouched,
        action: obj.action,
        deletedAt: obj.deletedAt,
        ebmSynced: obj.ebmSynced,

        /// add relationship later.
        variant: obj.variant != null
            ? Variant(
                obj.variant!.realmId,
                name: obj.variant!.name,
                color: obj.variant!.color,
                sku: obj.variant!.sku,
                productId: obj.variant!.productId,
                unit: obj.variant!.unit,
                productName: obj.variant!.productName,
                branchId: obj.variant!.branchId,
                taxName: obj.variant!.taxName,
                taxPercentage: obj.variant!.taxPercentage,
                deletedAt: obj.deletedAt,
                isTaxExempted: obj.variant!.isTaxExempted,
                itemSeq: obj.variant!.itemSeq,
                isrccCd: obj.variant!.isrccCd,
                isrccNm: obj.variant!.isrccNm,
                isrcRt: obj.variant!.isrcRt,
                isrcAmt: obj.variant!.isrcAmt,
                taxTyCd: obj.variant!.taxTyCd,
                bcd: obj.variant!.bcd,
                itemClsCd: obj.variant!.itemClsCd,
                itemTyCd: obj.variant!.itemTyCd,
                itemStdNm: obj.variant!.itemStdNm,
                orgnNatCd: obj.variant!.orgnNatCd,
                pkg: obj.variant!.pkg,
                itemCd: obj.variant!.itemCd,
                pkgUnitCd: obj.variant!.pkgUnitCd,
                qtyUnitCd: obj.variant!.qtyUnitCd,
                itemNm: obj.variant!.itemNm,
                qty: obj.variant!.qty,
                prc: obj.variant!.prc,
                splyAmt: obj.variant!.splyAmt,
                tin: obj.tin,
                bhfId: obj.bhfId,
                dftPrc: obj.variant!.dftPrc,
                addInfo: obj.variant!.addInfo,
                isrcAplcbYn: obj.variant!.isrcAplcbYn,
                useYn: obj.variant!.useYn,
                regrId: obj.variant!.regrId,
                regrNm: obj.variant!.regrNm,
                modrId: obj.variant!.modrId,
                modrNm: obj.variant!.modrNm,
                rsdQty: obj.rsdQty,
                lastTouched: obj.lastTouched,
                supplyPrice: obj.supplyPrice,
                retailPrice: obj.retailPrice,
                action: obj.action,
                spplrItemClsCd: obj.variant!.spplrItemClsCd,
                spplrItemCd: obj.variant!.spplrItemCd,
                spplrItemNm: obj.variant!.spplrItemNm,
                ebmSynced: obj.ebmSynced,
                taxType: obj.variant!.taxType,
                branchIds: obj.variant!.branchIds.map((e) => e).toList(),
              )
            : null,
      ) as T;
    } else if (obj is Category) {
      return Category(
        obj.realmId,
        id: obj.id,
        active: obj.active,
        focused: obj.focused,
        name: obj.name,
        branchId: obj.branchId,
        deletedAt: obj.deletedAt,
        lastTouched: obj.lastTouched,
        action: obj.action,
      ) as T;
    } else if (obj is PColor) {
      return PColor(
        obj.realmId, // ObjectId
        id: obj.id,
        name: obj.name,
        colors: obj.colors,
        branchId: obj.branchId,
        active: obj.active,
        lastTouched: obj.lastTouched,
        action: obj.action,
        deletedAt: obj.deletedAt,
      ) as T;
    } else if (obj is Counter) {
      return Counter(
        obj.realmId, // ObjectId
        id: obj.id,
        businessId: obj.businessId,
        branchId: obj.branchId,
        receiptType: obj.receiptType,
        totRcptNo: obj.totRcptNo,
        curRcptNo: obj.curRcptNo,
        invcNo: obj.invcNo,
        lastTouched: obj.lastTouched,
        action: obj.action,
      ) as T;
    } else if (obj is Customer) {
      return Customer(
        obj.realmId, // ObjectId
        id: obj.id,
        custNm: obj.custNm,
        email: obj.email,
        telNo: obj.telNo,
        adrs: obj.adrs,
        branchId: obj.branchId,
        updatedAt: obj.updatedAt,
        custNo: obj.custNo,
        custTin: obj.custTin,
        regrNm: obj.regrNm,
        regrId: obj.regrId,
        modrNm: obj.modrNm,
        modrId: obj.modrId,
        ebmSynced: obj.ebmSynced,
        lastTouched: obj.lastTouched,
        action: obj.action,
        deletedAt: obj.deletedAt,
        tin: obj.tin,
        bhfId: obj.bhfId,
        useYn: obj.useYn,
        customerType: obj.customerType,
      ) as T;
    } else if (obj is Device) {
      return Device(
        obj.realmId, // ObjectId
        id: obj.id,
        linkingCode: obj.linkingCode,
        deviceName: obj.deviceName,
        deviceVersion: obj.deviceVersion,
        pubNubPublished: obj.pubNubPublished,
        phone: obj.phone,
        branchId: obj.branchId,
        businessId: obj.businessId,
        userId: obj.userId,
        defaultApp: obj.defaultApp,
        lastTouched: obj.lastTouched,
        deletedAt: obj.deletedAt,
        action: obj.action,
      ) as T;
    } else if (obj is Drawers) {
      return Drawers(
        obj.realmId, // ObjectId
        id: obj.id,
        openingBalance: obj.openingBalance,
        closingBalance: obj.closingBalance,
        openingDateTime: obj.openingDateTime,
        closingDateTime: obj.closingDateTime,
        csSaleCount: obj.csSaleCount,
        tradeName: obj.tradeName,
        totalNsSaleIncome: obj.totalNsSaleIncome,
        totalCsSaleIncome: obj.totalCsSaleIncome,
        nrSaleCount: obj.nrSaleCount,
        nsSaleCount: obj.nsSaleCount,
        trSaleCount: obj.trSaleCount,
        psSaleCount: obj.psSaleCount,
        incompleteSale: obj.incompleteSale,
        otherTransactions: obj.otherTransactions,
        paymentMode: obj.paymentMode,
        cashierId: obj.cashierId,
        open: obj.open,
        deletedAt: obj.deletedAt,
        businessId: obj.businessId,
        branchId: obj.branchId,
      ) as T;
    } else if (obj is EBM) {
      return EBM(
        id: obj.id,
        obj.realmId,
        obj.bhfId,
        obj.tinNumber,
        obj.dvcSrlNo,
        obj.userId,
        taxServerUrl: obj.taxServerUrl!,
        obj.businessId,
        obj.branchId,
        lastTouched: obj.lastTouched,
        obj.action,
      ) as T;
    } else if (obj is Favorite) {
      return Favorite(
        obj.realmId, // ObjectId
        id: obj.id,
        favIndex: obj.favIndex,
        productId: obj.productId,
        branchId: obj.branchId,
        lastTouched: obj.lastTouched,
        action: obj.action,
        deletedAt: obj.deletedAt,
      ) as T;
    } else if (obj is Receipt) {
      return Receipt(
        obj.realmId, // ObjectId
        id: obj.id,
        resultCd: obj.resultCd,
        resultMsg: obj.resultMsg,
        resultDt: obj.resultDt,
        rcptNo: obj.rcptNo,
        intrlData: obj.intrlData,
        rcptSign: obj.rcptSign,
        totRcptNo: obj.totRcptNo,
        vsdcRcptPbctDate: obj.vsdcRcptPbctDate,
        sdcId: obj.sdcId,
        mrcNo: obj.mrcNo,
        qrCode: obj.qrCode,
        receiptType: obj.receiptType,
        branchId: obj.branchId,
        transactionId: obj.transactionId,
        lastTouched: obj.lastTouched,
        action: obj.action,
        invcNo: obj.invcNo,
      ) as T;
    } else if (obj is Composite) {
      return Composite(
        obj.realmId,
        id: obj.id,
        productId: obj.productId,
        variantId: obj.variantId,
        qty: obj.qty,
        branchId: obj.branchId,
        businessId: obj.businessId,
        actualPrice: obj.actualPrice,
      ) as T;
    } else if (obj is Setting) {
      return Setting(
        obj.realmId,
        id: obj.id,
        email: obj.email,
        userId: obj.userId,
        openReceiptFileOSaleComplete: obj.openReceiptFileOSaleComplete,
        autoPrint: obj.autoPrint,
        sendDailyReport: obj.sendDailyReport,
        defaultLanguage: obj.defaultLanguage,
        attendnaceDocCreated: obj.attendnaceDocCreated,
        isAttendanceEnabled: obj.isAttendanceEnabled,
        type: obj.type,
        enrolledInBot: obj.enrolledInBot,
        deviceToken: obj.deviceToken,
        businessPhoneNumber: obj.businessPhoneNumber,
        autoRespond: obj.autoRespond,
        token: obj.token,
        hasPin: obj.hasPin,
        businessId: obj.businessId,
        createdAt: obj.createdAt,
        lastTouched: obj.lastTouched,
        deletedAt: obj.deletedAt,
        action: obj.action,
      ) as T;
    } else if (obj is StockRequest) {
      return StockRequest(
        obj.realmId,
        id: obj.id,
        mainBranchId: obj.mainBranchId,
        subBranchId: obj.subBranchId,
        createdAt: obj.createdAt,
        status: obj.status,
        deliveryDate: obj.deliveryDate,
        deliveryNote: obj.deliveryNote,
        orderNote: obj.orderNote,
        customerReceivedOrder: obj.customerReceivedOrder,
        driverRequestDeliveryConfirmation:
            obj.driverRequestDeliveryConfirmation,
        driverId: obj.driverId,
        items: obj.items
            .map((e) => TransactionItem(
                  e.realmId,
                  id: e.id,
                  name: e.name,
                  quantityRequested: e.quantityRequested,
                  quantityApproved: e.quantityApproved,
                  quantityShipped: e.quantityShipped,
                  transactionId: e.transactionId,
                  variantId: e.variantId,
                  qty: e.qty,
                  price: e.price,
                  discount: e.discount,
                  type: e.type,
                  remainingStock: e.remainingStock,
                  createdAt: e.createdAt,
                  updatedAt: e.updatedAt,
                  isTaxExempted: e.isTaxExempted,
                  isRefunded: e.isRefunded,
                  doneWithTransaction: e.doneWithTransaction,
                  active: e.active,
                  dcRt: e.dcRt,
                  dcAmt: e.dcAmt,
                  taxblAmt: e.taxblAmt,
                  taxAmt: e.taxAmt,
                  totAmt: e.totAmt,
                  itemSeq: e.itemSeq,
                  isrccCd: e.isrccCd,
                  isrccNm: e.isrccNm,
                  isrcRt: e.isrcRt,
                  isrcAmt: e.isrcAmt,
                  taxTyCd: e.taxTyCd,
                  bcd: e.bcd,
                  itemClsCd: e.itemClsCd,
                  itemTyCd: e.itemTyCd,
                  itemStdNm: e.itemStdNm,
                  orgnNatCd: e.orgnNatCd,
                  pkg: e.pkg,
                  itemCd: e.itemCd,
                  pkgUnitCd: e.pkgUnitCd,
                  qtyUnitCd: e.qtyUnitCd,
                  itemNm: e.itemNm,
                  prc: e.prc,
                  splyAmt: e.splyAmt,
                  tin: e.tin,
                  bhfId: e.bhfId,
                  dftPrc: e.dftPrc,
                  addInfo: e.addInfo,
                  isrcAplcbYn: e.isrcAplcbYn,
                  useYn: e.useYn,
                  regrId: e.regrId,
                  regrNm: e.regrNm,
                  modrId: e.modrId,
                  modrNm: e.modrNm,
                  lastTouched: e.lastTouched,
                  deletedAt: e.deletedAt,
                  action: e.action,
                  branchId: e.branchId,
                  ebmSynced: e.ebmSynced,
                  partOfComposite: e.partOfComposite,
                  compositePrice: e.compositePrice,
                ))
            .toList(),
        updatedAt: obj.updatedAt,
      ) as T;
    } else if (obj is TransactionItem) {
      return TransactionItem(
        obj.realmId,
        id: obj.id,
        name: obj.name,
        quantityRequested: obj.quantityRequested,
        quantityApproved: obj.quantityApproved,
        quantityShipped: obj.quantityShipped,
        transactionId: obj.transactionId,
        variantId: obj.variantId,
        qty: obj.qty,
        price: obj.price,
        discount: obj.discount,
        type: obj.type,
        remainingStock: obj.remainingStock,
        createdAt: obj.createdAt,
        updatedAt: obj.updatedAt,
        isTaxExempted: obj.isTaxExempted,
        isRefunded: obj.isRefunded,
        doneWithTransaction: obj.doneWithTransaction,
        active: obj.active,
        dcRt: obj.dcRt,
        dcAmt: obj.dcAmt,
        taxblAmt: obj.taxblAmt,
        taxAmt: obj.taxAmt,
        totAmt: obj.totAmt,
        itemSeq: obj.itemSeq,
        isrccCd: obj.isrccCd,
        isrccNm: obj.isrccNm,
        isrcRt: obj.isrcRt,
        isrcAmt: obj.isrcAmt,
        taxTyCd: obj.taxTyCd,
        bcd: obj.bcd,
        itemClsCd: obj.itemClsCd,
        itemTyCd: obj.itemTyCd,
        itemStdNm: obj.itemStdNm,
        orgnNatCd: obj.orgnNatCd,
        pkg: obj.pkg,
        itemCd: obj.itemCd,
        pkgUnitCd: obj.pkgUnitCd,
        qtyUnitCd: obj.qtyUnitCd,
        itemNm: obj.itemNm,
        prc: obj.prc,
        splyAmt: obj.splyAmt,
        tin: obj.tin,
        bhfId: obj.bhfId,
        dftPrc: obj.dftPrc,
        addInfo: obj.addInfo,
        isrcAplcbYn: obj.isrcAplcbYn,
        useYn: obj.useYn,
        regrId: obj.regrId,
        regrNm: obj.regrNm,
        modrId: obj.modrId,
        modrNm: obj.modrNm,
        lastTouched: obj.lastTouched,
        deletedAt: obj.deletedAt,
        action: obj.action,
        branchId: obj.branchId,
        ebmSynced: obj.ebmSynced,
        partOfComposite: obj.partOfComposite,
        compositePrice: obj.compositePrice,
      ) as T;
    } else if (obj is ITransaction) {
      return ITransaction(
        obj.realmId,
        id: obj.id,
        reference: obj.reference,
        categoryId: obj.categoryId,
        transactionNumber: obj.transactionNumber,
        branchId: obj.branchId,
        status: obj.status,
        transactionType: obj.transactionType,
        subTotal: obj.subTotal,
        paymentType: obj.paymentType,
        cashReceived: obj.cashReceived,
        customerChangeDue: obj.customerChangeDue,
        createdAt: obj.createdAt,
        receiptType: obj.receiptType,
        updatedAt: obj.updatedAt,
        customerId: obj.customerId,
        customerType: obj.customerType,
        note: obj.note,
        lastTouched: obj.lastTouched,
        action: obj.action,
        ticketName: obj.ticketName,
        deletedAt: obj.deletedAt,
        supplierId: obj.supplierId,
        ebmSynced: obj.ebmSynced,
        isIncome: obj.isIncome,
        isExpense: obj.isExpense,
        isRefunded: obj.isRefunded,
      ) as T;
    } else if (obj is IUnit) {
      return IUnit(
        obj.realmId,
        id: obj.id,
        branchId: obj.branchId,
        name: obj.name,
        value: obj.value,
        active: obj.active,
        lastTouched: obj.lastTouched,
        action: obj.action,
        createdAt: obj.createdAt,
        deletedAt: obj.deletedAt,
      ) as T;
    } else if (obj is Voucher) {
      return Voucher(
        obj.realmId,
        id: obj.id,
        value: obj.value,
        interval: obj.interval,
        used: obj.used,
        createdAt: obj.createdAt,
        usedAt: obj.usedAt,
        descriptor: obj.descriptor,
      ) as T;
    } else if (obj is Tenant) {
      return Tenant(
        obj.realmId,
        id: obj.id,
        name: obj.name,
        phoneNumber: obj.phoneNumber,
        email: obj.email,
        nfcEnabled: obj.nfcEnabled,
        businessId: obj.businessId,
        userId: obj.userId,
        imageUrl: obj.imageUrl,
        lastTouched: obj.lastTouched,
        deletedAt: obj.deletedAt,
        pin: obj.pin,
        sessionActive: obj.sessionActive,
        isDefault: obj.isDefault,
        isLongPressed: obj.isLongPressed,
        type: obj.type,
      ) as T;
    } else if (obj is Pin) {
      return Pin(
        obj.realmId,
        id: obj.id,
        userId: obj.userId,
        phoneNumber: obj.phoneNumber,
        pin: obj.pin,
        branchId: obj.branchId,
        businessId: obj.businessId,
      ) as T;
    } else if (obj is LPermission) {
      return LPermission(
        obj.realmId,
        id: obj.id,
        name: obj.name,
        userId: obj.userId,
      ) as T;
    } else if (obj is Token) {
      return Token(
        obj.realmId,
        id: obj.id,
        type: obj.type,
        token: obj.token,
        validFrom: obj.validFrom,
        validUntil: obj.validUntil,
        businessId: obj.businessId,
        lastTouched: obj.lastTouched,
        deletedAt: obj.deletedAt,
      ) as T;
    } else if (obj is Activity) {
      return Activity(
        obj.realmId,
        obj.action,
        id: obj.id,
        timestamp: obj.timestamp,
        lastTouched: obj.lastTouched,
        userId: obj.userId,
        event: obj.event,
        details: obj.details,
      ) as T;
    } else if (obj is UnversalProduct) {
      return UnversalProduct(
        obj.realmId,
        id: obj.id,
        itemClsCd: obj.itemClsCd,
        itemClsNm: obj.itemClsNm,
        itemClsLvl: obj.itemClsLvl,
        taxTyCd: obj.taxTyCd,
        mjrTgYn: obj.mjrTgYn,
        useYn: obj.useYn,
        businessId: obj.businessId,
        branchId: obj.branchId,
      ) as T;
    } else if (obj is Configurations) {
      return Configurations(
        obj.realmId,
        id: obj.id,
        taxType: obj.taxType,
        taxPercentage: obj.taxPercentage,
        businessId: obj.businessId,
        branchId: obj.branchId,
      ) as T;
    } else if (obj is AppNotification) {
      return AppNotification(
        obj.realmId,
        id: obj.id,
        completed: obj.completed,
        type: obj.type,
        message: obj.message,
        identifier: obj.identifier,
      ) as T;
    } else if (obj is Assets) {
      return Assets(
        obj.realmId,
        id: obj.id,
        branchId: obj.branchId,
        businessId: obj.businessId,
        assetName: obj.assetName,
        productId: obj.productId,
      ) as T;
    } else if (obj is SKU) {
      return SKU(
        obj.realmId,
        id: obj.id,
        sku: obj.sku,
        branchId: obj.branchId,
        businessId: obj.businessId,
        consumed: obj.consumed,
      ) as T;
    } else if (obj is Report) {
      return Report(
        obj.realmId,
        id: obj.id,
        branchId: obj.branchId,
        businessId: obj.businessId,
        filename: obj.filename,
        s3Url: obj.s3Url,
        downloaded: obj.downloaded,
      ) as T;
    } else if (obj is Computed) {
      return Computed(
        obj.id,
        branchId: obj.branchId,
        businessId: obj.businessId,
        grossProfit: obj.grossProfit,
        netProfit: obj.netProfit,
        totalStockValue: obj.totalStockValue,
        totalStockSoldValue: obj.totalStockSoldValue,
        totalStockItems: obj.totalStockItems,
        createdAt: obj.createdAt,
      ) as T;
    } else if (obj is Access) {
      return Access(
        obj.realmId,
        id: obj.id,
        branchId: obj.branchId,
        businessId: obj.businessId,
        userId: obj.userId,
        featureName: obj.featureName,
        userType: obj.userType,
        accessLevel: obj.accessLevel,
        createdAt: obj.createdAt,
        expiresAt: obj.expiresAt,
        status: obj.status,
      ) as T;
    } else if (obj is PaymentPlan) {
      return PaymentPlan(
        obj.realmId,
        id: obj.id,
        businessId: obj.businessId,
        selectedPlan: obj.selectedPlan,
        additionalDevices: obj.additionalDevices,
        isYearlyPlan: obj.isYearlyPlan,
        totalPrice: obj.totalPrice,
        createdAt: obj.createdAt,
        paymentCompletedByUser: obj.paymentCompletedByUser,
        payStackCustomerId: obj.payStackCustomerId,
        rule: obj.rule,
        paymentMethod: obj.paymentMethod,
        customerCode: obj.customerCode,
        payStackPlanId: obj.payStackPlanId,
      ) as T;
    } else if (obj is FlipperSaleCompaign) {
      return FlipperSaleCompaign(
        obj.realmId,
        id: obj.id,
        compaignId: obj.compaignId,
        discountRate: obj.discountRate,
        createdAt: obj.createdAt,
        couponCode: obj.couponCode,
      ) as T;
    }

    throw UnsupportedError('Unsupported type: ${T.runtimeType}');
  }
}
