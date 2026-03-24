// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260310052105_up = [
  InsertTable('FlipperSaleCompaign'),
  InsertColumn('id', Column.varchar, onTable: 'FlipperSaleCompaign', unique: true),
  InsertColumn('compaign_id', Column.integer, onTable: 'FlipperSaleCompaign'),
  InsertColumn('discount_rate', Column.integer, onTable: 'FlipperSaleCompaign'),
  InsertColumn('created_at', Column.datetime, onTable: 'FlipperSaleCompaign'),
  InsertColumn('coupon_code', Column.varchar, onTable: 'FlipperSaleCompaign'),
  CreateIndex(columns: ['id'], onTable: 'FlipperSaleCompaign', unique: true)
];

const List<MigrationCommand> _migration_20260310052105_down = [
  DropTable('FlipperSaleCompaign'),
  DropColumn('id', onTable: 'FlipperSaleCompaign'),
  DropColumn('compaign_id', onTable: 'FlipperSaleCompaign'),
  DropColumn('discount_rate', onTable: 'FlipperSaleCompaign'),
  DropColumn('created_at', onTable: 'FlipperSaleCompaign'),
  DropColumn('coupon_code', onTable: 'FlipperSaleCompaign'),
  DropIndex('index_FlipperSaleCompaign_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260310052105',
  up: _migration_20260310052105_up,
  down: _migration_20260310052105_down,
)
class Migration20260310052105 extends Migration {
  const Migration20260310052105()
    : super(
        version: 20260310052105,
        up: _migration_20260310052105_up,
        down: _migration_20260310052105_down,
      );
}
