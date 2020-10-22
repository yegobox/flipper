import 'package:flipper/couchbase.dart';
import 'package:flipper/data/dao/item_variation.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/helper/constant.dart';
import 'package:flipper/services/proxy.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/utils/data_manager.dart';
import 'package:flipper/utils/logger.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

class GeneralRepository {
  Future<bool> insertOrUpdateCart(
      Store<AppState> store, OrderDetailTableData data) async {
    OrderDetailTableData existingCart = await store
        .state.database.orderDetailDao
        .getExistingCartItem(variationId: data.variationId);

    if (existingCart == null) {
      store.state.database.orderDetailDao.insert(
        data.copyWith(
          quantity: store.state.currentIncrement.toDouble(),
          subTotal: data.subTotal, //ask ganza what is a subtotal
          id: data.id,
          taxAmount: data.taxAmount, //get current active tax rate * amount /100
          taxRate: data.taxRate, //get the current active tax rate
          unit: data.unit, //get unit of this item sold should hav it.
          note: data.note, //keep it lik this.
          discountAmount: data.discountAmount,
          discountRate: data.discountRate,
          updatedAt: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );
      return true;
    } else {
      store.state.database.orderDetailDao.updateCart(
        data.copyWith(
          id: existingCart.id,
          idLocal: existingCart.idLocal,
          createdAt: DateTime.now(), //always keep today's date for the order .
          updatedAt: DateTime.now(),
        ),
      );
      return true;
    }
  }

  Future<void> insertOrUpdateColor(
      Store<AppState> store, ColorTableData data) async {
    //if item with the same variationId exist update content
    ColorTableData colorsExists =
        await store.state.database.colorDao.colorExists(data.name);
    if (colorsExists == null) {
      store.state.database.colorDao.insert(data);
    }
  }

  Future<Order> createDraftOrderOrReturnExistingOne(
      Store<AppState> store) async {
         final Logger log = Logging.getLogger('General repo ....');
    // OrderTableData order =
    //     await store.state.database.orderDao.getExistingDraftOrder();
    final DatabaseService _databaseService = ProxyService.database;
    final List<Map<String, dynamic>> or = await _databaseService.filter(
      equator: 'draft',
      property: 'name',
      and: true,
      andProperty: 'table',
      andEquator: AppTables.order + store.state.branch.id,
    );
    if (or.isEmpty) {
      // ignore: always_specify_types
      final       String id = Uuid().v1();
      _databaseService.insert(id:id, data: {
        'name': 'draft',
        'id':id,
        'branchId': store.state.branch.id,
        'table':  AppTables.order + store.state.branch.id
      });
      
      final List<Map<String, dynamic>> or = await _databaseService.filter(
        equator: 'draft',
        property: 'name',
        and: true,
        andProperty: 'table',
        andEquator: AppTables.order + store.state.branch.id,
      );
      
      final Order order = Order.fromMap(or[0][AppDatabase.instance.dbName]);
      dispatchOrder(store, order);
      return order;
    } else {
      
      final Order order = Order.fromMap(or[0][AppDatabase.instance.dbName]);
      dispatchOrder(store, order);
      return order;
    }
  }

  Future<int> insertTabs(Store<AppState> store, int value) {
    //ignore:missing_required_param
    final TabsTableData tab = TabsTableData(tab: value, id: 1);
    return store.state.database.tabsDao.insert(tab);
  }

  Future<bool> updateCategory(Store<AppState> store, String categoryId,
      String categoryName, String branchId,
      {bool focused}) async {
    final DatabaseService _databaseService = ProxyService.database;
    final Document cat = await _databaseService.getById(id: categoryId);
    if (cat != null) {
      cat
          .toMutable()
          .setString('name', categoryName)
          .setString('branchId', branchId)
          .setString('updatedAt', DateTime.now().toIso8601String())
          .setBoolean('focused', focused);
      return await _databaseService.update(document: cat);
    }
    return false;
  }

  Future<bool> updateTab(Store<AppState> store, int value) {
    //ignore:missing_required_param
    final TabsTableData b = TabsTableData(id: 1, tab: value);
    return store.state.database.tabsDao.updateTab(b);
  }

  Future<bool> updateUnit(Store<AppState> store, Unit unit) {
    //ignore:missing_required_param
    // final UnitTableData b = UnitTableData(
    //     id: unit.id, name: unit.name, focused: unit.focused, value: null);
    // return store.state.database.unitDao.updateUnit(b);
  }

  Future<TabsTableData> getTab(Store<AppState> store) {
    return store.state.database.tabsDao.getTab();
  }

  Future<List<UnitTableData>> getUnits(Store<AppState> store) {
    return store.state.database.unitDao.getUnits();
  }

  Future<dynamic> insertItem(Store<AppState> store, Product data) async {
    return DataManager.insertProduct(store, data);
  }

  Future<List<CategoryTableData>> getCategories(Store<AppState> store) {
    return store.state.database.categoryDao.getCategories();
  }

  Future<void> insertCustomCategory(
      Store<AppState> store, CategoryTableData category) async {
    CategoryTableData categoryData =
        await store.state.database.categoryDao.getCategoryName(category.name);
    if (categoryData == null) {
      store.state.database.categoryDao
          .insert(category.copyWith(createdAt: DateTime.now()));
    }

    categoryData =
        await store.state.database.categoryDao.getCategoryName(category.name);
  }

  Future<int> insertCategory(
      Store<AppState> store, CategoryTableData category) async {
    CategoryTableData existingCategory =
        await store.state.database.categoryDao.getCategoryName(category.name);
    if (existingCategory == null) {
      return store.state.database.categoryDao.insert(category);
    }
    store.state.database.categoryDao
        .updateCategory(category.copyWith(updatedAt: DateTime.now()));
    existingCategory =
        await store.state.database.categoryDao.getCategoryName(category.name);
    return existingCategory.idLocal;
  }

  Future<void> insertVariant(Store<AppState> store, Variation data) async {
    final DatabaseService _databaseService = ProxyService.database;
    _databaseService.insert(id: Uuid().v1(), data: data.toMap());
  }
}

Future<void> insertHistory(Store<AppState> store, int variantId, int count) {
  final DatabaseService _databaseService = ProxyService.database;
  // TODO(richard): inset a history here.
  // return store.state.database.stockHistoryDao
  //     // ignore: missing_required_param
  //     .insert(StockHistoryTableData(quantity: count, variantId: variantId));
}

Future<List<ProductTableData>> getItems(Store<AppState> store) {
  return store.state.database.productDao.getProducts();
}

Future<List<ItemVariation>> getItemVariation(Store<AppState> store) {
//    return store.state.database.productDao.getItemVariations();
}

Future<List<VariationTableData>> getVariations(
    {Store<AppState> store, String productId}) {
  return store.state.database.variationDao.getItemVariations(productId);
}

Stream<List<OrderDetailTableData>> getCarts(Store<AppState> store) {
  return store.state.database.orderDetailDao
      .getCartsStream(store.state.order.id.toString());
}

Future<List<VariationTableData>> getVariationsByItems(
    Store<AppState> store, String productId) async {
  return await store.state.database.variationDao
      .getVariationByItemId(productId: productId);
}

Future<bool> updateOrder(Store<AppState> store, OrderTableData order) async {
  return await store.state.database.orderDao.updateOrder(order);
}

Future<OrderTableData> getOrder(Store<AppState> store, String orderId) async {
  return await store.state.database.orderDao.getOrderById(orderId);
}

Future<VariationTableData> getVariationById(
    Store<AppState> store, String variantId) async {
  // return await store.state.database.variationDao.getVariationById(variantId);
}

Future<void> insertNewDraftOrder(Store<AppState> store) async {
  if (store.state.branch != null) {
    return await store.state.database.orderDao.insert(
      //ignore: missing_required_param
      OrderTableData(
        status: 'draft',
        branchId: store.state.branch.id,
        id: Uuid().v1(),
        currency: 'RWF',
        deviceId: Uuid().v1(),
        orderDate: DateTime.now(),
        isDraft: true,
        orderType: 'sales',
        reference: Uuid().v1(),
        cashReceived: 0,
        customerChangeDue: 0,
        customerSaving: 0,
        deliverDate: DateTime.now(),
        discountAmount: 0,
        discountRate: 0,
        orderNote: 'none',
        variantName: 'custom',
        count: 1,
        orderNUmber: 0,
        paymentId: 0,
        saleTotal: 0,
        subTotal: 0,
        supplierId: 0,
        supplierInvoiceNumber: 0,
        taxAmount: 0,
        taxRate: 0,
        // userId: store.state.user.id,
      ),
    );
  }
}

void dispatchOrder(Store<AppState> store, Order order) {
  return store.dispatch(OrderCreated(
    order: order,
  ));
}
