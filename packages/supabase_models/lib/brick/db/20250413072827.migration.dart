// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250413072827_up = [
  InsertTable('User'),
  InsertColumn('id', Column.varchar, onTable: 'User', unique: true),
  InsertColumn('name', Column.varchar, onTable: 'User'),
  InsertColumn('email', Column.varchar, onTable: 'User'),
  InsertColumn('uuid', Column.varchar, onTable: 'User'),
  CreateIndex(columns: ['id'], onTable: 'User', unique: true),
];

const List<MigrationCommand> _migration_20250413072827_down = [
  DropTable('User'),
  DropColumn('id', onTable: 'User'),
  DropColumn('name', onTable: 'User'),
  DropColumn('email', onTable: 'User'),
  DropColumn('uuid', onTable: 'User'),
  DropIndex('index_User_on_id'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250413072827',
  up: _migration_20250413072827_up,
  down: _migration_20250413072827_down,
)
class Migration20250413072827 extends Migration {
  const Migration20250413072827()
      : super(
          version: 20250413072827,
          up: _migration_20250413072827_up,
          down: _migration_20250413072827_down,
        );
}
