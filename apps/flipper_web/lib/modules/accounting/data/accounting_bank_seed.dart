import 'package:flipper_web/modules/accounting/data/accounting_models.dart';

/// Demo statement lines from the design handoff — used when the ledger has none yet.
const accountingBankSeedLines = <BankLine>[
  BankLine(
    date: 'May 30',
    desc: 'POS settlement · counter',
    amt: 283200,
    matched: true,
    je: 'JE-1046',
  ),
  BankLine(
    date: 'May 29',
    desc: 'Rent payment · landlord',
    amt: -350000,
    matched: true,
    je: 'JE-1045',
  ),
  BankLine(
    date: 'May 27',
    desc: 'Transfer from Karake Retail',
    amt: 560000,
    matched: true,
    je: 'JE-1043',
  ),
  BankLine(
    date: 'May 26',
    desc: 'Salary run · staff',
    amt: -300000,
    matched: true,
    je: 'JE-1041',
  ),
  BankLine(
    date: 'May 25',
    desc: 'Bank charges',
    amt: -8500,
    matched: false,
  ),
  BankLine(
    date: 'May 23',
    desc: 'Marketing · radio spot',
    amt: -180000,
    matched: true,
    je: 'JE-1038',
  ),
  BankLine(
    date: 'May 22',
    desc: 'MoMo float top-up',
    amt: -120000,
    matched: false,
  ),
];
