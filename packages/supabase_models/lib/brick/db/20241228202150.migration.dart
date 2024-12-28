// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241228202150_up = [
  DropColumn('branch_id', onTable: 'Stock'),
  DropColumn('business_id', onTable: 'Conversation'),
  DropColumn('branch_id', onTable: 'Variant'),
  DropColumn('branch_id', onTable: 'Favorite'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Stock'),
  InsertColumn('business_id', Column.varchar, onTable: 'Conversation'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Variant'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Favorite')
];

const List<MigrationCommand> _migration_20241228202150_down = [
  DropColumn('branch_id', onTable: 'Stock'),
  DropColumn('business_id', onTable: 'Conversation'),
  DropColumn('branch_id', onTable: 'Variant'),
  DropColumn('branch_id', onTable: 'Favorite')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241228202150',
  up: _migration_20241228202150_up,
  down: _migration_20241228202150_down,
)
class Migration20241228202150 extends Migration {
  const Migration20241228202150()
    : super(
        version: 20241228202150,
        up: _migration_20241228202150_up,
        down: _migration_20241228202150_down,
      );
}
