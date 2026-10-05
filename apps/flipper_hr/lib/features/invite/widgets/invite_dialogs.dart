import 'package:flipper_hr/features/invite/data/hr_invite.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_localize/flipper_localize.dart';
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
    builder: (context) =>
        _InviteRoleDialog(employee: employee, directReports: directReports),
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
    final l10n = context.flipperL10n;

    return AlertDialog(
      key: const Key('invite-role-dialog'),
      title: Text(l10n.hrInviteTitle(employee.fullName)),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.isEmpty
                  ? l10n.hrInviteNoContact
                  : l10n.hrInviteWillGetPin(contact),
              style: theme.textTheme.bodyMedium,
            ),
            if (contact.isNotEmpty && !hasPhone) ...[
              const SizedBox(height: 12),
              _Warning(l10n.hrInviteEmailNoPhone),
            ],
            if (employee.hasFlipperAccount) ...[
              const SizedBox(height: 12),
              _Warning(l10n.hrInviteAlreadyHasAccount),
            ],
            if (widget.directReports > 0) ...[
              const SizedBox(height: 12),
              _Warning(l10n.hrInviteDirectReports(widget.directReports)),
            ],
            const SizedBox(height: 20),
            Text(l10n.hrInviteWhatCanTheyDo, style: theme.textTheme.titleSmall),
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
                      subtitle: Text(_describe(l10n, role)),
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
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('invite-confirm'),
          onPressed: contact.isEmpty
              ? null
              : () => Navigator.of(context).pop(_role),
          child: Text(l10n.hrSendInvite),
        ),
      ],
    );
  }

  static String _describe(FlipperAppLocalizations l10n, HrRole role) =>
      switch (role) {
        HrRole.staff => l10n.hrRoleStaffDescription,
        HrRole.manager => l10n.hrRoleManagerDescription,
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
      final l10n = context.flipperL10n;
      return AlertDialog(
        key: const Key('invite-pin-dialog'),
        title: Text(l10n.hrInviteSent),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hrInviteCanNowSignIn(
                  name,
                  invite.role.shortLabel.toLowerCase(),
                ),
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
                      tooltip: l10n.hrCopyPin,
                      icon: const Icon(Icons.copy_all_outlined),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: invite.pin),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.hrPinCopied)),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.hrInvitePinHelp(invite.phoneNumber),
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
            child: Text(l10n.done),
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
        Icon(Icons.info_outline, size: 18, color: theme.colorScheme.tertiary),
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
