import 'package:flipper_localize/flipper_localize.dart';

/// Import status filter options: wire value (null = all) → localized label.
Map<String?, String> importStatusOptions(FlipperAppLocalizations l10n) => {
  null: l10n.importStatusAll,
  '2': l10n.importStatusWaiting,
  '3': l10n.approved,
  '4': l10n.importStatusRejected,
};
