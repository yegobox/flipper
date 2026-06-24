import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flipper_localize/flipper_localize.dart';
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
        // flutter_contacts v2.0.x returns `String?` (contactId),
        // flutter_contacts v2.1.x returns `Contact?`.
        final dynamic picked = await FlutterContacts.native.showPicker();

        String? contactId;
        Contact? contact;

        if (picked is Contact) {
          contact = picked;
          contactId = picked.id;
        } else if (picked is String) {
          contactId = picked;
        }

        contact ??= contactId == null
            ? null
            : await FlutterContacts.get(
                contactId,
                properties: {ContactProperty.phone},
              );

        if (contact != null && contact.phones.isNotEmpty) {
          final rawPhone = contact.phones.first.number;
          final normalizedPhone = MomoUssdService.cleanPhoneNumber(rawPhone);
          onPhoneSelected(normalizedPhone);
          HapticFeedback.lightImpact();
        } else if (contact != null) {
          if (context.mounted) {
            _showNoPhoneError(context);
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
      SnackBar(
        content: Text(
          FLocalization.of(context).selectedContactHasNoPhoneNumber,
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showPermissionRequiredSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(FLocalization.of(context).contactsPermissionRequired),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(FLocalization.of(context).permissionRequired),
        content: Text(
          FLocalization.of(context).contactsPermissionDeniedSettings,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(FLocalization.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              FlutterContacts.permissions.openSettings();
            },
            child: Text(FLocalization.of(context).openSettings),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(FLocalization.of(context).errorMessage(error)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const buttonSize = 40.0;

    return IconButton(
      icon: Icon(icon),
      iconSize: 22,
      tooltip: tooltip ?? FLocalization.of(context).pickFromContacts,
      onPressed: () => _pickContact(context),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        fixedSize: const Size.square(buttonSize),
        minimumSize: const Size.square(buttonSize),
        maximumSize: const Size.square(buttonSize),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
