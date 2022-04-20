import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterfire_ui/auth.dart';

Future<bool> showReauthenticateDialog({
  required BuildContext context,
  required List<ProviderConfiguration> providerConfigs,
  FirebaseAuth? auth,
  VoidCallback? onSignedIn,
}) async {
  return await showGeneralDialog<bool>(
        context: context,
        pageBuilder: (context, _, __) => ReauthenticateDialog(
          providerConfigs: providerConfigs,
          auth: auth,
          onSignedIn: onSignedIn,
        ),
      ) ??
      false;
}

Future<void> showDifferentMethodSignInDialog({
  required BuildContext context,
  required List<String> availableProviders,
  required List<ProviderConfiguration> providerConfigs,
  FirebaseAuth? auth,
  VoidCallback? onSignedIn,
}) async {
  await showGeneralDialog(
    context: context,
    pageBuilder: (context, _, __) => DifferentMethodSignInDialog(
      availableProviders: availableProviders,
      providerConfigs: providerConfigs,
      auth: auth,
      onSignedIn: () {
        Navigator.of(context).pop();
      },
    ),
  );
}
