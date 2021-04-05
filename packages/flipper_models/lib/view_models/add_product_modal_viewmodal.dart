library flipper_models;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/tax.dart';
import 'package:flipper_models/view_models/Queries.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'base_model.dart';

class AddProductModalViewModal extends BaseModel {
  final Logger log = Logging.getLogger('Add Product:');

  String _taxId;
  String get taxId {
    return _taxId;
  }

  String _productId;
  String get productId {
    return _productId;
  }

  Category _category;
  Category get category {
    return _category;
  }

  final _sharedStateService = locator<SharedStateService>();

  // this is a product to edit later on and add variation on it.
  Future createTemporalProduct({String productName, String userId}) async {
    final DatabaseService _db = ProxyService.database;

    assert(_sharedStateService.branch.id != null);

    final q = Query(_db.db, Queries.Q_4);

    q.parameters = {'VALUE': AppTables.category, 'NAME': 'NONE'};

    final categories = q.execute();
    for (Map map in categories.allResults) {
      _category = Category.fromMap(map);
    }

    //  find tmp product
    final product = Query(_db.db, Queries.Q_5);

    product.parameters = {'VALUE': AppTables.product, 'NAME': productName};

    final getTax = Query(_db.db, Queries.Q_6);

    getTax.parameters = {'VALUE': AppTables.tax, 'NAME': 'Vat'};

    final taxResults = getTax.execute();
    final productResults = product.execute();
    final List t = productResults.allResults;
    if (t.isEmpty) {
      for (Map map in taxResults.allResults) {
        _taxId = Tax.fromMap(map).id;
      }
      notifyListeners();

      final id1 = Uuid().v1();

      final Document productDoc = _db.insert(id: id1, data: {
        'name': productName,
        'categoryId': category.id,
        'color': '#955be9',
        'id': id1,
        'active': true,
        'hasPicture': false,
        'channels': [userId],
        'table': AppTables.product,
        'isCurrentUpdate': false,
        'isDraft': true,
        'taxId': _taxId,
        'businessId': _sharedStateService.business.id,
        'branchId': _sharedStateService.branch.id,
        'description': productName,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // we make productDoc.ID equal to variation.ID on regular variant to make it easy to update the regular variant
      // otherwise other variant should have independent ID to avoid mixeup
      final variantId = Uuid().v1();
      _db.insert(id: variantId, data: {
        'isActive': false,
        'name': 'Regular',
        'unit': 'kg',
        'channels': [userId],
        'table': AppTables.variation,
        'productId': productDoc.ID,
        'sku': Uuid().v1().substring(0, 4),
        'id': variantId,
        'userId': userId,
        'productName': productName,
        'createdAt': DateTime.now().toIso8601String(),
      });

      final id3 = Uuid().v1();

      _db.insert(id: id3, data: {
        'variantId': variantId,
        'supplyPrice': 0.0,
        'canTrackingStock': false,
        'showLowStockAlert': false,
        'retailPrice': 0.0,
        'channels': [userId],
        'isActive': true,
        'table': AppTables.stock,
        'lowStock': 0.0,
        'currentStock': 0.0,
        'id': id3,
        'productId': productDoc.ID,
        'branchId': _sharedStateService.branch.id,
        'createdAt': DateTime.now().toIso8601String(),
      });
      final id4 = Uuid().v1();
      _db.insert(id: id4, data: {
        'branchId': _sharedStateService.branch.id,
        'productId': productDoc.ID,
        'table': AppTables.branchProduct,
        'id': id4
      });
      // log.d('productId:' + productDoc.ID);
      return productDoc.ID;
    } else {
      for (Map map in t) {
        _productId = Product.fromMap(map).id;
      }
      notifyListeners();
      return productId;
    }
  }

  void navigateAddProduct() {
    final FlipperNavigationService _navigationService = ProxyService.nav;
    _navigationService.navigateTo(Routing.addProduct);
  }
}
