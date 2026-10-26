import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_credit_due_picker.dart';
import 'package:flipper_dashboard/utils/sale_receipt_settlement.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_customer_sheet.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/utils/bar_credit_utils.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// Who owes a tab put on credit, and by when.
class BarCreditTerms {
  const BarCreditTerms({required this.customer, required this.dueDate});

  final Customer customer;
  final DateTime dueDate;

  String get customerName => barCreditCustomerName(customer);
}

/// A quick-added customer may have only a phone; that is their name then.
String barCreditCustomerName(Customer customer) {
  final name = customer.custNm?.trim() ?? '';
  return name.isNotEmpty ? name : (customer.telNo ?? '').trim();
}

/// Putting a bar tab on credit, and collecting it later, without leaving Bar
/// Mode.
///
/// A tab on credit is the same loan the POS parks with "Mark as loan": PARKED,
/// `isLoan`, a customer and a due date. Like a POS credit sale it is receipted
/// and its stock leaves when the guest does, so later installments only
/// record money. The table frees up at once.
abstract final class BarCredit {
  /// Tender label for the settle screen. The payment row says [tender].
  static const method = 'Credit';

  /// How the POS spells a credit tender on payment rows and receipts.
  static const tender = 'CREDIT';

  /// Asks who owes the tab, then by when. Null if either step is cancelled.
  static Future<BarCreditTerms?> pickTerms(
    BuildContext context, {
    required bool mobile,
    Customer? current,
  }) async {
    final pick = await MposCustomerSheet.pick(context, current: current);
    final customer = pick?.customer;
    if (customer == null || !context.mounted) return null;
    final due = await BarCreditDuePicker.show(
      context,
      customerName: barCreditCustomerName(customer),
      mobile: mobile,
    );
    if (due == null) return null;
    return BarCreditTerms(customer: customer, dueDate: due);
  }

  /// Receipts the tab to the customer and turns it into a loan.
  ///
  /// Returns true when the tab went on credit; the caller stays put otherwise.
  static Future<bool> putOnCredit({
    required BuildContext context,
    required WidgetRef ref,
    required ITransaction tab,
    required BarTable table,
    required BarCreditTerms terms,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.flipperL10n;
    final services = ref.read(barServicesProvider);
    final sync = services.sync;
    try {
      // Read fresh: the lines the screen shows can trail a just-added round.
      final lines = await sync.barTabLines(transactionId: tab.id);
      final total = barTabTotal(lines);
      // Before the receipt is filed: an empty tab must not reach RRA.
      if (lines.isEmpty || total <= 0) {
        throw Exception(l10n.barCreditEmptyTab);
      }
      final customer = terms.customer;
      final phone = (customer.telNo ?? '').replaceAll(RegExp(r'\D'), '');

      // The receipt reads the buyer's phone from the box, as on settle.
      services.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: phone,
      );
      final booked = tab.copyWith(
        subTotal: total,
        cashReceived: 0,
        customerChangeDue: 0,
        paymentType: tender,
        customerId: customer.id,
        customerName: terms.customerName,
        customerPhone: phone,
      );

      await finalizeServiceModeSale(
        sync: sync,
        transaction: booked,
        lines: lines,
        transactionId: tab.id,
        payments: [PaymentLineForSaleCompletion(amount: total, method: tender)],
        receiptContext: 'credit receipt',
        complete: (invoiced) => sync.parkBarTabAsLoan(
          transaction: invoiced,
          lines: lines,
          customerId: customer.id,
          customerName: terms.customerName,
          customerPhone: phone,
          dueDate: terms.dueDate,
        ),
      );

      ref.invalidate(barTabLinesProvider(tab.id));
      ref
          .read(barModeProvider.notifier)
          .afterSettle(
            tableName: table.name,
            message: l10n.barCreditParked(
              table.name,
              terms.customerName,
              barCreditMoney(total),
            ),
          );
      return true;
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
      return false;
    }
  }

  /// Customer, due date and the write in one step, for the tab screens.
  static Future<bool> promptAndPutOnCredit({
    required BuildContext context,
    required WidgetRef ref,
    required ITransaction tab,
    required BarTable table,
    required bool mobile,
  }) async {
    final terms = await pickTerms(context, mobile: mobile);
    if (terms == null || !context.mounted) return false;
    return putOnCredit(
      context: context,
      ref: ref,
      tab: tab,
      table: table,
      terms: terms,
    );
  }

  /// Takes one installment on [loan]. Returns the loan as it now stands, or
  /// null when nothing was recorded.
  static Future<ITransaction?> collect({
    required BuildContext context,
    required WidgetRef ref,
    required ITransaction loan,
    required double amount,
    required String method,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.flipperL10n;
    final sync = ref.read(barServicesProvider).sync;
    final payments = [
      PaymentLineForSaleCompletion(amount: amount, method: method),
    ];
    try {
      // Writes the installment's payment row with the loan, in one step.
      final after = await sync.collectBarCreditPayment(
        transaction: loan,
        payments: payments,
      );

      final name = barCreditDebtorName(loan);
      final left = barCreditBalance(after);
      ref
          .read(barModeProvider.notifier)
          .showToast(
            barCreditIsOpen(after)
                ? l10n.barCreditPaidLeft(
                    name,
                    barCreditMoney(amount),
                    barCreditMoney(left),
                  )
                : l10n.barCreditCleared(name),
          );
      return after;
    } on BarCreditOverpaid catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.barCreditAmountTooHigh(
              barCreditDebtorName(loan),
              barCreditMoney(e.balance),
            ),
          ),
        ),
      );
      return null;
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
      return null;
    }
  }
}

/// `RWF 3,000`, the bar's money format.
String barCreditMoney(num amount) =>
    'RWF ${NumberFormat('#,###').format(amount.round())}';

/// A due date as the cashier reads it: `Nov 9, 2026`. MaterialLocalizations,
/// not intl's DateFormat, which has no date symbols for Kinyarwanda.
String barCreditDate(BuildContext context, DateTime date) =>
    MaterialLocalizations.of(context).formatMediumDate(date.toLocal());
