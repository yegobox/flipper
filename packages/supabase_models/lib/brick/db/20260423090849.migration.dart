// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260423090849_up = [
  DropTable('_brick_Plan_addons'),
  DropTable('Plan'),
  InsertColumn('image_url', Column.varchar, onTable: 'Variant'),
  CreateIndex(columns: ['l_Plan_brick_id', 'f_PlanAddon_brick_id'], onTable: '_brick_Plan_addons', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Plan', unique: true)
];

const List<MigrationCommand> _migration_20260423090849_down = [
  InsertTable('_brick_Plan_addons'),
  InsertTable('Plan'),
  DropColumn('image_url', onTable: 'Variant'),
  DropIndex('index__brick_Plan_addons_on_l_Plan_brick_id_f_PlanAddon_brick_id'),
  DropIndex('index_Plan_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260423090849',
  up: _migration_20260423090849_up,
  down: _migration_20260423090849_down,
)
class Migration20260423090849 extends Migration {
  const Migration20260423090849()
    : super(
        version: 20260423090849,
        up: _migration_20260423090849_up,
        down: _migration_20260423090849_down,
      );
}
