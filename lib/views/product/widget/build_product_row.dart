import 'package:flipper/views/product/add/add_product_modal.dart';

import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/flitter_color.dart';
import 'package:flutter/material.dart';


void buildProductRowHeader({List<Widget> list, BuildContext context,
      String createButtonName, String userId,String type='add'}) {
   return type=='add'?
     list.add(
      GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddProductModal(
                userId: userId,
              );
            },
          );
        },
        child: ListTile(
          leading: const Icon(Icons.add),
          title: Text(
            createButtonName,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    ):list.add(
      ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Container(
          width: 50,
          color: HexColor(FlipperColors.gray),
          child: IconButton(
            icon: const Icon(Icons.star_border),
            color: Colors.white,
            onPressed: () {},
          ),
        ),
        title: const Text(
          'Reedeem Rewards',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }