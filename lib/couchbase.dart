import 'dart:async';

import 'package:couchbase_lite/couchbase_lite.dart' as lite;
import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/observable_response.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/util/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/subjects.dart';
import 'package:uuid/uuid.dart';

import 'domain/redux/app_state.dart';

typedef ResultSetCallback = void Function(lite.ResultSet results);

class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase instance = AppDatabase._internal();
  final Logger log = Logging.getLogger('Old Database service ....');

  String dbName = 'main';
  // ignore: always_specify_types
  List<Future> pendingListeners = [];
  lite.ListenerToken _replicatorListenerToken;
  lite.Database database;
  lite.Replicator replicator;
  lite.ListenerToken _docListenerToken;
  lite.ListenerToken _dbListenerToken;

  Future<dynamic> createBranch(Map map) async {
    assert(map['_id'] != null);
    assert(map['name'] != null);
    assert(map['channels'] != null);
    assert(map['active'] != null);
    assert(map['businessId'] != null);
    assert(map['mapLatitude'] != null);
    assert(map['mapLongitude'] != null);
    assert(map['id'] != null);
    assert(map['updatedAt'] != null);
    assert(map['createdAt'] != null);
    assert(map['_id'] != null);
    // ignore: always_specify_types
    // final List<Map> m = [map];
    final DatabaseService _databaseService = locator<DatabaseService>();
    _databaseService.insert(id:map['id'],data:map);
    // FIXME(richard): update the document online to remove branch in array just save them and rely on table name
    return map['id'];
  }

  Future<lite.Document> createDocumentIfNotExists(
      String id, Map<String, dynamic> map) async {
    try {
      final lite.Document oldDoc = await database.document(id);
      if (oldDoc != null) {
        return oldDoc;
      }

      final lite.MutableDocument newDoc =
          lite.MutableDocument(id: id, data: map);
      if (await database.saveDocument(newDoc)) {
        return newDoc;
      } else {
        return null;
      }
    } on PlatformException {
      return null;
    }
  }

  Future<bool> login(
      {String username, String password, List<String> channels}) async {
    try {
      database = await lite.Database.initWithName(dbName);
      // Note wss://10.0.2.2:4984/main is for the android simulator on your local machine's couchbase database
      final String gatewayUrl = DotEnv().env['GATEWAY_URL'];
      final lite.ReplicatorConfiguration config =
          lite.ReplicatorConfiguration(database, 'ws://$gatewayUrl/main');

      config.replicatorType = lite.ReplicatorType.pushAndPull;
      config.continuous = true;
      config.channels = channels;

      final String username = DotEnv().env['PASSWORD'];
      final String password = DotEnv().env['USERNAME'];
      log.d('username:' + username);
      log.d('password:' + password);
      // Using self signed certificate
      //config.pinnedServerCertificate = 'assets/cert-android.cer';
      // config.authenticator = lite.BasicAuthenticator(username, password);
      replicator = lite.Replicator(config);

      replicator.addChangeListener((lite.ReplicatorChange event) {
        if (event.status.error != null) {
          print('Error: ' + event.status.error);
        }
        print(event.status.activity.toString());
      });

      await replicator.start();

      const String indexName = 'TypeNameIndex';
      final List<String> indices = await database.indexes;
      if (!indices.contains(indexName)) {
        final lite.ValueIndex index = lite.IndexBuilder.valueIndex(items: [
          lite.ValueIndexItem.property('type'),
          lite.ValueIndexItem.expression(lite.Expression.property('name'))
        ]);
        await database.createIndex(index, withName: indexName);
      }

      final lite.Document pref =
          await createDocumentIfNotExists('MyPreference', {'theme': 'dark'});
      _docListenerToken = database.addDocumentChangeListener(pref.id,
          (lite.DocumentChange change) {
        print('Document change ${change.documentID}');
      });

      _dbListenerToken =
          database.addChangeListener((lite.DatabaseChange dbChange) async {
        for (String id in dbChange.documentIDs) {
         
          final lite.Document document = await database.document(id);
          //until we save document right in all place keep this code here to keep things smooth.
          if (document != null && !document.getBoolean('touched')) {
             log.d('change in id: $id');
            //only update once to avoid infinite loop
            log.i('updated non touched document,we update the document to make the id be usable for update');
            final lite.MutableDocument mutableDoc = document
                .toMutable()
                .setBoolean('touched', true)
                .setString(
                  'id',
                  id,
                ); //to make sure that the id that is in doc is the one we can use to make update about a single doc, this is a work around as we can not have id in a simple way
            database.saveDocument(mutableDoc);
          }
        }
      });

      return true;
    } on PlatformException {
      return false;
    }
  }

  Future<void> logout() async {
    await Future.wait(pendingListeners);

    await database.removeChangeListener(_docListenerToken);
    await database.removeChangeListener(_dbListenerToken);
    _docListenerToken = null;
    _dbListenerToken = null;

    await replicator.removeChangeListener(_replicatorListenerToken);
    _replicatorListenerToken =
        replicator.addChangeListener((lite.ReplicatorChange event) async {
      if (event.status.activity == lite.ReplicatorActivityLevel.stopped) {
        await database.close();
        await replicator.removeChangeListener(_replicatorListenerToken);
        await replicator.dispose();
        _replicatorListenerToken = null;
      }
    });
    await replicator.stop();
  }

  ObservableResponse<lite.ResultSet> getMyDocument(String documentId) {
    final BehaviorSubject<lite.ResultSet> stream =
        BehaviorSubject<lite.ResultSet>();
    // Execute lite query and then post results and all changes to the stream

    final lite.Query query = lite.QueryBuilder.select([
      lite.SelectResult.expression(lite.Meta.id.from('mydocs')).as('id'),
      lite.SelectResult.expression(
          lite.Expression.property('foo').from('mydocs')),
      lite.SelectResult.expression(
          lite.Expression.property('bar').from('mydocs')),
    ]).from(dbName, as: 'mydocs').where(lite.Meta.id
        .from('mydocs')
        .equalTo(lite.Expression.string(documentId)));

    final Null Function(lite.ResultSet results) processResults =
        (lite.ResultSet results) {
      if (!stream.isClosed) {
        stream.add(results);
      }
    };

    // return _buildObservableQueryResponse(stream, query, processResults);
  }

  // ignore: sort_constructors_first
  // CouchBase(): super();

  //create lite branch

  // ignore: always_specify_types
  Future<dynamic> createTax(map) async {
    assert(map['channels'] != null);
    assert(map['name'] != null);
    assert(map['active'] != null);
    assert(map['isDefault'] != null);
    assert(map['id'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);
    assert(map['businessId'] != null);

    // ignore: always_specify_types
    final DatabaseService _databaseService = locator<DatabaseService>();
    // ignore: flutter_style_todos
    // TODO: discuss with @ganze to abandon saving array within a document
    _databaseService.insert(id:map['id'],data:map);
  }

  //create business.
  Future<String> createBusiness(Map map) async {
    //if user has business do nothing

    assert(map['_id'] != null);

    assert(map['channels'] != null);
    assert(map['name'] != null);
    assert(map['active'] != null);
    assert(map['categoryId'] != null);
    assert(map['typeId'] != null);
    assert(map['country'] != null);
    assert(map['currency'] != null);
    assert(map['id'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);
    assert(map['userId'] != null);

    final DatabaseService _databaseService = locator<DatabaseService>();
    _databaseService.insert(id:map['id'],data:map);
    return map['id'];
  }

  //create user
  // ignore: always_specify_types
  Future<void> createUser(Map map) async {
    assert(map['_id'] != null);
    assert(map['name'] != null);
    assert(map['channels'] != null);
    assert(map['token'] != null);
    assert(map['id'] != null);
    assert(map['active'] != null);
    assert(map['email'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);

    // ignore: always_specify_types
    final DatabaseService _databaseService = locator<DatabaseService>();
    _databaseService.insert(id:map['id'],data:map);
  }

  Future<void> syncRemoteToLocal({Store<AppState> store}) async {
    //load all app units:
    await syncUnit(store);
  }

  Future<void> syncUnit(Store<AppState> store) async {
    // ignore: always_specify_types
    final List<Map<String, String>> units = [
      {'name': 'Per Item', 'value': ''},
      {'name': 'Per Kilogram (kg)', 'value': 'kg'},
      {'name': 'Per Cup (c)', 'value': 'c'},
      {'name': 'Per Liter (l)', 'value': 'l'},
      {'name': 'Per Pound (lb)', 'value': 'lb'},
      {'name': 'Per Pint (pt)', 'value': 'pt'},
      {'name': 'Per Acre (ac)', 'value': 'ac'},
      {'name': 'Per Centimeter (cm)', 'value': 'cm'},
      {'name': 'Per Cubic Footer (cu ft)', 'value': 'cu ft'},
      {'name': 'Per Day (day)', 'value': 'day'},
      {'name': 'Footer (ft)', 'value': 'ft'},
      {'name': 'Per Gram (g)', 'value': 'g'},
      {'name': 'Per Hour (hr)', 'value': 'hr'},
      {'name': 'Per Minute (min)', 'value': 'min'},
      {'name': 'Per Acre (ac)', 'value': 'ac'},
      {'name': 'Per Cubic Inch (cu in)', 'value': 'cu in'},
      {'name': 'Per Cubic Yard (cu yd)', 'value': 'cu yd'},
      {'name': 'Per Fluid Ounce (fl oz)', 'value': 'fl oz'},
      {'name': 'Per Gallon (gal)', 'value': 'gal'},
      {'name': 'Per Inch (in)', 'value': 'in'},
      {'name': 'Per Kilometer (km)', 'value': 'km'},
      {'name': 'Per Meter (m)', 'value': 'm'},
      {'name': 'Per Mile (mi)', 'value': 'mi'},
      {'name': 'Per Milligram (mg)', 'value': 'mg'},
      {'name': 'Per Milliliter (mL)', 'value': 'mL'},
      {'name': 'Per Millimeter (mm)', 'value': 'mm'},
      {'name': 'Per Millisecond (ms)', 'value': 'ms'},
      {'name': 'Per Ounce (oz)', 'value': 'oz'},
      {'name': 'Per  Quart (qt)', 'value': 'qt'},
      {'name': 'Per Second (sec)', 'value': 'sec'},
      {'name': 'Per Shot (sh)', 'value': 'sh'},
      {'name': 'Per Square Centimeter (sq cm)', 'value': 'sq cm'},
      {'name': 'Per Square Foot (sq ft)', 'value': 'sq ft'},
      {'name': 'Per Square Inch (sq in)', 'value': 'sq in'},
      {'name': 'Per Square Kilometer (sq km)', 'value': 'sq km'},
      {'name': 'Per Square Meter (sq m)', 'value': 'sq m'},
      {'name': 'Per Square Mile (sq mi)', 'value': 'sq mi'},
      {'name': 'Per Square Yard (sq yd)', 'value': 'sq yd'},
      {'name': 'Per Stone (st)', 'value': 'st'},
      {'name': 'Per Yard (yd)', 'value': 'yd'}
    ];
    for (int i = 0; i < units.length; i++) {
      //insert or update unit in table set focus to false for all.
      final UnitTableData unit = await store.state.database.unitDao
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
  }

  Future<dynamic> createVariant(Map map) async {
    assert(map['_id'] != null);

    final lite.Document variants = await database.document(map['id']);

    assert(map['channels'] != null);
    assert(map['SKU'] != null);
    assert(map['name'] != null);
    assert(map['productId'] != null);
    assert(map['id'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);

    List m = [map];

    variants
        .toMutable()
        .setList('variants', m)
        .setList('channels', [map['channels']])
        .setString('uid', Uuid().v1())
        .setString('_id', map['_id']);

    return await database.saveDocument(variants);
  }

  Future<dynamic> createBranchProduct(Map map) async {
    assert(map['_id'] != null);

    assert(map['channels'] != null);
    assert(map['productId'] != null);
    assert(map['branchId'] != null);
    assert(map['id'] != null);

    // ignore: always_specify_types
    final List<Map> m = [map];
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id')
            .equalTo(lite.Expression.string(map['id'])));
    // Run the query.
    try {
      final lite.ResultSet result = await query.execute();

      if (!result.allResults().isNotEmpty) {
        final lite.MutableDocument mutableDoc = lite.MutableDocument()
            .setList('branchProducts', m)
            .setString('id', map['id'])
            // ignore: always_specify_types
            .setList('channels', [map['channels']])
            .setString('uid', Uuid().v1())
            .setString('_id', map['_id']);
        try {
          await database.saveDocument(mutableDoc);
        } on PlatformException {
          return 'Error saving document';
        }
      } else {
        //todo: deal with result return [] of them.....
        final List<Map<String, dynamic>> model = result.map((result) {
          // return Beer.fromMap();
          return result.toMap();
        }).toList();
      }
    } on PlatformException {
      // ignore: prefer_single_quotes
      return "Error running the query";
    }
  }

  Future<dynamic> createStockHistory(Map map) async {
    assert(map['_id'] != null);

    assert(map['channels'] != null);
    assert(map['variantId'] != null);
    assert(map['stockId'] != null);
    assert(map['quantity'] != null);
    assert(map['reason'] != null);
    assert(map['note'] != null);
    assert(map['updatedAt'] != null);
    assert(map['createdAt'] != null);
    assert(map['id'] != null);

    // ignore: always_specify_types
    final List<Map> m = [map];
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id')
            .equalTo(lite.Expression.string(map['id'])));
    // Run the query.
    try {
      final lite.ResultSet result = await query.execute();

      if (!result.allResults().isNotEmpty) {
        final lite.MutableDocument mutableDoc = lite.MutableDocument()
            .setList('stockHistory', m)
            .setString('id', map['id'])
            // ignore: always_specify_types
            .setList('channels', [map['channels']])
            .setString('uid', Uuid().v1())
            .setString('_id', map['_id']);
        try {
          await database.saveDocument(mutableDoc);
        } on PlatformException {
          return 'Error saving document';
        }
      } else {
        //todo: deal with result return [] of them.....
        final List<Map<String, dynamic>> model = result.map((result) {
          // return Beer.fromMap();
          return result.toMap();
        }).toList();
      }
    } on PlatformException {
      // ignore: prefer_single_quotes
      return "Error running the query";
    }
  }

  Future<dynamic> createStock(Map map) async {
    assert(map['_id'] != null);

    final lite.Document stocks = await database.document(map['id']);

    assert(map['channels'] != null);
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

    stocks
        .toMutable()
        .setList('stocks', m)
        .setString('channels', map['channels'])
        .setString('uid', Uuid().v1())
        .setString('_id', map['_id']);

    return await database.saveDocument(stocks);
  }

  Future<dynamic> syncLocalToRemote(
      {Store<AppState> store, String partial}) async {
    // //L stands for local and R stands for remote.
    switch (partial) {
      case 'Business':
        await syncBusinessLRemote(store);
        break;
      case 'Variant':
        await syncVariantLRemote(store);
        break;
      case 'Stock':
        await syncStockLRemote(store);
        break;
      case 'Order':
        await syncOrderLRemote(store);
        break;
      default:
        await syncBusinessLRemote(store);
        await syncVariantLRemote(store);
        await syncProductsLRemote(store);
        await syncStockLRemote(store);
    }
  }

  Future<void> syncBranchProductLRemote(Store<AppState> store) async {
    final List<BranchProductTableData> branchProducts =
        await store.state.database.branchProductDao.branchProducts();

    final lite.Document bP = await database
        .document('branchProducts_' + store.state.userId.toString());
    // return await createDocumentIfNotExists(map['_id'], map);

    // ignore: always_specify_types
    final List mapTypeListBranchProducts = [];
    for (int i = 0; i < branchProducts.length; i++) {
      final Map map = {
        'branchId': branchProducts[i].branchId,
        'id': branchProducts[i].id,
        'branchProducts_': store.state.userId.toString(),
        'productId': branchProducts[i].productId,
      };
      mapTypeListBranchProducts.add(map);
    }

    bP
        .toMutable()
        .setList('branchProducts', mapTypeListBranchProducts)
        // .setList('channels', [store.state.userId.toString()])
        .setString('uid', Uuid().v1())
        .setString('_id', 'branchProducts_' + store.state.userId.toString());

    await database.saveDocument(bP);
  }

  Future<lite.Document> syncStockLRemote(Store<AppState> store) async {
    List<StockTableData> stocks =
        await store.state.database.stockDao.getStocks();

    lite.Document stock =
        await database.document(store.state.userId.toString());

    final List mapTypeListStocks = [];
    for (int i = 0; i < stocks.length; i++) {
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
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      mapTypeListStocks.add(map);
    }

    stock
        .toMutable()
        .setList('stocks', mapTypeListStocks)
        // .setList('channels', [store.state.userId.toString()])
        .setString('uid', Uuid().v1())
        .setString('_id', 'stocks_' + store.state.userId.toString());

    await database.saveDocument(stock);
    return stock;
  }

  Future syncProductsLRemote(Store<AppState> store) async {
    List<ProductTableData> products =
        await store.state.database.productDao.getProducts();

    // Document product =

    final lite.Document product =
        await database.document(store.state.userId.toString());

    final List mapTypeListProducts = [];
    for (int i = 0; i < products.length; i++) {
      Map map = {
        'name': products[i].name,
        'id': products[i].id,
        'color': products[i].color,
        'picture': products[i].picture,
        'active': products[i].active,
        'hasPicture': products[i].hasPicture,
        'isDraft': products[i].isDraft,
        'isCurrentUpdate': products[i].isCurrentUpdate,
        'description': products[i].description,
        'businessId': products[i].businessId,
        'supplierId': products[i].supplierId,
        'categoryId': products[i].categoryId,
        'taxId': products[i].taxId,
        'createdAt': products[i].createdAt.toIso8601String(),
        'updatedAt': products[i].updatedAt == null
            ? DateTime.now().toIso8601String()
            : products[i].updatedAt.toIso8601String(),
      };
      mapTypeListProducts.add(map);
    }

    product
        .toMutable()
        .setList('products', mapTypeListProducts)
        // .setList('channels', [store.state.userId.toString()])
        .setString('uid', Uuid().v1())
        .setString('_id', 'products_' + store.state.userId.toString());

    await database.saveDocument(product);
  }

  Future<List<VariationTableData>> syncVariantLRemote(
      Store<AppState> store) async {
    List<VariationTableData> variations =
        await store.state.database.variationDao.getVariations();

    final lite.Document variant =
        await database.document(store.state.userId.toString());

    final List mapTypeListVariants = [];
    for (int i = 0; i < variations.length; i++) {
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
        // .setList('channels', [store.state.userId.toString()])
        .setString('uid', Uuid().v1())
        .setString('_id', 'variants_' + store.state.userId.toString());

    await database.saveDocument(variant);
    return variations;
  }

  Future syncOrderLRemote(Store<AppState> store) async {}

  Future syncOrderDetailLRemote(Store<AppState> store) async {}

  Future<void> syncOrdersLRemote(Store<AppState> store) async {}

  Future<void> syncBusinessLRemote(Store<AppState> store) async {}

  void insertHistory(Store<AppState> store, StockTableData stock) {
    store.state.database.stockHistoryDao.insert(
      //ignore:missing_required_param
      StockHistoryTableData(
        id: Uuid().v1(),
        note: stock.action + stock.currentStock.toString() + 'qty',
        reason: stock.action,
        stockId: stock.id,
        variantId: stock.variantId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        quantity: stock.currentStock,
      ),
    );
  }

  // ignore: always_declare_return_types
  partialSyncHistory(
      {StockHistoryTableData history, Store<AppState> store}) async {
    final lite.Document histo = await database
        .document('stockHistory_' + store.state.userId.toString());

    final List mapHistory = [];
    Map map = {
      'id': history.id,
      'stockId': history.id,
      'reason': history.reason,
      'variantId': history.variantId,
      'stockHistory_': store.state.userId.toString(),
      'note': history.note,
      'quantity': history.quantity,
    };
    mapHistory.add(map);
    histo
        .toMutable()
        .setList('stockHistory', mapHistory)
        // .setList('channels', [store.state.userId.toString()])
        .setString('uid', Uuid().v1())
        .setString('_id', 'stockHistory_' + store.state.userId.toString());
    await database.saveDocument(histo);
  }
}
