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
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/services/shared_state_service.dart';

class AddProductModalViewModal extends BaseModel {
  // this is a product to edit later on and add variation on it.
  Future createTemporalProduct({String productName, String userId}) async {
    final Logger log = Logging.getLogger('Data manager   Model ....');
    final _sharedStateService = locator<SharedStateService>();

    final DatabaseService _databaseService = ProxyService.database;

    final category = await _databaseService.filter(
      equator: AppTables.category,
      property: 'table',
      and: true,
      andEquator: 'custom',
      andProperty: 'name',
    );

    final List<Map<String, dynamic>> product = await _databaseService.filter(
      equator: productName,
      property: 'name',
      and: true,
      andProperty: 'table',
      andEquator: AppTables.product,
    );

    final List<Map<String, dynamic>> gettax = await _databaseService.filter(
      equator: AppTables.tax,
      property: 'table',
      and: true,
      andEquator: 'Vat',
      andProperty: 'name',
    );
    log.d('categoryId:' + Category.fromMap(category[0]['main']).id);
    log.d('taxId:' + Tax.fromMap(gettax[0]['main']).id);

    if (!product.isEmpty) {
      final Document productDoc = await _databaseService.insert(data: {
        'name': 'productName',
        'categoryId': Category.fromMap(category[0]['main']).id,
        'color': '#955be9',
        'id': Uuid().v1(),
        'active': true,
        'hasPicture': false,
        'channels': <String>[userId],
        'table': AppTables.product,
        'isCurrentUpdate': false,
        'isDraft': true,
        'taxId': Tax.fromMap(gettax[0]['main']).id,
        'businessId': _sharedStateService.product.id,
        'description': productName,
        'createdAt': DateTime.now().toIso8601String(),
      });

      final Document variant = await _databaseService.insert(data: {
        'isActive': false,
        'name': 'Regular',
        'unit': 'kg',
        'channels': <String>[userId],
        'table': AppTables.variation,
        'productId': productDoc.id,
        'sku': Uuid().v1().substring(0, 4),
        'id': Uuid().v1(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      await _databaseService.insert(data: {
        'variantId': variant.id,
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
        'productId': productDoc.id,
        'branchId': _sharedStateService.branch.id,
        'createdAt': DateTime.now().toIso8601String(),
      });

      await _databaseService.insert(data: {
        'branchId': _sharedStateService.branch.id,
        'productId': productDoc.id,
        'table': AppTables.branchProduct,
        'id': Uuid().v1()
      });
      log.d(productDoc);
      return productDoc.id;
    } else {
      final Product pro = Product.fromMap(product[0]['main']);
      log.d(pro);
      return pro.id;
    }
  }

  void navigateAddProduct() {
      final FlipperNavigationService _navigationService = ProxyService.nav;
      _navigationService.navigateTo(Routing.addProduct);
    }
}
