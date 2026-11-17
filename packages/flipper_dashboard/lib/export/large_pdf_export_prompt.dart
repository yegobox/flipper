import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';

/// Above this many rows a report PDF is slow enough to freeze the app.
///
/// Syncfusion builds the PDF from the live grid on the UI thread (convert,
/// lay out every page, then serialise), and none of it can move to another
/// isolate without changing the file. So past this size we offer Excel,
/// whose export yields as it goes.
const int kLargePdfExportRowLimit = 5000;

/// What the user picked for a report too large for a quick PDF.
enum LargePdfExportChoice { excel, pdf, cancel }

/// Whether to ask before a PDF export of [rowCount] rows. An unknown count
/// (no grid, e.g. the headless export) never asks.
bool shouldOfferExcelForPdf({required bool asPdf, required int? rowCount}) =>
    asPdf && rowCount != null && rowCount > kLargePdfExportRowLimit;

/// Whether the grid's data source was replaced while the prompt was open.
///
/// A parent rebuild can swap in another source (e.g. a paginated one), and
/// exporting it would drop rows the user agreed to export. No source before
/// (headless export) is never a change.
bool gridSourceReplaced(Object? before, Object? after) =>
    before != null && !identical(before, after);

/// Asks whether to export a [rowCount]-row report as Excel instead of PDF.
/// Dismissing the dialog cancels the export.
Future<LargePdfExportChoice> showLargePdfExportPrompt(
  BuildContext context, {
  required int rowCount,
}) async {
  final l10n = context.flipperL10n;
  final choice = await showDialog<LargePdfExportChoice>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.reportLargePdfTitle),
      content: Text(l10n.reportLargePdfBody('$rowCount')),
      actions: [
        TextButton(
          key: const Key('largePdfCancel'),
          onPressed: () =>
              Navigator.of(context).pop(LargePdfExportChoice.cancel),
          child: Text(l10n.cancel),
        ),
        TextButton(
          key: const Key('largePdfAnyway'),
          onPressed: () => Navigator.of(context).pop(LargePdfExportChoice.pdf),
          child: Text(l10n.reportLargePdfAnyway),
        ),
        FilledButton(
          key: const Key('largePdfUseExcel'),
          onPressed: () =>
              Navigator.of(context).pop(LargePdfExportChoice.excel),
          child: Text(l10n.reportLargePdfUseExcel),
        ),
      ],
    ),
  );
  return choice ?? LargePdfExportChoice.cancel;
}

/// Tells the user an export stopped because the report changed while the
/// prompt was open (see [gridSourceReplaced]), so they export again.
void showReportExportChangedNotice(BuildContext context) {
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(content: Text(context.flipperL10n.reportExportChanged)),
  );
}
