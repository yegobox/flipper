import 'package:built_collection/built_collection.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/unit.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

final appActionReducer = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, AppAction>(_onAppActions),
  TypedReducer<AppState, BusinessId>(_onBusinessId),
  TypedReducer<AppState, UnitR>(_onUnits),
  TypedReducer<AppState, CurrentUnit>(_onCurrentUnit),
  TypedReducer<AppState, CurrentColor>(_onCurrentColor),
  TypedReducer<AppState, TempCategoryIdAction>(_onTempCategoryId),
  TypedReducer<AppState, UpdateUnitAction>(_onUpdateUnit),
  TypedReducer<AppState, WithUnitId>(_withUnitId),
  TypedReducer<AppState, ResetAppAction>(_onResetAppAction),
  TypedReducer<AppState, CurrentTab>(_onSetTab),
  TypedReducer<AppState, ItemLoaded>(_onItemLoaded),
  TypedReducer<AppState, AddItemToCartAction>(_onAddingOneItemOnCart),
  TypedReducer<AppState, IncrementAction>(_onIncrement),
  TypedReducer<AppState, ItemsVariation>(_onItemsVariation),
  TypedReducer<AppState, CurrentActiveSaleProduct>(_onCurrentSaleProduct),
  TypedReducer<AppState, CurrentActiveSaleVariant>(_onCurrentSaleVariant),
  TypedReducer<AppState, Carts>(_onCarts),
  TypedReducer<AppState, CartQuantity>(_onCartQuantity),
  TypedReducer<AppState, KayPadAction>(_onKeyPad),
  TypedReducer<AppState, CleanKeyPad>(_onCleanKeyPad),
  TypedReducer<AppState, TempProduct>(_onTempItem),
  TypedReducer<AppState, CleanAppActions>(_onCleanAppAction),
  TypedReducer<AppState, CleanCurrentColor>(_onCleanCurrentColor),
  TypedReducer<AppState, CustomUnit>(_onCustomUnit),
  TypedReducer<AppState, CategoryAction>(_onCategory),
  TypedReducer<AppState, VariationAction>(_onVariation),
  TypedReducer<AppState, CustomItem>(_onCustomItem),
  TypedReducer<AppState, DefaultTax>(_onDefaultTax),
  TypedReducer<AppState, ImagePreview>(_onImagePreview),
  TypedReducer<AppState, Note>(_onNote),
  TypedReducer<AppState, DateFilters>(_onDateFilter),
  TypedReducer<AppState, ReportAction>(onReport),
];
AppState _onAppActions(AppState state, AppAction action) {
  return state.rebuild((a) => a..action = action.actions.toBuilder());
}

AppState _onResetAppAction(AppState state, ResetAppAction action) {
  //TODO(richard): should update the
  switch (action.type) {
    case 'User':
      return state.rebuild((a) => a..userId = null);
      break;
    default:
      return state.rebuild((a) => a..action = null);
  }
}

AppState _onUpdateUnit(AppState state, UpdateUnitAction action) {
  List<Unit> updatedUnits = [];
  state.units.forEach((u) => {
        if (u.id == action.unitId)
          {
            updatedUnits.add(Unit((j) => j
              ..id = u.id
              ..businessId = u.businessId
              ..branchId = u.branchId
              ..focused = true
              ..name = u.name))
          }
        else
          {
            updatedUnits.add(Unit((j) => j
              ..id = u.id
              ..businessId = u.businessId
              ..branchId = u.branchId
              ..focused = false
              ..name = u.name))
          }
      });
  return state.rebuild((a) => a..units = ListBuilder(updatedUnits));
}

AppState _onBusinessId(AppState state, BusinessId action) {
  return state.rebuild((a) => a..businessId = action.businessId);
}

AppState _onUnits(AppState state, UnitR action) {
  return state.rebuild((a) => a..units = ListBuilder(action.units));
}

AppState _onSetTab(AppState state, CurrentTab action) {
  return state.rebuild((a) => a..tab = action.tab);
}

AppState _withUnitId(AppState state, WithUnitId action) {
  return state.rebuild((a) => a..focusedUnit = action.unitId);
}

AppState _onTempCategoryId(AppState state, TempCategoryIdAction action) {
  return state.rebuild((a) => a..tempCategoryId = action.categoryId);
}

AppState _onCurrentUnit(AppState state, CurrentUnit action) {
  return state.rebuild((a) => a..currentUnit = action.unit.toBuilder());
}

AppState _onCurrentColor(AppState state, CurrentColor action) {
  return state.rebuild((a) => a..currentColor = action.color.toBuilder());
}

AppState _onItemLoaded(AppState state, ItemLoaded action) {
  return state.rebuild((a) => a..items = ListBuilder(action.items));
}

//per same item can not add two different variant
AppState _onAddingOneItemOnCart(AppState state, AddItemToCartAction action) {
  return state.rebuild((a) => a..cartItem = action.cartItem.toBuilder());
}

AppState _onIncrement(AppState state, IncrementAction action) {
  return state.rebuild((a) => a..currentIncrement = action.increment);
}

AppState _onItemsVariation(AppState state, ItemsVariation action) {
  return state
      .rebuild((a) => a..itemVariations = ListBuilder(action.variations));
}

AppState _onCurrentSaleProduct(
    AppState state, CurrentActiveSaleProduct action) {
  return state
      .rebuild((a) => a..currentActiveSaleProduct = action.product.toBuilder());
}

AppState _onCurrentSaleVariant(
    AppState state, CurrentActiveSaleVariant action) {
  return state.rebuild(
      (a) => a..currentActiveSaleVariant = action.variation.toBuilder());
}

AppState _onCarts(AppState state, Carts action) {
  return state.rebuild((a) => a..carts = ListBuilder(action.carts));
}

AppState _onCartQuantity(AppState state, CartQuantity action) {
  return state.rebuild((a) => a..cartQuantities = action.quantity);
}

AppState _onKeyPad(AppState state, KayPadAction action) {
  return state.rebuild((a) => a..keypad = action.keyPad.toBuilder());
}

AppState _onCleanKeyPad(AppState state, CleanKeyPad action) {
  return state.rebuild((a) => a..keypad = null);
}

AppState _onCleanAppAction(AppState state, CleanAppActions action) {
  return state.rebuild((a) => a..action = null);
}

AppState _onCleanCurrentColor(AppState state, CleanCurrentColor action) {
  return state.rebuild((a) => a..currentColor = null);
}

AppState _onCustomUnit(AppState state, CustomUnit action) {
  return state.rebuild((a) => a..customUnit = action.unit.toBuilder());
}

AppState _onCategory(AppState state, CategoryAction action) {
  return state.rebuild((a) => a..category = action.category.toBuilder());
}

AppState _onCustomItem(AppState state, CustomItem action) {
  return state.rebuild((a) => a..customItem = action.item.toBuilder());
}

AppState _onVariation(AppState state, VariationAction action) {
  return state.rebuild((a) => a..variant = action.variation.toBuilder());
}

AppState _onTempItem(AppState state, TempProduct action) {
  return state.rebuild((a) => a..tmpItem = action.product.toBuilder());
}

AppState _onDefaultTax(AppState state, DefaultTax action) {
  return state.rebuild((a) => a..defaultTax = action.tax.toBuilder());
}

AppState _onImagePreview(AppState state, ImagePreview action) {
  return state.rebuild((a) => a..image = action.image.toBuilder());
}

AppState _onNote(AppState state, Note action) {
  return state.rebuild((a) => a..note = action.note);
}

AppState _onDateFilter(AppState state, DateFilters action) {
  return state.rebuild((a) => a..dateFilter = action.dateFilter?.toBuilder());
}

AppState onReport(AppState state, ReportAction action) {
  return state.rebuild((a) => a..report = action.report?.toBuilder());
}
