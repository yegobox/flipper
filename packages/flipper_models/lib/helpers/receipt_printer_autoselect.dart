import 'package:printing/printing.dart';

/// Name fragments of printers that are not paper: Windows ships several of
/// these on every install, and remote-desktop tools (AnyDesk on the P70E
/// tills) add their own. They are why a till with one real receipt printer
/// still reported five or six printers and showed the picker on every sale.
const List<String> _virtualPrinterFragments = <String>[
  'microsoft print to pdf',
  'microsoft xps document writer',
  'onenote',
  'fax',
  'anydesk',
  'teamviewer',
  'pdf',
  'xps',
  'send to',
];

/// Whether [printer] is a software printer (PDF/XPS writer, OneNote, fax,
/// remote-desktop redirect) rather than one that puts ink or heat on paper.
bool isVirtualReceiptPrinter(Printer printer) {
  final name = printer.name.toLowerCase();
  return _virtualPrinterFragments.any(name.contains);
}

/// Picks the receipt printer to use without asking, or null when the choice is
/// genuinely ambiguous and the cashier must pick.
///
/// Of the printers that are physical and available: exactly one wins outright;
/// otherwise the OS default wins if it is one of them.
Printer? pickAutoReceiptPrinter(List<Printer> printers) {
  final physical = printers
      .where((p) => p.isAvailable && !isVirtualReceiptPrinter(p))
      .toList(growable: false);
  if (physical.length == 1) return physical.first;
  for (final p in physical) {
    if (p.isDefault) return p;
  }
  return null;
}
