// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260107143027_up = [
  InsertTable('DiscountCode'),
  InsertTable('PlanDiscount'),
  InsertColumn('id', Column.varchar, onTable: 'DiscountCode', unique: true),
  InsertColumn('code', Column.varchar, onTable: 'DiscountCode'),
  InsertColumn('discount_type', Column.varchar, onTable: 'DiscountCode'),
  InsertColumn('discount_value', Column.Double, onTable: 'DiscountCode'),
  InsertColumn('max_uses', Column.integer, onTable: 'DiscountCode'),
  InsertColumn('current_uses', Column.integer, onTable: 'DiscountCode'),
  InsertColumn('valid_from', Column.datetime, onTable: 'DiscountCode'),
  InsertColumn('valid_until', Column.datetime, onTable: 'DiscountCode'),
  InsertColumn('applicable_plans', Column.varchar, onTable: 'DiscountCode'),
  InsertColumn('minimum_amount', Column.Double, onTable: 'DiscountCode'),
  InsertColumn('is_active', Column.boolean, onTable: 'DiscountCode'),
  InsertColumn('created_at', Column.datetime, onTable: 'DiscountCode'),
  InsertColumn('description', Column.varchar, onTable: 'DiscountCode'),
  InsertColumn('id', Column.varchar, onTable: 'PlanDiscount', unique: true),
  InsertColumn('plan_id', Column.varchar, onTable: 'PlanDiscount'),
  InsertColumn('discount_code_id', Column.varchar, onTable: 'PlanDiscount'),
  InsertColumn('original_price', Column.Double, onTable: 'PlanDiscount'),
  InsertColumn('discount_amount', Column.Double, onTable: 'PlanDiscount'),
  InsertColumn('final_price', Column.Double, onTable: 'PlanDiscount'),
  InsertColumn('applied_at', Column.datetime, onTable: 'PlanDiscount'),
  InsertColumn('business_id', Column.varchar, onTable: 'PlanDiscount'),
  CreateIndex(columns: ['id'], onTable: 'DiscountCode', unique: true),
  CreateIndex(columns: ['id'], onTable: 'PlanDiscount', unique: true),
  CreateIndex(columns: ['plan_id'], onTable: 'PlanDiscount', unique: false)
];

const List<MigrationCommand> _migration_20260107143027_down = [
  DropTable('DiscountCode'),
  DropTable('PlanDiscount'),
  DropColumn('id', onTable: 'DiscountCode'),
  DropColumn('code', onTable: 'DiscountCode'),
  DropColumn('discount_type', onTable: 'DiscountCode'),
  DropColumn('discount_value', onTable: 'DiscountCode'),
  DropColumn('max_uses', onTable: 'DiscountCode'),
  DropColumn('current_uses', onTable: 'DiscountCode'),
  DropColumn('valid_from', onTable: 'DiscountCode'),
  DropColumn('valid_until', onTable: 'DiscountCode'),
  DropColumn('applicable_plans', onTable: 'DiscountCode'),
  DropColumn('minimum_amount', onTable: 'DiscountCode'),
  DropColumn('is_active', onTable: 'DiscountCode'),
  DropColumn('created_at', onTable: 'DiscountCode'),
  DropColumn('description', onTable: 'DiscountCode'),
  DropColumn('id', onTable: 'PlanDiscount'),
  DropColumn('plan_id', onTable: 'PlanDiscount'),
  DropColumn('discount_code_id', onTable: 'PlanDiscount'),
  DropColumn('original_price', onTable: 'PlanDiscount'),
  DropColumn('discount_amount', onTable: 'PlanDiscount'),
  DropColumn('final_price', onTable: 'PlanDiscount'),
  DropColumn('applied_at', onTable: 'PlanDiscount'),
  DropColumn('business_id', onTable: 'PlanDiscount'),
  DropIndex('index_DiscountCode_on_id'),
  DropIndex('index_PlanDiscount_on_id'),
  DropIndex('index_PlanDiscount_on_plan_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260107143027',
  up: _migration_20260107143027_up,
  down: _migration_20260107143027_down,
)
class Migration20260107143027 extends Migration {
  const Migration20260107143027()
    : super(
        version: 20260107143027,
        up: _migration_20260107143027_up,
        down: _migration_20260107143027_down,
      );
}
