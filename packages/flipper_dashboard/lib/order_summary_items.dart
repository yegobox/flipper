import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

List<Widget> buildItems(
    {required Function callback,
    required BuildContext context,
    required List<OrderItem> items}) {
  final List<Widget> list = [];

  if (items.isEmpty) {
    list.add(
      Column(
        children: [
          SizedBox(
            height: 120,
          ),
          Text(
            'Current order has no items',
            style: GoogleFonts.poppins(
              fontSize: 19,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
    return list;
  }

  for (OrderItem item in items) {
    list.add(
      Slidable(
        key: ValueKey(item.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => callback(item),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => callback(item),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 40.0, right: 40.0),
          trailing: Text(
            'RWF ' +
                NumberFormat('#,###').format(item.price * item.qty).toString(),
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),
          ),
          leading: Text(
            item.name,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.close,
                color: Colors.black,
                size: 16.0,
              ),
              const Text(' '),
              Text(
                item.qty.toInt().toString(),
              )
            ],
          ),
        ),
      ),
    );
  }
  return list;
}
