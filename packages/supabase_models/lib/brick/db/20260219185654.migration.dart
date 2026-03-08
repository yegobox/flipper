// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260219185654_up = [
  InsertTable('IntegrationConfig'),
  InsertColumn('id', Column.varchar, onTable: 'IntegrationConfig', unique: true),
  InsertColumn('business_id', Column.varchar, onTable: 'IntegrationConfig'),
  InsertColumn('provider', Column.varchar, onTable: 'IntegrationConfig'),
  InsertColumn('token', Column.varchar, onTable: 'IntegrationConfig'),
  InsertColumn('refresh_token', Column.varchar, onTable: 'IntegrationConfig'),
  InsertColumn('created_at', Column.datetime, onTable: 'IntegrationConfig'),
  InsertColumn('updated_at', Column.datetime, onTable: 'IntegrationConfig'),
  InsertColumn('config', Column.varchar, onTable: 'IntegrationConfig'),
  CreateIndex(columns: ['id'], onTable: 'IntegrationConfig', unique: true),
  CreateIndex(columns: ['business_id'], onTable: 'IntegrationConfig', unique: false),
  CreateIndex(columns: ['provider'], onTable: 'IntegrationConfig', unique: false)
];

const List<MigrationCommand> _migration_20260219185654_down = [
  DropTable('IntegrationConfig'),
  DropColumn('id', onTable: 'IntegrationConfig'),
  DropColumn('business_id', onTable: 'IntegrationConfig'),
  DropColumn('provider', onTable: 'IntegrationConfig'),
  DropColumn('token', onTable: 'IntegrationConfig'),
  DropColumn('refresh_token', onTable: 'IntegrationConfig'),
  DropColumn('created_at', onTable: 'IntegrationConfig'),
  DropColumn('updated_at', onTable: 'IntegrationConfig'),
  DropColumn('config', onTable: 'IntegrationConfig'),
  DropIndex('index_IntegrationConfig_on_id'),
  DropIndex('index_IntegrationConfig_on_business_id'),
  DropIndex('index_IntegrationConfig_on_provider')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260219185654',
  up: _migration_20260219185654_up,
  down: _migration_20260219185654_down,
)
class Migration20260219185654 extends Migration {
  const Migration20260219185654()
    : super(
        version: 20260219185654,
        up: _migration_20260219185654_up,
        down: _migration_20260219185654_down,
      );
}
