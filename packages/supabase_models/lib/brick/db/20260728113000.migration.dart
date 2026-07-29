// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260728113000_up = [
  RenameColumn(
    'enable_order_notification',
    'enable_sms',
    onTable: 'BranchSmsConfig',
  ),
  InsertColumn('enable_whatsapp', Column.boolean, onTable: 'BranchSmsConfig'),
];

const List<MigrationCommand> _migration_20260728113000_down = [
  DropColumn('enable_whatsapp', onTable: 'BranchSmsConfig'),
  RenameColumn(
    'enable_sms',
    'enable_order_notification',
    onTable: 'BranchSmsConfig',
  ),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260728113000',
  up: _migration_20260728113000_up,
  down: _migration_20260728113000_down,
)
class Migration20260728113000 extends Migration {
  const Migration20260728113000()
    : super(
        version: 20260728113000,
        up: _migration_20260728113000_up,
        down: _migration_20260728113000_down,
      );
}
