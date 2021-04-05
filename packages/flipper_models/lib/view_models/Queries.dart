library flipper_models;

class Queries {
  //table = variation
  static const String Q_1 =
      'SELECT id, sku, productId, name, unit, table, productName,  channels WHERE table=\$VALUE AND productId=\$PRODUCTID';
  //table = stock
  static const String Q_2 =
      'SELECT id,branchId,variantId,isActive,canTrackingStock,productId,lowStock,currentStock,supplyPrice,retailPrice,showLowStockAlert,channels,table WHERE table=\$VALUE AND variantId=\$VARIANTID';
  //table = order
  static const String Q_3 = 'SELECT  *  WHERE table=\$T AND status=\$S';
  //table = category
  static const String Q_4 =
      'SELECT name,id,focused,table,touched,active,branchId,channels WHERE table=\$VALUE AND name=\$NAME';
  //static = product
  static const String Q_5 =
      'SELECT name,id,description,picture,taxId,active,hasPicture,isImageLocal,touched,table,isDraft,color,isCurrentUpdate,businessId,supplierId,categoryId,createdAt,unit,updatedAt,count,channels WHERE table=\$VALUE AND name=\$NAME';
  //static=tax
  static const String Q_6 =
      'SELECT name, id,  touched, table,  isDefault, percentage, businessId, channels WHERE table=\$VALUE AND name=\$NAME';
  //table = variation
  static const String Q_7 =
      'SELECT id,name,sku,productId,unit,table,channels WHERE table=\$VALUE AND name=\$NAME AND productId=\$PRODUCTID';
}
