import 'dart:convert';

import 'package:flipper_dashboard/features/admin/sections/admin_style.dart';
import 'package:flipper_dashboard/features/daily_report_recipients/daily_report_recipients_settings.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/user_profile_name_service.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:supabase_models/brick/models/user.model.dart';

/// The signed-in admin's name, phone and email, editable in place.
///
/// Desktop Admin Control shows it under its "Profile" header; the phone
/// settings hub shows it on its own page with [quiet] styling.
class AdminProfileCard extends StatefulWidget {
  const AdminProfileCard({
    super.key,
    this.showDailyReportRecipients = true,
    this.quiet = false,
  });

  /// Desktop embeds the daily report recipients here; the phone hub lists
  /// them as their own row.
  final bool showDailyReportRecipients;

  /// Neutral avatar and icon tiles, for the phone hub.
  final bool quiet;

  @override
  State<AdminProfileCard> createState() => AdminProfileCardState();
}

class AdminProfileCardState extends State<AdminProfileCard> {
  final settingsService = locator<SettingsService>();

  /// Loaded from Supabase `users` via [ProxyService.box.getUserId] (set at login).
  User? _profileUser;

  /// `users.email` from PostgREST (Brick [User] has no email field).
  String? _profileAccountEmail;

  /// From last Supabase row: non-empty `email` column (edit email only while empty).
  bool _serverHasEmail = false;

  /// From last Supabase row: non-empty `phone_number` column (set phone only while empty).
  bool _serverHasPhone = false;
  bool _profileUserLoading = true;

  bool _inlineEditingEmail = false;
  bool _savingProfileEmail = false;
  late final TextEditingController _profileEmailEditController;

  bool _inlineEditingName = false;
  bool _savingProfileName = false;
  late final TextEditingController _profileNameEditController;

  bool _inlineEditingPhone = false;
  bool _savingProfilePhone = false;
  late final TextEditingController _profilePhoneEditController;

  @override
  void initState() {
    super.initState();
    _profileEmailEditController = TextEditingController();
    _profileNameEditController = TextEditingController();
    _profilePhoneEditController = TextEditingController();
    _loadProfileUserFromSupabase();
  }

  @override
  void dispose() {
    _profileEmailEditController.dispose();
    _profileNameEditController.dispose();
    _profilePhoneEditController.dispose();
    super.dispose();
  }

  /// Re-reads the profile from Supabase (Admin Control's Refresh menu).
  Future<void> reload() => _loadProfileUserFromSupabase();

  /// Reads the signed-in row from Supabase `users` using `userId` from local box.
  Future<void> _loadProfileUserFromSupabase() async {
    final userId = ProxyService.box.getUserId()?.trim();
    if (!mounted) return;
    if (userId == null || userId.isEmpty) {
      setState(() {
        _profileUser = null;
        _profileAccountEmail = null;
        _serverHasEmail = false;
        _serverHasPhone = false;
        _profileUserLoading = false;
      });
      return;
    }
    setState(() => _profileUserLoading = true);
    try {
      final row = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (!mounted) return;
      if (row == null) {
        setState(() {
          _profileUser = null;
          _profileAccountEmail = null;
          _serverHasEmail = false;
          _serverHasPhone = false;
          _profileUserLoading = false;
        });
        return;
      }
      final map = Map<String, dynamic>.from(row);
      final u = _parseUserFromSupabaseRow(map);
      final rawEmail = map['email'];
      final parsedEmail = rawEmail is String ? rawEmail.trim() : null;
      final rawPhone = map['phone_number'];
      final parsedPhone = rawPhone is String ? rawPhone.trim() : null;
      final keyStr = map['key'] is String ? (map['key'] as String).trim() : '';
      final hasLegacyEmailInKey = keyStr.contains('@');
      setState(() {
        _profileUser = u;
        _profileAccountEmail = (parsedEmail != null && parsedEmail.isNotEmpty)
            ? parsedEmail
            : null;
        _serverHasEmail =
            (parsedEmail != null && parsedEmail.isNotEmpty) ||
            hasLegacyEmailInKey;
        _serverHasPhone = parsedPhone != null && parsedPhone.isNotEmpty;
        _profileUserLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _profileUser = null;
        _profileAccountEmail = null;
        _serverHasEmail = false;
        _serverHasPhone = false;
        _profileUserLoading = false;
      });
    }
  }

  /// Maps a PostgREST row to [User] (same fields as generated `_$UserFromSupabase`).
  User? _parseUserFromSupabaseRow(Map<String, dynamic> data) {
    try {
      final id = data['id'] as String?;
      if (id == null || id.isEmpty) return null;
      return User(
        id: id,
        name: data['name'] as String?,
        key: data['key'] as String?,
        pin: data['pin'] as int?,
        editId: data['edit_id'] as bool?,
        isExternal: data['is_external'] as bool?,
        ownership: data['ownership'] as String?,
        groupId: data['group_id'] as int?,
        external: data['external'] as bool?,
        updatedAt: data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
        deletedAt: data['deleted_at'] == null
            ? null
            : DateTime.tryParse(data['deleted_at'] as String),
        phoneNumber: data['phone_number'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  String? _resolvedProfileName(User? u) {
    final name = u?.name?.trim();
    if (name != null && name.isNotEmpty && !_looksLikeUuid(name)) {
      return name;
    }
    return null;
  }

  String _profileDisplayName(User? u) {
    final resolved = _resolvedProfileName(u);
    if (resolved != null) return resolved;
    if (u != null) {
      final key = u.key?.trim() ?? '';
      if (key.contains('@')) {
        final local = key.split('@').first;
        if (local.isNotEmpty) {
          return local.replaceAll('.', ' ').replaceAll('_', ' ');
        }
      } else if (key.isNotEmpty && !_looksLikeUuid(key)) {
        return key;
      }
    }
    final email = _profileEmailFromUser(u)?.trim();
    if (email != null && email.isNotEmpty) {
      final local = email.split('@').first;
      if (local.isNotEmpty) {
        return local.replaceAll('.', ' ').replaceAll('_', ' ');
      }
    }
    return context.flipperL10n.adminUserFallback;
  }

  bool _looksLikeUuid(String value) {
    return RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    ).hasMatch(value.trim());
  }

  String? _profileEmailFromUser(User? u) {
    final direct = _profileAccountEmail?.trim();
    if (direct != null && direct.isNotEmpty) return direct;
    if (u == null) return null;
    final k = u.key?.trim() ?? '';
    if (k.contains('@')) return k;
    return null;
  }

  String _profileInitials(String displayName) {
    final parts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isNotEmpty) {
      final s = parts[0];
      if (s.length >= 2) return s.substring(0, 2).toUpperCase();
      return s[0].toUpperCase();
    }
    return 'U';
  }

  String _formatPhoneSpaces(String raw) {
    if (raw.replaceAll(RegExp(r'[^\d]'), '').length < 9) return raw;
    if (raw.trim().startsWith('+')) {
      final d = raw.replaceAll(RegExp(r'[^\d+]'), '');
      if (d.startsWith('+') && d.length > 4) {
        final rest = d.substring(1);
        final buf = StringBuffer(
          '+${rest.substring(0, rest.length >= 3 ? 3 : rest.length)}',
        );
        var i = 3;
        while (i < rest.length) {
          buf.write(' ');
          buf.write(rest.substring(i, (i + 3).clamp(0, rest.length)));
          i += 3;
        }
        return buf.toString();
      }
    }
    return raw;
  }

  bool _isValidProfileEmail(String value) {
    return RegExp(r'^[\w.+\-]+@[\w\-]+(\.[\w\-]+)+$').hasMatch(value.trim());
  }

  /// Only `name`, `email`, and `phone_number` may be written — never `user_id`, `id`, etc.
  static const Set<String> _kUsersTableProfilePatchKeys = {
    'name',
    'email',
    'phone_number',
  };

  void _clearOtherProfileEditors({
    bool keepEmail = false,
    bool keepName = false,
    bool keepPhone = false,
  }) {
    if (!keepEmail && _inlineEditingEmail) {
      _inlineEditingEmail = false;
      _profileEmailEditController.clear();
    }
    if (!keepName && _inlineEditingName) {
      _inlineEditingName = false;
      _profileNameEditController.clear();
    }
    if (!keepPhone && _inlineEditingPhone) {
      _inlineEditingPhone = false;
      _profilePhoneEditController.clear();
    }
  }

  /// Persists profile fields. Name uses Supabase RPC (login-key check) first, then
  /// flipper-turbo PATCH. Direct client UPDATE often affects 0 rows under RLS.
  Future<void> _patchUsersTableProfileFields(Map<String, dynamic> patch) async {
    final userId = ProxyService.box.getUserId()?.trim();
    if (userId == null || userId.isEmpty) {
      throw StateError('Not signed in');
    }
    final loginKey =
        ProxyService.box.getUserPhone()?.trim() ??
        _profileEmailFromUser(_profileUser)?.trim();
    if (loginKey == null || loginKey.isEmpty) {
      throw StateError('Missing login key for profile update');
    }

    final filteredPatch = <String, dynamic>{};
    for (final e in patch.entries) {
      if (_kUsersTableProfilePatchKeys.contains(e.key)) {
        filteredPatch[e.key] = e.value;
      }
    }
    if (filteredPatch.isEmpty) return;

    final name = filteredPatch['name'];
    if (name is String && name.trim().isNotEmpty) {
      final savedViaRpc = await _trySaveProfileNameViaRpc(
        userId: userId,
        loginKey: loginKey,
        name: name.trim(),
      );
      if (savedViaRpc) {
        filteredPatch.remove('name');
      }
    }

    if (filteredPatch.isEmpty) return;

    final body = <String, dynamic>{
      'id': userId,
      'user_id': userId,
      ...filteredPatch,
    };

    final response = await ProxyService.http.patch(
      Uri.parse('${AppSecrets.apihubProd}/v2/api/user'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Profile update failed (${response.statusCode}): ${response.body}',
      );
    }
  }

  /// Shared with signup (`UserProfileNameService`) so a name saved here and a
  /// name saved at signup land through exactly the same write path.
  Future<bool> _trySaveProfileNameViaRpc({
    required String userId,
    required String loginKey,
    required String name,
  }) {
    return UserProfileNameService.saveViaRpc(
      userId: userId,
      name: name,
      loginKeys: [
        loginKey,
        _profileEmailFromUser(_profileUser),
        _profileUser?.phoneNumber,
      ],
    );
  }

  Future<void> _trySaveProfileNameViaUserPost({
    required String loginKey,
    required String name,
  }) {
    return UserProfileNameService.saveViaUserPost(
      loginKey: loginKey,
      name: name,
    );
  }

  Future<void> _verifyProfileNameSaved(String expectedName) async {
    await _loadProfileUserFromSupabase();
    final actual = _resolvedProfileName(_profileUser);
    if (actual != expectedName.trim()) {
      throw Exception(
        'Name did not persist (still showing ${actual ?? 'empty'}). '
        'Apply the latest Supabase migration and redeploy flipper-turbo.',
      );
    }
  }

  Future<void> _refreshDittoUserAccessAfterProfileChange() async {
    final loginKey =
        ProxyService.box.getUserPhone()?.trim() ??
        ProxyService.box.getUserId()?.trim();
    if (loginKey == null || loginKey.isEmpty) return;
    try {
      await ProxyService.strategy.sendLoginRequest(
        loginKey,
        ProxyService.http,
        AppSecrets.apihubProd,
        expectedPinUserId: ProxyService.box.getUserId(),
        refreshUserAccessOnly: true,
      );
    } catch (_) {
      // Best-effort; Admin profile reloads from Supabase regardless.
    }
  }

  void _startInlineEmailEdit({String? initial}) {
    if (_serverHasEmail) return;
    setState(() {
      _clearOtherProfileEditors(keepEmail: true);
      _inlineEditingEmail = true;
      _profileEmailEditController.text = (initial ?? '').trim();
    });
  }

  void _cancelInlineEmailEdit() {
    setState(() {
      _inlineEditingEmail = false;
      _profileEmailEditController.clear();
    });
  }

  void _startInlineNameEdit({String? initial}) {
    setState(() {
      _clearOtherProfileEditors(keepName: true);
      _inlineEditingName = true;
      final resolved = _resolvedProfileName(_profileUser);
      _profileNameEditController.text = (initial ?? resolved ?? '').trim();
    });
  }

  void _cancelInlineNameEdit() {
    setState(() {
      _inlineEditingName = false;
      _profileNameEditController.clear();
    });
  }

  void _startInlinePhoneEdit({String? initial}) {
    if (_serverHasPhone) return;
    setState(() {
      _clearOtherProfileEditors(keepPhone: true);
      _inlineEditingPhone = true;
      _profilePhoneEditController.text = (initial ?? '').trim();
    });
  }

  void _cancelInlinePhoneEdit() {
    setState(() {
      _inlineEditingPhone = false;
      _profilePhoneEditController.clear();
    });
  }

  Future<void> _saveInlineName() async {
    final name = _profileNameEditController.text.trim();
    if (name.isEmpty) {
      showErrorNotification(context, context.flipperL10n.adminEnterDisplayName);
      return;
    }
    final userId = ProxyService.box.getUserId()?.trim();
    if (userId == null || userId.isEmpty) {
      showErrorNotification(context, context.flipperL10n.adminNotSignedIn);
      return;
    }
    final loginKey =
        ProxyService.box.getUserPhone()?.trim() ??
        _profileEmailFromUser(_profileUser)?.trim();
    if (loginKey == null || loginKey.isEmpty) {
      showErrorNotification(context, context.flipperL10n.adminMissingLoginKey);
      return;
    }
    setState(() => _savingProfileName = true);
    try {
      var saved = await _trySaveProfileNameViaRpc(
        userId: userId,
        loginKey: loginKey,
        name: name,
      );
      if (!saved) {
        await _patchUsersTableProfileFields({'name': name});
      }
      if (!mounted) return;
      setState(() {
        _savingProfileName = false;
        _inlineEditingName = false;
        _profileNameEditController.clear();
        _profileUser = _profileUser?.copyWith(name: name);
      });
      await _verifyProfileNameSaved(name);
      await _refreshDittoUserAccessAfterProfileChange();
      if (mounted) {
        showSuccessNotification(context, context.flipperL10n.adminNameUpdated);
      }
    } catch (e) {
      try {
        await _trySaveProfileNameViaUserPost(loginKey: loginKey, name: name);
        if (!mounted) return;
        setState(() {
          _savingProfileName = false;
          _inlineEditingName = false;
          _profileNameEditController.clear();
          _profileUser = _profileUser?.copyWith(name: name);
        });
        await _verifyProfileNameSaved(name);
        await _refreshDittoUserAccessAfterProfileChange();
        if (mounted) {
          showSuccessNotification(
            context,
            context.flipperL10n.adminNameUpdated,
          );
        }
        return;
      } catch (_) {
        // Fall through to primary error.
      }
      if (!mounted) return;
      setState(() => _savingProfileName = false);
      showErrorNotification(
        context,
        context.flipperL10n.adminSaveNameFailed('$e'),
      );
    }
  }

  Future<void> _saveInlinePhone() async {
    var raw = _profilePhoneEditController.text.trim();
    if (!adminIsValidPhoneNumber(raw)) {
      showErrorNotification(
        context,
        context.flipperL10n.adminPhoneWithCountryCode,
      );
      return;
    }
    raw = adminFormatPhoneNumber(raw);
    final userId = ProxyService.box.getUserId()?.trim();
    if (userId == null || userId.isEmpty) {
      showErrorNotification(context, context.flipperL10n.adminNotSignedIn);
      return;
    }
    if (_serverHasPhone) {
      showErrorNotification(context, context.flipperL10n.adminPhoneSetOnce);
      return;
    }
    setState(() => _savingProfilePhone = true);
    try {
      await _patchUsersTableProfileFields({'phone_number': raw});
      if (!mounted) return;
      setState(() {
        _savingProfilePhone = false;
        _inlineEditingPhone = false;
        _profilePhoneEditController.clear();
      });
      await _loadProfileUserFromSupabase();
      await _refreshDittoUserAccessAfterProfileChange();
      if (mounted) {
        showSuccessNotification(context, context.flipperL10n.adminPhoneSaved);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _savingProfilePhone = false);
      showErrorNotification(
        context,
        context.flipperL10n.adminSavePhoneFailed('$e'),
      );
    }
  }

  Future<void> _saveInlineEmail() async {
    if (_serverHasEmail) {
      showErrorNotification(context, context.flipperL10n.adminEmailAlreadySet);
      return;
    }
    final email = _profileEmailEditController.text.trim();
    if (!_isValidProfileEmail(email)) {
      showErrorNotification(context, context.flipperL10n.adminInvalidEmail);
      return;
    }
    final userId = ProxyService.box.getUserId()?.trim();
    if (userId == null || userId.isEmpty) {
      showErrorNotification(context, context.flipperL10n.adminNotSignedIn);
      return;
    }
    setState(() => _savingProfileEmail = true);
    try {
      await _patchUsersTableProfileFields({'email': email});
      final syncedSettings = await settingsService.updateSettings(
        map: {'email': email},
      );
      if (!mounted) return;
      if (!syncedSettings) {
        showWarningNotification(
          context,
          context.flipperL10n.adminEmailSavedBusinessFailed,
        );
      }
      setState(() {
        _savingProfileEmail = false;
        _inlineEditingEmail = false;
        _profileEmailEditController.clear();
      });
      await _loadProfileUserFromSupabase();
      await _refreshDittoUserAccessAfterProfileChange();
      if (mounted) {
        showSuccessNotification(context, context.flipperL10n.adminEmailUpdated);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _savingProfileEmail = false);
      showErrorNotification(
        context,
        context.flipperL10n.adminSaveEmailFailed('$e'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 520;
    return Container(
      decoration: adminCardDecoration(),
      padding: const EdgeInsets.all(20),
      child: _profileUserLoading
          ? const SizedBox(
              height: 96,
              child: Center(child: CircularProgressIndicator()),
            )
          : _buildAdminProfileCardBody(context, narrow),
    );
  }

  Widget _buildInlineEmailEditor(BuildContext context, bool narrow) {
    final borderGrey = Colors.grey.shade300;

    final field = TextField(
      controller: _profileEmailEditController,
      enabled: !_savingProfileEmail,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: context.flipperL10n.adminEmailHint,
        hintStyle: GoogleFonts.outfit(fontSize: 14, color: kAdminSubtitleText),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
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
          borderSide: const BorderSide(color: kAdminBarBlue, width: 1.4),
        ),
      ),
      style: GoogleFonts.outfit(fontSize: 14, color: kAdminTitleText),
    );

    final saveBtn = OutlinedButton(
      onPressed: _savingProfileEmail ? null : _saveInlineEmail,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: BorderSide(color: borderGrey),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: _savingProfileEmail
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: kAdminBarBlue,
              ),
            )
          : Text(
              context.flipperL10n.save,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
    );

    final cancelBtn = OutlinedButton(
      onPressed: _savingProfileEmail ? null : _cancelInlineEmailEdit,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: BorderSide(color: borderGrey),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        context.flipperL10n.cancel,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w400, fontSize: 14),
      ),
    );

    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          field,
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [saveBtn, const SizedBox(width: 8), cancelBtn],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: field),
        const SizedBox(width: 10),
        saveBtn,
        const SizedBox(width: 8),
        cancelBtn,
      ],
    );
  }

  Widget _buildInlineNameEditor(BuildContext context, bool narrow) {
    final borderGrey = Colors.grey.shade300;
    final field = TextField(
      controller: _profileNameEditController,
      enabled: !_savingProfileName,
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        hintText: context.flipperL10n.displayName,
        hintStyle: GoogleFonts.outfit(fontSize: 14, color: kAdminSubtitleText),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
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
          borderSide: const BorderSide(color: kAdminBarBlue, width: 1.4),
        ),
      ),
      style: GoogleFonts.outfit(fontSize: 14, color: kAdminTitleText),
    );

    final saveBtn = OutlinedButton(
      onPressed: _savingProfileName ? null : _saveInlineName,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: BorderSide(color: borderGrey),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: _savingProfileName
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: kAdminBarBlue,
              ),
            )
          : Text(
              context.flipperL10n.save,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
    );

    final cancelBtn = OutlinedButton(
      onPressed: _savingProfileName ? null : _cancelInlineNameEdit,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: BorderSide(color: borderGrey),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        context.flipperL10n.cancel,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w400, fontSize: 14),
      ),
    );

    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          field,
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [saveBtn, const SizedBox(width: 8), cancelBtn],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: field),
        const SizedBox(width: 10),
        saveBtn,
        const SizedBox(width: 8),
        cancelBtn,
      ],
    );
  }

  Widget _buildInlinePhoneEditor(BuildContext context, bool narrow) {
    final borderGrey = Colors.grey.shade300;
    final field = TextField(
      controller: _profilePhoneEditController,
      enabled: !_savingProfilePhone,
      autofocus: true,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: context.flipperL10n.adminPhoneExampleHint,
        hintStyle: GoogleFonts.outfit(fontSize: 14, color: kAdminSubtitleText),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
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
          borderSide: const BorderSide(color: kAdminBarTeal, width: 1.4),
        ),
      ),
      style: GoogleFonts.outfit(fontSize: 14, color: kAdminTitleText),
    );

    final saveBtn = OutlinedButton(
      onPressed: _savingProfilePhone ? null : _saveInlinePhone,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: BorderSide(color: borderGrey),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: _savingProfilePhone
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: kAdminBarTeal,
              ),
            )
          : Text(
              context.flipperL10n.save,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
    );

    final cancelBtn = OutlinedButton(
      onPressed: _savingProfilePhone ? null : _cancelInlinePhoneEdit,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: BorderSide(color: borderGrey),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        context.flipperL10n.cancel,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w400, fontSize: 14),
      ),
    );

    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          field,
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [saveBtn, const SizedBox(width: 8), cancelBtn],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: field),
        const SizedBox(width: 10),
        saveBtn,
        const SizedBox(width: 8),
        cancelBtn,
      ],
    );
  }

  Widget _buildAdminProfileCardBody(BuildContext context, bool narrow) {
    final u = _profileUser;
    final displayName = _profileDisplayName(u);
    final initials = _profileInitials(displayName);
    final emailRaw = _profileEmailFromUser(u)?.trim() ?? '';
    final hasEmail = emailRaw.isNotEmpty;
    final phoneOnAccount = u?.phoneNumber?.trim();
    final hasPhoneOnAccount =
        phoneOnAccount != null && phoneOnAccount.isNotEmpty;

    final centerBlock = Column(
      crossAxisAlignment: narrow
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (_inlineEditingName)
          _buildInlineNameEditor(context, narrow)
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  displayName,
                  textAlign: narrow ? TextAlign.center : TextAlign.start,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                tooltip: context.flipperL10n.editName,
                onPressed: () => _startInlineNameEdit(),
                icon: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Colors.grey.shade700,
                ),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield_outlined, size: 14, color: kAdminBarBlue),
              const SizedBox(width: 4),
              Text(
                context.flipperL10n.adminBadge,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: kAdminBarBlue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _adminProfileInfoRow(
          iconBg: const Color(0xFFCCFBF1),
          icon: Icons.phone_outlined,
          iconColor: kAdminBarTeal,
          child: _inlineEditingPhone
              ? _buildInlinePhoneEditor(context, narrow)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        hasPhoneOnAccount
                            ? _formatPhoneSpaces(phoneOnAccount)
                            : context.flipperL10n.adminNoPhoneOnAccount,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: hasPhoneOnAccount
                              ? kAdminTitleText
                              : kAdminSubtitleText,
                          fontStyle: hasPhoneOnAccount
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                      ),
                    ),
                    if (!_serverHasPhone)
                      TextButton.icon(
                        onPressed: () => _startInlinePhoneEdit(),
                        icon: Icon(Icons.add, size: 18, color: kAdminBarTeal),
                        label: Text(
                          context.flipperL10n.adminAddPhone,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: kAdminBarTeal,
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 10),
        _adminProfileInfoRow(
          iconBg: const Color(0xFFEFF6FF),
          icon: Icons.mail_outline_rounded,
          iconColor: kAdminBarBlue,
          child: _inlineEditingEmail
              ? _buildInlineEmailEditor(context, narrow)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        hasEmail
                            ? emailRaw
                            : context.flipperL10n.adminNoEmailSet,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: hasEmail
                              ? kAdminTitleText
                              : kAdminSubtitleText,
                          fontStyle: hasEmail
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                      ),
                    ),
                    if (!_serverHasEmail)
                      TextButton.icon(
                        onPressed: () => _startInlineEmailEdit(),
                        icon: Icon(Icons.add, size: 18, color: kAdminBarBlue),
                        label: Text(
                          context.flipperL10n.adminAddEmail,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: kAdminBarBlue,
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        if (widget.showDailyReportRecipients) ...[
          const SizedBox(height: 20),
          const Divider(height: 1, color: kAdminCardBorder),
          const SizedBox(height: 16),
          const DailyReportRecipientsSettings(),
        ],
      ],
    );

    final avatar = Container(
      width: 72,
      height: 72,
      alignment: Alignment.center,
      decoration: widget.quiet
          ? const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF1F5F9),
            )
          : const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
      child: Text(
        initials,
        style: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: widget.quiet ? kAdminTitleText : Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );

    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          avatar,
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: centerBlock),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        avatar,
        const SizedBox(width: 20),
        Expanded(child: centerBlock),
      ],
    );
  }

  Widget _adminProfileInfoRow({
    required Color iconBg,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: widget.quiet ? const Color(0xFFF1F5F9) : iconBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: widget.quiet ? kAdminSubtitleText : iconColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: child),
      ],
    );
  }
}
