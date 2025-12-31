// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251227183153_up = [
  DropColumn('business_id', onTable: 'Branch'),
  DropColumn('business_id', onTable: 'Tenant'),
  DropColumn('user_id', onTable: 'Tenant'),
  DropColumn('branch_id', onTable: 'Access'),
  DropColumn('business_id', onTable: 'Access'),
  DropColumn('user_id', onTable: 'Access'),
  DropColumn('user_id', onTable: 'Business'),
  DropColumn('business_type_id', onTable: 'Business'),
  DropColumn('business_id', onTable: 'Shift'),
  InsertTable('BusinessType'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Access'),
  InsertColumn('business_id', Column.varchar, onTable: 'Access'),
  InsertColumn('user_id', Column.varchar, onTable: 'Access'),
  InsertColumn('tenant_id', Column.varchar, onTable: 'Access'),
  InsertColumn('business_id', Column.varchar, onTable: 'Branch'),
  InsertColumn('deleted_at', Column.datetime, onTable: 'Branch'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Branch'),
  InsertColumn('user_id', Column.varchar, onTable: 'Business'),
  InsertColumn('business_type_id', Column.varchar, onTable: 'Business'),
  InsertColumn('referred_by', Column.varchar, onTable: 'Business'),
  InsertColumn('id', Column.varchar, onTable: 'BusinessType', unique: true),
  InsertColumn('name', Column.varchar, onTable: 'BusinessType'),
  InsertColumn('description', Column.varchar, onTable: 'BusinessType'),
  InsertColumn('created_at', Column.datetime, onTable: 'BusinessType'),
  InsertColumn('business_id', Column.varchar, onTable: 'Shift'),
  InsertColumn('business_id', Column.varchar, onTable: 'Tenant'),
  InsertColumn('user_id', Column.varchar, onTable: 'Tenant'),
  InsertColumn('is_default', Column.boolean, onTable: 'Tenant'),
  InsertColumn('pin', Column.integer, onTable: 'User'),
  InsertColumn('edit_id', Column.boolean, onTable: 'User'),
  InsertColumn('is_external', Column.boolean, onTable: 'User'),
  InsertColumn('ownership', Column.varchar, onTable: 'User'),
  InsertColumn('group_id', Column.integer, onTable: 'User'),
  InsertColumn('external', Column.boolean, onTable: 'User'),
  InsertColumn('updated_at', Column.datetime, onTable: 'User'),
  InsertColumn('deleted_at', Column.datetime, onTable: 'User'),
  InsertColumn('phone_number', Column.varchar, onTable: 'User'),
  CreateIndex(columns: ['id'], onTable: 'BusinessType', unique: true)
];

const List<MigrationCommand> _migration_20251227183153_down = [
  DropTable('BusinessType'),
  DropColumn('branch_id', onTable: 'Access'),
  DropColumn('business_id', onTable: 'Access'),
  DropColumn('user_id', onTable: 'Access'),
  DropColumn('tenant_id', onTable: 'Access'),
  DropColumn('business_id', onTable: 'Branch'),
  DropColumn('deleted_at', onTable: 'Branch'),
  DropColumn('updated_at', onTable: 'Branch'),
  DropColumn('user_id', onTable: 'Business'),
  DropColumn('business_type_id', onTable: 'Business'),
  DropColumn('referred_by', onTable: 'Business'),
  DropColumn('id', onTable: 'BusinessType'),
  DropColumn('name', onTable: 'BusinessType'),
  DropColumn('description', onTable: 'BusinessType'),
  DropColumn('created_at', onTable: 'BusinessType'),
  DropColumn('business_id', onTable: 'Shift'),
  DropColumn('business_id', onTable: 'Tenant'),
  DropColumn('user_id', onTable: 'Tenant'),
  DropColumn('is_default', onTable: 'Tenant'),
  DropColumn('pin', onTable: 'User'),
  DropColumn('edit_id', onTable: 'User'),
  DropColumn('is_external', onTable: 'User'),
  DropColumn('ownership', onTable: 'User'),
  DropColumn('group_id', onTable: 'User'),
  DropColumn('external', onTable: 'User'),
  DropColumn('updated_at', onTable: 'User'),
  DropColumn('deleted_at', onTable: 'User'),
  DropColumn('phone_number', onTable: 'User'),
  DropIndex('index_BusinessType_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251227183153',
  up: _migration_20251227183153_up,
  down: _migration_20251227183153_down,
)
class Migration20251227183153 extends Migration {
  const Migration20251227183153()
    : super(
        version: 20251227183153,
        up: _migration_20251227183153_up,
        down: _migration_20251227183153_down,
      );
}
