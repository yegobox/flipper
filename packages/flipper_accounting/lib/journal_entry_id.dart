/// Ditto document ids for journal entries.
///
/// A generated entry id embeds the human entry reference (`Auto · JE-9536`),
/// and that id travels three places that only accept a restricted alphabet:
///   * the data-connector approval endpoint (`/accounting/journal-entries/{id}`),
///     which rejects anything outside `[A-Za-z0-9_-]` with "invalid document id"
///   * the URL path of that request
///   * journal line ids, which are `<entryId>_<accountCode>`
///
/// So the reference is slugified before it becomes part of a document id; the
/// original text still reaches the ledger through `entry_number` / `reference`.
library;

/// Max characters kept from the human reference inside a generated id.
const int _maxRefSlugLength = 40;

/// Reduces [raw] to `[A-Za-z0-9_-]`, collapsing every other run to a single `_`.
String slugifyJournalIdPart(String raw) {
  final buffer = StringBuffer();
  var pendingSeparator = false;
  for (final rune in raw.runes) {
    final ch = String.fromCharCode(rune);
    final isSafe = RegExp(r'[A-Za-z0-9_-]').hasMatch(ch);
    if (isSafe) {
      if (pendingSeparator && buffer.isNotEmpty) buffer.write('_');
      pendingSeparator = false;
      buffer.write(ch);
      if (buffer.length >= _maxRefSlugLength) break;
    } else {
      pendingSeparator = true;
    }
  }
  final slug = buffer.toString().replaceAll(RegExp(r'^[_-]+|[_-]+$'), '');
  return slug.isEmpty ? 'je' : slug;
}

/// Document id for a new journal entry header.
///
/// [entryRef] is the human reference (`entry.id`) and is slugified; [businessId]
/// is a UUID and is used as-is.
String generateJournalEntryId({
  required String businessId,
  required String entryRef,
  required int microsecondsSinceEpoch,
}) {
  final ref = slugifyJournalIdPart(entryRef);
  return 'je_${businessId}_${ref}_$microsecondsSinceEpoch';
}
