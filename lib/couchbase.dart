import 'dart:async';

import 'package:couchbase_lite/couchbase_lite.dart' as lite;
import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/observable_response.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/fuser.dart';
import 'package:flipper/model/tax.dart';
import 'package:flipper/util/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/subjects.dart';
import 'package:uuid/uuid.dart';

import 'domain/redux/app_actions/actions.dart';
import 'domain/redux/app_state.dart';

typedef ResultSetCallback = void Function(lite.ResultSet results);

class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase instance = AppDatabase._internal();
  final Logger log = Logging.getLogger('Firestore service ....');
  
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
    assert(map['channel'] != null);
    assert(map['active'] != null);
    assert(map['businessId'] != null);
    assert(map['mapLatitude'] != null);
    assert(map['mapLongitude'] != null);
    assert(map['id'] != null);
    assert(map['updatedAt'] != null);
    assert(map['createdAt'] != null);
    assert(map['_id'] != null);
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
            .setList('branches', m)
            .setString('id', map['id'])
            // ignore: always_specify_types
            .setList('channels', [map['channel']])
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
      log.d('username:'+username);
      log.d('password:'+password);
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
      } else {
        // var query = _buildBeerQuery(100, 0, false);
        print('explanation:');
        // print(await query.explain());
      }

      final lite.Document pref =
          await createDocumentIfNotExists('MyPreference', {'theme': 'dark'});
      _docListenerToken = database.addDocumentChangeListener(pref.id,
          (lite.DocumentChange change) {
        print('Document change ${change.documentID}');
      });

      _dbListenerToken = database.addChangeListener((dbChange) {
        for (String change in dbChange.documentIDs) {
          print('change in id: $change');
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

  Future<dynamic> createTax(Map map) async {
    lite.Document doc = await database.document(map['id']);

    assert(map['channel'] != null);
    assert(map['name'] != null);
    assert(map['active'] != null);
    assert(map['isDefault'] != null);
    assert(map['id'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);
    assert(map['businessId'] != null);

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
            .setList('taxes', m)
            .setString('id', map['id'])
            // ignore: always_specify_types
            .setList('channels', [map['channel']])
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

  //create business.
  Future<dynamic> createBusiness(Map map) async {
    //if user has business do nothing

    assert(map['_id'] != null);

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
            .setList('businesses', m)
            .setString('id', map['id'])
            // ignore: always_specify_types
            .setList('channels', [map['channel']])
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

  //create user
  // ignore: always_specify_types
  Future<void> createUser(Map map) async {
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

    // ignore: always_specify_types
    final List<Map> m = [map];
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id')
            .equalTo(lite.Expression.string(map['id'])));

    // Run the query.
    try {
      final lite.ResultSet result = await query.execute();
      // ignore: prefer_single_quotes
      // print("Number of rows :: ${result.allResults().length}");
      if (!result.allResults().isNotEmpty) {
        final lite.MutableDocument mutableDoc = lite.MutableDocument()
            .setList('users', m)
            .setString('id', map['id'])
            .setList('channels', [map['channel']])
            .setString('uid', 'uid')
            .setString('_id', map['_id']);
        try {
          await database.saveDocument(mutableDoc);
        } on PlatformException {
          return 'Error saving document';
        }
      } else {
        //todo: deal with result return [] of them.....
        final List<Map<String, dynamic>> model =
            result.map((lite.Result result) {
          // return Beer.fromMap();
          return result.toMap();
        }).toList();
      }
    } on PlatformException {
      // ignore: prefer_single_quotes
      return "Error running the query";
    }
  }

  Future<dynamic> getDocumentByFilter(
      {String filter, Store<AppState> store, T}) async {
    // Create a query to fetch documents of type SDK.
    // ignore: always_specify_types
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id')
            .equalTo(lite.Expression.string(filter)));
    lite.ResultSet result;

    // Run the query.
    try {
      result = await query.execute();
    } on PlatformException {
      return 'Error running the query';
    }
    switch (T.toString()) {
      case 'User':
        {
          return buildUserModel(result, store);
        }
        break;

      case 'Business':
        {
          return buildBusinessModel(result, store);
        }
      case 'Branch':
        {
          return buildBranchModel(result, store);
        }

        break;

      default:
        return null;
        break;
    }
  }

  Future<void> syncRemoteToLocal({Store<AppState> store}) async {
    //load branch products
    await syncBranchProductRLocal(store);

    //load products
    await syncProductRLocal(store);

    //load all app units:
    await syncUnit(store);

    //load taxes:
    await syncTaxesRLocal(store);
    //end loading taxes
    //category
    await syncCategoriesRLocal(store);
    //done loading category

    //sync branch
    await syncBranchRLocal(store);
    //load business.
    await syncBusinessRLocal(store);

    //load variants:
    await syncVariantsRLocal(store);

    //load all stocks:
    await syncStockRLocal(store);

    //load stock history
    await syncHistoryRLocal(store);
  }

  Future<void> syncHistoryRLocal(Store<AppState> store) async {
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id').equalTo(lite.Expression.string(
            'stockHistory_' + store.state.userId.toString())));
    lite.ResultSet result;
    // Run the query.
    try {
      result = await query.execute();
    } on PlatformException {
      return 'Error running the query';
    }

    final List<Map<String, dynamic>> model = result.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();

    if (model.isEmpty) {
      return null;
    }
    // ignore: always_specify_types
    final r = model[0][dbName]['stockHistory'];

    for (int i = 0; i < r.length; i++) {
      final StockHistoryTableData history =
          await store.state.database.stockHistoryDao.getById(id: r[i]['id']);
      // ignore:missing_required_param
      final StockHistoryTableData historyData = StockHistoryTableData(
          id: r[i]['id'],
          note: r[i]['note'],
          quantity: r[i]['quantity'],
          stockId: r[i]['stockId'],
          reason: r[i]['reason'],
          variantId: r[i]['variantId'],
          createdAt: DateTime.parse(r[i]['createdAt']),
          updatedAt: DateTime.parse(r[i]['updatedAt']));

      if (history == null) {
        await store.state.database.stockHistoryDao.insert(historyData);
      } else {
        await store.state.database.stockHistoryDao
            .updateHistory(historyData.copyWith(idLocal: history.idLocal));
      }
    }
  }

  Future<void> syncStockRLocal(Store<AppState> store) async {
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id').equalTo(
            lite.Expression.string('stocks_' + store.state.userId.toString())));
    lite.ResultSet result;
    // Run the query.
    try {
      result = await query.execute();
    } on PlatformException {
      return 'Error running the query';
    }

    final List<Map<String, dynamic>> model = result.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();

    if (model.isEmpty) {
      return null;
    }
    final r = model[0][dbName]['stocks'];

    for (int i = 0; i < r.length; i++) {
      final StockTableData stock =
          await store.state.database.stockDao.getById(id: r[i]['id']);
      // ignore:missing_required_param
      final StockTableData branchProductData = StockTableData(
          id: r[i]['id'],
          supplyPrice: r[i]['supplyPrice'].toDouble(),
          retailPrice: r[i]['retailPrice'].toDouble(),
          lowStock: r[i]['lowStock'],
          action: r[i]['action'],
          variantId: r[i]['variantId'],
          branchId: r[i]['branchId'],
          productId: r[i]['productId'],
          currentStock: r[i]['currentStock'],
          canTrackingStock: r[i]['canTrackingStock'],
          showLowStockAlert: r[i]['showLowStockAlert'],
          createdAt: DateTime.parse(r[i]['createdAt']),
          updatedAt: DateTime.parse(r[i]['updatedAt']));

      if (stock == null) {
        await store.state.database.stockDao.insert(branchProductData);
      } else {
        await store.state.database.stockDao.updateStock(branchProductData
            .copyWith(idLocal: stock.idLocal, isActive: false, action: 'NONE'));
      }
    }
  }

  Future<void> syncVariantsRLocal(Store<AppState> store) async {
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id').equalTo(lite.Expression.string(
            'variants_' + store.state.userId.toString())));
    lite.ResultSet result;
    // Run the query.
    try {
      result = await query.execute();
    } on PlatformException {
      return 'Error running the query';
    }

    final List<Map<String, dynamic>> model = result.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();
    if (model.isEmpty) {
      return null;
    }
    final r = model[0][dbName]['variants'];

    for (int i = 0; i < r.length; i++) {
      final VariationTableData variation = await store
          .state.database.variationDao
          .getVariationById(variantId: r[i]['id']);
      // ignore:missing_required_param
      final VariationTableData variationData = VariationTableData(
          name: r[i]['name'],
          id: r[i]['id'],
          isActive: false,
          sku: r[i]['SKU'],
          productId: r[i]['productId'],
          unit: r[i]['unit'],
          createdAt: DateTime.parse(r[i]['createdAt']),
          updatedAt: DateTime.parse(r[i]['updatedAt']));

      if (variation == null) {
        await store.state.database.variationDao.insert(variationData);
      } else {
        await store.state.database.variationDao.updateVariation(
            variationData.copyWith(idLocal: variation.idLocal));
      }
    }
  }

  Future<void> syncBranchRLocal(Store<AppState> store) async {
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id').equalTo(lite.Expression.string(
            'branches_' + store.state.userId.toString())));
    lite.ResultSet result;
    // Run the query.
    try {
      result = await query.execute();
    } on PlatformException {
      return 'Error running the query';
    }

    final List<Map<String, dynamic>> model = result.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();

    if (model.isEmpty) {
      return null;
    }
    final r = model[0][dbName]['branches'];

    for (int i = 0; i < r.length; i++) {
      final BranchTableData brachi = await store.state.database.branchDao
          .getBranchById(branchId: r[i]['id']);

      final BranchTableData businessTableData = BranchTableData(
        id: r[i]['id'],
        name: r[i]['name'],
        isActive: r[i]['isActive'] ?? false,
        businessId: r[i]['businessId'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        idLocal: 1,
      );
      if (brachi == null) {
        await store.state.database.branchDao.insert(businessTableData);
      } else {
        await store.state.database.branchDao
            .updateBranch(businessTableData.copyWith(idLocal: brachi.idLocal));
      }
    }
  }

  Future<void> syncBusinessRLocal(Store<AppState> store) async {
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id').equalTo(lite.Expression.string(
            'business_' + store.state.userId.toString())));
    lite.ResultSet result;
    // Run the query.
    try {
      result = await query.execute();
    } on PlatformException {
      return 'Error running the query';
    }

    final List<Map<String, dynamic>> model = result.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();

    if (model.isEmpty) {
      return null;
    }
    // ignore: always_specify_types
    final r = model[0][dbName]['businesses'];
    for (int i = 0; i < r.length; i++) {
      final BusinessTableData busine =
          await store.state.database.businessDao.getBusinesById(id: r[i]['id']);
      // ignore:missing_required_param
      final BusinessTableData businessTableData = BusinessTableData(
          active: r[i]['active'],
          name: r[i]['name'],
          id: r[i]['id'],
          userId: r[i]['userId'].toString(),
          longitude: r[i]['longitude'],
          typeId: r[i]['typeId'].toString(),
          categoryId: r[i]['categoryId'].toString(),
          country: r[i]['country'],
          timeZone: r[i]['timeZone'],
          currency: r[i]['currency'],
          latitude: r[i]['latitude'],
          createdAt: DateTime.parse(r[i]['createdAt']),
          updatedAt: DateTime.parse(r[i]['updatedAt']));

      if (busine == null) {
        await store.state.database.businessDao.insert(businessTableData);
      } else {
        await store.state.database.businessDao.updateBusiness(
            businessTableData.copyWith(idLocal: busine.idLocal));
      }
    }
  }

  Future<void> syncCategoriesRLocal(Store<AppState> store) async {
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id').equalTo(lite.Expression.string(
            'categories_' + store.state.userId.toString())));
    lite.ResultSet result;
    // Run the query.
    try {
      result = await query.execute();
    } on PlatformException {
      return 'Error running the query';
    }

    final List<Map<String, dynamic>> model = result.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();

    if (model.isNotEmpty) {
      // ignore: always_specify_types
      final r = model[0][dbName]['categories'];

      for (int i = 0; i < r.length; i++) {
        final CategoryTableData category =
            await store.state.database.categoryDao.getById(id: r[i]['id']);
        CategoryTableData categoryData;
        if (i == 1) {
          // ignore:missing_required_param
          categoryData = CategoryTableData(
              id: r[i]['id'],
              name: r[i]['name'],
              focused: true,
              branchId: r[i]['branchId'],
              createdAt: DateTime.parse(r[i]['createdAt']),
              updatedAt: DateTime.parse(r[i]['updatedAt']));
        } else {
          // ignore:missing_required_param
          categoryData = CategoryTableData(
              id: r[i][i]['id'],
              name: r[i]['name'],
              focused: false,
              branchId: r[i]['branchId'],
              createdAt: DateTime.parse(r[i]['createdAt']),
              updatedAt: DateTime.parse(r[i]['updatedAt']));
        }

        if (category == null) {
          await store.state.database.categoryDao.insert(categoryData);
        } else {
          await store.state.database.categoryDao
              .updateCategory(categoryData.copyWith(idLocal: category.idLocal));
        }
      }
    } else {
      //TODO(richard): remember to sync lite custom category created local and tax to remote so other client can have them too.
      if (store.state.branch == null) return;
      final CategoryTableData category =
          await store.state.database.categoryDao.getCategoryByNameBranchId(
        'custom',
        store.state.branch.id,
      );
      if (category == null) {
        //ignore:missing_required_param
        final CategoryTableData categoryData = CategoryTableData(
            id: Uuid().v1(),
            name: 'custom',
            focused: true,
            branchId: store.state.branch.id,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());

        await store.state.database.categoryDao.insert(categoryData);
      }
    }
  }

  Future<void> syncTaxesRLocal(Store<AppState> store) async {
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id').equalTo(
            lite.Expression.string('taxes_' + store.state.userId.toString())));
    lite.ResultSet result;
    // Run the query.
    try {
      result = await query.execute();
    } on PlatformException {
      return 'Error running the query';
    }

    final List<Map<String, dynamic>> model = result.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();

    if (model.isEmpty) {
      return [];
    }
    // ignore: always_specify_types
    final r = model[0][dbName]['taxes'];

    for (int i = 0; i < r.length; i++) {
      final TaxTableData tax =
          await store.state.database.taxDao.getById(taxid: r[i]['id']);
      // ignore:missing_required_param
      final TaxTableData taxData = TaxTableData(
          id: r[i]['id'],
          name: r[i]['name'],
          businessId: r[i]['businessId'],
          isDefault: r[i]['isDefault'],
          percentage: r[i]['percentage'].toDouble(),
          createdAt: DateTime.parse(r[i]['createdAt']),
          updatedAt: DateTime.parse(r[i]['updatedAt']));

      if (tax == null) {
        await store.state.database.taxDao.insert(taxData);
        if (r[i]['isDefault']) {
          store.dispatch(
            DefaultTax(
              tax: Tax((TaxBuilder t) => t
                ..name = taxData.name
                ..id = taxData.id
                ..isDefault = taxData.isDefault
                ..percentage = taxData.percentage
                ..businessId = taxData.businessId),
            ),
          );
        }
      } else {
        await store.state.database.taxDao
            .updateTax(taxData.copyWith(idLocal: tax.idLocal));

        if (r[i]['isDefault']) {
          store.dispatch(
            DefaultTax(
              tax: Tax((TaxBuilder t) => t
                ..name = taxData.name
                ..id = taxData.id
                ..isDefault = taxData.isDefault
                ..percentage = taxData.percentage
                ..businessId = taxData.businessId),
            ),
          );
        }
      }
    }
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

  Future<void> syncProductRLocal(Store<AppState> store) async {
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id').equalTo(lite.Expression.string(
            'products_' + store.state.userId.toString())));
    lite.ResultSet result;
    // Run the query.
    try {
      result = await query.execute();
    } on PlatformException {
      return 'Error running the query';
    }

    final List<Map<String, dynamic>> model = result.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();

    if (model.isEmpty) {
      return [];
    }
    // ignore: always_specify_types
    final r = model[0][dbName]['products'];

    for (int i = 0; i < r.length; i++) {
      final ProductTableData product = await store.state.database.productDao
          .getItemById(productId: r[i]['id']);
      // ignore:missing_required_param
      final ProductTableData productData = ProductTableData(
          businessId: r[i]['businessId'].toString(),
          active: r[i][i]['active'],
          isImageLocal: false,
          name: r[i]['name'],
          id: r[i]['id'],
          color: r[i]['color'],
          description: r[i]['description'],
          picture: r[i]['picture'],
          taxId: r[i]['taxId'],
          hasPicture: r[i]['hasPicture'],
          isDraft: r[i]['isDraft'],
          isCurrentUpdate: r[i]['isCurrentUpdate'],
          supplierId: r[i]['supplierId'].toString(),
          categoryId: r[i]['categoryId'].toString(),
          createdAt: DateTime.parse(r[i]['createdAt']),
          updatedAt: DateTime.parse(r[i]['updatedAt']));

      if (product == null) {
        await store.state.database.productDao.insert(productData);
      } else {
        await store.state.database.productDao
            .updateProduct(productData.copyWith(idLocal: product.idLocal));
      }
    }
  }

  Future<void> syncBranchProductRLocal(Store<AppState> store) async {
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('id').equalTo(lite.Expression.string(
            'branchProducts_' + store.state.userId.toString())));
    lite.ResultSet result;

    // Run the query.
    try {
      result = await query.execute();
    } on PlatformException {
      return 'Error running the query';
    }

    final List<Map<String, dynamic>> model = result.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();

    if (model.isEmpty) return;
    // ignore: always_specify_types
    final r = model[0][dbName]['branchProducts'];

    for (int i = 0; i < r.length; i++) {
      final BranchProductTableData branchProduct =
          await store.state.database.branchProductDao.getById(id: r[i]['id']);
      final BranchProductTableData branchProductData = BranchProductTableData(
        id: r[i]['id'],
        branchId: r[i]['branchId'],
        productId: r[i]['productId'],
        idLocal: 1,
      );

      if (branchProduct == null) {
        await store.state.database.branchProductDao.insert(branchProductData);
      } else {
        await store.state.database.branchProductDao.updateBP(
            branchProductData.copyWith(idLocal: branchProduct.idLocal));
      }
    }
  }

  Future<dynamic> queryEmail(Store<AppState> store, String email) async {
    // ResultSet results = await query.execute();
  }

  FUser buildUserModel(lite.ResultSet doc, Store<AppState> store) {
    final List<Map<String, dynamic>> model = doc.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();

    // (richard): right now dealing with one user will support multi user in near future.
    return FUser(
      (FUserBuilder u) => u
        ..id = model[0][dbName]['businesses']['name']
        ..email = model[0][dbName]['email']
        ..name = model[0][dbName][dbName]['name']
        ..createdAt = model[0][dbName][dbName]['createdAt']
        ..updatedAt = model[0][dbName][dbName]['ceatedAt']
        ..active = model[0][dbName][dbName]['active']
        ..token = model[0][dbName][dbName]['token'],
    );
  }

  List<Business> buildBusinessModel(lite.ResultSet doc, Store<AppState> store) {
    final List<Business> business = [];

    final List<Map<String, dynamic>> model = doc.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();
    // ignore: always_specify_types
    if (model.isEmpty) {
      return [];
    }
    // ignore: always_specify_types
    final r = model[0][dbName]['businesses'];
    for (int i = 0; i < r.length; i++) {
      business.add(Business((BusinessBuilder b) => b
        ..name = r[i]['name']
        ..id = r[i]['id']
        ..currency = r[i]['currency']
        ..categoryId = r[i]['categoryId'].toString()
        ..country = r[i]['country']
        ..userId = r[i]['userId'].toString()
        ..active = r[i]['active']
        ..typeId = r[i]['typeId'].toString()
        ..userId = r[i]['userId'].toString()
        ..timeZone = r[i]['timeZone']
        ..businessUrl = r[i]['businessUrl']
        ..createdAt = r[i]['country']));
    }
    return business;
  }

  List<Branch> buildBranchModel(lite.ResultSet doc, Store<AppState> store) {
    final List<Branch> branch = [];

    final List<Map<String, dynamic>> model = doc.map((lite.Result result) {
      // return Beer.fromMap();
      return result.toMap();
    }).toList();

    // ignore: always_specify_types
    if (model.isEmpty) {
      return [];
    }
    final r = model[0][dbName]['branches'];
    for (int i = 0; i < r.length; i++) {
      branch.add(Branch((BranchBuilder b) => b
        ..name = r[i]['name']
        ..id = r[i]['id']
        ..active = r[i]['active']
        ..businessId = r[i]['businessId'].toString()
        ..createdAt = r[i]['createdAt']
        ..mapLatitude = r[i]['mapLatitude'].toString()
        ..mapLongitude = r[i]['mapLongitude'].toString()
        ..mapLongitude = r[i]['mapLongitude'].toString()
        ..updatedAt = r[i]['updatedAt']));
    }
    return branch;
  }

  Future<dynamic> createProduct(Map map) async {
    assert(map['_id'] != null);

    final lite.Document products = await database.document(map['id']);

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

    // ignore: always_specify_types
    final List m = [map];
    products
        .toMutable()
        .setList('products', m)
        .setString('uid', Uuid().v1())
        .setString('_id', map['_id']);
    return await database.saveDocument(products);
  }

  Future<dynamic> createVariant(Map map) async {
    assert(map['_id'] != null);

    final lite.Document variants = await database.document(map['id']);

    assert(map['channel'] != null);
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
        .setList('channels', [map['channel']])
        .setString('uid', Uuid().v1())
        .setString('_id', map['_id']);

    return await database.saveDocument(variants);
  }

  Future<dynamic> createBranchProduct(Map map) async {
    assert(map['_id'] != null);

    assert(map['channel'] != null);
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
            .setList('channels', [map['channel']])
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

    assert(map['channel'] != null);
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
            .setList('channels', [map['channel']])
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

    stocks
        .toMutable()
        .setList('stocks', m)
        .setString('channel', map['channel'])
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

  Future<void> syncProduct(String productId, Store<AppState> store) async {
    // get product sync it to couch db
    // get product variants sync them too
    // get stock of each variant and sync them each to couch
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
          product.categoryId, //pet store lite default id when signup on mobile
      'channel': store.state.userId.toString(),
      'businessId':
          product.businessId, //pet store lite default id when signup on mobile
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
    await createProduct(_mapProduct);

    //sync variants
    final List<VariationTableData> variations = await store
        .state.database.variationDao
        .getVariantByProductId(productId: productId);

    for (int i = 0; i < variations.length; i++) {
      final Map _mapVariant = {
        'name': variations[i].name,
        'productId': variations[i].productId,
        'id': variations[i].id,
        'channel': store.state.userId.toString(),
        'unit': variations[i].unit,
        'createdAt': variations[i].createdAt.toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'SKU': variations[i].sku,
        '_id': 'variants_' + store.state.userId.toString(),
      };
      //sync stock:
      final StockTableData stock = await store.state.database.stockDao
          .getStockByVariantId(
              variantId: variations[i].id, branchId: store.state.branch.id);

      //sync stock history:
      StockHistoryTableData history = await store.state.database.stockHistoryDao
          .getByVariantId(variantId: variations[i].id);
      if (history != null) {
        final Map _history = {
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

    final BranchProductTableData branchProduct = await store
        .state.database.branchProductDao
        .getBranchProduct(productId: productId);
    final Map _mapBranchProduct = {
      'id': branchProduct.id,
      'branchId': branchProduct.branchId,
      'productId': branchProduct.productId,
      'channel': store.state.userId.toString(),
      '_id': 'branchProducts_' + store.state.userId.toString(),
    };
    await createBranchProduct(_mapBranchProduct);
  }

  //database listners, provide listners for database then sync
  //the data being touched or inserted this is the most effective way
  //of syncing small database changes so we can avoid 1MB constraints of couchDB.
  dbListner({Store<AppState> store}) {
    // store.state.database.listner.streamUpdate().listen((stock) {
    //   if (stock != null && stock.action != 'NONE') {
    //     insertHistory(store, stock);
    //   }
    // });

    // store.state.database.listner.streamInsert().listen((stock) {
    //   if (stock.action != 'NONE') {
    //     insertHistory(store, stock);
    //   }
    // });

    //now sync them.
    // store.state.database.listner.listenOnStockHistory().listen((history) {
    //   partialSyncHistory(history: history);
    // });
  }

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
