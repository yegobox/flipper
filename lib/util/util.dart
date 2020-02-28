import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/item.dart';
import 'package:random_string/random_string.dart';
import 'package:redux/redux.dart';

class Util {
  static Future updateVariation({
    VariationTableData variation,
    Store<AppState> store,
    double retailPrice,
    double costPrice,
    String variantName,
  }) async {
    if (variation != null) {
      final stock = await store.state.database.stockDao.getStockByVariantId(
          branchId: store.state.branch.id, variantId: variation.id);
      final variant = await store.state.database.variationDao
          .getVariationById(variation.id);
      await store.state.database.variationDao
          .updateVariation(variant.copyWith(name: variantName));

      await store.state.database.stockDao.updateStock(
        stock.copyWith(
          retailPrice: retailPrice ?? stock.retailPrice,
          costPrice: costPrice ?? stock.costPrice,
        ),
      );
    }
  }

  static updateOrder(Store<AppState> store, OrderTableData order) {
    store.state.database.orderDao.updateOrder(order);
  }

  static removeItemFromTrash(Store<AppState> store, int itemId) async {
    ItemTableData item = await store.state.database.itemDao
        .getItemByIdBranch(branchId: store.state.branch.id, itemId: itemId);

    if (item == null) return;
    List<StockTableData> stocks = await store.state.database.stockDao
        .getItemFromStockByItemId(
            branchId: store.state.branch.id, itemId: item.id);
    for (var i = 0; i < stocks.length; i++) {
      VariationTableData variant = await store.state.database.variationDao
          .getVariationById(stocks[i].variantId);

      await store.state.database.variationDao
          .updateVariation(variant.copyWith(deletedAt: 'null'));

      await store.state.database.stockDao
          .updateStock(stocks[i].copyWith(deletedAt: 'null'));
    }
    store.state.database.itemDao.updateItem(item.copyWith(deletedAt: 'null'));
  }

  static deleteItem(Store<AppState> store, String itemName, int itemId) async {
    ItemTableData item = await store.state.database.itemDao.getItemBy(
        name: itemName, branchId: store.state.branch.id, itemId: itemId);

    if (item == null) return;
    List<StockTableData> stocks = await store.state.database.stockDao
        .getItemFromStockByItemId(
            branchId: store.state.branch.id, itemId: item.id);

    for (var i = 0; i < stocks.length; i++) {
      VariationTableData variant = await store.state.database.variationDao
          .getVariationById(stocks[i].variantId);

      await store.state.database.variationDao.softDelete(variant);

      await store.state.database.stockDao.softDelete(stocks[i]);
    }

    store.state.database.itemDao.softDelete(item);
  }

  static deleteVariant(Store<AppState> store, int variantId) async {
    VariationTableData variationTableData =
        await store.state.database.variationDao.getVariationById(variantId);
    store.state.database.variationDao.updateVariation(variationTableData
        .copyWith(deletedAt: DateTime.now().toIso8601String()));
  }

  static Future getActiveBranch(Store<AppState> store, int branchId) async {
    BranchTableData branche =
        await store.state.database.branchDao.getBranchById(branchId: branchId);
    //todo:broadcast the branch
    store.dispatch(
      OnCurrentBranchAction(
        branch: Branch(
          (b) => b
            ..id = branche.id
            ..name = branche.name
            ..active = branche.isActive,
        ),
      ),
    );
  }

  static Future createCustomItem(Store<AppState> store, String itemName) async {
    CategoryTableData category = await store.state.database.categoryDao
        .getCategoryNameAndBranch("custom", store.state.branch.id);

    UnitTableData unit = await store.state.database.unitDao
        .getExistingUnit("custom", store.state.branch.id);

    ItemTableData item = await store.state.database.itemDao
        .getItemByName(name: itemName, branchId: store.state.branch.id);

    int variantId;
    VariationTableData variant = await store.state.database.variationDao
        .getVariationBy(itemName, store.state.branch.id);
    TaxTableData tax = await store.state.database.taxDao
        .getTaxByName('vat', store.state.branch.id);
    if (item == null) {
      int itemId = await store.state.database.itemDao.insert(
        //ignore: missing_required_param
        ItemTableData(
          name: itemName,
          taxId: tax.id,
          branchId: store.state.branch.id,
          categoryId: category.id, //this will be updated ,
          color: "#955be9",
          description: itemName,
          unitId: unit.id,
          createdAt: DateTime.now(),
        ),
      );
      if (variant == null) {
        variantId = await store.state.database.variationDao.insert(
          //ignore: missing_required_param
          VariationTableData(
              name: itemName,
              itemId: itemId,
              sku: DateTime.now().year.toString() + randomAlpha(5),
              branchId: store.state.branch.id,
              isActive: false,
              createdAt: DateTime.now()),
        );
      } else {
        variantId = variant.id;
      }
      store.state.database.stockDao.insert(
        //ignore: missing_required_param
        StockTableData(
          canTrackStock: false,
          itemId: itemId,
          variantId: variantId,
          branchId: store.state.branch.id,
          createdAt: DateTime.now(),
        ),
      );
      ItemTableData item = await store.state.database.itemDao
          .getItemByName(name: itemName, branchId: store.state.branch.id);

      dispatchCurrentTmpItem(store, item, variantId);
    } else {
      dispatchCurrentTmpItem(store, item, variant.id);
    }
  }

  static void dispatchCurrentTmpItem(
      Store<AppState> store, ItemTableData item, variantId) {
    return store.dispatch(
      TempItem(
        item: Item(
          (i) => i
            ..id = item.id
            ..unitId = item.unitId
            ..name = item.name
            ..branchId = item.branchId
            ..color = item.color
            ..parentName = item.name
            ..categoryId = item.categoryId
            ..branchId = store.state.branch.id
            ..variantId = variantId,
        ),
      ),
    );
  }

  static Future insertItem(Store<AppState> store, ItemTableData data) async {
    ItemTableData itemData = await store.state.database.itemDao
        .getItemByBranch(name: data.name, branchId: data.branchId);

    if (itemData == null) {
      await store.state.database.itemDao
          .insert(data.copyWith(createdAt: DateTime.now()));
    }
    itemData = await store.state.database.itemDao
        .getItemByBranch(name: data.name, branchId: data.branchId);

    store.dispatch(
      CustomItem(
        item: Item((i) => i
          ..id = itemData.id
          ..isActive = false
          ..name = itemData.name
          ..branchId = itemData.branchId
          ..categoryId = itemData.categoryId
          ..unitId = itemData.unitId
          ..description = itemData.description),
      ),
    );
    return itemData.id;
  }
}
