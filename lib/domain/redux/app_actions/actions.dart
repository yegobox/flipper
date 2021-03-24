import 'package:flipper_models/app_action.dart';
import 'package:flipper_models/branch.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_models/date_filter.dart';
import 'package:flipper_models/image.dart';
import 'package:flipper_models/key_pad.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/report.dart';
import 'package:flipper_models/tax.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_models/variation.dart';
import 'package:flutter/material.dart';

@immutable
class AppAction {
  final AppActions actions;

  const AppAction({@required this.actions});
}

@immutable
class PersistFocusedUnitAction {}

@immutable
class BusinessId {
  final String businessId;

  BusinessId(this.businessId);
}

@immutable
class UnitR {
  final List<Unit> units;
  UnitR(this.units);
}

@immutable
class CategoryNameAction {
  final String name;

  CategoryNameAction({this.name});
}

@immutable
class CreateEmptyTempCategoryAction {
  final String name;

  CreateEmptyTempCategoryAction({this.name});
}

@immutable
class TempCategoryIdAction {
  final String categoryId;

  TempCategoryIdAction({this.categoryId});
}

@immutable
class ListCategoryAction {
  final List<Category> categories;
  ListCategoryAction(this.categories);
}

@immutable
class WithUnitId {
  final int unitId;

  WithUnitId({@required this.unitId});
}

@immutable
class UpdateUnitAction {
  final int unitId;

  UpdateUnitAction({@required this.unitId});
}

@immutable
class OnSetTab {}

@immutable
class CreateUnit {}

@immutable
class CreateCategoryFromAddItemScreenAction {
  final String categoryName;

  CreateCategoryFromAddItemScreenAction({this.categoryName});
}

@immutable
class CurrentTab {
  final int tab;

  const CurrentTab({@required this.tab});
}

@immutable
class CurrentUnit {
  final Unit unit;

  const CurrentUnit({@required this.unit});
}

@immutable
class ResetAppAction {
  final String type;

  ResetAppAction({this.type});
}

@immutable
class SaveItemAction {
  final Business business;
  final Branch branch;
  final String price;
  final List<Variation> variations;
  final int categoryId;
  final String description;
  final String name;
  final Unit unit;
  final String color;

  SaveItemAction({
    this.business,
    this.branch,
    this.price,
    this.variations,
    this.categoryId,
    this.description,
    this.name,
    this.unit,
    this.color,
  });
}

@immutable
class ItemLoaded {
  final List<Product> items;

  ItemLoaded({this.items});
}

@immutable
class AddItemToCartAction {
  final Product cartItem;

  AddItemToCartAction({this.cartItem});
}

@immutable
class IncrementAction {
  final int increment;

  IncrementAction({this.increment});
}

@immutable
class SwitchVariation {
  final Product item;

  SwitchVariation({this.item});
}

@immutable
class ItemsVariation {
  final List<Variation> variations;

  ItemsVariation({this.variations});
}

//CurrentActiveSaleProduct
@immutable
class CurrentActiveSaleVariant {
  final Variation variation;

  CurrentActiveSaleVariant({this.variation});
}

@immutable
class CurrentActiveSaleProduct {
  final Product product;

  CurrentActiveSaleProduct({this.product});
}

@immutable
class CartQuantity {
  final int quantity;

  CartQuantity({this.quantity});
}

@immutable
class SavePayment {
  final String note;
  final double amount;
  final double customerChangeDue;

  SavePayment({this.customerChangeDue, this.note, this.amount});
}

@immutable
class Note {
  final String note;

  Note({this.note});
}

@immutable
class KayPadAction {
  final KeyPad keyPad;

  KayPadAction({this.keyPad});
}

class CleanKeyPad {}

class CleanVariation {}

class CleanAppActions {}

class CleanCurrentColor {}

class CleanCartItem {}

@immutable
class CustomUnit {
  final Unit unit;

  CustomUnit({this.unit});
}

@immutable
class CategoryAction {
  final Category category;

  CategoryAction({this.category});
}

@immutable
class ImagePreview {
  final ImageP image;

  ImagePreview({this.image});
}

@immutable
class DefaultTax {
  final Tax tax;

  DefaultTax({this.tax});
}

@immutable
class CustomItem {
  final Product item;

  CustomItem({this.item});
}

class SaveCartCustom {}

class SaveRegular {
  final String name;
  final int itemId;
  final int count;
  final double retailPrice;
  final double costPrice;
  final int variantId;
  final String sku;

  SaveRegular(
      {this.count,
      this.variantId,
      this.name,
      this.itemId,
      this.retailPrice,
      this.sku,
      this.costPrice});
}

@immutable
class TempProduct {
  final Product product;

  const TempProduct({this.product});
}

@immutable
class VariationAction {
  final Variation variation;

  VariationAction({this.variation});
}

@immutable
class Total {
  final int total;

  Total({this.total});
}

@immutable
class DateFilters {
  final DateFilter dateFilter;

  DateFilters({this.dateFilter});
}

@immutable
class ReportAction {
  final Report report;

  ReportAction({this.report});
}

@immutable
class NavigateOtp {
  final String navigate;
  final String phone;

  NavigateOtp({this.navigate, this.phone});
}

@immutable
class OtpCode {
  const OtpCode({this.otpcode});
  final String otpcode;
}
