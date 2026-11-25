import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OAuthConsentScreen extends StatefulWidget {
  const OAuthConsentScreen({
    super.key,
    required this.authorizationId,
    this.supabaseClient,
  });

  final String authorizationId;
  final SupabaseClient? supabaseClient;

  @override
  State<OAuthConsentScreen> createState() => _OAuthConsentScreenState();
}

class _OAuthConsentScreenState extends State<OAuthConsentScreen> {
  OAuthAuthorizationDetailsResponse? _details;
  String? _redirectUrl;
  String? _error;
  bool? _approved;
  bool _loading = false;
  bool _authorizationWasAlreadyApproved = false;

  SupabaseClient get _supabase =>
      widget.supabaseClient ?? Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if (widget.authorizationId.trim().isNotEmpty &&
        _supabase.auth.currentUser != null) {
      _loadAuthorization();
    }
  }

  void _logFailure(String operation, Object error, StackTrace stackTrace) {
    talker.error(
      'MCP OAuth $operation failed (${error.runtimeType})',
      stackTrace,
    );
  }

  Future<void> _loadAuthorization() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await _supabase.auth.oauth.getAuthorizationDetails(
        widget.authorizationId,
      );
      if (!mounted) return;
      if (response is OAuthAuthorizationDetailsResponse) {
        setState(() {
          _details = response;
          _authorizationWasAlreadyApproved = false;
        });
      } else if (response is OAuthAuthorizationRedirectResponse) {
        setState(() {
          _redirectUrl = response.redirectUrl;
          _approved = true;
          _authorizationWasAlreadyApproved = true;
        });
      } else {
        setState(() => _error = context.flipperL10n.mcpConsentLoadFailed);
      }
    } on AuthException catch (error, stackTrace) {
      _logFailure('load authorization', error, stackTrace);
      if (mounted) {
        setState(() => _error = context.flipperL10n.mcpConsentLoadFailed);
      }
    } on Exception catch (error, stackTrace) {
      _logFailure('load authorization', error, stackTrace);
      if (mounted) {
        setState(() => _error = context.flipperL10n.mcpConsentLoadFailed);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _decide({required bool approve}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = approve
          ? await _supabase.auth.oauth.approveAuthorization(
              widget.authorizationId,
            )
          : await _supabase.auth.oauth.denyAuthorization(
              widget.authorizationId,
            );
      if (!mounted) return;
      final redirectUrl = response.redirectUrl?.trim();
      if (redirectUrl == null || redirectUrl.isEmpty) {
        setState(() => _error = context.flipperL10n.mcpConsentRedirectMissing);
        return;
      }
      setState(() {
        _redirectUrl = redirectUrl;
        _approved = approve;
        _authorizationWasAlreadyApproved = false;
      });
    } on AuthException catch (error, stackTrace) {
      _logFailure(approve ? 'approve' : 'deny', error, stackTrace);
      if (mounted) {
        setState(() => _error = context.flipperL10n.mcpConsentDecisionFailed);
      }
    } on Exception catch (error, stackTrace) {
      _logFailure(approve ? 'approve' : 'deny', error, stackTrace);
      if (mounted) {
        setState(() => _error = context.flipperL10n.mcpConsentDecisionFailed);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _isAllowedRedirect(Uri uri) {
    if (uri.userInfo.isNotEmpty) return false;
    final scheme = uri.scheme.toLowerCase();
    if (scheme == 'http' || scheme == 'https') {
      if (uri.host.isEmpty) return false;
    } else if (!_isValidCustomScheme(scheme)) {
      return false;
    }

    final registeredRedirectUri = _details?.redirectUri;
    if (registeredRedirectUri != null) {
      final registered = Uri.tryParse(registeredRedirectUri);
      return registered != null &&
          registered.scheme.toLowerCase() == scheme &&
          registered.host.toLowerCase() == uri.host.toLowerCase() &&
          registered.port == uri.port &&
          registered.path == uri.path;
    }

    return _authorizationWasAlreadyApproved;
  }

  bool _isValidCustomScheme(String scheme) {
    const blockedSchemes = {
      'about',
      'blob',
      'chrome',
      'chrome-extension',
      'data',
      'file',
      'javascript',
      'resource',
      'view-source',
    };
    return !blockedSchemes.contains(scheme) &&
        RegExp(r'^[a-z][a-z0-9+.-]*$').hasMatch(scheme);
  }

  Future<void> _continueToClient() async {
    final redirectUrl = _redirectUrl;
    final uri = redirectUrl == null ? null : Uri.tryParse(redirectUrl);
    if (uri == null || !_isAllowedRedirect(uri)) {
      setState(() => _error = context.flipperL10n.mcpConsentInvalidRedirect);
      return;
    }
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
        webOnlyWindowName: kIsWeb ? '_self' : null,
      );
      if (!launched && mounted) {
        setState(() => _error = context.flipperL10n.mcpConsentRedirectFailed);
      }
    } on Exception catch (error, stackTrace) {
      _logFailure('open client redirect', error, stackTrace);
      if (mounted) {
        setState(() => _error = context.flipperL10n.mcpConsentRedirectFailed);
      }
    }
  }

  void _signIn() {
    final consentLocation = Uri(
      path: '/oauth/consent',
      queryParameters: {'authorization_id': widget.authorizationId},
    ).toString();
    final loginLocation = Uri(
      path: '/login',
      queryParameters: {'continue': consentLocation},
    );
    context.go(loginLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    final user = _supabase.auth.currentUser;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: SingleChildScrollView(
                child: _loading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : user == null
                    ? _signedOutContent()
                    : _consentContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signedOutContent() {
    final l10n = context.flipperL10n;
    if (widget.authorizationId.trim().isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.mcpConsentUnavailable,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _ErrorText(message: _error ?? l10n.mcpConsentRequestMissingId),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.mcpConsentTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text(l10n.mcpConsentSignInDescription),
        if (_error != null) ...[
          const SizedBox(height: 16),
          _ErrorText(message: _error!),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _signIn,
          child: Text(l10n.mcpConsentSignInButton),
        ),
      ],
    );
  }

  Widget _consentContent() {
    final l10n = context.flipperL10n;
    final details = _details;
    final redirectUrl = _redirectUrl;
    if (widget.authorizationId.trim().isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.mcpConsentUnavailable,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _ErrorText(message: l10n.mcpConsentRequestMissingId),
        ],
      );
    }
    if (_error != null && details == null && redirectUrl == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.mcpConsentUnavailable,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _ErrorText(message: _error!),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: _loadAuthorization,
            child: Text(l10n.mcpConsentTryAgain),
          ),
        ],
      );
    }
    if (redirectUrl != null) {
      final approved = _approved ?? true;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            approved
                ? l10n.mcpConsentAccessApproved
                : l10n.mcpConsentAccessDenied,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            approved
                ? l10n.mcpConsentReturnApproved
                : l10n.mcpConsentReturnDenied,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            _ErrorText(message: _error!),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _continueToClient,
            child: Text(l10n.mcpConsentContinue),
          ),
        ],
      );
    }
    if (details == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final scopes = (details.scope ?? '')
        .split(RegExp(r'\s+'))
        .where((scope) => scope.isNotEmpty)
        .toList();
    final clientName = details.client.clientName?.trim();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.mcpConsentTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        Text(
          clientName == null || clientName.isEmpty
              ? l10n.mcpConsentClientDefault
              : clientName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(l10n.mcpConsentReadOnlyDescription),
        const SizedBox(height: 16),
        Text(
          l10n.mcpConsentClientRedirectUri,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        SelectableText(details.redirectUri),
        if (scopes.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            l10n.mcpConsentRequestedScopes,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final scope in scopes) Text('• $scope'),
        ],
        const SizedBox(height: 20),
        Text(
          l10n.mcpConsentAfterDecision,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          _ErrorText(message: _error!),
        ],
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: _loading ? null : () => _decide(approve: true),
              child: Text(l10n.mcpConsentApprove),
            ),
            OutlinedButton(
              onPressed: _loading ? null : () => _decide(approve: false),
              child: Text(l10n.mcpConsentDeny),
            ),
          ],
        ),
      ],
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    );
  }
}
