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

      setReplicatorContinuous(true);
      initReplicator();
      startReplicator();

      //this is the way of getting notified about db change. adding a live query
      //https://docs.couchbase.com/couchbase-lite/2.5/java.html#live-query

      //query.removeChangeListener(token);
      //https://blog.couchbase.com/document-conflicts-couchbase-mobile/
      //todo: to be tested alongside the desktop app,because when I edit data manually in dashboard it create conflict.
      //todo: experimenting with live Query.
      Query query = QueryBuilder.select([SelectResult.all()]).from("lagrace");

      query.execute();
      ListenerToken token =
          await query.addChangeListener((change) => {print(change)});

      Query b = QueryBuilder.select([SelectResult.all()]).from('lagrace').where(
          Expression.property("_id").equalTo(Expression.string('business_1')));

      ResultSet results = await b.execute();
      b.addChangeListener((change) => {print(change.results)});
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
//          channel: doc.getList('products')[i]['channel'] ?? '',
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
        await store.state.database.productDao.insert(productData);
      } else {
        await store.state.database.productDao
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
        await store.state.database.variationDao.insert(variationData);
      } else {
        await store.state.database.variationDao.updateVariation(
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
//        channel: branchProducts.getList('branchProducts')[i]['channel'] ?? '',
        branchId: branchProducts.getList('branchProducts')[i]['branchId'],
        productId: branchProducts.getList('branchProducts')[i]['productId'],
      );

      if (branchProduct == null) {
        await store.state.database.branchProductDao.insert(branchProductData);
      } else {
        await store.state.database.branchProductDao.updateBP(
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
//          channel: stocks.getList('stocks')[i]['channel'] ?? '',
          variantId: stocks.getList('stocks')[i]['variantId'],
          branchId: stocks.getList('stocks')[i]['branchId'],
          productId: stocks.getList('stocks')[i]['productId'],
          currentStock: stocks.getList('stocks')[i]['currentStock'],
          canTrackingStock: stocks.getList('stocks')[i]['canTrackingStock'],
          showLowStockAlert: stocks.getList('stocks')[i]['showLowStockAlert'],
          createdAt: DateTime.parse(stocks.getList('stocks')[i]['createdAt']),
          updatedAt: DateTime.parse(stocks.getList('stocks')[i]['updatedAt']));

      if (stock == null) {
        await store.state.database.stockDao.insert(branchProductData);
      } else {
        await store.state.database.stockDao.updateStock(branchProductData
            .copyWith(idLocal: stock.idLocal, isActive: false));
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
//          channel: stockHistories.getList('stockHistory')[i]['channel'] ?? '',
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
        await store.state.database.stockHistoryDao.insert(historyData);
      } else {
        await store.state.database.stockHistoryDao
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
//          channel: taxes.getList('taxes')[i]['channel'] ?? '',
          name: taxes.getList('taxes')[i]['name'],
          businessId: taxes.getList('taxes')[i]['businessId'],
          isDefault: taxes.getList('taxes')[i]['isDefault'],
          percentage: taxes.getList('taxes')[i]['percentage'].toDouble(),
          createdAt: DateTime.parse(taxes.getList('taxes')[i]['createdAt']),
          updatedAt: DateTime.parse(taxes.getList('taxes')[i]['updatedAt']));

      if (tax == null) {
        await store.state.database.taxDao.insert(taxData);
      } else {
        await store.state.database.taxDao
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
      CategoryTableData categoryData;
      if (i == 1) {
        // ignore:missing_required_param
        categoryData = CategoryTableData(
            id: categories.getList('categories')[i]['id'],
            name: categories.getList('categories')[i]['name'],
//            channel: categories.getList('categories')[i]['channel'] ?? '',
            focused: true,
            branchId: categories.getList('categories')[i]['branchId'],
            createdAt: DateTime.parse(
                categories.getList('categories')[i]['createdAt']),
            updatedAt: DateTime.parse(
                categories.getList('categories')[i]['updatedAt']));
      } else {
        // ignore:missing_required_param
        categoryData = CategoryTableData(
            id: categories.getList('categories')[i]['id'],
            name: categories.getList('categories')[i]['name'],
//            channel: categories.getList('categories')[i]['channel'] ?? '',
            focused: false,
            branchId: categories.getList('categories')[i]['branchId'],
            createdAt: DateTime.parse(
                categories.getList('categories')[i]['createdAt']),
            updatedAt: DateTime.parse(
                categories.getList('categories')[i]['updatedAt']));
      }

      if (category == null) {
        await store.state.database.categoryDao.insert(categoryData);
      } else {
        await store.state.database.categoryDao
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

      UnitTableData unitTableData;
      if (units[i]['value'] == 'kg') {
        unitTableData =
            //ignore:missing_required_param
            UnitTableData(
          name: units[i]['name'],
          focused: true,
          value: units[i]['value'],
        );
      } else {
        unitTableData =
            //ignore:missing_required_param
            UnitTableData(
                name: units[i]['name'],
                focused: false,
                value: units[i]['value']);
      }

      if (unit == null) {
        await store.state.database.unitDao.insert(unitTableData);
      } else {
        await store.state.database.unitDao
            .updateUnit(unitTableData.copyWith(id: unit.id));
      }
    }
    //merging: get product of this branchId
  }

  //return
  //FIXME: this worked but could not
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

  Future<dynamic> createProduct(Map map) async {
    assert(map['_id'] != null);
    Document products = await getDocumentWithId(map['_id']);

    assert(map['channel'] != null);
    assert(map['name'] != null);
    assert(map['active'] != null);
    assert(map['businessId'] != null);
    assert(map['hasPicture'] != null);
    assert(map['isDraft'] != null);
    assert(map['picture'] != null);
    assert(map['color'] != null);
    assert(map['taxId'] != null);
    assert(map['isCurrentUpdate'] != null);
    assert(map['id'] != null);
    assert(map['supplierId'] != null);
    assert(map['categoryId'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);

    List m = [map];
    List m2 = products.getList('products');
    m2.addAll(m); //merge two array
    products
        .toMutable()
        .setList('products', m2)
        .setString('channel', map['channel'])
        .setString('uid', Uuid().v1())
        .setString('_id', map['_id']);

    return await saveDocumentWithId(map['_id'], products);
  }

  Future<dynamic> createVariant(Map map) async {
    assert(map['_id'] != null);
    Document variants = await getDocumentWithId(map['_id']);

    assert(map['channel'] != null);
    assert(map['SKU'] != null);
    assert(map['name'] != null);
    assert(map['productId'] != null);
    assert(map['id'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);

    List m = [map];
    List m2 = variants.getList('variants');
    m.addAll(m2);

    variants
        .toMutable()
        .setList('variants', m)
        .setString('channel', map['channel'])
        .setString('uid', Uuid().v1())
        .setString('_id', map['_id']);

    return await saveDocumentWithId(map['_id'], variants);
  }

  Future<dynamic> createBranchProduct(Map map) async {
    assert(map['_id'] != null);
    Document branchProducts = await getDocumentWithId(map['_id']);

    assert(map['channel'] != null);
    assert(map['productId'] != null);
    assert(map['branchId'] != null);
    assert(map['id'] != null);

    List m = [map];
    List m2 = branchProducts.getList('branchProducts');
    m.addAll(m2);

    branchProducts
        .toMutable()
        .setList('branchProducts', m)
        .setString('channel', map['channel'])
        .setString('uid', Uuid().v1())
        .setString('_id', map['_id']);

    return await saveDocumentWithId(map['_id'], branchProducts);
  }

  Future<dynamic> createStockHistory(Map map) async {
    assert(map['_id'] != null);
    Document history = await getDocumentWithId(map['_id']);

    assert(map['channel'] != null);
    assert(map['variantId'] != null);
    assert(map['stockId'] != null);
    assert(map['quantity'] != null);
    assert(map['reason'] != null);
    assert(map['note'] != null);
    assert(map['updatedAt'] != null);
    assert(map['createdAt'] != null);
    assert(map['id'] != null);

    List m = [map];
    List m2 = history.getList('stockHistory');
    m.addAll(m2);

    history
        .toMutable()
        .setList('stockHistory', m)
        .setString('channel', map['channel'])
        .setString('uid', Uuid().v1())
        .setString('_id', map['_id']);

    return await saveDocumentWithId(map['_id'], history);
  }

  Future<dynamic> createStock(Map map) async {
    assert(map['_id'] != null);
    Document stocks = await getDocumentWithId(map['_id']);

    assert(map['channel'] != null);
    assert(map['productId'] != null);
    assert(map['retailPrice'] != null);
    assert(map['supplyPrice'] != null);
    assert(map['canTrackingStock'] != null);
    assert(map['lowStock'] != null);
    assert(map['variantId'] != null);
    assert(map['showLowStockAlert'] != null);
    assert(map['currentStock'] != null);
    assert(map['isActive'] != null);
    assert(map['branchId'] != null);
    assert(map['branchId'] != null);
    assert(map['id'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);

    List m = [map];
    List m2 = stocks.getList('stocks');
    m.addAll(m2);

    stocks
        .toMutable()
        .setList('stocks', m)
        .setString('channel', map['channel'])
        .setString('uid', Uuid().v1())
        .setString('_id', map['_id']);

    return await saveDocumentWithId(map['_id'], stocks);
  }

  Future<dynamic> syncLocalDbToRemote({Store<AppState> store}) async {
    //get all
    List<VariationTableData> variations =
        await store.state.database.variationDao.getVariations();

    Document variant =
        await getDocumentWithId('variants_' + store.state.userId.toString());

    List mapTypeListVariants = [];
    for (var i = 0; i < variations.length; i++) {
      Map map = {
        'name': variations[i].name,
        'id': variations[i].id,
        'sku': variations[i].sku,
        'unit': variations[i].unit,
        'productId': variations[i].productId,
        'createdAt': variations[i].createdAt.toIso8601String(),
        'updatedAt': variations[i].updatedAt == null
            ? DateTime.now().toIso8601String()
            : variations[i].updatedAt.toIso8601String(),
      };
      mapTypeListVariants.add(map);
    }

    variant
        .toMutable()
        .setList('variants', mapTypeListVariants)
        .setString('channel', store.state.userId.toString())
        .setString('uid', Uuid().v1())
        .setString('_id', 'variants_' + store.state.userId.toString());

    await saveDocumentWithId(
        'variants_' + store.state.userId.toString(), variant);
    //done sync variant

    List<ProductTableData> products =
        await store.state.database.productDao.getProducts();

    Document product =
        await getDocumentWithId('products_' + store.state.userId.toString());

    List mapTypeListProducts = [];
    for (var i = 0; i < products.length; i++) {
      Map map = {
        'name': products[i].name,
        'id': products[i].id,
        'color': products[i].color,
        'picture': products[i].picture,
        'active': products[i].active,
        'hasPicture': products[i].hasPicture,
        'id': products[i].id,
        'isDraft': products[i].isDraft,
        'isCurrentUpdate': products[i].isCurrentUpdate,
        'description': products[i].description,
        'businessId': products[i].businessId,
        'supplierId': products[i].supplierId,
        'categoryId': products[i].categoryId,
        'taxId': products[i].taxId,
        'createdAt': products[i].createdAt.toIso8601String(),
        'updatedAt': variations[i].updatedAt == null
            ? DateTime.now().toIso8601String()
            : variations[i].updatedAt.toIso8601String(),
      };
      mapTypeListProducts.add(map);
    }

    product
        .toMutable()
        .setList('products', mapTypeListProducts)
        .setString('channel', store.state.userId.toString())
        .setString('uid', Uuid().v1())
        .setString('_id', 'products_' + store.state.userId.toString());

    await saveDocumentWithId(
        'products_' + store.state.userId.toString(), product);

    //done sync products:

    List<StockTableData> stocks =
        await store.state.database.stockDao.getStocks();

    Document stock =
        await getDocumentWithId('stocks_' + store.state.userId.toString());

    List mapTypeListStocks = [];
    for (var i = 0; i < stocks.length; i++) {
      Map map = {
        'currentStock': stocks[i].currentStock,
        'id': stocks[i].id,
        'lowStock': stocks[i].lowStock,
        'canTrackingStock': stocks[i].canTrackingStock,
        'showLowStockAlert': stocks[i].showLowStockAlert,
        'isActive': stocks[i].isActive,
        'supplyPrice': stocks[i].supplyPrice,
        'retailPrice': stocks[i].retailPrice,
        'variantId': stocks[i].variantId,
        'branchId': stocks[i].branchId,
        'productId': stocks[i].productId,
        'createdAt': stocks[i].createdAt.toIso8601String(),
        'updatedAt': stocks[i].updatedAt == null
            ? DateTime.now().toIso8601String()
            : variations[i].updatedAt.toIso8601String(),
      };
      mapTypeListStocks.add(map);
    }

    stock
        .toMutable()
        .setList('stocks', mapTypeListStocks)
        .setString('channel', store.state.userId.toString())
        .setString('uid', Uuid().v1())
        .setString('_id', 'stocks_' + store.state.userId.toString());

    await saveDocumentWithId('stocks_' + store.state.userId.toString(), stock);
    //done sync stock:

    List<BranchProductTableData> branchProducts =
        await store.state.database.branchProductDao.branchProducts();

    Document bP = await getDocumentWithId(
        'branchProducts_' + store.state.userId.toString());

    List mapTypeListBranchProducts = [];
    for (var i = 0; i < branchProducts.length; i++) {
      Map map = {
        'branchId': branchProducts[i].branchId,
        'id': branchProducts[i].id,
        'productId': branchProducts[i].productId,
      };
      mapTypeListBranchProducts.add(map);
    }

    bP
        .toMutable()
        .setList('branchProducts', mapTypeListBranchProducts)
        .setString('channel', store.state.userId.toString())
        .setString('uid', Uuid().v1())
        .setString('_id', 'branchProducts_' + store.state.userId.toString());

    await saveDocumentWithId(
        'branchProducts_' + store.state.userId.toString(), stock);
    //done sync branchProduct:
  }

  Future syncProduct(String productId, Store<AppState> store) async {
    //get product sync it to couch db
    //get product variants sync them too
    //get stock of each variant and sync them each to couch
    ProductTableData product = await store.state.database.productDao
        .getProductById(productId: productId);

    Map _mapProduct = {
      'active': product.active,
      'name': product.name,
      'id': product.id,
      'supplierId': product.supplierId,
      'hasPicture': product.hasPicture,
      'picture': product.picture,
      'isDraft': product.isDraft,
      'taxId': product.taxId,
      'isCurrentUpdate': product.isCurrentUpdate,
      'color': product.color,
      '_id': 'products_' + store.state.userId.toString(),
      'categoryId':
          product.categoryId, //pet store a default id when signup on mobile
      'channel': store.state.userId.toString(),
      'businessId':
          product.businessId, //pet store a default id when signup on mobile
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
    await createProduct(_mapProduct);

    //sync variants
    List<VariationTableData> variations = await store
        .state.database.variationDao
        .getVariantByProductId(productId: productId);

    for (var i = 0; i < variations.length; i++) {
      Map _mapVariant = {
        'name': variations[i].name,
        'productId': variations[i].productId,
        'id': variations[i].id,
        'channel': store.state.userId.toString(),
        'unit': variations[i].unit,
        'createdAt': variations[i].createdAt.toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'SKU': variations[i].sku,
        '_id': 'variants_' + store.state.userId.toString(),
      };
      //sync stock:
      StockTableData stock = await store.state.database.stockDao
          .getStockByVariantId(
              variantId: variations[i].id, branchId: store.state.branch.id);

      //sync stock history:
      StockHistoryTableData history = await store.state.database.stockHistoryDao
          .getByVariantId(variantId: variations[i].id);
      if (history != null) {
        Map _history = {
          'variantId': history.variantId,
          'stockId': history.stockId,
          'quantity': history.quantity,
          'note': history.note,
          'reason': history.reason,
          'id': history.id,
          '_id': 'stockHistory_' + store.state.userId.toString(),
          'channel': store.state.userId.toString(),
          'createdAt': history.createdAt.toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };
        await createStockHistory(_history);
      }

      Map _mapStock = {
        'branchId': stock.branchId,
        'productId': productId,
        'createdAt': stock.createdAt.toIso8601String(),
        'id': stock.id,
        '_id': 'stocks_' + store.state.userId.toString(),
        'channel': store.state.userId.toString(),
        'variantId': stock.variantId,
        'retailPrice': stock.retailPrice,
        'supplyPrice': stock.supplyPrice,
        'isActive': stock.isActive,
        'showLowStockAlert': stock.showLowStockAlert,
        'updatedAt': DateTime.now().toIso8601String(),
        'canTrackingStock': stock.canTrackingStock,
        'lowStock': stock.lowStock,
        'currentStock': stock.currentStock,
      };
      await createVariant(_mapVariant);
      await createStock(_mapStock);
    }

    //sync branchProduct:

    BranchProductTableData branchProduct = await store
        .state.database.branchProductDao
        .getBranchProduct(productId: productId);
    Map _mapBranchProduct = {
      'id': branchProduct.id,
      'branchId': branchProduct.branchId,
      'productId': branchProduct.productId,
      'channel': store.state.userId.toString(),
      '_id': 'branchProducts_' + store.state.userId.toString(),
      'branchId': branchProduct.branchId
    };
    await createBranchProduct(_mapBranchProduct);
  }
}
