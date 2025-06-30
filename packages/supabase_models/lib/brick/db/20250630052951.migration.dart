// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250630052951_up = [
  InsertTable('Retryable'),
  InsertColumn('id', Column.varchar, onTable: 'Retryable', unique: true),
  InsertColumn('entity_id', Column.varchar, onTable: 'Retryable'),
  InsertColumn('entity_table', Column.varchar, onTable: 'Retryable'),
  InsertColumn('last_failure_reason', Column.varchar, onTable: 'Retryable'),
  InsertColumn('retry_count', Column.integer, onTable: 'Retryable'),
  InsertColumn('created_at', Column.datetime, onTable: 'Retryable'),
  CreateIndex(columns: ['id'], onTable: 'Retryable', unique: true)
];

const List<MigrationCommand> _migration_20250630052951_down = [
  DropTable('Retryable'),
  DropColumn('id', onTable: 'Retryable'),
  DropColumn('entity_id', onTable: 'Retryable'),
  DropColumn('entity_table', onTable: 'Retryable'),
  DropColumn('last_failure_reason', onTable: 'Retryable'),
  DropColumn('retry_count', onTable: 'Retryable'),
  DropColumn('created_at', onTable: 'Retryable'),
  DropIndex('index_Retryable_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250630052951',
  up: _migration_20250630052951_up,
  down: _migration_20250630052951_down,
)
class Migration20250630052951 extends Migration {
  const Migration20250630052951()
    : super(
        version: 20250630052951,
        up: _migration_20250630052951_up,
        down: _migration_20250630052951_down,
      );
}
