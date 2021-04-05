library flipper_models;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_models/branch.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class ProductsViewModel extends ReactiveViewModel {
  final Logger log = Logging.getLogger('product observer:)');

  final _sharedState = locator<SharedStateService>();

  String _branchId;
  String _businessId;
  final DatabaseService _databaseService = ProxyService.database;

  final List<Product> _products = <Product>[];

  List<Product> get products => _products;

  Future<bool> isCategory({String branchId}) async {
    final q = Query(
        _databaseService.db, 'SELECT * WHERE table=\$VALUE AND name=\$NAME');

    q.parameters = {'VALUE': AppTables.category, 'NAME': 'custom'};
    return q.execute().allResults.isNotEmpty;
  }

  String get branchId {
    return _branchId;
  }

  String get businessId {
    return _businessId;
  }

  /// @deprecated I have no idea why I created this functions whatsoever
  Future initializeNeededIds({@required userId}) async {
    setBusy(true);
    //load the branch
    final DatabaseService _databaseService = ProxyService.database;

    final branche = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE ');

    branche.parameters = {'VALUE': AppTables.branch};
    final branchResult = branche.execute();
    final List<Branch> branches = [];
    if (branchResult.allResults.isNotEmpty) {
      // ignore: unnecessary_type_check
      for (Map map in branchResult.allResults) {
        map.forEach((key, value) {
          if (!branches.contains(Branch.fromMap(value))) {
            branches.add(Branch.fromMap(value));
          }
        });
      }
    }

    for (Branch branch in branches) {
      if (branch.active) {
        _branchId = branch.id;
      }
    }
    final doc = Query(_databaseService.db,
        'SELECT * WHERE table=\$VALUE AND userId=\$USERID');

    doc.parameters = {'VALUE': AppTables.business, 'USERID': userId};

    final docResults = doc.execute();

    final List<Business> businesses = [];

    if (docResults.allResults.isNotEmpty) {
      for (Map map in docResults.allResults) {
        map.forEach((key, value) {
          if (!businesses.contains(Business.fromMap(value))) {
            businesses.add(Business.fromMap(value));
          }
        });
      }
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
    assert(_sharedState.branch.id != null);

    final q = Query(_databaseService.db,
        'SELECT name,id,description,picture,taxId,active,hasPicture,isImageLocal,touched,table,isDraft,color,isCurrentUpdate,businessId,supplierId,categoryId,createdAt,unit,updatedAt,count,channels WHERE table=\$VALUE AND branchId=\$BID');

    q.parameters = {'VALUE': AppTables.product, 'BID': _sharedState.branch.id};

    q.addChangeListener((results) {
      for (Map map in results.allResults) {
        if (!_products.contains(Product.fromMap(map))) {
          _products.add(Product.fromMap(map));
        }
      }
      notifyListeners();
    });
  }

  // selling a product
  void shouldSeeItemOnly(BuildContext context, Product product) {
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
    ProxyService.nav.navigateTo(
      Routing.onSellingView,
      arguments: OnSellingViewArguments(product: product),
    );
  }

  void navigateTo({@required String path}) {
    ProxyService.nav.navigateTo(path);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedState];

  /// given an ID of a product delete it from database
  /// this does not erase all transaction made on this product
  /// FIXME: decide if we mark the product as deleted but not entirely delete it!
  /// Also this does not delete related variants or stock but as the app
  /// improve we shall see a better solution.
  void deleteProduct({String productId}) {
    _databaseService.delete(id: productId);
    notifyListeners();
  }
}
