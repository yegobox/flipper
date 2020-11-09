import 'package:flipper/core_db.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:couchbase_lite/couchbase_lite.dart';


class ProductsViewModel extends BaseModel {
  final Logger log = Logging.getLogger('product observer:)');

  String _branchId;
  String _businessId;
  final DatabaseService _databaseService = ProxyService.database;
  final List<Product> _products = <Product>[];

  List<Product> get data => _products;

  Future<bool> isCategory({String branchId}) async {
    final DatabaseService _databaseService = ProxyService.database;
    final List<Map<String, dynamic>> category = await _databaseService.filter(
      equator: 'custom',
      property: 'name',
      and: true,
      andProperty: 'table',
      andEquator: AppTables.category,
    );
    return category.isNotEmpty;
  }

  String get branchId {
    return _branchId;
  }

  String get businessId {
    return _businessId;
  }

  Future initializeNeededIds({@required userId}) async {
    setBusy(true);
    //load the branch
    final DatabaseService _databaseService = ProxyService.database;
    final List<Map<String, dynamic>> branche = await _databaseService.filter(
      equator: AppTables.branch,
      property: 'table',
    );
    List<Branch> branches = [];
    if (branche.isNotEmpty) {
      // ignore: unnecessary_type_check
      if (branche[0][CoreDB.instance.dbName] is Object) {
        branches.add(Branch.fromMap(branche[0][CoreDB.instance.dbName]));
      } else {
        branches = branche[0][CoreDB.instance.dbName]
            .map((e) => Branch.fromMap(e))
            .toList();
      }
    }

    for (Branch branch in branches) {
      if (branch.active) {
        _branchId = branch.id;
      }
    }

    // load busines
    final List<Map<String, dynamic>> doc = await _databaseService.filter(
      equator: AppTables.business,
      property: 'table',
      and: true, //define that this query is and type.
      andEquator: userId,
      andProperty: 'userId',
    );

    final List<Business> businesses = [];

    if (doc.isNotEmpty) {
      // log.i(doc[0]['main']);
      businesses.add(Business.fromMap(doc[0]['main']));
    }

    for (Business business in businesses) {
      if (business.active) {
        _businessId = business.id;
      }
    }
    notifyListeners();
    setBusy(false);
  }

  void getProducts({BuildContext context}) {
    setBusy(true);

    _databaseService
        .observer(equator: AppTables.product, property: 'table')
        .stream
        .listen((ResultSet event) {
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();

      // remove unnecessarry nesting "main"appended on each map value
      for (Map<String, dynamic> map in model) {
        // ignore: always_specify_types
        // ignore: always_specify_types
        map.forEach((String key, value) {
          _products.add(Product.fromMap(value));
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }

  // selling a product
  void shouldSeeItemOnly(BuildContext context, Product product) {
    final FlipperNavigationService _navigationService = ProxyService.nav;

    // _navigationService.navigateTo(
    //   Routing.viewSingleItem,
    //   arguments: ViewSingleItemScreenArguments(
    //     productId: product.id,
    //     itemName: product.name,
    //     itemColor: product.color,
    //   ),
    // );
  }

  void onSellingItem(BuildContext context, Product product) async {
    // TODO(telesphore): finish selling process.
    // final List<Variation> variants = await buildVariantsList(context, product);

    // _navigationService.navigateTo(Routing.editQuantityItemScreen,
    //     arguments: ChangeQuantityForSellingArguments(productId: product.id));
  }
}
