import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/flipper_color.dart';
import 'package:flipper/model/fuser.dart';
import 'package:flipper/model/hint.dart';
import 'package:flipper/model/image.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/unit.dart';

import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:redux/redux.dart';

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


  // ignore: sort_constructors_first
  CommonViewModel._();
  // ignore: sort_unnamed_constructors_first
  // ignore: sort_constructors_first
  factory CommonViewModel([void Function(CommonViewModelBuilder) updates]) =
      _$CommonViewModel;

   // ignore: always_declare_return_types
  createTempCategory({Store<AppState> store,String name})async {
    final DatabaseService _databaseService = ProxyService.database;
    _databaseService.insert(data: {'branchId': store.state.branch.id,'name':name});
  }
  static CommonViewModel fromStore(Store<AppState> store) {
    return CommonViewModel(
      (CommonViewModelBuilder vm) => vm
        
        ..businesses = store.state.businesses
      
        ..units = store.state.units.toBuilder()

        ..user = store.state.user?.toBuilder()
       
        ..currentBusiness = store.state.currentActiveBusiness?.toBuilder()

        ..hint = store.state.hint?.toBuilder()
        
        ..category = store.state.category?.toBuilder()
       
        ..branches = store.state.branches

        ..tmpItem = store.state.tmpItem?.toBuilder()
        
        ..note = store.state.note

        ..otpcode = store.state.otpcode

        ..image = store.state.image?.toBuilder()

        ..branch = store.state.branch?.toBuilder(),
    );
  }
}
