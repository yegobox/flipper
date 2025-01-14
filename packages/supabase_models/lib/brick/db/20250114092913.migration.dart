// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250114092913_up = [
  InsertTable('BranchPaymentIntegration'),
  InsertColumn('id', Column.varchar, onTable: 'BranchPaymentIntegration', unique: true),
  InsertColumn('branch_id', Column.varchar, onTable: 'BranchPaymentIntegration'),
  InsertColumn('is_enabled', Column.boolean, onTable: 'BranchPaymentIntegration'),
  CreateIndex(columns: ['id'], onTable: 'BranchPaymentIntegration', unique: true)
];

const List<MigrationCommand> _migration_20250114092913_down = [
  DropTable('BranchPaymentIntegration'),
  DropColumn('id', onTable: 'BranchPaymentIntegration'),
  DropColumn('branch_id', onTable: 'BranchPaymentIntegration'),
  DropColumn('is_enabled', onTable: 'BranchPaymentIntegration'),
  DropIndex('index_BranchPaymentIntegration_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250114092913',
  up: _migration_20250114092913_up,
  down: _migration_20250114092913_down,
)
class Migration20250114092913 extends Migration {
  const Migration20250114092913()
    : super(
        version: 20250114092913,
        up: _migration_20250114092913_up,
        down: _migration_20250114092913_down,
      );
}
