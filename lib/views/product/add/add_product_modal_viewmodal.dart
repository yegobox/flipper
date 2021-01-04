import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/tax.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'package:flipper/services/shared_state_service.dart';

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
    final DatabaseService _databaseService = ProxyService.database;

    // log.d(userId);

    assert(_sharedStateService.branch.id != null);

    final q = Query(
        _databaseService.db, 'SELECT * WHERE table=\$VALUE AND name=\$NAME');

    q.parameters = {'VALUE': AppTables.category, 'NAME': 'NONE'};

    final categories = q.execute();

    if (categories.isNotEmpty) {
      for (Map map in categories) {
        map.forEach((key, value) {
          _category = Category.fromMap(value);
        });
        notifyListeners();
      }
    }
    //  find tmp product
    final product = Query(
        _databaseService.db, 'SELECT * WHERE table=\$VALUE AND name=\$NAME');

    product.parameters = {'VALUE': AppTables.product, 'NAME': productName};

    final getTax = Query(
        _databaseService.db, 'SELECT * WHERE table=\$VALUE AND name=\$NAME');

    getTax.parameters = {'VALUE': AppTables.tax, 'NAME': 'Vat'};

    final taxResults = getTax.execute();
    final productResults = product.execute();
    if (productResults.isEmpty) {
      if (taxResults.isNotEmpty) {
        for (Map map in taxResults) {
          map.forEach((key, value) {
            _taxId = Tax.fromMap(value).id;
          });
          notifyListeners();
        }
      }
      final id1 = Uuid().v1();

      final Document productDoc = _databaseService.insert(id: id1, data: {
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
      _databaseService.insert(id: variantId, data: {
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

      log.i(variantId);

      final id3 = Uuid().v1();
      _databaseService.insert(id: id3, data: {
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
      _databaseService.insert(id: id4, data: {
        'branchId': _sharedStateService.branch.id,
        'productId': productDoc.ID,
        'table': AppTables.branchProduct,
        'id': id4
      });
      // log.d('productId:' + productDoc.ID);
      return productDoc.ID;
    } else {
      for (Map map in productResults) {
        map.forEach((key, value) {
          _productId = Product.fromMap(value).id;
        });
        notifyListeners();
      }
      // log.d('productId:' + productId);

      return productId;
    }
  }

  void navigateAddProduct() {
    final FlipperNavigationService _navigationService = ProxyService.nav;
    _navigationService.navigateTo(Routing.addProduct);
  }
}
