import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/flipper_localizations.dart'; // Add this line.

class Localization {
  static AppLocalizations? of(BuildContext context) {
    return AppLocalizations.of(context);
  }
}
