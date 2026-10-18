// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20261018173810_up = [
  InsertColumn('enable_sale_exchange', Column.boolean, onTable: 'Setting'),
  InsertColumn('exchange_id', Column.varchar, onTable: 'ITransaction')
];

const List<MigrationCommand> _migration_20261018173810_down = [
  DropColumn('enable_sale_exchange', onTable: 'Setting'),
  DropColumn('exchange_id', onTable: 'ITransaction')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20261018173810',
  up: _migration_20261018173810_up,
  down: _migration_20261018173810_down,
)
class Migration20261018173810 extends Migration {
  const Migration20261018173810()
      : super(
          version: 20261018173810,
          up: _migration_20261018173810_up,
          down: _migration_20261018173810_down,
        );
}
