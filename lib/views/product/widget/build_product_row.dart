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
                Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: GestureDetector(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new Icon(Icons.add,
                            size: 20,
                            // These colors are not defined in the Material Design spec.
                            color: Colors.white),
                        Text("  " + createButtonName,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
                // child: GestureDetector(
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return AddProductModal(
                //           userId: userId,
                //         );
                //       },
                //     );
                //   },
                //   // child: ListTile(
                //   //   leading: const Icon(Icons.add),
                //   //   title: Text(
                //   //     createButtonName,
                //   //     style: const TextStyle(color: Colors.black),
                //   //   ),
                //   // ),
                //
                //   child: ListTile(
                //     contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                //     // leading: callImageBox(context, product),
                //     leading: SizedBox(
                //       height: MediaQuery.of(context).size.height,
                //       width: 58,
                //       child: Container(
                //         child: Icon(
                //           Icons.add,
                //           color: Colors.white,
                //           size: 25,
                //         ),
                //       ),
                //     ),
                //     title: Text(
                //       createButtonName,
                //       style: const TextStyle(
                //           color: Colors.white, fontSize: 14),
                //     ),
                //   ),
                // ),
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
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return AddProductModal(
                    //       userId: userId,
                    //     );
                    //},
                    // );
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
