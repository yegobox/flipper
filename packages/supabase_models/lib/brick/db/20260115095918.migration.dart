// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260115095918_up = [
  InsertColumn('remote_server_url', Column.varchar, onTable: 'Ebm')
];

const List<MigrationCommand> _migration_20260115095918_down = [
  DropColumn('remote_server_url', onTable: 'Ebm')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260115095918',
  up: _migration_20260115095918_up,
  down: _migration_20260115095918_down,
)
class Migration20260115095918 extends Migration {
  const Migration20260115095918()
    : super(
        version: 20260115095918,
        up: _migration_20260115095918_up,
        down: _migration_20260115095918_down,
      );
}
