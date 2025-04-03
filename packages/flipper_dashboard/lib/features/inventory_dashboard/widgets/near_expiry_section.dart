import 'package:flutter/material.dart';
import '../models/inventory_models.dart';

class NearExpirySection extends StatelessWidget {
  const NearExpirySection({
    Key? key,
    required this.nearExpiryItems,
  }) : super(key: key);

  final List<InventoryItem> nearExpiryItems;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Near Expiry Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: nearExpiryItems.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = nearExpiryItems[index];
                final daysLeft =
                    item.expiryDate.difference(DateTime.now()).inDays;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getExpiryColor(daysLeft).withOpacity(0.2),
                    child: Icon(
                      Icons.timelapse,
                      color: _getExpiryColor(daysLeft),
                    ),
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    '${item.quantity} units - ${item.location}',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getExpiryColor(daysLeft).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$daysLeft days left',
                      style: TextStyle(
                        color: _getExpiryColor(daysLeft),
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getExpiryColor(int daysLeft) {
    if (daysLeft <= 1) {
      return Colors.red;
    } else if (daysLeft <= 3) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
