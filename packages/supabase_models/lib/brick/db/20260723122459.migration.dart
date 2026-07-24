// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260723122459_up = [
  InsertColumn('enable_ticket_review_workflow', Column.boolean, onTable: 'Setting'),
  InsertColumn('reviewed_by', Column.varchar, onTable: 'ITransaction'),
  InsertColumn('reviewed_at', Column.datetime, onTable: 'ITransaction'),
  InsertColumn('handover_by', Column.varchar, onTable: 'ITransaction'),
  InsertColumn('handover_at', Column.datetime, onTable: 'ITransaction')
];

const List<MigrationCommand> _migration_20260723122459_down = [
  DropColumn('enable_ticket_review_workflow', onTable: 'Setting'),
  DropColumn('reviewed_by', onTable: 'ITransaction'),
  DropColumn('reviewed_at', onTable: 'ITransaction'),
  DropColumn('handover_by', onTable: 'ITransaction'),
  DropColumn('handover_at', onTable: 'ITransaction')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260723122459',
  up: _migration_20260723122459_up,
  down: _migration_20260723122459_down,
)
class Migration20260723122459 extends Migration {
  const Migration20260723122459()
    : super(
        version: 20260723122459,
        up: _migration_20260723122459_up,
        down: _migration_20260723122459_down,
      );
}
