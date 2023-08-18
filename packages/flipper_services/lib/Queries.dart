library flipper_models;

class Queries {
  //table = variation
  static const String Q_1 =
      'SELECT id,taxName,taxPercentage, sku, productId,supplyPrice,retailPrice,canTrackingStock,branchId, name, unit, table, productName,  channels WHERE table=\$T AND productId=\$PRODUCTID';
  //table = stock
  static const String Q_2 =
      'SELECT id,branchId,variantId,isActive,canTrackingStock,productId,lowStock,currentStock,supplyPrice,retailPrice,showLowStockAlert,channels,table,value WHERE table=\$T AND variantId=\$VARIANTID';
  //table = order
  static const String Q_3 =
      'SELECT  id,paymentType,reference,orderNumber,branchId,status,orderType,active,draft,subTotal,cashReceived,customerChangeDue,createdAt,updatedAt,orderItems,table,channels  WHERE table=\$T AND status=\$S';
  //table = category
  static const String Q_4 =
      'SELECT name,id,focused,table,touched,active,branchId,channels WHERE table=\$VALUE AND name=\$NAME';
  //static = product
  static const String Q_5 =
      'SELECT name,id,description,picture,taxId,active,hasPicture,isImageLocal,touched,table,isDraft,color,isCurrentUpdate,businessId,supplierId,categoryId,createdAt,unit,updatedAt,count,channels WHERE table=\$T AND name=\$NAME';
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
      'SELECT id, name,table,branchId,active,channels WHERE table=\$T AND branchId=\$BRANCHID';
  //table = customer
  static const String Q_11 =
      'SELECT id,name,email,totalPoints,totalVisit,firstVisit,totalSpent,phoneNumber,address,city,region,postalCode,countryCode,customerCode,note,createdAt,updatedAt,channels WHERE table=\$T';
  //table = color
  static const String Q_12 =
      'SELECT id,branchId,name,channels,table,active,channels WHERE table=\$T AND branchId=\$BRANCHID';

  //table NONE
  static const String Q_13 =
      'SELECT variants.id,variants.name, stocks.lowStock,stocks.currentStock,stocks.supplyPrice,stocks.retailPrice,stocks.value FROM variants JOIN stocks ON variants.productId=stocks.productId WHERE variants.table = "variants" AND variants.productId=\$PRODUCTID';
  //table =business
  static const String Q_14 =
      'SELECT id,name,active,currency,categoryId,latitude,longitude,userId,typeId,timeZone,createdAt,updatedAt,channels,country,businessUrl,hexColor,image,type,table WHERE table=\$T';
  //table = branch
  static const String Q_15 =
      'SELECT id,businessId,createdAt,name,longitude,latitude,updatedAt,description,active,channels,channels,businessId,table WHERE table=\$T AND businessId=\$BUSINESSID';
  //static = product
  static const String Q_16 =
      'SELECT name,id,description,picture,taxId,active,hasPicture,isImageLocal,touched,table,isDraft,color,isCurrentUpdate,businessId,supplierId,categoryId,createdAt,unit,updatedAt,count,channels WHERE table=\$T';
  //static table = variantProduct
  //p=product,v=variation,s=stock
  static const String Q_17 =
      'SELECT p.name as productName,v.name as variantName,v.id ,v.id as variantId,s.canTrackingStock,s.retailPrice,s.unit,s.sku,s.branchId,s.variantId,s.taxName,s.taxPercentage,s.value,s.lowStock,s.currentStock FROM variants v  JOIN stocks s ON v.productId=s.productId  JOIN products p ON v.productId=p.id WHERE v.table=\$T AND s.productId=\$PRODUCTID';
  //static table = variantStock
  static const String Q_18 =
      'SELECT variants.taxtName,variants.taxPercentage, variants.name as variantName,products.name as productName, variants.id as variantId,variants.id,variants.sku,variants.unit,stocks.retailPrice,stocks.canTrackingStock,stocks.currentStock,stocks.lowStock,stocks.value,stocks.branchId FROM variants JOIN stocks ON variants.id=stocks.variantId JOIN products ON variants.productId=products.id WHERE variants.table=\$T AND variants.id=\$VARIANTID';

  static const String Q_19 =
      'SELECT id,branchId,variantId,lowStock,value,currentStock,supplyPrice,retailPrice,canTrackingStock,showLowStockAlert,channels,table,productId,active WHERE table=\$T AND productId=\$PRODUCTID';
  static const String Q_20 =
      'SELECT  id,name WHERE table=\$T AND name=\$NAME LIMIT 1';
  static const String Q_21 =
      'SELECT  id WHERE table=\$T AND productId=\$PRODUCTID';
  static const String Q_22 =
      'SELECT  id,paymentType,table,branchId,quantity,reference,draft,active,orderType,orderNumber,subTotal,taxAmount,saleTotal,orderNote,status,stockId,channels,customerChangeDue,cashReceived  WHERE table=\$T AND variantId=\$VARIANTID';

  static const String b = 'SELECT id,name, asi WHERE name=\$N';
  static const String a = 'SELECT id,name WHERE name=\$N';
}
