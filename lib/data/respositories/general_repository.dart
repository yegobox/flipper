import 'package:flipper/data/dao/item_variation.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/managers/dialog_manager.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

class GeneralRepository {
  Future<int> insertTabs(Store<AppState> store, int value) {
    //ignore:missing_required_param
    var tab = new TabsTableData(tab: value, id: 1);
    return store.state.database.tabsDao.insert(tab);
  }

  Future<bool> updateCategory(
      Store<AppState> store, int categoryId, String categoryName, int branchId,
      {bool focused}) async {
    Manager.deprecatedNotification();
    // final cat =
    //     await store.state.database.categoryDao.getCategoryById(categoryId);

    // if (cat == null) {
    //   return false;
    // }
    // //ignore:missing_required_param
    // final updated = CategoryTableData(
    //   name: categoryName ?? cat.name,
    //   id: cat.id,
    //   focused: focused,
    //   branchId: branchId,
    //   updatedAt: DateTime.now(),
    // );

    // return store.state.database.categoryDao.updateCategory(updated);
  }

  Future<bool> updateTab(Store<AppState> store, int value) {
    //ignore:missing_required_param
    final b = TabsTableData(id: 1, tab: value);
    return store.state.database.tabsDao.updateTab(b);
  }

  Future<bool> updateUnit(Store<AppState> store, Unit unit) {
    //ignore:missing_required_param
    final b =
        UnitTableData(id: unit.id, name: unit.name, focused: unit.focused);
    return store.state.database.unitDao.updateUnit(b);
  }

  Future<TabsTableData> getTab(Store<AppState> store) {
    return store.state.database.tabsDao.getTab();
  }

  Future<List<UnitTableData>> getUnits(Store<AppState> store) {
    return store.state.database.unitDao.getUnits();
  }

  Future<int> insertItem(Store<AppState> store, ProductTableData data) async {
    return DataManager.insertProduct(store, data);
  }

  Future<List<CategoryTableData>> getCategories(Store<AppState> store) {
    return store.state.database.categoryDao.getCategories();
  }

  Future<int> insertCustomCategory(
      Store<AppState> store, CategoryTableData category) async {
    CategoryTableData categoryData =
        await store.state.database.categoryDao.getCategoryName(category.name);
    if (categoryData == null) {
      store.state.database.categoryDao
          .insert(category.copyWith(createdAt: DateTime.now()));
    }

    categoryData =
        await store.state.database.categoryDao.getCategoryName(category.name);

    Manager.deprecatedNotification();
    // store.dispatch(
    //   CustomCategory(
    //     category: Category(
    //       (u) => u
    //         ..name = categoryData.name
    //         ..focused = categoryData.focused
    //         ..branchId = categoryData.branchId
    //         ..id = categoryData.id,
    //     ),
    //   ),
    // );

    // return categoryData.id;
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

  Future<int> insertVariant(
      Store<AppState> store, VariationTableData data) async {
    //insert or update if exist
    // VariationTableData exist;
    // if (data.name == 'Regular') {
    //   exist = await store.state.database.variationDao.getVariationById(data.id);
    // } else {
    //   exist = await store.state.database.variationDao.getVariationBy(data.id);
    // }

    // if (exist != null) {
    //   store.state.database.variationDao.updateVariation(
    //       exist.copyWith(name: data.name, updatedAt: DateTime.now()));
    //   return 1;
    // } else {
    //   return store.state.database.variationDao.insert(data);
    // }
  }

  Future<int> insertHistory(Store<AppState> store, int variantId, int count) {
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

  Future insertOrUpdateColor(Store<AppState> store, ColorTableData data) async {
    //if item with the same variationId exist update content
    ColorTableData colorsExists =
        await store.state.database.colorDao.colorExists(data.name);
    if (colorsExists == null) {
      store.state.database.colorDao.insert(data);
    }
  }

  Future<List<VariationTableData>> getVariationsByItems(
      Store<AppState> store, String productId) async {
    return await store.state.database.variationDao
        .getVariationByItemId(productId: productId);
  }

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

  Future<OrderTableData> createDraftOrderOrReturnExistingOne(
      Store<AppState> store) async {
    OrderTableData order =
        await store.state.database.orderDao.getExistingDraftOrder();
    if (order != null) {
      dispatchOrder(store, order);
      return order;
    } else {
      await insertNewDraftOrder(store);
      OrderTableData order =
          await store.state.database.orderDao.getExistingDraftOrder();
      dispatchOrder(store, order);
      return order;
    }
  }

  Future insertNewDraftOrder(Store<AppState> store) async {
    if (store.state.branch == null) return null;
    return await store.state.database.orderDao.insert(
      //ignore: missing_required_param
      OrderTableData(
        status: 'draft',
        branchId: store.state.branch.id,
        id: Uuid().v1(),
        currency: 'RWF', // TODO(richard): change dummy
        deviceId: Uuid().v1(), // TODO(richard): change dummy
        orderDate: DateTime.now(),
        isDraft: true,
        orderType: 'sales', // TODO(richard): change dummy
        reference: Uuid().v1(), // TODO(richard): change dummy.
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
        userId: store.state.userId,
      ),
    );
  }

  void dispatchOrder(Store<AppState> store, OrderTableData order) {
    return store.dispatch(OrderCreated(
      order: Order(
        (o) => o
          ..status = order.status
          ..id = order.id
          ..userId = store.state.userId
          ..branchId = order.branchId
          ..orderNote = order.orderNote
          ..orderNUmber = order.orderNUmber
          ..supplierId = order.supplierId
          ..subTotal = order.subTotal
          ..supplierInvoiceNumber = order.supplierInvoiceNumber
          ..deliverDate = order.deliverDate
          ..taxRate = order.taxRate
          ..discountAmount = order.discountAmount
          ..taxAmount = order.taxAmount
          ..cashReceived = order.cashReceived
          ..discountRate = order.discountRate
          ..saleTotal = order.saleTotal
          ..userId = order.userId
          ..customerSaving = order.customerSaving
          ..paymentId = order.paymentId
          ..orderNote = order.orderNote
          ..status = order.status
          ..customerChangeDue = order.customerChangeDue,
      ),
    ));
  }
}
