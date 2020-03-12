import 'dart:async';

import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/product.dart';
import 'package:flutter/services.dart';
import 'package:fluttercouch/fluttercouch.dart';
import 'package:redux/redux.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';

import 'model/user.dart';

class CouchBase extends Model with Fluttercouch {
  String databaseName;
  Document docExample;
  MutableDocument _doc = MutableDocument();
  Query query;
  final bool shouldInitDb;

  CouchBase({this.shouldInitDb}) {
    if (shouldInitDb) {
      initPlatformState();
    }
  }

  //create a branch
  Future<dynamic> createBranch(Map map) async {
    assert(map['_id'] != null);
    assert(map['name'] != null);
    assert(map['channel'] != null);
    assert(map['active'] != null);
    assert(map['businessId'] != null);
    assert(map['mapLatitude'] != null);
    assert(map['mapLongitude'] != null);
    assert(map['id'] != null);
    assert(map['updatedAt'] != null);
    assert(map['createdAt'] != null);
    assert(map['_id'] != null);

    Document doc = await getDocumentWithId(map['_id']);

    List m = [map];

    doc
        .toMutable()
        .setList('branches', m)
        .setString('uid', Uuid().v1())
        .setString('channel', map['channel'])
        .setString('_id', map['_id']);
    return await saveDocumentWithId(map['_id'], doc);
  }

  Future<dynamic> createTax(Map map) async {
    assert(map['_id'] != null);
    Document doc = await getDocumentWithId(map['_id']);

    assert(map['channel'] != null);
    assert(map['name'] != null);
    assert(map['active'] != null);
    assert(map['isDefault'] != null);
    assert(map['id'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);
    assert(map['businessId'] != null);

    List m = [map];
    doc
        .toMutable()
        .setList('taxes', m)
        .setString('uid', Uuid().v1())
        .setString('channel', map['channel'])
        .setString('_id', map['_id']);
    ;

    return await saveDocumentWithId(map['_id'], doc);
  }

  //create business.
  Future<dynamic> createBusiness(Map map) async {
    assert(map['_id'] != null);
    Document doc = await getDocumentWithId(map['_id']);

    assert(map['channel'] != null);
    assert(map['name'] != null);
    assert(map['active'] != null);
    assert(map['categoryId'] != null);
    assert(map['typeId'] != null);
    assert(map['businessUrl'] != null);
    assert(map['country'] != null);
    assert(map['currency'] != null);
    assert(map['id'] != null);
    assert(map['timeZone'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);
    assert(map['userId'] != null);

    List m = [map];
    doc
        .toMutable()
        .setList('businesses', m)
        .setString('channel', map['channel'])
        .setString('uid', Uuid().v1())
        .setString('_id', map['_id']);
    ;

    return await saveDocumentWithId(map['_id'], doc);
  }

  //create user
  Future<dynamic> createUser(Map map) async {
    assert(map['_id'] != null);

    assert(map['name'] != null);
    assert(map['channel'] != null);
    assert(map['token'] != null);
    assert(map['id'] != null);
    assert(map['active'] != null);
    assert(map['email'] != null);
    assert(map['channel'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);

    Document doc = await getDocumentWithId(map['_id']);

    if (doc.toMutable().getString('email') != null) {
      MutableDocument mutableDocument = doc.toMutable();
      mutableDocument
          .setString('id', doc.getString('id'))
          .setString('uid', Uuid().v1())
          .setString('_id', map['_id']);

      map.forEach((key, value) {
        if (value is int) {
          mutableDocument.setInt(key, value);
        }
        if (value is String) {
          mutableDocument.setString(key, value);
        }
        if (value is bool) {
          mutableDocument.setBoolean(key, value);
        }
        if (value is double) {
          mutableDocument.setDouble(key, value);
        }
      });
      return await saveDocumentWithId(map['_id'], mutableDocument);
    } else {
      _doc.setString('uid', Uuid().v1()).setString('_id', map['_id']);
      map.forEach((key, value) {
        if (value is int) {
          _doc.setInt(key, value);
        }
        if (value is String) {
          _doc.setString(key, value);
        }
        if (value is bool) {
          _doc.setBoolean(key, value);
        }
        if (value is double) {
          _doc.setDouble(key, value);
        }
      });
      return await saveDocumentWithId(map['_id'], _doc);
    }
  }

  //sampleCode
  // CouchBase(shouldInitDb: false).getDocument(docId:'richie')
  Future<dynamic> getDocumentByDocId(
      {String docId, Store<AppState> store, T}) async {
    Document doc = await getDocumentWithId(docId);

    switch (T.toString()) {
      case 'User':
        {
          return buildUserModel(doc, store);
        }
        break;

      case 'Business':
        {
          return buildBusinessModel(doc, store);
        }
      case 'Branch':
        {
          return buildBranchModel(doc, store);
        }
      case 'Item':
        {
          return buildProduct(doc, store);
        }
        break;

      default:
        return null;
        break;
    }
  }

  //validation methods (business name will be docId)
  Future<bool> docExist(String docId) async {
    var doc = await getDocumentWithId(docId);
    if (doc == null) {
      return false;
    }
    return true;
  }

  //return stream of branches
  static getBranches(int userId) {}

  initPlatformState() async {
    try {
      await initDatabaseWithName("lagrace");
      //todo: enable this sync replication when user has paid.
      setReplicatorEndpoint(
          "ws://enexus.rw:4984/lagrace"); //todo: move this to credential file to avoid security breach
      setReplicatorType("PUSH_AND_PULL");
      setReplicatorBasicAuthentication(<String, String>{
        "username":
            "Administrator", //todo: move this to credential file to avoid security breach
        "password":
            "password" //todo: move this to credential file to avoid security breach
      });

      //this is the way of getting notified about db change. adding a live query
      //https://docs.couchbase.com/couchbase-lite/2.5/java.html#live-query

      // Query query = QueryBuilder.select([SelectResult.all()]).from("lagrace");
      // ListenerToken token =
      //     await query.addChangeListener((change) => {print(change)});

      setReplicatorContinuous(true);
      initReplicator();
      startReplicator();
    } on PlatformException {}
  }

  Future initSqlDb(Store<AppState> store) async {
    //load products
    Document doc =
        await getDocumentWithId('products_' + store.state.userId.toString());
    if (doc.getList('products') == null) return; //no need to go further!
    for (var i = 0; i < doc.getList('products').length; i++) {
      ProductTableData product = await store.state.database.productDao
          .getItemById(productId: doc.getList('products')[i]['id']);
      // ignore:missing_required_param
      ProductTableData productData = ProductTableData(
          businessId: doc.getList('products')[i]['businessId'].toString(),
          active: doc.getList('products')[i]['active'],
          name: doc.getList('products')[i]['name'],
          id: doc.getList('products')[i]['id'],
          color: doc.getList('products')[i]['color'],
          description: doc.getList('products')[i]['description'],
          picture: doc.getList('products')[i]['picture'],
          taxId: doc.getList('products')[i]['taxId'],
          hasPicture: doc.getList('products')[i]['hasPicture'],
          isDraft: doc.getList('products')[i]['isDraft'],
          isCurrentUpdate: doc.getList('products')[i]['isCurrentUpdate'],
          supplierId: doc.getList('products')[i]['supplierId'],
          categoryId: doc.getList('products')[i]['categoryId'],
          createdAt: DateTime.parse(doc.getList('products')[i]['createdAt']),
          updatedAt: DateTime.parse(doc.getList('products')[i]['updatedAt']));

      if (product == null) {
        store.state.database.productDao.insert(productData);
      } else {
        store.state.database.productDao
            .updateProduct(productData.copyWith(idLocal: product.idLocal));
      }
    }

    //load variants:
    Document variants =
        await getDocumentWithId('variants_' + store.state.userId.toString());

    if (variants.getList('variants') == null) return; //no need to go further!

    for (var i = 0; i < variants.getList('variants').length; i++) {
      VariationTableData variation = await store.state.database.variationDao
          .getVariationById(variantId: variants.getList('variants')[i]['id']);
      // ignore:missing_required_param
      VariationTableData variationData = VariationTableData(
          name: variants.getList('variants')[i]['name'],
          id: variants.getList('variants')[i]['id'],
          sku: variants.getList('variants')[i]['SKU'],
          productId: variants.getList('variants')[i]['productId'],
          unit: variants.getList('variants')[i]['unit'],
          createdAt:
              DateTime.parse(variants.getList('variants')[i]['createdAt']),
          updatedAt:
              DateTime.parse(variants.getList('variants')[i]['updatedAt']));

      if (variation == null) {
        store.state.database.variationDao.insert(variationData);
      } else {
        store.state.database.variationDao.updateVariation(
            variationData.copyWith(idLocal: variation.idLocal));
      }
    }

    //load branch products
    Document branchProducts = await getDocumentWithId(
        'branchProducts_' + store.state.userId.toString());

    if (branchProducts.getList('branchProducts') == null)
      return; //no need to go further!

    for (var i = 0; i < branchProducts.getList('branchProducts').length; i++) {
      BranchProductTableData branchProduct = await store
          .state.database.branchProductDao
          .getById(id: branchProducts.getList('branchProducts')[i]['id']);
      // ignore:missing_required_param
      BranchProductTableData branchProductData = BranchProductTableData(
        id: branchProducts.getList('branchProducts')[i]['id'],
        branchId: branchProducts.getList('branchProducts')[i]['branchId'],
        productId: branchProducts.getList('branchProducts')[i]['productId'],
      );

      if (branchProduct == null) {
        store.state.database.branchProductDao.insert(branchProductData);
      } else {
        store.state.database.branchProductDao.updateBP(
            branchProductData.copyWith(idLocal: branchProduct.idLocal));
      }
    }

    //load all stocks:
    Document stocks =
        await getDocumentWithId('stocks_' + store.state.userId.toString());
    if (stocks.getList('stocks') == null) return; //no need to go further!

    for (var i = 0; i < stocks.getList('stocks').length; i++) {
      StockTableData stock = await store.state.database.stockDao
          .getById(id: stocks.getList('stocks')[i]['id']);
      // ignore:missing_required_param
      StockTableData branchProductData = StockTableData(
          id: stocks.getList('stocks')[i]['id'],
          supplyPrice: stocks.getList('stocks')[i]['supplyPrice'].toDouble(),
          retailPrice: stocks.getList('stocks')[i]['retailPrice'].toDouble(),
          lowStock: stocks.getList('stocks')[i]['lowStock'],
          variantId: stocks.getList('stocks')[i]['variantId'],
          branchId: stocks.getList('stocks')[i]['branchId'],
          productId: stocks.getList('stocks')[i]['productId'],
          currentStock: stocks.getList('stocks')[i]['currentStock'],
          canTrackingStock: stocks.getList('stocks')[i]['canTrackingStock'],
          showLowStockAlert: stocks.getList('stocks')[i]['showLowStockAlert'],
          createdAt: DateTime.parse(stocks.getList('stocks')[i]['createdAt']),
          updatedAt: DateTime.parse(stocks.getList('stocks')[i]['updatedAt']));

      if (stock == null) {
        store.state.database.stockDao.insert(branchProductData);
      } else {
        store.state.database.stockDao.updateStock(branchProductData.copyWith(
            idLocal: stock.idLocal, isActive: false));
      }
    }

    //load stock history
    Document stockHistories = await getDocumentWithId(
        'stockHistory_' + store.state.userId.toString());
    if (stockHistories.getList('stockHistory') == null)
      return; //no need to go further!
    for (var i = 0; i < stockHistories.getList('stockHistory').length; i++) {
      StockHistoryTableData history = await store.state.database.stockHistoryDao
          .getById(id: stockHistories.getList('stockHistory')[i]['id']);
      // ignore:missing_required_param
      StockHistoryTableData historyData = StockHistoryTableData(
          id: stockHistories.getList('stockHistory')[i]['id'],
          note: stockHistories.getList('stockHistory')[i]['note'],
          quantity: stockHistories.getList('stockHistory')[i]['quantity'],
          stockId: stockHistories.getList('stockHistory')[i]['stockId'],
          reason: stockHistories.getList('stockHistory')[i]['reason'],
          variantId: stockHistories.getList('stockHistory')[i]['variantId'],
          createdAt: DateTime.parse(
              stockHistories.getList('stockHistory')[i]['createdAt']),
          updatedAt: DateTime.parse(
              stockHistories.getList('stockHistory')[i]['updatedAt']));

      if (history == null) {
        store.state.database.stockHistoryDao.insert(historyData);
      } else {
        store.state.database.stockHistoryDao
            .updateHistory(historyData.copyWith(idLocal: history.idLocal));
      }
    }

    //load taxes:

    Document taxes =
        await getDocumentWithId('taxes_' + store.state.userId.toString());

    if (taxes.getList('taxes') == null) return; //no need to go further!

    for (var i = 0; i < taxes.getList('taxes').length; i++) {
      TaxTableData tax = await store.state.database.taxDao
          .getById(taxid: taxes.getList('taxes')[i]['id']);
      // ignore:missing_required_param
      TaxTableData taxData = TaxTableData(
          id: taxes.getList('taxes')[i]['id'],
          name: taxes.getList('taxes')[i]['name'],
          businessId: taxes.getList('taxes')[i]['businessId'],
          isDefault: taxes.getList('taxes')[i]['isDefault'],
          percentage: taxes.getList('taxes')[i]['percentage'].toDouble(),
          createdAt: DateTime.parse(taxes.getList('taxes')[i]['createdAt']),
          updatedAt: DateTime.parse(taxes.getList('taxes')[i]['updatedAt']));

      print(taxes.getList('taxes'));
      if (tax == null) {
        store.state.database.taxDao.insert(taxData);
      } else {
        store.state.database.taxDao
            .updateTax(taxData.copyWith(idLocal: tax.idLocal));
      }
    }

    //load categories:
    Document categories =
        await getDocumentWithId('categories_' + store.state.userId.toString());

    if (categories.getList('categories') == null)
      return; //no need to go further!

    for (var i = 0; i < categories.getList('categories').length; i++) {
      CategoryTableData category = await store.state.database.categoryDao
          .getById(id: categories.getList('categories')[i]['id']);
      // ignore:missing_required_param
      CategoryTableData categoryData = CategoryTableData(
          id: categories.getList('categories')[i]['id'],
          name: categories.getList('categories')[i]['name'],
          focused: false,
          branchId: categories.getList('categories')[i]['branchId'],
          createdAt:
              DateTime.parse(categories.getList('categories')[i]['createdAt']),
          updatedAt:
              DateTime.parse(categories.getList('categories')[i]['updatedAt']));

      if (category == null) {
        store.state.database.categoryDao.insert(categoryData);
      } else {
        store.state.database.categoryDao
            .updateCategory(categoryData.copyWith(idLocal: category.idLocal));
      }
    }

    //load all app units:
    var units = [
      {"name": "Per Item", "value": ""},
      {"name": "Per Kilogram (kg)", "value": "kg"},
      {"name": "Per Cup (c)", "value": "c"},
      {"name": "Per Liter (l)", "value": "l"},
      {"name": "Per Pound (lb)", "value": "lb"},
      {"name": "Per Pint (pt)", "value": "pt"},
      {"name": "Per Acre (ac)", "value": "ac"},
      {"name": "Per Centimeter (cm)", "value": "cm"},
      {"name": "Per Cubic Footer (cu ft)", "value": "cu ft"},
      {"name": "Per Day (day)", "value": "day"},
      {"name": "Footer (ft)", "value": "ft"},
      {"name": "Per Gram (g)", "value": "g"},
      {"name": "Per Hour (hr)", "value": "hr"},
      {"name": "Per Minute (min)", "value": "min"},
      {"name": "Per Acre (ac)", "value": "ac"},
      {"name": "Per Cubic Inch (cu in)", "value": "cu in"},
      {"name": "Per Cubic Yard (cu yd)", "value": "cu yd"},
      {"name": "Per Fluid Ounce (fl oz)", "value": "fl oz"},
      {"name": "Per Gallon (gal)", "value": "gal"},
      {"name": "Per Inch (in)", "value": "in"},
      {"name": "Per Kilometer (km)", "value": "km"},
      {"name": "Per Meter (m)", "value": "m"},
      {"name": "Per Mile (mi)", "value": "mi"},
      {"name": "Per Milligram (mg)", "value": "mg"},
      {"name": "Per Milliliter (mL)", "value": "mL"},
      {"name": "Per Millimeter (mm)", "value": "mm"},
      {"name": "Per Millisecond (ms)", "value": "ms"},
      {"name": "Per Ounce (oz)", "value": "oz"},
      {"name": "Per  Quart (qt)", "value": "qt"},
      {"name": "Per Second (sec)", "value": "sec"},
      {"name": "Per Shot (sh)", "value": "sh"},
      {"name": "Per Square Centimeter (sq cm)", "value": "sq cm"},
      {"name": "Per Square Foot (sq ft)", "value": "sq ft"},
      {"name": "Per Square Inch (sq in)", "value": "sq in"},
      {"name": "Per Square Kilometer (sq km)", "value": "sq km"},
      {"name": "Per Square Meter (sq m)", "value": "sq m"},
      {"name": "Per Square Mile (sq mi)", "value": "sq mi"},
      {"name": "Per Square Yard (sq yd)", "value": "sq yd"},
      {"name": "Per Stone (st)", "value": "st"},
      {"name": "Per Yard (yd)", "value": "yd"}
    ];
    for (var i = 0; i < units.length; i++) {
      //insert or update unit in table set focus to false for all.
      UnitTableData unit = await store.state.database.unitDao
          .getUnitByName(name: units[i]['name']);

      UnitTableData unitTableData =
          //ignore:missing_required_param
          UnitTableData(
              name: units[i]['name'], focused: false, value: units[i]['value']);
      if (unit == null) {
        store.state.database.unitDao.insert(unitTableData);
      } else {
        store.state.database.unitDao
            .updateUnit(unitTableData.copyWith(id: unit.id));
      }
    }
    //merging: get product of this branchId
  }

  //return
  Stream<dynamic> getDocumentByQuery(Store<AppState> store) async* {
    Query query = QueryBuilder.select([SelectResult.all()])
        .from(store.state.couchDbClient.name)
        .where(Expression.property("_id")
            .equalTo(Expression.string('businesses')));

    ResultSet results = await query.execute();
    query.addChangeListener((change) => {
          // if(change.results != null)
          //   {
          print(change.results)
          //resultsCallback(change.results);
          // }
        });

    yield results.allResults();
  }

  Future<dynamic> queryEmail(Store<AppState> store, String email) async {
    Query query = QueryBuilder.select([SelectResult.all()])
        .from(store.state.couchDbClient.name)
        .where(Expression.property("_id").equalTo(Expression.string('users')));
    // ResultSet results = await query.execute();
  }

  User buildUserModel(Document doc, Store<AppState> store) {
    return User(
      (u) => u
        ..id = doc.getString('id')
        ..email = doc.getString('email')
        ..name = doc.getString('name')
        ..createdAt = doc.getString('createdAt')
        ..updatedAt = doc.getString('createdAt')
        ..active = doc.getBoolean('active')
        ..token = doc.getString('token'),
    );
  }

  List<Business> buildBusinessModel(Document doc, Store<AppState> store) {
    List<Business> business = [];
    var business_ = 'businesses';
    if (doc.getList(business_) == null) return business;

    for (var i = 0; i < doc.getList(business_).length; i++) {
      business.add(Business((b) => b
        ..name = doc.getList(business_)[i]['name']
        ..id = doc.getList(business_)[i]['id']
        ..currency = doc.getList(business_)[i]['currency']
        ..categoryId = doc.getList(business_)[i]['categoryId'].toString()
        ..country = doc.getList(business_)[i]['country']
        ..userId = doc.getList(business_)[i]['userId'].toString()
        ..active = doc.getList(business_)[i]['active']
        ..typeId = doc.getList(business_)[i]['typeId'].toString()
        ..userId = doc.getList(business_)[i]['userId'].toString()
        ..timeZone = doc.getList(business_)[i]['timeZone']
        ..businessUrl = doc.getList(business_)[i]['businessUrl']
        ..createdAt = doc.getList(business_)[i]['country']));
    }
    return business;
  }

  List<Product> buildProduct(Document doc, Store<AppState> store) {}

  List<Branch> buildBranchModel(Document doc, Store<AppState> store) {
    List<Branch> branch = [];
    var branch_ = 'branches';

    if (doc.getList(branch_) == null) return branch;
    for (var i = 0; i < doc.getList('branches').length; i++) {
      branch.add(Branch((b) => b
        ..name = doc.getList(branch_)[i]['name']
        ..id = doc.getList(branch_)[i]['id']
        ..active = doc.getList(branch_)[i]['active']
        ..businessId = doc
            .getList(branch_)[i]['businessId']
            .toString() //todo: remove toString() when desktop set it as string
        ..createdAt = doc.getList(branch_)[i]['createdAt']
        ..mapLatitude = doc
            .getList(branch_)[i]['mapLatitude']
            .toString() //todo:remove casting
        ..mapLongitude = doc.getList(branch_)[i]['mapLongitude'].toString()
        ..mapLongitude = doc.getList(branch_)[i]['mapLongitude'].toString()
        ..updatedAt = doc.getList(branch_)[i]['updatedAt']));
    }
    return branch;
  }

  syncProduct(String productId) async {
    //get product sync it to couch db
    //get product variants sync them too
    //get stock of each variant and sync them each to couch
  }
}
