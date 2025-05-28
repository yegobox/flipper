// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250528195902_up = [
  InsertTable('Notice'),
  InsertColumn('id', Column.varchar, onTable: 'Notice', unique: true),
  InsertColumn('notice_no', Column.integer, onTable: 'Notice'),
  InsertColumn('title', Column.varchar, onTable: 'Notice'),
  InsertColumn('cont', Column.varchar, onTable: 'Notice'),
  InsertColumn('dtl_url', Column.varchar, onTable: 'Notice'),
  InsertColumn('regr_nm', Column.varchar, onTable: 'Notice'),
  InsertColumn('reg_dt', Column.varchar, onTable: 'Notice'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Notice'),
  CreateIndex(columns: ['id'], onTable: 'Notice', unique: true),
];

const List<MigrationCommand> _migration_20250528195902_down = [
  DropTable('Notice'),
  DropColumn('id', onTable: 'Notice'),
  DropColumn('notice_no', onTable: 'Notice'),
  DropColumn('title', onTable: 'Notice'),
  DropColumn('cont', onTable: 'Notice'),
  DropColumn('dtl_url', onTable: 'Notice'),
  DropColumn('regr_nm', onTable: 'Notice'),
  DropColumn('reg_dt', onTable: 'Notice'),
  DropColumn('branch_id', onTable: 'Notice'),
  DropIndex('index_Notice_on_id'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250528195902',
  up: _migration_20250528195902_up,
  down: _migration_20250528195902_down,
)
class Migration20250528195902 extends Migration {
  const Migration20250528195902()
      : super(
          version: 20250528195902,
          up: _migration_20250528195902_up,
          down: _migration_20250528195902_down,
        );
}
