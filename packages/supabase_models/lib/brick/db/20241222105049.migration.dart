// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241222105049_up = [
  DropTable('AppNotification'),
  InsertTable('Appnotification'),
  InsertColumn('id', Column.integer, onTable: 'Appnotification', unique: true),
  InsertColumn('type', Column.varchar, onTable: 'Appnotification'),
  InsertColumn('message', Column.varchar, onTable: 'Appnotification'),
  InsertColumn('identifier', Column.integer, onTable: 'Appnotification'),
  InsertColumn('completed', Column.boolean, onTable: 'Appnotification')
];

const List<MigrationCommand> _migration_20241222105049_down = [
  InsertTable('AppNotification'),
  DropTable('Appnotification'),
  DropColumn('id', onTable: 'Appnotification'),
  DropColumn('type', onTable: 'Appnotification'),
  DropColumn('message', onTable: 'Appnotification'),
  DropColumn('identifier', onTable: 'Appnotification'),
  DropColumn('completed', onTable: 'Appnotification')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241222105049',
  up: _migration_20241222105049_up,
  down: _migration_20241222105049_down,
)
class Migration20241222105049 extends Migration {
  const Migration20241222105049()
    : super(
        version: 20241222105049,
        up: _migration_20241222105049_up,
        down: _migration_20241222105049_down,
      );
}
