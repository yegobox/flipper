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
  Category get category{
    return _category;
  }
  final _sharedStateService = locator<SharedStateService>();

  // this is a product to edit later on and add variation on it.
  Future createTemporalProduct({String productName, String userId}) async {
    
    log.i('adding product'+_sharedStateService.business.id);
    final DatabaseService _databaseService = ProxyService.database;
    
    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE AND name=\$NAME');

    q.parameters = {'VALUE': AppTables.category,'NAME':'custom'};

    final categories = q.execute();

    if (categories.isNotEmpty) {
   
      for (Map map in categories) {
        map.forEach((key,value){
           _category = Category.fromMap(value);
        });
        notifyListeners();
      }
    }
   
    final product = Query(
        _databaseService.db, 'SELECT * WHERE table=\$VALUE AND name=\$NAME');

    product.parameters = {'VALUE': AppTables.product, 'NAME': productName};

    final gettax = Query(
        _databaseService.db, 'SELECT * WHERE table=\$VALUE AND name=\$NAME');

    gettax.parameters = {'VALUE': AppTables.tax, 'NAME': 'Vat'};

    final taxResults = gettax.execute();
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
      final Document productDoc = _databaseService.insert(data: {
        'name': productName,
        'categoryId': category.id,
        'color': '#955be9',
        'id': Uuid().v1(),
        'active': true,
        'hasPicture': false,
        'channels': <String>[userId],
        'table': AppTables.product,
        'isCurrentUpdate': false,
        'isDraft': true,
        'taxId': _taxId,
        'businessId': _sharedStateService.business.id,
        'description': productName,
        'createdAt': DateTime.now().toIso8601String(),
      });

      final Document variant = _databaseService.insert(data: {
        'isActive': false,
        'name': 'Regular',
        'unit': 'kg',
        'channels': <String>[userId],
        'table': AppTables.variation,
        'productId': productDoc.ID,
        'sku': Uuid().v1().substring(0, 4),
        'id': Uuid().v1(),
        'createdAt': DateTime.now().toIso8601String(),
      });

       _databaseService.insert(data: {
        'variantId': variant.ID,
        'supplyPrice': 0,
        'canTrackingStock': false,
        'showLowStockAlert': false,
        'retailPrice': 0,
        'channels': [userId],
        'isActive': true,
        'table': AppTables.stock,
        'lowStock': 0,
        'currentStock': 0,
        'id': Uuid().v1(),
        'productId': productDoc.ID,
        'branchId': _sharedStateService.branch.id,
        'createdAt': DateTime.now().toIso8601String(),
      });

       _databaseService.insert(data: {
        'branchId': _sharedStateService.branch.id,
        'productId': productDoc.ID,
        'table': AppTables.branchProduct,
        'id': Uuid().v1()
      });
      log.d('productId:'+ productDoc.ID);
      return productDoc.ID;
    } else {
     
        for (Map map in productResults) {
          map.forEach((key, value) {
            _productId = Product.fromMap(value).id;
          });
          notifyListeners();
        }
        log.d('productId:'+productId);
        return productId;
    }
  }

  void navigateAddProduct() {
    final FlipperNavigationService _navigationService = ProxyService.nav;
    _navigationService.navigateTo(Routing.addProduct);
  }
}
