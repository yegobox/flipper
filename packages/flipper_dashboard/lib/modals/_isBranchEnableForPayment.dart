import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

void showPaymentSettingsModal(BuildContext context) async {
  final String branchId = (await ProxyService.strategy.activeBranch()).id;
  final ValueNotifier<bool> isEnabledNotifier = ValueNotifier<bool>(false);

  // Fetch initial toggle state
  isEnabledNotifier.value = await ProxyService.strategy
      .isBranchEnableForPayment(currentBranchId: branchId);

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<bool>(
              valueListenable: isEnabledNotifier,
              builder: (context, isEnabled, child) {
                return ListTile(
                  leading: Image.asset(
                    'assets/momo.jpg',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.mobile_friendly,
                          size: 40, color: Colors.yellow);
                    },
                  ),
                  title: const Text('MTN Mobile Money'),
                  subtitle: Text(isEnabled ? 'Enabled' : 'Disabled'),
                  trailing: Switch(
                    value: isEnabled,
                    onChanged: (bool value) async {
                      try {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        // Update payment status
                        await ProxyService.strategy.setBranchPaymentStatus(
                          currentBranchId: branchId,
                          status: value,
                        );

                        // Update the notifier
                        isEnabledNotifier.value = value;

                        // Close loading indicator
                        Navigator.pop(context);

                        // Show success message
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text(
                        //       value
                        //           ? 'MTN MOMO payments enabled'
                        //           : 'MTN MOMO payments disabled',
                        //     ),
                        //     backgroundColor: Colors.green,
                        //   ),
                        // );
                      } catch (e) {
                        // Close loading indicator
                        Navigator.pop(context);

                        // Show error message
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('Error: ${e.toString()}'),
                        //     backgroundColor: Colors.red,
                        //   ),
                        // );
                      }
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
