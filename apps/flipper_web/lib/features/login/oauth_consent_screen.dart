import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OAuthConsentScreen extends StatefulWidget {
  const OAuthConsentScreen({super.key, required this.authorizationId});

  final String authorizationId;

  @override
  State<OAuthConsentScreen> createState() => _OAuthConsentScreenState();
}

class _OAuthConsentScreenState extends State<OAuthConsentScreen> {
  OAuthAuthorizationDetailsResponse? _details;
  String? _redirectUrl;
  String? _error;
  bool? _approved;
  bool _loading = false;

  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if (widget.authorizationId.trim().isEmpty) {
      _error = 'This authorization request is missing its request ID.';
    } else if (_supabase.auth.currentUser != null) {
      _loadAuthorization();
    }
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
        setState(() => _details = response);
      } else if (response is OAuthAuthorizationRedirectResponse) {
        setState(() {
          _redirectUrl = response.redirectUrl;
          _approved = true;
        });
      }
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on Exception catch (error) {
      if (mounted) setState(() => _error = 'Could not load authorization: $error');
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
        setState(
          () => _error = 'Supabase returned no authorization redirect URL.',
        );
        return;
      }
      setState(() {
        _redirectUrl = redirectUrl;
        _approved = approve;
      });
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on Exception catch (error) {
      if (mounted) setState(() => _error = 'Could not submit your decision: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _continueToClient() async {
    final redirectUrl = _redirectUrl;
    final uri = redirectUrl == null ? null : Uri.tryParse(redirectUrl);
    if (uri == null || !uri.hasScheme) {
      setState(() => _error = 'The authorization server returned an invalid redirect.');
      return;
    }
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (!launched && mounted) {
        setState(() => _error = 'Could not open the MCP client redirect.');
      }
    } on Exception catch (error) {
      if (mounted) setState(() => _error = 'Could not open the MCP client redirect: $error');
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
    );
  }

  Widget _signedOutContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Connect an AI client to Flipper', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const Text('Sign in to review this client’s read-only access request.'),
        if (_error != null) ...[
          const SizedBox(height: 16),
          _ErrorText(message: _error!),
        ],
        const SizedBox(height: 24),
        FilledButton(onPressed: _signIn, child: const Text('Sign in to Flipper')),
      ],
    );
  }

  Widget _consentContent() {
    final details = _details;
    final redirectUrl = _redirectUrl;
    if (_error != null && details == null && redirectUrl == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Authorization unavailable', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          _ErrorText(message: _error!),
          const SizedBox(height: 20),
          OutlinedButton(onPressed: _loadAuthorization, child: const Text('Try again')),
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
            approved ? 'Access approved' : 'Access denied',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            approved
                ? 'Return to the AI client to finish connecting to Flipper.'
                : 'Return to the AI client. It will not be connected to Flipper.',
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            _ErrorText(message: _error!),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _continueToClient,
            child: const Text('Continue to AI client'),
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
        Text('Connect an AI client to Flipper', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 20),
        Text(
          clientName == null || clientName.isEmpty ? 'MCP client' : clientName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const Text(
          'This client can read the branches available to your Flipper account '
          'and completed transaction summaries for those branches. It cannot '
          'change Flipper data.',
        ),
        const SizedBox(height: 16),
        Text('Client redirect URI', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        SelectableText(details.redirectUri),
        if (scopes.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Requested identity scopes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final scope in scopes) Text('• $scope'),
        ],
        const SizedBox(height: 20),
        Text(
          'After approving, return to the client to finish connecting. '
          'You can deny this request instead.',
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
              child: const Text('Approve read-only access'),
            ),
            OutlinedButton(
              onPressed: _loading ? null : () => _decide(approve: false),
              child: const Text('Deny'),
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
