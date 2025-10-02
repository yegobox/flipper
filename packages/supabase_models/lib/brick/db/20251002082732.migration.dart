// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251002082732_up = [
  InsertTable('StockRecount'),
  InsertTable('StockRecountItem'),
  InsertColumn('id', Column.varchar, onTable: 'StockRecount', unique: true),
  InsertColumn('branch_id', Column.integer, onTable: 'StockRecount'),
  InsertColumn('status', Column.varchar, onTable: 'StockRecount'),
  InsertColumn('user_id', Column.varchar, onTable: 'StockRecount'),
  InsertColumn('device_id', Column.varchar, onTable: 'StockRecount'),
  InsertColumn('device_name', Column.varchar, onTable: 'StockRecount'),
  InsertColumn('created_at', Column.datetime, onTable: 'StockRecount'),
  InsertColumn('submitted_at', Column.datetime, onTable: 'StockRecount'),
  InsertColumn('synced_at', Column.datetime, onTable: 'StockRecount'),
  InsertColumn('notes', Column.varchar, onTable: 'StockRecount'),
  InsertColumn('total_items_counted', Column.integer, onTable: 'StockRecount'),
  InsertColumn('is_draft', Column.boolean, onTable: 'StockRecount'),
  InsertColumn('is_submitted', Column.boolean, onTable: 'StockRecount'),
  InsertColumn('is_synced', Column.boolean, onTable: 'StockRecount'),
  InsertColumn('id', Column.varchar, onTable: 'StockRecountItem', unique: true),
  InsertColumn('recount_id', Column.varchar, onTable: 'StockRecountItem'),
  InsertColumn('variant_id', Column.varchar, onTable: 'StockRecountItem'),
  InsertColumn('stock_id', Column.varchar, onTable: 'StockRecountItem'),
  InsertColumn('product_name', Column.varchar, onTable: 'StockRecountItem'),
  InsertColumn('previous_quantity', Column.num, onTable: 'StockRecountItem'),
  InsertColumn('counted_quantity', Column.num, onTable: 'StockRecountItem'),
  InsertColumn('difference', Column.num, onTable: 'StockRecountItem'),
  InsertColumn('notes', Column.varchar, onTable: 'StockRecountItem'),
  InsertColumn('created_at', Column.datetime, onTable: 'StockRecountItem'),
  InsertColumn('is_increase', Column.boolean, onTable: 'StockRecountItem'),
  InsertColumn('is_decrease', Column.boolean, onTable: 'StockRecountItem'),
  InsertColumn('is_unchanged', Column.boolean, onTable: 'StockRecountItem'),
  CreateIndex(columns: ['id'], onTable: 'StockRecount', unique: true),
  CreateIndex(columns: ['branch_id'], onTable: 'StockRecount', unique: false),
  CreateIndex(columns: ['id'], onTable: 'StockRecountItem', unique: true),
  CreateIndex(columns: ['recount_id'], onTable: 'StockRecountItem', unique: false),
  CreateIndex(columns: ['variant_id'], onTable: 'StockRecountItem', unique: false),
  CreateIndex(columns: ['stock_id'], onTable: 'StockRecountItem', unique: false)
];

const List<MigrationCommand> _migration_20251002082732_down = [
  DropTable('StockRecount'),
  DropTable('StockRecountItem'),
  DropColumn('id', onTable: 'StockRecount'),
  DropColumn('branch_id', onTable: 'StockRecount'),
  DropColumn('status', onTable: 'StockRecount'),
  DropColumn('user_id', onTable: 'StockRecount'),
  DropColumn('device_id', onTable: 'StockRecount'),
  DropColumn('device_name', onTable: 'StockRecount'),
  DropColumn('created_at', onTable: 'StockRecount'),
  DropColumn('submitted_at', onTable: 'StockRecount'),
  DropColumn('synced_at', onTable: 'StockRecount'),
  DropColumn('notes', onTable: 'StockRecount'),
  DropColumn('total_items_counted', onTable: 'StockRecount'),
  DropColumn('is_draft', onTable: 'StockRecount'),
  DropColumn('is_submitted', onTable: 'StockRecount'),
  DropColumn('is_synced', onTable: 'StockRecount'),
  DropColumn('id', onTable: 'StockRecountItem'),
  DropColumn('recount_id', onTable: 'StockRecountItem'),
  DropColumn('variant_id', onTable: 'StockRecountItem'),
  DropColumn('stock_id', onTable: 'StockRecountItem'),
  DropColumn('product_name', onTable: 'StockRecountItem'),
  DropColumn('previous_quantity', onTable: 'StockRecountItem'),
  DropColumn('counted_quantity', onTable: 'StockRecountItem'),
  DropColumn('difference', onTable: 'StockRecountItem'),
  DropColumn('notes', onTable: 'StockRecountItem'),
  DropColumn('created_at', onTable: 'StockRecountItem'),
  DropColumn('is_increase', onTable: 'StockRecountItem'),
  DropColumn('is_decrease', onTable: 'StockRecountItem'),
  DropColumn('is_unchanged', onTable: 'StockRecountItem'),
  DropIndex('index_StockRecount_on_id'),
  DropIndex('index_StockRecount_on_branch_id'),
  DropIndex('index_StockRecountItem_on_id'),
  DropIndex('index_StockRecountItem_on_recount_id'),
  DropIndex('index_StockRecountItem_on_variant_id'),
  DropIndex('index_StockRecountItem_on_stock_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251002082732',
  up: _migration_20251002082732_up,
  down: _migration_20251002082732_down,
)
class Migration20251002082732 extends Migration {
  const Migration20251002082732()
    : super(
        version: 20251002082732,
        up: _migration_20251002082732_up,
        down: _migration_20251002082732_down,
      );
}
