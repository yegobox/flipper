// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

const List<MigrationCommand> _migration_20260509120000_up = [
  DropIndex('index_PlanAddon_on_id'),
  DropTable('PlanAddon'),
];

const List<MigrationCommand> _migration_20260509120000_down = [
  InsertTable('PlanAddon'),
  InsertColumn(
    'id',
    Column.varchar,
    onTable: 'PlanAddon',
    unique: true,
  ),
  InsertColumn('plan_id', Column.varchar, onTable: 'PlanAddon'),
  InsertColumn('addon_name', Column.varchar, onTable: 'PlanAddon'),
  InsertColumn('created_at', Column.datetime, onTable: 'PlanAddon'),
  CreateIndex(columns: ['id'], onTable: 'PlanAddon', unique: true),
];

@Migratable(
  version: '20260509120000',
  up: _migration_20260509120000_up,
  down: _migration_20260509120000_down,
)
class Migration20260509120000 extends Migration {
  const Migration20260509120000()
      : super(
          version: 20260509120000,
          up: _migration_20260509120000_up,
          down: _migration_20260509120000_down,
        );
}
