import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/momo_ussd_service.dart';

/// A button that opens the device's contact picker and returns the selected phone number
class ContactPickerButton extends StatelessWidget {
  /// Callback when a phone number is selected from contacts
  final ValueChanged<String> onPhoneSelected;

  /// Optional icon to display
  final IconData icon;

  /// Optional tooltip text
  final String? tooltip;

  const ContactPickerButton({
    super.key,
    required this.onPhoneSelected,
    this.icon = Icons.contacts,
    this.tooltip,
  });

  Future<void> _pickContact(BuildContext context) async {
    try {
      // Request contacts permission using new API
      final status = await FlutterContacts.permissions.request(
        PermissionType.read,
      );

      if (status == PermissionStatus.granted) {
        // Open the native contact picker using new API
        final contactId = await FlutterContacts.native.showPicker();

        if (contactId != null) {
          // Fetch full contact details to get phone numbers using new API
          final fullContact = await FlutterContacts.get(
            contactId,
            properties: {ContactProperty.phone},
          );

          if (fullContact != null && fullContact.phones.isNotEmpty) {
            // Get the first phone number and normalize it
            final rawPhone = fullContact.phones.first.number;
            // Normalize phone number to remove country codes, spaces, and special characters
            // This converts numbers like "+2507830 54 874" to "0783054874"
            final normalizedPhone = MomoUssdService.cleanPhoneNumber(rawPhone);
            onPhoneSelected(normalizedPhone);
            HapticFeedback.lightImpact();
          } else {
            if (context.mounted) {
              _showNoPhoneError(context);
            }
          }
        }
      } else if (status == PermissionStatus.permanentlyDenied) {
        if (context.mounted) {
          _showPermissionDeniedDialog(context);
        }
      } else {
        if (context.mounted) {
          _showPermissionRequiredSnackbar(context);
        }
      }
    } catch (e, s) {
      talker.error('ContactPickerButton: Error picking contact: $e');
      talker.error(s);
      if (context.mounted) {
        _showErrorSnackbar(context, e.toString());
      }
    }
  }

  void _showNoPhoneError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selected contact has no phone number'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showPermissionRequiredSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contacts permission is required to pick a contact'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Contacts permission has been permanently denied. '
          'Please enable it in your device settings to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              FlutterContacts.permissions.openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip ?? 'Pick from contacts',
      onPressed: () => _pickContact(context),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
