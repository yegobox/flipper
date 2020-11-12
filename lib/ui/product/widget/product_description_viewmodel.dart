import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProductDescriptionViewmodel extends BaseViewModel {
  double _quantity = 1;
  double get quantity {
    return _quantity;
  }

  double _titleAmount;
  double get titleAmount {
    return _titleAmount;
  }

  double _paramsDefault = 230.8;
  double get paramsDefault {
    return _paramsDefault;
  }

  double _checked =0;
  double get checked {
    return _checked;
  }
   
  double _slider = 0;
  double get slider{
    return _slider;
  }

  TextEditingController _notesController;
  TextEditingController get notesController{
    return _notesController;
  }

  TextEditingController _quantityController;
  TextEditingController get quantityController{
    return _quantityController;
  }

  initFields(){
    _quantityController = TextEditingController();
    _notesController = TextEditingController();
  }


  void increaseQty() {
    _quantity++;
    _titleAmount = _paramsDefault + (_checked * _quantity);
    notifyListeners();
  }

  void decreaseQty() {
    _quantity--;
    _titleAmount = _paramsDefault + (_checked * _quantity);
    notifyListeners();
  }

  void updateTitleAmountDefault({@required double value}){ // NOTE: [telesphore] in case of func parameter let's use the name parameter as it is much readable
    _checked = value;
    _titleAmount = paramsDefault + _checked;
    notifyListeners();
  }
  void slide({@required double value}){
    _slider = value;
    notifyListeners();
  }
}
