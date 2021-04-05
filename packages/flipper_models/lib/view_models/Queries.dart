class Queries {
  //table = variation
  static const String Q_1 =
      'SELECT id, sku, productId, name, unit, table, productName,  channels WHERE table=\$VALUE AND productId=\$PRODUCTID';
  //table = stock
  static const String Q_2 =
      'SELECT id,branchId,variantId,isActive,canTrackingStock,productId,lowStock,currentStock,supplyPrice,retailPrice,showLowStockAlert,channels,table WHERE table=\$VALUE AND variantId=\$VARIANTID';
}
