// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

const List<MigrationCommand> _migration_20260807090000_up = [
  InsertColumn(
    'payer_name',
    Column.varchar,
    onTable: 'TransactionPaymentRecord',
  ),
];

const List<MigrationCommand> _migration_20260807090000_down = [
  DropColumn('payer_name', onTable: 'TransactionPaymentRecord'),
];

@Migratable(
  version: '20260807090000',
  up: _migration_20260807090000_up,
  down: _migration_20260807090000_down,
)
class Migration20260807090000 extends Migration {
  const Migration20260807090000()
    : super(
        version: 20260807090000,
        up: _migration_20260807090000_up,
        down: _migration_20260807090000_down,
      );
}
