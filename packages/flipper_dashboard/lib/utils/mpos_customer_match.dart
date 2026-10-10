import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/domain/party/party_validation.dart';

/// Digits a typed phone needs before the mobile customer sheet can save it —
/// the same floor the MoMo charge gate uses.
const int mposMinCustomerPhoneDigits = 9;

String mposPhoneDigits(String? raw) =>
    (raw ?? '').replaceAll(RegExp(r'\D'), '');

/// Customers to list in the mobile checkout customer sheet.
///
/// With nothing typed, the most recently updated customers come first, so a
/// regular is one tap away. Otherwise [phone] (normalised digits) and [name]
/// (case-insensitive) narrow the list, and an exact phone match leads.
List<Customer> mposCustomerMatches(
  List<Customer> all, {
  String phone = '',
  String name = '',
  int limit = 6,
}) {
  final phoneKey = normalizePartyPhone(phone);
  final nameKey = name.trim().toLowerCase();

  final matches = all.where((c) {
    if (phoneKey.isNotEmpty &&
        !normalizePartyPhone(c.telNo).contains(phoneKey)) {
      return false;
    }
    if (nameKey.isNotEmpty &&
        !(c.custNm ?? '').toLowerCase().contains(nameKey)) {
      return false;
    }
    return true;
  }).toList();

  final epoch = DateTime.fromMillisecondsSinceEpoch(0);
  matches.sort((a, b) {
    if (phoneKey.isNotEmpty) {
      final aExact = normalizePartyPhone(a.telNo) == phoneKey;
      final bExact = normalizePartyPhone(b.telNo) == phoneKey;
      if (aExact != bExact) return aExact ? -1 : 1;
    }
    return (b.updatedAt ?? epoch).compareTo(a.updatedAt ?? epoch);
  });

  return matches.length > limit ? matches.sublist(0, limit) : matches;
}

/// The existing customer whose phone is [phone], so a full number attaches
/// them instead of creating a duplicate. Null until the phone is complete.
Customer? mposExactPhoneMatch(List<Customer> all, String phone) {
  if (mposPhoneDigits(phone).length < mposMinCustomerPhoneDigits) return null;
  for (final c in all) {
    if (partyPhonesMatch(c.telNo, phone)) return c;
  }
  return null;
}
