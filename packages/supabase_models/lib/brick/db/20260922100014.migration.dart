// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260922100014_up = [
  InsertColumn('enable_sms', Column.boolean, onTable: 'BranchSmsConfig'),
  InsertColumn('avg_cost', Column.Double, onTable: 'Variant'),
  InsertColumn('avg_cost_source', Column.varchar, onTable: 'Variant'),
  InsertColumn('last_avg_cost_receipt_ref', Column.varchar, onTable: 'Variant')
];

const List<MigrationCommand> _migration_20260922100014_down = [
  DropColumn('enable_sms', onTable: 'BranchSmsConfig'),
  DropColumn('avg_cost', onTable: 'Variant'),
  DropColumn('avg_cost_source', onTable: 'Variant'),
  DropColumn('last_avg_cost_receipt_ref', onTable: 'Variant')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260922100014',
  up: _migration_20260922100014_up,
  down: _migration_20260922100014_down,
)
class Migration20260922100014 extends Migration {
  const Migration20260922100014()
    : super(
        version: 20260922100014,
        up: _migration_20260922100014_up,
        down: _migration_20260922100014_down,
      );
}
