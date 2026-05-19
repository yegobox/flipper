// GENERATED CODE EDIT WITH CAUTION
part of 'schema.g.dart';

const List<MigrationCommand> _migration_20260519120000_up = [
  InsertColumn('attributed_agent_user_id', Column.varchar, onTable: 'ITransaction'),
  InsertColumn('agent_commission_type', Column.varchar, onTable: 'ITransaction'),
  InsertColumn('agent_commission_value', Column.num, onTable: 'ITransaction'),
  InsertColumn('agent_commission_amount', Column.num, onTable: 'ITransaction'),
];

const List<MigrationCommand> _migration_20260519120000_down = [
  DropColumn('attributed_agent_user_id', onTable: 'ITransaction'),
  DropColumn('agent_commission_type', onTable: 'ITransaction'),
  DropColumn('agent_commission_value', onTable: 'ITransaction'),
  DropColumn('agent_commission_amount', onTable: 'ITransaction'),
];

@Migratable(
  version: '20260519120000',
  up: _migration_20260519120000_up,
  down: _migration_20260519120000_down,
)
class Migration20260519120000 extends Migration {
  const Migration20260519120000()
      : super(
          version: 20260519120000,
          up: _migration_20260519120000_up,
          down: _migration_20260519120000_down,
        );
}
