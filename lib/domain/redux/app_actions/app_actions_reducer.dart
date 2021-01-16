import 'package:built_collection/built_collection.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper_models/unit.dart';
import 'package:redux/redux.dart';
import 'package:flipper/domain/app_actions.dart';
import 'actions.dart';

final appActionReducer = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, UnitR>(_onUnits),
  TypedReducer<AppState, TempCategoryIdAction>(_onTempCategoryId),
  TypedReducer<AppState, UpdateUnitAction>(_onUpdateUnit),
  TypedReducer<AppState, WithUnitId>(_withUnitId),
  TypedReducer<AppState, ItemLoaded>(_onItemLoaded),
  TypedReducer<AppState, ImagePreview>(_onImagePreview),
  TypedReducer<AppState, Note>(_onNote),
  TypedReducer<AppState, ReportAction>(onReport),
  TypedReducer<AppState, OtpCode>(onOtpCode),
  TypedReducer<AppState, CurrentColor>(_currentColor),
  TypedReducer<AppState, Variations>(_variations),
];

AppState _onUpdateUnit(AppState state, UpdateUnitAction action) {
  List<Unit> updatedUnits = [];
  state.units.forEach((u) => {
        if (u.id == action.unitId)
          {
            updatedUnits.add(Unit((j) => j
              ..id = u.id
              ..focused = true
              ..name = u.name))
          }
        else
          {
            updatedUnits.add(Unit((j) => j
              ..id = u.id
              // ..businessId = u.businessId
              // ..branchId = u.branchId
              ..focused = false
              ..name = u.name))
          }
      });
  return state.rebuild((a) => a..units = ListBuilder(updatedUnits));
}

AppState _onUnits(AppState state, UnitR action) {
  return state.rebuild((a) => a..units = ListBuilder(action.units));
}

AppState _withUnitId(AppState state, WithUnitId action) {
  return state.rebuild((a) => a..focusedUnit = action.unitId);
}

AppState _onTempCategoryId(AppState state, TempCategoryIdAction action) {
  return state.rebuild((a) => a..tempCategoryId = action.categoryId);
}

AppState _onItemLoaded(AppState state, ItemLoaded action) {
  return state.rebuild((a) => a..items = ListBuilder(action.items));
}

AppState _onImagePreview(AppState state, ImagePreview action) {
  return state.rebuild((a) => a..image = action.image.toBuilder());
}

AppState _onNote(AppState state, Note action) {
  return state.rebuild((a) => a..note = action.note);
}

AppState onReport(AppState state, ReportAction action) {
  return state.rebuild((a) => a..report = action.report?.toBuilder());
}

AppState onOtpCode(AppState state, OtpCode action) {
  return state.rebuild((AppStateBuilder a) => a..otpcode = action.otpcode);
}

AppState _currentColor(AppState state, CurrentColor action) {
  return state.rebuild(
      (AppStateBuilder a) => a..currentColor = action.color.toBuilder());
}

AppState _variations(AppState state, Variations action) {
  return state.rebuild(
      (AppStateBuilder a) => a..variants = action.variations.toBuilder());
}
