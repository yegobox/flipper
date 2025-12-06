// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251206040313_up = [
  InsertColumn('message_type', Column.varchar, onTable: 'Message'),
  InsertColumn('message_source', Column.varchar, onTable: 'Message'),
  InsertColumn('whatsapp_message_id', Column.varchar, onTable: 'Message'),
  InsertColumn('whatsapp_phone_number_id', Column.varchar, onTable: 'Message'),
  InsertColumn('contact_name', Column.varchar, onTable: 'Message'),
  InsertColumn('wa_id', Column.varchar, onTable: 'Message'),
  InsertColumn('reply_to_message_id', Column.varchar, onTable: 'Message'),
  InsertColumn('messaging_channels', Column.varchar, onTable: 'Business')
];

const List<MigrationCommand> _migration_20251206040313_down = [
  DropColumn('message_type', onTable: 'Message'),
  DropColumn('message_source', onTable: 'Message'),
  DropColumn('whatsapp_message_id', onTable: 'Message'),
  DropColumn('whatsapp_phone_number_id', onTable: 'Message'),
  DropColumn('contact_name', onTable: 'Message'),
  DropColumn('wa_id', onTable: 'Message'),
  DropColumn('reply_to_message_id', onTable: 'Message'),
  DropColumn('messaging_channels', onTable: 'Business')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251206040313',
  up: _migration_20251206040313_up,
  down: _migration_20251206040313_down,
)
class Migration20251206040313 extends Migration {
  const Migration20251206040313()
    : super(
        version: 20251206040313,
        up: _migration_20251206040313_up,
        down: _migration_20251206040313_down,
      );
}
