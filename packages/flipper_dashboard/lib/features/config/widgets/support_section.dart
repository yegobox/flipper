import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Help?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact support to add EBM to Flipper',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                int businessId = ProxyService.box.getBusinessId()!;
                final initialMessage =
                    "I am writing to request support to add EBM to flipper, my businessID is: $businessId";
                final Uri whatsappUri = Uri.parse(
                    'https://wa.me/250788360058?text=${Uri.encodeComponent(initialMessage)}');
                if (await canLaunchUrl(whatsappUri)) {
                  await launchUrl(whatsappUri,
                      mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch $whatsappUri';
                }
              },
              icon: const Icon(Icons.support_agent),
              label: const Text('Contact Support'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
