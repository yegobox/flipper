// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

const List<MigrationCommand> _migration_20260728163000_up = [
  InsertColumn('whatsapp_provider', Column.integer, onTable: 'BranchSmsConfig'),
];

const List<MigrationCommand> _migration_20260728163000_down = [
  DropColumn('whatsapp_provider', onTable: 'BranchSmsConfig'),
];

@Migratable(
  version: '20260728163000',
  up: _migration_20260728163000_up,
  down: _migration_20260728163000_down,
)
class Migration20260728163000 extends Migration {
  const Migration20260728163000()
    : super(
        version: 20260728163000,
        up: _migration_20260728163000_up,
        down: _migration_20260728163000_down,
      );
}
