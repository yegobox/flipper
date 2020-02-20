import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/item.dart';
import 'package:redux/redux.dart';

class Util {
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
            ..isActive = branche.isActive,
        ),
      ),
    );
  }

  static Future createCustomItem(Store<AppState> store, String itemName) async {
    CategoryTableData category = await store.state.database.categoryDao
        .getCategoryNameAndBranch("custom", store.state.branch.id);

    UnitTableData unit = await store.state.database.unitDao
        .getExistingUnit("custom", store.state.branch.id);

    int itemId = await store.state.database.itemDao.insert(
      //ignore: missing_required_param
      ItemTableData(
        name: itemName,
        branchId: store.state.branch.id,
        categoryId: category.id, //this will be updated ,
        color: "#955be9",
        description: itemName,
        unitId: unit.id,
        createdAt: DateTime.now(),
      ),
    );
    //insert tmp variant
    int variantId = await store.state.database.variationDao.insert(
      //ignore: missing_required_param
      VariationTableData(
          name: itemName,
          itemId: itemId,
          sku: DateTime.now().year.toString(),
          branchId: store.state.branch.id,
          isActive: false,
          createdAt: DateTime.now()),
    );

    store.state.database.stockDao.insert(
      //ignore: missing_required_param
      StockTableData(
        currentStock: 0,
        canTrackStock: false,
        retailPrice: 0,
        itemId: itemId,
        variantId: variantId,
        branchId: store.state.branch.id,
        createdAt: DateTime.now(),
      ),
    );
    store.dispatch(
      TempItem(
        item: Item(
          (i) => i
            ..id = itemId
            ..branchId = store.state.branch.id,
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
