// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250609133534_up = [
  InsertColumn('external_id', Column.varchar, onTable: 'Plan'),
  InsertColumn('payment_status', Column.varchar, onTable: 'Plan'),
  InsertColumn('last_processed_at', Column.datetime, onTable: 'Plan'),
  InsertColumn('last_error', Column.varchar, onTable: 'Plan'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Plan'),
  InsertColumn('last_updated', Column.datetime, onTable: 'Plan'),
  InsertColumn('processing_status', Column.varchar, onTable: 'Plan')
];

const List<MigrationCommand> _migration_20250609133534_down = [
  DropColumn('external_id', onTable: 'Plan'),
  DropColumn('payment_status', onTable: 'Plan'),
  DropColumn('last_processed_at', onTable: 'Plan'),
  DropColumn('last_error', onTable: 'Plan'),
  DropColumn('updated_at', onTable: 'Plan'),
  DropColumn('last_updated', onTable: 'Plan'),
  DropColumn('processing_status', onTable: 'Plan')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250609133534',
  up: _migration_20250609133534_up,
  down: _migration_20250609133534_down,
)
class Migration20250609133534 extends Migration {
  const Migration20250609133534()
      : super(
          version: 20250609133534,
          up: _migration_20250609133534_up,
          down: _migration_20250609133534_down,
        );
}
