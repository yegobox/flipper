library flipper_models;

class Queries {
  //table = variation
  static const String Q_1 =
      'SELECT id, sku, productId, name, unit, table, productName,  channels WHERE table=\$VALUE AND productId=\$PRODUCTID';
  //table = stock
  static const String Q_2 =
      'SELECT id,branchId,variantId,isActive,canTrackingStock,productId,lowStock,currentStock,supplyPrice,retailPrice,showLowStockAlert,channels,table WHERE table=\$VALUE AND variantId=\$VARIANTID';
  //table = order
  static const String Q_3 =
      'SELECT  id,branchId,quantity,reference,draft,active,orderType,orderNUmber,subTotal,taxAmount,amount,saleTotal,orderNote,status,variantId,stockId,productName,variantName,channels,customerChangeDue  WHERE table=\$T AND status=\$S';
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
  //table = drawerHistories
  static const String Q_8 =
      'SELECT  id,cashierName,openingHour,isSocial,table,openingFloat,closingFloat,displayText,businessId,userId,createdAt WHERE table=\$T AND openingHour=\$OPEN';
  //table = category
  static const String Q_9 =
      'SELECT name,id,focused,table,touched,active,branchId,channels WHERE table=\$VALUE AND branchId=\$BRANCHID';
  //table = unit
  static const String Q_10 =
      'SELECT id, name,table,branchId,focused,channels WHERE table=\$T';
  //table = customer
  static const String Q_11 =
      'SELECT id,name,email,totalPoints,totalVisit,firstVisit,totalSpent,phoneNumber,address,city,region,postalCode,countryCode,customerCode,note,createdAt,updatedAt,channels WHERE table=\$T';
  //table = color
  static const String Q_12 =
      'SELECT id,name,table,isActive,channels WHERE table=\$T';

  //table NONE
  static const String Q_13 =
      'SELECT variants.id,variants.name, stocks.lowStock,stocks.currentStock,stocks.supplyPrice,stocks.retailPrice FROM variants JOIN stocks ON variants.productId=stocks.productId WHERE variants.table = "variants" AND variants.productId=\$PRODUCTID';

}
