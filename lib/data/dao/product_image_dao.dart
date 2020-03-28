import 'package:flipper/data/image_product.dart';
import 'package:flipper/data/main_database.dart';
import 'package:moor/moor.dart';

part 'product_image_dao.g.dart';

@UseDao(tables: [ProductImageTable])
class ProductImageDao extends DatabaseAccessor<Database>
    with _$ProductImageDaoMixin {
  final Database db;

  ProductImageDao(this.db) : super(db);

  Future insertImageProduct(Insertable<ProductImageTableData> imageProduct) =>
      into(db.productImageTable).insert(imageProduct);

  Future updateUser(ProductImageTableData entry) {
    return update(db.productImageTable).replace(entry);
  }

  Future<List<ProductImageTableData>> getByid({String productId}) {
    return (select(db.productImageTable)
          ..where((t) => t.productId.equals(productId)))
        .get();
  }

  Future deleteImageProduct(Insertable<ProductImageTableData> imageProduct) =>
      delete(db.productImageTable).delete(imageProduct);

  Future<List<ProductImageTableData>> getImageProducts() {
    return (select(db.productImageTable)).get();
  }
}
