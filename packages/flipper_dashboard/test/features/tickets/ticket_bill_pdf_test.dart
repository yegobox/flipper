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
