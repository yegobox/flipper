import 'package:flipper_dashboard/features/tickets/utils/order_form_pdf.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/features/tickets/ticket_bill_pdf_test.dart
ITransaction _ticket({
  String? customerName,
  String? customerPhone,
  String? customerTin,
}) => ITransaction(
  id: 'ticket-9',
  reference: '9',
  branchId: 'branch-1',
  status: PARKED,
  transactionType: 'sale',
  paymentType: 'CASH',
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime.utc(2026, 10, 21, 9),
  isIncome: true,
  isExpense: false,
  agentId: 'agent-test',
  customerName: customerName,
  customerPhone: customerPhone,
  customerTin: customerTin,
);

TicketBillData _data({bool useA4 = false, TicketPrintCustomer? customer}) =>
    TicketBillData(
      businessName: 'Muhazi Shop',
      reference: '9',
      ticketName: 'Table 4',
      note: 'No ice',
      createdAt: DateTime.utc(2026, 10, 21, 9),
      customer:
          customer ??
          const TicketPrintCustomer(name: 'Mura', phone: '0783000000'),
      lines: const [
        TicketBillLine(name: 'Fanta', qty: 2, unitPrice: 1000, lineTotal: 2000),
        TicketBillLine(
          name: 'Brochette',
          qty: 1.5,
          unitPrice: 3000,
          lineTotal: 4500,
        ),
      ],
      total: 6500,
      paid: 1000,
      currency: 'RWF',
      useA4: useA4,
    );

void main() {
  final l10n = lookupFlipperAppLocalizations(const Locale('en'));

  group('renderTicketBillPdf', () {
    test('builds a PDF on an 80mm roll', () async {
      final bytes = await renderTicketBillPdf(_data(), l10n: l10n);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('builds a PDF on A4', () async {
      final bytes = await renderTicketBillPdf(_data(useA4: true), l10n: l10n);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('builds a walk-in PDF with no customer', () async {
      final bytes = await renderTicketBillPdf(
        _data(customer: const TicketPrintCustomer()),
        l10n: l10n,
      );
      expect(bytes, isNotEmpty);
    });
  });

  group('renderTicketBillEscPos (built-in printer)', () {
    // Printable text of the ESC/POS stream: drop control bytes, keep ASCII.
    String printable(List<int> bytes) => String.fromCharCodes(
      bytes.map((b) => b >= 0x20 && b < 0x7F ? b : 0x0A),
    );

    test('prints the customer, every line and the non-fiscal footer', () {
      final bytes = renderTicketBillEscPos(_data(), l10n: l10n);
      final text = printable(bytes);
      // ESC @ first: a clean printer state, as receipts start.
      expect(bytes.take(2), [0x1B, 0x40]);
      expect(text, contains('MUHAZI SHOP'));
      expect(text, contains('Table 4'));
      expect(text, contains('Mura'));
      expect(text, contains('0783000000'));
      expect(text, contains('Fanta'));
      expect(text, contains('Brochette'));
      expect(text, contains('1.50 x'));
      expect(text, contains('No ice'));
      expect(text, contains('NOT A FISCAL RECEIPT'));
    });

    test('no line is wider than a 58 mm roll (32 columns)', () {
      final text = printable(renderTicketBillEscPos(_data(), l10n: l10n));
      for (final line in text.split('\n')) {
        expect(line.length, lessThanOrEqualTo(32), reason: line);
      }
    });

    test('a walk-in prints Walk-in', () {
      final text = printable(
        renderTicketBillEscPos(
          _data(customer: const TicketPrintCustomer()),
          l10n: l10n,
        ),
      );
      expect(text, contains('Walk-in'));
    });
  });

  group('resolveTicketPaid', () {
    ITransaction paidTicket() => _ticket()..cashReceived = 1500;

    test('uses the payment records when the lookup succeeds', () async {
      final paid = await resolveTicketPaid(
        paidTicket(),
        branchId: 'branch-1',
        lookup: () async => 4000,
      );
      expect(paid, 4000);
    });

    test(
      'a throwing lookup falls back to cashReceived and still prints',
      () async {
        final paid = await resolveTicketPaid(
          paidTicket(),
          branchId: 'branch-1',
          lookup: () async => throw StateError('Ditto not initialized'),
        );
        expect(paid, 1500);

        final data = _data();
        final bytes = await renderTicketBillPdf(
          TicketBillData(
            businessName: data.businessName,
            reference: data.reference,
            customer: data.customer,
            lines: data.lines,
            total: data.total,
            paid: paid,
            currency: data.currency,
          ),
          l10n: l10n,
        );
        expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      },
    );

    test('a null lookup or no branch falls back to cashReceived', () async {
      expect(
        await resolveTicketPaid(
          paidTicket(),
          branchId: 'branch-1',
          lookup: () async => null,
        ),
        1500,
      );
      expect(
        await resolveTicketPaid(
          paidTicket(),
          branchId: '',
          lookup: () async => fail('no lookup without a branch'),
        ),
        1500,
      );
    });
  });

  group('TicketPrintCustomer.resolve', () {
    test('ticket snapshot wins over the customer record', () {
      final c = TicketPrintCustomer.resolve(
        ticket: _ticket(customerName: 'Mura', customerPhone: '0783000000'),
        customer: Customer(custNm: 'Old Name', telNo: '0788111111'),
      );
      expect(c.name, 'Mura');
      expect(c.phone, '0783000000');
    });

    test('empty ticket fields fill from the customer record', () {
      final c = TicketPrintCustomer.resolve(
        ticket: _ticket(customerName: '  ', customerPhone: '0783000000'),
        customer: Customer(
          custNm: 'Mura Ltd',
          custTin: '123456789',
          email: 'mura@example.com',
          adrs: 'Kigali',
        ),
      );
      expect(c.name, 'Mura Ltd');
      expect(c.phone, '0783000000');
      expect(c.tin, '123456789');
      expect(c.email, 'mura@example.com');
      expect(c.address, 'Kigali');
      expect(c.isEmpty, isFalse);
    });

    test('no customer at all is empty (prints Walk-in)', () {
      final c = TicketPrintCustomer.resolve(ticket: _ticket());
      expect(c.isEmpty, isTrue);
    });
  });

  test('TicketBillLine applies the line discount rate', () {
    final line = TicketBillLine.fromItem(
      TransactionItem(
        name: 'Fanta',
        qty: 2,
        price: 1000,
        discount: 0,
        dcRt: 10,
        prc: 1000,
        ttCatCd: 'B',
      ),
    );
    expect(line.lineTotal, 1800);
  });
}
