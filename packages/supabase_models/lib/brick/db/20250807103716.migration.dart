// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250807103716_up = [
  DropTable('AiConversation'),
  DropColumn('user_name', onTable: 'Conversation'),
  DropColumn('body', onTable: 'Conversation'),
  DropColumn('avatar', onTable: 'Conversation'),
  DropColumn('channel_type', onTable: 'Conversation'),
  DropColumn('from_number', onTable: 'Conversation'),
  DropColumn('to_number', onTable: 'Conversation'),
  DropColumn('message_type', onTable: 'Conversation'),
  DropColumn('phone_number_id', onTable: 'Conversation'),
  DropColumn('message_id', onTable: 'Conversation'),
  DropColumn('responded_by', onTable: 'Conversation'),
  DropColumn('conversation_id', onTable: 'Conversation'),
  DropColumn('business_phone_number', onTable: 'Conversation'),
  DropColumn('business_id', onTable: 'Conversation'),
  DropColumn('scheduled_at', onTable: 'Conversation'),
  DropColumn('delivered', onTable: 'Conversation'),
  DropColumn('last_touched', onTable: 'Conversation'),
  DropColumn('deleted_at', onTable: 'Conversation'),
  InsertTable('_brick_Conversation_messages'),
  InsertForeignKey('_brick_Conversation_messages', 'Conversation', foreignKeyColumn: 'l_Conversation_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('_brick_Conversation_messages', 'Message', foreignKeyColumn: 'f_Message_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertColumn('title', Column.varchar, onTable: 'Conversation'),
  InsertColumn('branch_id', Column.integer, onTable: 'Conversation'),
  InsertColumn('last_message_at', Column.datetime, onTable: 'Conversation'),
  CreateIndex(columns: ['l_Conversation_brick_id', 'f_Message_brick_id'], onTable: '_brick_Conversation_messages', unique: true),
  CreateIndex(columns: ['id'], onTable: 'AiConversation', unique: true)
];

const List<MigrationCommand> _migration_20250807103716_down = [
  InsertTable('AiConversation'),
  DropTable('_brick_Conversation_messages'),
  DropColumn('l_Conversation_brick_id', onTable: '_brick_Conversation_messages'),
  DropColumn('f_Message_brick_id', onTable: '_brick_Conversation_messages'),
  DropColumn('title', onTable: 'Conversation'),
  DropColumn('branch_id', onTable: 'Conversation'),
  DropColumn('last_message_at', onTable: 'Conversation'),
  DropIndex('index__brick_Conversation_messages_on_l_Conversation_brick_id_f_Message_brick_id'),
  DropIndex('index_AiConversation_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250807103716',
  up: _migration_20250807103716_up,
  down: _migration_20250807103716_down,
)
class Migration20250807103716 extends Migration {
  const Migration20250807103716()
    : super(
        version: 20250807103716,
        up: _migration_20250807103716_up,
        down: _migration_20250807103716_down,
      );
}
