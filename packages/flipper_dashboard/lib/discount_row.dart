import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flipper_models/realm_model_export.dart';

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
  final Discount discount;
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
              contentPadding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              leading: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: 58,
                child: const CircleAvatar(
                  child: SizedBox(
                    height: 10,
                    child: Icon(
                      Ionicons.pricetags_sharp,
                      color: Colors.black,
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
        endActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {}),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: doSomething(context, discount.id!),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ));
  }

  doSomething(BuildContext context, int id) {
    delete(id);
  }
}
