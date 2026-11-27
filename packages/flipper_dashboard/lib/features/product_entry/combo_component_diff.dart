/// One component line of a combo as the editor holds it: which variant, and
/// how many of it go into one combo.
typedef ComboLine = ({String variantId, double qty});

/// A component row already saved for the combo.
typedef SavedComboComponent = ({String id, String variantId, double qty});

/// What saving an edited combo writes. [upserts] carries the row id to write
/// (the saved row's id for a kept line, null for a new line), and [deleteIds]
/// the saved rows whose line was removed.
typedef ComboComponentChanges = ({
  List<({String? id, String variantId, double qty})> upserts,
  List<String> deleteIds,
});

/// Works out how to turn the saved component rows into the editor's lines
/// without duplicating any: a kept line reuses its row (so a quantity change
/// updates it in place), a new line gets a new row, and a removed line's row is
/// deleted. Every current line is upserted, so a combo whose rows predate Ditto
/// gets them all written there.
ComboComponentChanges planComboComponentChanges({
  required List<SavedComboComponent> saved,
  required List<ComboLine> lines,
}) {
  final savedByVariant = <String, SavedComboComponent>{};
  final duplicateIds = <String>[];
  for (final row in saved) {
    // Older saves could write the same component twice; keep one row and
    // delete the rest.
    if (savedByVariant.containsKey(row.variantId)) {
      duplicateIds.add(row.id);
    } else {
      savedByVariant[row.variantId] = row;
    }
  }

  final lineIds = lines.map((l) => l.variantId).toSet();
  return (
    upserts: [
      for (final line in lines)
        (
          id: savedByVariant[line.variantId]?.id,
          variantId: line.variantId,
          qty: line.qty,
        ),
    ],
    deleteIds: [
      for (final row in savedByVariant.values)
        if (!lineIds.contains(row.variantId)) row.id,
      ...duplicateIds,
    ],
  );
}
