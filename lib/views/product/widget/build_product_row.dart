import 'package:flipper/views/product/add/add_product_modal.dart';

import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/flitter_color.dart';
import 'package:flutter/material.dart';

// NOTE: this is a product row
void buildProductRowHeader(
    {List<Widget> list,
    BuildContext context,
    String createButtonName,
    String userId,
    String type = 'add'}) {
  return type == 'add'
      ? list.add(
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                  // child: ListTile(
                  //   leading: const Icon(Icons.add),
                  //   title: Text(
                  //     createButtonName,
                  //     style: const TextStyle(color: Colors.black),
                  //   ),
                  // ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    // leading: callImageBox(context, product),
                    leading: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: 58,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black12),
                        child: Icon(
                          Icons.add,
                          color: const Color(0xFF2996cc),
                          size: 35,
                        ),
                      ),
                    ),
                    title: Text(
                      createButtonName,
                      style: const TextStyle(
                          color: const Color(0xFF2996cc), fontSize: 15),
                    ),
                  ),
                ),
                Container(
                  height: 0.5,
                  color: Colors.black26,
                ),
              ]),
        )
      : list.add(
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    // leading: callImageBox(context, product),
                    leading: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: 58,
                      child: Container(
                        decoration:
                            BoxDecoration(color: HexColor(FlipperColors.gray)),
                        child: IconButton(
                          icon: const Icon(
                            Icons.star_border,
                            size: 30,
                          ),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ),
                    title: Text(
                      'Reedeem Rewards',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
                Container(
                  height: 0.5,
                  color: Colors.black26,
                ),
              ]),
        );
  // ListTile(
  //   contentPadding: const EdgeInsets.all(0),
  //   leading: Container(
  //     width: 50,
  //     color: HexColor(FlipperColors.gray),
  //     child: IconButton(
  //       icon: const Icon(Icons.star_border),
  //       color: Colors.white,
  //       onPressed: () {},
  //     ),
  //   ),
  //   title: const Text(
  //     'Reedeem Rewards',
  //     style: TextStyle(color: Colors.black),
  //   ),
  // ),
}
