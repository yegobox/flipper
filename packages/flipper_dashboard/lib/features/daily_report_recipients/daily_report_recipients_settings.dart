import 'package:flipper_dashboard/features/daily_report_recipients/business_report_recipient_repository.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kTitleText = Color(0xFF111827);
const _kSubtitleText = Color(0xFF6B7280);
const _kMutedText = Color(0xFF9CA3AF);
const _kCardBorder = Color(0xFFE5E7EB);
const _kBarBlue = Color(0xFF2563EB);
const _kFieldFill = Color(0xFFF8FAFC);

/// Admin settings: extra daily report email recipients for the current business.
class DailyReportRecipientsSettings extends StatefulWidget {
  const DailyReportRecipientsSettings({super.key});

  @override
  State<DailyReportRecipientsSettings> createState() =>
      _DailyReportRecipientsSettingsState();
}

class _DailyReportRecipientsSettingsState
    extends State<DailyReportRecipientsSettings> {
  final _repo = BusinessReportRecipientRepository();
  final _emailController = TextEditingController();
  final _labelController = TextEditingController();

  List<BusinessReportRecipient> _recipients = const [];
  bool _loading = true;
  bool _saving = false;
  bool _showAddForm = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  void _notifySuccess(String message) {
    if (!mounted) return;
    showSuccessNotification(context, message);
  }

  void _notifyError(String message) {
    if (!mounted) return;
    showErrorNotification(context, message);
  }

  void _notifyWarning(String message) {
    if (!mounted) return;
    showWarningNotification(context, message);
  }

  InputDecoration _fieldDecoration({
    required String hintText,
    IconData? prefixIcon,
  }) {
    final borderGrey = Colors.grey.shade300;
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.outfit(fontSize: 14, color: _kSubtitleText),
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, size: 18, color: _kSubtitleText),
      filled: true,
      fillColor: _kFieldFill,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _kBarBlue, width: 1.4),
      ),
    );
  }

  void _openAddForm() {
    setState(() => _showAddForm = true);
  }

  void _cancelAddForm() {
    _emailController.clear();
    _labelController.clear();
    setState(() => _showAddForm = false);
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final rows = await _repo.listRecipients();
      if (!mounted) return;
      setState(() {
        _recipients = rows;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _notifyError('Could not load daily report recipients: $e');
    }
  }

  Future<void> _addRecipient() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _notifyWarning('Enter an email address.');
      return;
    }

    setState(() => _saving = true);
    try {
      final row = await _repo.addRecipient(
        email: email,
        label: _labelController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _recipients = [..._recipients, row];
        _emailController.clear();
        _labelController.clear();
        _showAddForm = false;
        _saving = false;
      });
      _notifySuccess('Recipient added.');
    } on BusinessReportRecipientException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _notifyError(e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _notifyError('Could not add recipient: $e');
    }
  }

  Future<void> _removeRecipient(BusinessReportRecipient row) async {
    setState(() => _saving = true);
    try {
      await _repo.deleteRecipient(row.id);
      if (!mounted) return;
      setState(() {
        _recipients = _recipients.where((r) => r.id != row.id).toList();
        _saving = false;
      });
      _notifySuccess('Recipient removed.');
    } on BusinessReportRecipientException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _notifyError(e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _notifyError('Could not remove recipient: $e');
    }
  }

  Widget _recipientTile(BusinessReportRecipient r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _kFieldFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kCardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              size: 16,
              color: _kBarBlue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.email,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kTitleText,
                  ),
                ),
                if (r.label != null && r.label!.isNotEmpty)
                  Text(
                    r.label!,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: _kSubtitleText,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove',
            onPressed: _saving ? null : () => _removeRecipient(r),
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.close, size: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAddForm(bool narrow) {
    final borderGrey = Colors.grey.shade300;
    final emailField = TextField(
      controller: _emailController,
      enabled: !_saving,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: _fieldDecoration(
        hintText: 'e.g. accountant@example.com',
        prefixIcon: Icons.alternate_email_rounded,
      ),
      style: GoogleFonts.outfit(fontSize: 14, color: _kTitleText),
    );
    final labelField = TextField(
      controller: _labelController,
      enabled: !_saving,
      decoration: _fieldDecoration(
        hintText: 'Label (optional)',
        prefixIcon: Icons.label_outline_rounded,
      ),
      style: GoogleFonts.outfit(fontSize: 14, color: _kTitleText),
    );

    final saveBtn = FilledButton(
      onPressed: _saving ? null : _addRecipient,
      style: FilledButton.styleFrom(
        backgroundColor: _kBarBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: _saving
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              'Save recipient',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
    );

    final cancelBtn = OutlinedButton(
      onPressed: _saving ? null : _cancelAddForm,
      style: OutlinedButton.styleFrom(
        foregroundColor: _kTitleText,
        side: BorderSide(color: borderGrey),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        'Cancel',
        style: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kCardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add recipient',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _kTitleText,
              ),
            ),
            const SizedBox(height: 12),
            if (narrow) ...[
              emailField,
              const SizedBox(height: 10),
              labelField,
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: emailField),
                  const SizedBox(width: 10),
                  Expanded(flex: 2, child: labelField),
                ],
              ),
            const SizedBox(height: 12),
            if (narrow)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  saveBtn,
                  const SizedBox(height: 8),
                  cancelBtn,
                ],
              )
            else
              Row(
                children: [
                  saveBtn,
                  const SizedBox(width: 8),
                  cancelBtn,
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 520;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily report recipients',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _kTitleText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'The owner email above receives the daily detailed transactions report. '
                    'Add more addresses to receive the same report.',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: _kSubtitleText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (!_showAddForm && !_loading)
              TextButton.icon(
                onPressed: _saving ? null : _openAddForm,
                icon: const Icon(Icons.add, size: 18, color: _kBarBlue),
                label: Text(
                  'Add',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: _kBarBlue,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (_recipients.isEmpty && !_showAddForm)
          Text(
            'No additional recipients yet.',
            style: GoogleFonts.outfit(fontSize: 12, color: _kMutedText),
          )
        else if (_recipients.isNotEmpty)
          ..._recipients.map(_recipientTile),
        if (_showAddForm) ...[
          if (_recipients.isNotEmpty) const SizedBox(height: 4),
          _buildAddForm(narrow),
        ],
      ],
    );
  }
}
