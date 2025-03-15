import 'package:flutter/material.dart';

class SaveProgressDialog extends StatelessWidget {
  final String progress;
  final int currentItem;
  final int totalItems;

  const SaveProgressDialog({
    Key? key,
    required this.progress,
    required this.currentItem,
    required this.totalItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safely calculate the progress percentage
    double progressPercentage = 0.0; // Default to 0 if totalItems is zero

    if (totalItems > 0) {
      progressPercentage = (currentItem / totalItems) * 100;
    }

    final bool isComplete = currentItem == totalItems;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Saving items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Progress Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: totalItems > 0
                        ? currentItem / totalItems
                        : 0.0, // Avoid division by zero here too
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isComplete ? Colors.green : Colors.blue,
                    ),
                  ),
                ),
                Text(
                  '${progressPercentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progress,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: totalItems > 0
                          ? currentItem / totalItems
                          : 0.0, // avoid division by zero
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isComplete ? Colors.green : Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$currentItem of $totalItems items processed',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
