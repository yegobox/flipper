import 'package:flipper_hr/features/invite/data/hr_invite.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Asks what the invitee may do, and warns when the record cannot support an
/// invite at all.
///
/// Returns the chosen role, or null if cancelled.
Future<HrRole?> showInviteRoleDialog(
  BuildContext context, {
  required Employee employee,
  int directReports = 0,
}) {
  return showDialog<HrRole>(
    context: context,
    builder: (context) => _InviteRoleDialog(
      employee: employee,
      directReports: directReports,
    ),
  );
}

class _InviteRoleDialog extends StatefulWidget {
  const _InviteRoleDialog({required this.employee, this.directReports = 0});

  final Employee employee;

  /// How many people report to them on the roster. Shown because it changes what
  /// the Staff role means for this person: the reporting line grants approval on
  /// its own, so a supervisor does not need the HR-manager grant to answer their
  /// own team.
  final int directReports;

  @override
  State<_InviteRoleDialog> createState() => _InviteRoleDialogState();
}

class _InviteRoleDialogState extends State<_InviteRoleDialog> {
  HrRole _role = HrRole.staff;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final employee = widget.employee;
    final contact = employee.inviteContact;
    // An email reaches /v2/api/user, but the PIN is confirmed by an SMS OTP, so
    // a record with no phone produces a login nobody can complete.
    final hasPhone = employee.phone.trim().isNotEmpty;

    return AlertDialog(
      key: const Key('invite-role-dialog'),
      title: Text('Invite ${employee.fullName} to HR'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.isEmpty
                  ? 'This record has no phone number or email, so there is '
                        'nowhere to send an invite. Add one first.'
                  : 'They will get a PIN to sign in at hr.useflipper.com with, '
                        'confirmed by a code sent to $contact.',
              style: theme.textTheme.bodyMedium,
            ),
            if (contact.isNotEmpty && !hasPhone) ...[
              const SizedBox(height: 12),
              _Warning(
                'This record has an email but no phone number. Signing in '
                'needs a code sent by SMS, so add a phone number before '
                'inviting.',
              ),
            ],
            if (employee.hasFlipperAccount) ...[
              const SizedBox(height: 12),
              _Warning(
                'They already have an account. Inviting again issues a fresh '
                'PIN and updates what they can do — it does not create a '
                'second person.',
              ),
            ],
            if (widget.directReports > 0) ...[
              const SizedBox(height: 12),
              _Warning(
                '${widget.directReports} '
                '${widget.directReports == 1 ? 'person' : 'people'} '
                'report to them, so they will approve that leave whichever role '
                'you pick. The roster and everyone else\'s pay is what the '
                'manager role adds.',
              ),
            ],
            const SizedBox(height: 20),
            Text('What can they do?', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            // RadioGroup owns the selection: the per-tile groupValue/onChanged
            // pair is deprecated in this Flutter.
            RadioGroup<HrRole>(
              groupValue: _role,
              onChanged: (value) =>
                  setState(() => _role = value ?? HrRole.staff),
              child: Column(
                children: [
                  for (final role in HrRole.values)
                    RadioListTile<HrRole>(
                      key: Key('invite-role-${role.name}'),
                      value: role,
                      title: Text(role.label),
                      subtitle: Text(_describe(role)),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('invite-confirm'),
          onPressed: contact.isEmpty
              ? null
              : () => Navigator.of(context).pop(_role),
          child: const Text('Send invite'),
        ),
      ],
    );
  }

  static String _describe(HrRole role) => switch (role) {
    HrRole.staff =>
      'Sees their own record, books leave and checks their balance — plus '
          'approves leave for anyone who reports to them.',
    HrRole.manager =>
      'Everything above, plus the branch roster, pay, and approving leave for '
          'the whole business.',
  };
}

/// Shows the issued PIN. This is the only time it is visible — apihub does not
/// hand it back a second time — so it is presented to be copied, not dismissed
/// in passing.
Future<void> showInvitePinDialog(
  BuildContext context, {
  required HrInvite invite,
  required String name,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final theme = Theme.of(context);
      return AlertDialog(
        key: const Key('invite-pin-dialog'),
        title: const Text('Invite sent'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$name can now sign in at hr.useflipper.com as '
                '${invite.role.label.split('—').first.trim().toLowerCase()}.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PIN', style: theme.textTheme.labelSmall),
                          const SizedBox(height: 2),
                          SelectableText(
                            invite.pin,
                            key: const Key('invite-pin-value'),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      key: const Key('invite-pin-copy'),
                      tooltip: 'Copy PIN',
                      icon: const Icon(Icons.copy_all_outlined),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: invite.pin),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('PIN copied.')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Signing in asks for this PIN, then a code sent to '
                '${invite.phoneNumber}. Pass the PIN on now — it is not shown '
                'again, and a lost one is replaced by inviting them a second '
                'time.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      );
    },
  );
}

class _Warning extends StatelessWidget {
  const _Warning(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline,
          size: 18,
          color: theme.colorScheme.tertiary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
