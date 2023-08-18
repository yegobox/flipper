import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  static MenuController instance = Get.find();
  var activeItem = "/".obs;

  var hoverItem = "".obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String? itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName!;
  }

  isHovering(String? itemName) => hoverItem.value == itemName;

  isActive(String? itemName) => activeItem.value == itemName;

  Widget returnIconFor(String? itemName) {
    switch (itemName) {
      // case overviewPageDisplayName:
      //   return _customIcon(Icons.trending_up, itemName);
      // case driversPageDisplayName:
      //   return _customIcon(Icons.drive_eta, itemName);
      // case clientsPageDisplayName:
      //   return _customIcon(Icons.people_alt_outlined, itemName);
      // case authenticationPageDisplayName:
      //   return _customIcon(Icons.exit_to_app, itemName);
      default:
        return _customIcon(Icons.exit_to_app, itemName);
    }
  }

  Widget _customIcon(IconData icon, String? itemName) {
    if (isActive(itemName)) return Icon(icon, size: 22, color: Colors.red);

    return Icon(
      icon,
      color: isHovering(itemName) ? Colors.red : Colors.black,
    );
  }
}
