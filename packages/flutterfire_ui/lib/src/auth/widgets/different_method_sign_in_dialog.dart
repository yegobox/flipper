import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/i10n.dart';

import '../widgets/internal/title.dart';

class DifferentMethodSignInDialog extends StatelessWidget {
  final FirebaseAuth? auth;
  final List<String> availableProviders;
  final List<ProviderConfiguration> providerConfigs;
  final VoidCallback? onSignedIn;

  const DifferentMethodSignInDialog({
    Key? key,
    required this.availableProviders,
    required this.providerConfigs,
    this.auth,
    this.onSignedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = FlutterFireUILocalizations.labelsOf(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Title(text: l.differentMethodsSignInTitleText),
                const SizedBox(height: 32),
                DifferentMethodSignInView(
                  auth: auth,
                  providerConfigs: providerConfigs,
                  availableProviders: availableProviders,
                  onSignedIn: onSignedIn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
