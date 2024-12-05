// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241128071851_up = [
  InsertTable('_brick_Product_composites'),
  InsertForeignKey('_brick_Product_composites', 'Product', foreignKeyColumn: 'l_Product_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('_brick_Product_composites', 'Composite', foreignKeyColumn: 'f_Composite_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  CreateIndex(columns: ['l_Product_brick_id', 'f_Composite_brick_id'], onTable: '_brick_Product_composites', unique: true)
];

const List<MigrationCommand> _migration_20241128071851_down = [
  DropTable('_brick_Product_composites'),
  DropColumn('l_Product_brick_id', onTable: '_brick_Product_composites'),
  DropColumn('f_Composite_brick_id', onTable: '_brick_Product_composites'),
  DropIndex('index__brick_Product_composites_on_l_Product_brick_id_f_Composite_brick_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241128071851',
  up: _migration_20241128071851_up,
  down: _migration_20241128071851_down,
)
class Migration20241128071851 extends Migration {
  const Migration20241128071851()
    : super(
        version: 20241128071851,
        up: _migration_20241128071851_up,
        down: _migration_20241128071851_down,
      );
}
