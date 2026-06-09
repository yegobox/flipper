import 'package:flipper_web/modules/accounting/data/accounting_models.dart';

/// Design-handoff demo rows — shown when no live AR/AP data exists yet.
const accountingArSeedRows = <AgingRow>[
  AgingRow(
    name: 'Karake Retail Group',
    inv: 'INV-2208',
    current: 0,
    d30: 640000,
    d60: 0,
    d90: 0,
  ),
  AgingRow(
    name: 'Mutoni Boutique',
    inv: 'INV-2204',
    current: 380000,
    d30: 0,
    d60: 0,
    d90: 0,
  ),
  AgingRow(
    name: 'Gisenyi Mini-Mart',
    inv: 'INV-2199',
    current: 0,
    d30: 0,
    d60: 410000,
    d90: 0,
  ),
  AgingRow(
    name: 'Twesigye Hardware',
    inv: 'INV-2188',
    current: 0,
    d30: 0,
    d60: 0,
    d90: 290000,
  ),
  AgingRow(
    name: 'Umutara Traders',
    inv: 'INV-2210',
    current: 520000,
    d30: 0,
    d60: 0,
    d90: 0,
  ),
  AgingRow(
    name: 'Kivu Fresh Foods',
    inv: 'INV-2195',
    current: 0,
    d30: 120000,
    d60: 0,
    d90: 0,
  ),
];

const accountingApSeedRows = <AgingRow>[
  AgingRow(
    name: 'Habimana Wholesalers',
    inv: 'BILL-512',
    current: 1200000,
    d30: 0,
    d60: 0,
    d90: 0,
  ),
  AgingRow(
    name: 'Rwanda Beverage Co.',
    inv: 'BILL-498',
    current: 0,
    d30: 340000,
    d60: 0,
    d90: 0,
  ),
  AgingRow(
    name: 'Kigali Packaging Ltd',
    inv: 'BILL-491',
    current: 0,
    d30: 0,
    d60: 180000,
    d90: 0,
  ),
  AgingRow(
    name: 'Akagera Logistics',
    inv: 'BILL-487',
    current: 260000,
    d30: 0,
    d60: 0,
    d90: 0,
  ),
];
