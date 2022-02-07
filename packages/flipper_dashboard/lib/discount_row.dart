import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flipper_models/models/models.dart';

import 'package:flipper_services/constants.dart';

class DiscountRow extends StatelessWidget {
  const DiscountRow(
      {Key? key,
      required this.name,
      required this.hasImage,
      this.imageUrl,
      this.addToMenu,
      required this.discount,
      required this.edit,
      required this.applyDiscount,
      required this.model,
      required this.delete})
      : super(key: key);
  final String name;
  final bool hasImage;
  final String? imageUrl;
  final DiscountSync discount;
  final Function delete;
  final Function applyDiscount;
  final Function? addToMenu;
  final Function edit;
  final ProductViewModel model;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: GestureDetector(
        onTap: () {
          applyDiscount(discount);
        },
        onLongPress: () {},
        child: Column(children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            leading: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: 58,
              child: CircleAvatar(
                child: Container(
                  height: 10,
                  child: Icon(
                    Ionicons.pricetags_sharp,
                    color: black,
                  ),
                ),
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: Text(discount.amount.toString() + 'RWF off'),
          ),
          Container(
            height: 0.5,
            color: Colors.black26,
          ),
        ]),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: FLocalization.of(context).edit,
          color: Colors.white,
          icon: Icons.edit,
          onTap: () {
            edit(discount);
          },
        ),
        IconSlideAction(
          caption: FLocalization.of(context).delete,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            delete(discount.id);
          },
        ),
      ],
      actionPane: SlidableDrawerActionPane(),
    );
  }
}
