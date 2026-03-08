// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260225075135_up = [
  InsertColumn('use_case', Column.varchar, onTable: 'Conversation'),
  InsertColumn('expires_at', Column.datetime, onTable: 'IntegrationConfig')
];

const List<MigrationCommand> _migration_20260225075135_down = [
  DropColumn('use_case', onTable: 'Conversation'),
  DropColumn('expires_at', onTable: 'IntegrationConfig')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260225075135',
  up: _migration_20260225075135_up,
  down: _migration_20260225075135_down,
)
class Migration20260225075135 extends Migration {
  const Migration20260225075135()
    : super(
        version: 20260225075135,
        up: _migration_20260225075135_up,
        down: _migration_20260225075135_down,
      );
}
