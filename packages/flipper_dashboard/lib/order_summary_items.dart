import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

List<Widget> buildItems({
  required Function(TransactionItem) callback,
  required BuildContext context,
  required List<TransactionItem> items,
}) {
  // Check if the list is empty.
  if (items.isEmpty) {
    return [
      Column(
        children: [
          SizedBox(height: 120),
          Text(
            'Current transaction has no items',
            style: GoogleFonts.poppins(
              fontSize: 19,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ];
  }

  // Create a list of widgets for each item in the list.
  return items.map((item) {
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) =>
                callback(item), // Added the context argument
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
            onPressed: (context) =>
                callback(item), // Added the context argument
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
          'RWF ${NumberFormat('#,###').format(item.price * item.qty)}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        leading: Container(
          child: Flexible(
            child: Text(
              item.name.substring(0, 10),
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: Container(
          child: Flexible(
            child: Row(
              children: [
                const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 16.0,
                ),
                const Text(' '),
                Text(
                  item.qty.toInt().toString(),
                ),
              ],
            ),
          ),
        ),
        onTap: () => callback(item), // Added the value argument
      ),
    );
  }).toList();
}
