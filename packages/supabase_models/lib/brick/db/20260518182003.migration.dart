// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260518182003_up = [
  DropTable('Tenant'),
  CreateIndex(columns: ['id'], onTable: 'Tenant', unique: true)
];

const List<MigrationCommand> _migration_20260518182003_down = [
  InsertTable('Tenant'),
  DropIndex('index_Tenant_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260518182003',
  up: _migration_20260518182003_up,
  down: _migration_20260518182003_down,
)
class Migration20260518182003 extends Migration {
  const Migration20260518182003()
    : super(
        version: 20260518182003,
        up: _migration_20260518182003_up,
        down: _migration_20260518182003_down,
      );
}
