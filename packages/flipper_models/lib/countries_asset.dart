import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Bundled ISO country reference data.
///
/// The `countries` table is remote-only (Brick fetches it with
/// `awaitRemoteWhenNoneExist`), so a business whose backend has no rows gets an
/// empty country-of-origin dropdown — a dead control. This CSV ships inside the
/// app so the picker always has options.
///
/// Declared under `flutter/assets` in this package's pubspec.yaml; the runtime
/// key therefore carries the `packages/<name>/` prefix.
const String kBundledCountriesAsset =
    'packages/flipper_models/assets/countries.csv';

/// ISO code for Rwanda — the default origin, and what the product save path
/// already falls back to when nothing is chosen.
const String kDefaultCountryCode = 'RW';

/// Parses `countries.csv` (`name,sort_order,code,description`).
///
/// Deliberately not a full RFC 4180 parser: the file quotes some fields but
/// contains no embedded commas, so splitting on `,` and stripping wrapping
/// quotes is enough. Rows that do not have a numeric `sort_order` are skipped,
/// which also disposes of the header line. Duplicate codes keep the first row.
///
/// The returned [Country] objects get fresh generated ids each call — they are
/// only ever used to populate a picker keyed on [Country.code], never persisted.
List<Country> parseCountriesCsv(String csv) {
  final countries = <Country>[];
  final seenCodes = <String>{};

  for (final line in const LineSplitter().convert(csv)) {
    if (line.trim().isEmpty) continue;

    final fields = line.split(',');
    if (fields.length < 3) continue;

    final name = _unquote(fields[0]);
    final sortOrder = int.tryParse(_unquote(fields[1]));
    final code = _unquote(fields[2]).toUpperCase();

    if (name.isEmpty || code.isEmpty || sortOrder == null) continue;
    if (!seenCodes.add(code)) continue;

    countries.add(
      Country(
        name: name,
        sortOrder: sortOrder,
        code: code,
        description: fields.length > 3 ? _unquote(fields[3]) : name,
      ),
    );
  }

  return countries;
}

/// Loads and parses [kBundledCountriesAsset].
Future<List<Country>> loadBundledCountries() async {
  return parseCountriesCsv(await rootBundle.loadString(kBundledCountriesAsset));
}

/// Rwanda first, then the rest by name.
///
/// Both widgets that read the country list treat the FIRST entry as the default
/// origin (one of them writes it straight into the form controller), so the
/// order is load-bearing: alphabetical alone would default products to
/// "Ascension Island". Also de-duplicates by code.
List<Country> countriesWithDefaultFirst(List<Country> countries) {
  final byCode = <String, Country>{};
  for (final country in countries) {
    byCode.putIfAbsent(country.code, () => country);
  }

  final rest = byCode.values.toList()
    ..sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

  final defaultIndex = rest.indexWhere((c) => c.code == kDefaultCountryCode);
  if (defaultIndex <= 0) return rest;

  return [rest.removeAt(defaultIndex), ...rest];
}

String _unquote(String value) {
  final trimmed = value.trim();
  if (trimmed.length >= 2 &&
      trimmed.startsWith('"') &&
      trimmed.endsWith('"')) {
    return trimmed.substring(1, trimmed.length - 1).trim();
  }
  return trimmed;
}
