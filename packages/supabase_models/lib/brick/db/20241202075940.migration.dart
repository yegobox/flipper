// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241202075940_up = [
  DropColumn('isrc_r', onTable: 'TransactionItem'),
  DropColumn('isrc_am', onTable: 'TransactionItem'),
  InsertColumn('isrc_rt', Column.integer, onTable: 'TransactionItem'),
  InsertColumn('isrc_amt', Column.integer, onTable: 'TransactionItem')
];

const List<MigrationCommand> _migration_20241202075940_down = [
  DropColumn('isrc_rt', onTable: 'TransactionItem'),
  DropColumn('isrc_amt', onTable: 'TransactionItem')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241202075940',
  up: _migration_20241202075940_up,
  down: _migration_20241202075940_down,
)
class Migration20241202075940 extends Migration {
  const Migration20241202075940()
    : super(
        version: 20241202075940,
        up: _migration_20241202075940_up,
        down: _migration_20241202075940_down,
      );
}
