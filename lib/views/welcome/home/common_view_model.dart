import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper_models/branch.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_models/fuser.dart';
import 'package:flipper_models/hint.dart';
import 'package:flipper_models/image.dart';
import 'package:flipper_models/pcolor.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/database_service.dart';
import 'package:redux/redux.dart';
import 'package:flipper_models/variation.dart';
part 'common_view_model.g.dart';

abstract class CommonViewModel
    implements Built<CommonViewModel, CommonViewModelBuilder> {
  @nullable
  BuiltList<Unit> get units;

  @nullable //because when app start it is null!
  Business get currentBusiness;

  List<Branch> get branches;

  List<Business> get businesses;

  @nullable //because when app start it is null!
  Hint get hint;

  @nullable
  Category get category;

  @nullable
  String get otpcode;

  @nullable
  Branch get branch;

  @nullable
  PColor get currentColor;

  @nullable //because when app start it is null!
  FUser get user;

  @nullable
  Product get customItem;

  @nullable
  Product get tmpItem;

  @nullable
  ImageP get image;

  @nullable
  String get note;

  @nullable
  BuiltList<Variation> get variants;

  // ignore: sort_constructors_first
  CommonViewModel._();
  // ignore: sort_unnamed_constructors_first
  // ignore: sort_constructors_first
  factory CommonViewModel([void Function(CommonViewModelBuilder) updates]) =
      _$CommonViewModel;

  // ignore: always_declare_return_types
  createTempCategory({Store<AppState> store, String name}) async {
    final DatabaseService _databaseService = ProxyService.database;
    _databaseService
        .insert(data: {'branchId': store.state.branch.id, 'name': name});
  }

  static CommonViewModel fromStore(Store<AppState> store) {
    return CommonViewModel(
      (CommonViewModelBuilder vm) => vm
        ..businesses = store.state.businesses
        ..units = store.state.units.toBuilder()
        ..variants = store.state.variants?.toBuilder()
        ..user = store.state.user?.toBuilder()
        ..currentBusiness = store.state.currentActiveBusiness?.toBuilder()
        ..hint = store.state.hint?.toBuilder()
        ..category = store.state.category?.toBuilder()
        ..branches = store.state.branches
        ..currentColor = store.state.currentColor?.toBuilder()
        ..tmpItem = store.state.tmpItem?.toBuilder()
        ..note = store.state.note
        ..otpcode = store.state.otpcode
        ..image = store.state.image?.toBuilder()
        ..branch = store.state.branch?.toBuilder(),
    );
  }
}
