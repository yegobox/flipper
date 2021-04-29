import 'dart:convert';

import 'package:flipper_models/models/variant_stock.dart';
import 'package:flipper_models/models/unit.dart';

import 'package:flipper_models/models/sync.dart';

import 'package:flipper_models/models/stock.dart';

import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/variation.dart';

import 'package:flipper_models/models/login.dart';

import 'package:flipper_models/models/color.dart';

import 'package:flipper_models/models/category.dart';

import 'package:flipper_models/models/branch.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/models/business.dart';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'Queries.dart';
import 'abstractions/api.dart';
import 'constants.dart';
import 'http_api.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class LiteApi<T> implements Api {
  Replicator? replicator;
  Database db = Database("main_01");
  ExtendedClient client = ExtendedClient(http.Client());
  String flipperApi = "https://flipper.yegobox.com";
  String apihub = "https://apihub.yegobox.com";
  dynamic Q14;
  dynamic Q15;
  dynamic Q9;
  dynamic Q12;
  dynamic Q10;
  dynamic Q16;
  dynamic Q17;
  dynamic Q18;
  dynamic Q5;
  registerQueries() {
    Q14 = Query(db, Queries.Q_14);
    Q15 = Query(db, Queries.Q_15);
    Q9 = Query(db, Queries.Q_9);
    Q12 = Query(db, Queries.Q_12);
    Q10 = Query(db, Queries.Q_10);
    Q16 = Query(db, Queries.Q_16);
    Q17 = Query(db, Queries.Q_17);
    Q18 = Query(db, Queries.Q_18);
    Q5 = Query(db, Queries.Q_5);
  }

  LiteApi({required Database database}) {
    db = database;
    init();
    //pre-register queries
  }
  init() async {
    //start the database
    // final Directory appDocDir = await getApplicationDocumentsDirectory();
    // final String appDocPath = appDocDir.path;
    // ignore: prefer_single_quotes
    // db = Database("main", directory: appDocPath);
    print(db);
    if (!db.isOpen) {
      db.open();
    }
    registerQueries();

    // final FlipperConfig flipperConfig =
    //     await ProxyService.firestore.getConfigs();
    // if (flipperConfig == null) {
    //   return null;
    // }
    // final String gatewayUrl = flipperConfig.gateway;
    // final String username = flipperConfig.username;
    // final String password = flipperConfig.password;

    // assert(gatewayUrl != null);
    // assert(username != null);
    // assert(password != null);
    final gatewayUrl = "yegobox.com:4985";
    replicator = Replicator(
      db,
      endpointUrl: 'ws://$gatewayUrl/main/',
      username: 'admin',
      password: 'iloveaurore',
      channels: ["300"],
      continuous: true,
      //in dev use pushAndPull to keep experimental otherwise push only.
      replicatorType: ReplicatorType.pushAndPull,
    );

    // Set up a status listener
    replicator!.addChangeListener((status) {
      print('Replicator status: ' + status.activityLevel.toString());
    });
    replicator!.start();
  }

  @override
  Future<Sync> authenticateWithOfflineDb({required String userId}) async {
    final response = await client.post(Uri.parse("$apihub/auth"),
        body: jsonEncode({'userId': userId}),
        headers: {'Content-Type': 'application/json'});

    ProxyService.box
        .write(key: 'bearerToken', value: syncFromJson(response.body).token);
    ProxyService.box
        .write(key: 'userId', value: syncFromJson(response.body).userId);
    return syncFromJson(response.body);
  }

  @override
  Future<List<Branch>> branches({required String businessId}) async {
    Q15.parameters = {'T': AppTables.branch, 'BUSINESSID': businessId};
    final ResultSet result = Q15.execute();
    final List<Branch> branches = [];
    for (Map map in result.allResults) {
      branches.add(sbranchFromJson(jsonEncode(map)));
    }
    return branches;
  }

  @override
  Future<List<Business>> businesses() async {
    Q14.parameters = {'VALUE': AppTables.business};
    final ResultSet business = Q14.execute();
    final List<Business> businesses = [];
    for (Map map in business.allResults) {
      businesses.add(sbusinessFromJson(jsonEncode(map)));
    }
    return businesses;
  }

  @override
  Future<List<Category>> categories({required String branchId}) async {
    Q9.parameters = {'VALUE': AppTables.category, 'BRANCHID': branchId};
    final ResultSet business = Q9.execute();
    final List<Category> categories = [];
    for (Map map in business.allResults) {
      categories.add(scategoryFromJson(jsonEncode(map)));
    }
    return categories;
  }

  @override
  Future<List<PColor>> colors({required String branchId}) async {
    Q12.parameters = {'T': AppTables.color, 'BRANCHID': branchId};
    final ResultSet business = Q12.execute();
    final List<PColor> colors = [];
    for (Map map in business.allResults) {
      if (map['name'] != null &&
          map['id'] != null &&
          map['table'] != null &&
          map['branchId'] != null &&
          map['active'] != null) {
        colors.add(spColorFromJson(jsonEncode(map)));
      }
    }
    return colors;
  }

  @override
  Future<int> create<T>({required Map data, required String endPoint}) async {
    final doc = Document(data['id'], data: data);

    db.saveDocument(doc);
    return 200;
  }

  @override
  Future<Product> createProduct({required Product product}) async {
    final doc = Document(product.id, data: product.toJson());

    final Document productDocument = db.saveDocument(doc);
    //create  variation
    final id = Uuid().v1();
    final String? userId = ProxyService.box.read(key: 'userId');
    final String? branchId = ProxyService.box.read(key: 'branchId');
    final Map productMap = json.decode(productDocument.json);
    final variation = new Variation(
      id: id,
      name: 'Regular',
      sku: 'sku',
      productId: productMap['id'],
      unit: 'Per Item',
      table: AppTables.variation,
      channels: [userId!],
      productName: productMap['name'],
      currentStock: 0.0,
      lowStock: 0.0,
      supplyPrice: 0.0,
      retailPrice: 0.0,
      canTrackingStock: false,
      stockId: 'XX',
      branchId: branchId!,
    );
    final variationDoc = Document(variation.id, data: variation.toJson());
    final Document variationDocument = db.saveDocument(variationDoc);
    final stockId = Uuid().v1() + '-STOCK';
    final Map variationMap = json.decode(variationDocument.json);
    //create stock now.

    final stock = new Stock(
      id: stockId,
      value: 0.0,
      branchId: branchId,
      variantId: variationMap['id'],
      lowStock: 0.0,
      currentStock: 0.0,
      supplyPrice: 0.0,
      retailPrice: 0.0,
      canTrackingStock: false,
      showLowStockAlert: false,
      channels: [userId],
      table: AppTables.stock,
      productId: productMap['id'],
      active: false,
    );
    final Document stockDoc = Document(stock.id, data: stock.toJson());
    db.saveDocument(stockDoc);

    return sproductFromJson(productDocument.json);
  }

  @override
  Future<List<Product>> isTempProductExist() async {
    Q5!.parameters = {'T': AppTables.product, 'NAME': 'temp'};
    final ResultSet product = Q5.execute();
    final List<Product> p = [];
    for (Map map in product.allResults) {
      p.add(sproductFromJson(jsonEncode(map)));
    }
    return p;
  }

  @override
  Future<bool> logOut() async {
    ProxyService.box.remove(key: 'userId');
    ProxyService.box.remove(key: 'bearerToken');
    return true;
  }

  @override
  Future<Login> login({required String phone}) async {
    final response = await client
        .post(Uri.parse("$flipperApi/open-login"), body: {'phone': phone});
    final Login resp = loginFromJson(response.body);
    ProxyService.box.write(key: 'UToken', value: resp.token);
    return resp;
  }

  @override
  Future<List<Product>> products() async {
    Q16.parameters = {'T': AppTables.product};
    final ResultSet product = Q16.execute();
    final List<Product> p = [];
    for (Map map in product.allResults) {
      p.add(sproductFromJson(jsonEncode(map)));
    }
    return p;
  }

  @override
  Future<int> signup({required Map business}) async {
    final http.Response response = await client.post(
        Uri.parse("$apihub/api/business"),
        body: jsonEncode(business),
        headers: {'Content-Type': 'application/json'});
    return response.statusCode;
  }

  @override
  Future<List<Stock>> stocks({required String productId}) async {
    // TODO: implement when internet is available to load from internet and when not load from local
    final response = await client
        .get(Uri.parse("$apihub/api/stocks-byProductId/$productId"));

    return stockFromJson(response.body);
  }

  @override
  Future<List<Unit>> units({required String branchId}) async {
    Q10.parameters = {'T': AppTables.unit, 'BRANCHID': branchId};
    final ResultSet business = Q10.execute();
    final List<Unit> units = [];
    for (Map map in business.allResults) {
      if (map['name'] != null && map['focused'] != null && map['id'] != null) {
        units.add(sunitFromJson(jsonEncode(map)));
      }
    }
    return units;
  }

  @override
  Future<int> update<T>({required Map data, required String endPoint}) async {
    final Map dn = data;
    Document doc = db.getMutableDocument(dn['id']);
    data.forEach((key, value) {
      doc.properties[key] = value;
    });
    db.saveDocument(doc);
    return 1;
  }

  @override
  Future<List<VariantStock>> variantProduct(
      {required String branchId, required String productId}) async {
    Q17.parameters = {'T': AppTables.variation, 'PRODUCTID': productId};
    final ResultSet business = Q17.execute();
    final List<VariantStock> variantStocks = [];
    for (Map map in business.allResults) {
      variantStocks.add(svariantStockFromJson(jsonEncode(map)));
    }
    // TODO: change algorithm since join is a joke!
    // get the proeuct
    // get variants
    // get stock merge what I want into variantStock map then
    // use  variantStocks.add(svariantStockFromJson(jsonEncode(map))); on that map.
    return variantStocks;
  }

  @override
  Future<List<VariantStock>> variantStock(
      {required String branchId, required String variantId}) async {
    Q17.parameters = {'T': AppTables.variation, 'VARIANTID': variantId};
    final ResultSet business = Q17.execute();
    final List<VariantStock> variantStocks = [];
    for (Map map in business.allResults) {
      variantStocks.add(svariantStockFromJson(jsonEncode(map)));
    }
    return variantStocks;
  }

  @override
  Future<bool> delete({required String id, String? endPoint}) async {
    db.purgeDocument(id);
    return true;
  }

  @override
  Future<int> addUnits({required Map data}) async {
    for (Map map in data['units']) {
      final unitId = Uuid().v1();
      map['id'] = unitId;
      map['table'] = AppTables.unit;
      final doc = Document(unitId, data: map);
      db.saveDocument(doc);
    }
    return 200;
  }

  @override
  Future<PColor> getColor({required String id, String? endPoint}) async {
    //transform this into
    Document doc = db.getDocument(id);
    return spColorFromJson(doc.json);
  }
}
