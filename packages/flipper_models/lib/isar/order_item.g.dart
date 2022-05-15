// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers

extension GetOrderItemCollection on Isar {
  IsarCollection<OrderItem> get orderItems => getCollection();
}

const OrderItemSchema = CollectionSchema(
  name: 'OrderItem',
  schema:
      '{"name":"OrderItem","idName":"id","properties":[{"name":"addInfo","type":"String"},{"name":"bcd","type":"String"},{"name":"bhfId","type":"String"},{"name":"createdAt","type":"String"},{"name":"dcAmt","type":"Double"},{"name":"dcRt","type":"Double"},{"name":"dftPrc","type":"Double"},{"name":"discount","type":"Double"},{"name":"isrcAmt","type":"String"},{"name":"isrcAplcbYn","type":"String"},{"name":"isrcRt","type":"String"},{"name":"isrccCd","type":"String"},{"name":"isrccNm","type":"String"},{"name":"itemCd","type":"String"},{"name":"itemClsCd","type":"String"},{"name":"itemNm","type":"String"},{"name":"itemSeq","type":"String"},{"name":"itemStdNm","type":"String"},{"name":"itemTyCd","type":"String"},{"name":"modrId","type":"String"},{"name":"modrNm","type":"String"},{"name":"name","type":"String"},{"name":"orderId","type":"Long"},{"name":"orgnNatCd","type":"String"},{"name":"pkg","type":"String"},{"name":"pkgUnitCd","type":"String"},{"name":"prc","type":"Double"},{"name":"price","type":"Double"},{"name":"qty","type":"Double"},{"name":"qtyUnitCd","type":"String"},{"name":"regrId","type":"String"},{"name":"regrNm","type":"String"},{"name":"remainingStock","type":"Double"},{"name":"reported","type":"Bool"},{"name":"splyAmt","type":"Double"},{"name":"taxAmt","type":"Double"},{"name":"taxTyCd","type":"String"},{"name":"taxblAmt","type":"Double"},{"name":"tin","type":"Long"},{"name":"totAmt","type":"Double"},{"name":"type","type":"String"},{"name":"updatedAt","type":"String"},{"name":"useYn","type":"String"},{"name":"variantId","type":"Long"}],"indexes":[{"name":"orderId","unique":false,"replace":false,"properties":[{"name":"orderId","type":"Value","caseSensitive":false}]},{"name":"variantId_orderId","unique":false,"replace":false,"properties":[{"name":"variantId","type":"Value","caseSensitive":false},{"name":"orderId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: 'id',
  propertyIds: {
    'addInfo': 0,
    'bcd': 1,
    'bhfId': 2,
    'createdAt': 3,
    'dcAmt': 4,
    'dcRt': 5,
    'dftPrc': 6,
    'discount': 7,
    'isrcAmt': 8,
    'isrcAplcbYn': 9,
    'isrcRt': 10,
    'isrccCd': 11,
    'isrccNm': 12,
    'itemCd': 13,
    'itemClsCd': 14,
    'itemNm': 15,
    'itemSeq': 16,
    'itemStdNm': 17,
    'itemTyCd': 18,
    'modrId': 19,
    'modrNm': 20,
    'name': 21,
    'orderId': 22,
    'orgnNatCd': 23,
    'pkg': 24,
    'pkgUnitCd': 25,
    'prc': 26,
    'price': 27,
    'qty': 28,
    'qtyUnitCd': 29,
    'regrId': 30,
    'regrNm': 31,
    'remainingStock': 32,
    'reported': 33,
    'splyAmt': 34,
    'taxAmt': 35,
    'taxTyCd': 36,
    'taxblAmt': 37,
    'tin': 38,
    'totAmt': 39,
    'type': 40,
    'updatedAt': 41,
    'useYn': 42,
    'variantId': 43
  },
  listProperties: {},
  indexIds: {'orderId': 0, 'variantId_orderId': 1},
  indexValueTypes: {
    'orderId': [
      IndexValueType.long,
    ],
    'variantId_orderId': [
      IndexValueType.long,
      IndexValueType.long,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _orderItemGetId,
  setId: _orderItemSetId,
  getLinks: _orderItemGetLinks,
  attachLinks: _orderItemAttachLinks,
  serializeNative: _orderItemSerializeNative,
  deserializeNative: _orderItemDeserializeNative,
  deserializePropNative: _orderItemDeserializePropNative,
  serializeWeb: _orderItemSerializeWeb,
  deserializeWeb: _orderItemDeserializeWeb,
  deserializePropWeb: _orderItemDeserializePropWeb,
  version: 4,
);

int? _orderItemGetId(OrderItem object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _orderItemSetId(OrderItem object, int id) {
  object.id = id;
}

List<IsarLinkBase> _orderItemGetLinks(OrderItem object) {
  return [];
}

void _orderItemSerializeNative(
    IsarCollection<OrderItem> collection,
    IsarCObject cObj,
    OrderItem object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.addInfo;
  IsarUint8List? _addInfo;
  if (value0 != null) {
    _addInfo = IsarBinaryWriter.utf8Encoder.convert(value0);
  }
  dynamicSize += (_addInfo?.length ?? 0) as int;
  final value1 = object.bcd;
  IsarUint8List? _bcd;
  if (value1 != null) {
    _bcd = IsarBinaryWriter.utf8Encoder.convert(value1);
  }
  dynamicSize += (_bcd?.length ?? 0) as int;
  final value2 = object.bhfId;
  IsarUint8List? _bhfId;
  if (value2 != null) {
    _bhfId = IsarBinaryWriter.utf8Encoder.convert(value2);
  }
  dynamicSize += (_bhfId?.length ?? 0) as int;
  final value3 = object.createdAt;
  final _createdAt = IsarBinaryWriter.utf8Encoder.convert(value3);
  dynamicSize += (_createdAt.length) as int;
  final value4 = object.dcAmt;
  final _dcAmt = value4;
  final value5 = object.dcRt;
  final _dcRt = value5;
  final value6 = object.dftPrc;
  final _dftPrc = value6;
  final value7 = object.discount;
  final _discount = value7;
  final value8 = object.isrcAmt;
  IsarUint8List? _isrcAmt;
  if (value8 != null) {
    _isrcAmt = IsarBinaryWriter.utf8Encoder.convert(value8);
  }
  dynamicSize += (_isrcAmt?.length ?? 0) as int;
  final value9 = object.isrcAplcbYn;
  IsarUint8List? _isrcAplcbYn;
  if (value9 != null) {
    _isrcAplcbYn = IsarBinaryWriter.utf8Encoder.convert(value9);
  }
  dynamicSize += (_isrcAplcbYn?.length ?? 0) as int;
  final value10 = object.isrcRt;
  IsarUint8List? _isrcRt;
  if (value10 != null) {
    _isrcRt = IsarBinaryWriter.utf8Encoder.convert(value10);
  }
  dynamicSize += (_isrcRt?.length ?? 0) as int;
  final value11 = object.isrccCd;
  IsarUint8List? _isrccCd;
  if (value11 != null) {
    _isrccCd = IsarBinaryWriter.utf8Encoder.convert(value11);
  }
  dynamicSize += (_isrccCd?.length ?? 0) as int;
  final value12 = object.isrccNm;
  IsarUint8List? _isrccNm;
  if (value12 != null) {
    _isrccNm = IsarBinaryWriter.utf8Encoder.convert(value12);
  }
  dynamicSize += (_isrccNm?.length ?? 0) as int;
  final value13 = object.itemCd;
  IsarUint8List? _itemCd;
  if (value13 != null) {
    _itemCd = IsarBinaryWriter.utf8Encoder.convert(value13);
  }
  dynamicSize += (_itemCd?.length ?? 0) as int;
  final value14 = object.itemClsCd;
  IsarUint8List? _itemClsCd;
  if (value14 != null) {
    _itemClsCd = IsarBinaryWriter.utf8Encoder.convert(value14);
  }
  dynamicSize += (_itemClsCd?.length ?? 0) as int;
  final value15 = object.itemNm;
  IsarUint8List? _itemNm;
  if (value15 != null) {
    _itemNm = IsarBinaryWriter.utf8Encoder.convert(value15);
  }
  dynamicSize += (_itemNm?.length ?? 0) as int;
  final value16 = object.itemSeq;
  IsarUint8List? _itemSeq;
  if (value16 != null) {
    _itemSeq = IsarBinaryWriter.utf8Encoder.convert(value16);
  }
  dynamicSize += (_itemSeq?.length ?? 0) as int;
  final value17 = object.itemStdNm;
  IsarUint8List? _itemStdNm;
  if (value17 != null) {
    _itemStdNm = IsarBinaryWriter.utf8Encoder.convert(value17);
  }
  dynamicSize += (_itemStdNm?.length ?? 0) as int;
  final value18 = object.itemTyCd;
  IsarUint8List? _itemTyCd;
  if (value18 != null) {
    _itemTyCd = IsarBinaryWriter.utf8Encoder.convert(value18);
  }
  dynamicSize += (_itemTyCd?.length ?? 0) as int;
  final value19 = object.modrId;
  IsarUint8List? _modrId;
  if (value19 != null) {
    _modrId = IsarBinaryWriter.utf8Encoder.convert(value19);
  }
  dynamicSize += (_modrId?.length ?? 0) as int;
  final value20 = object.modrNm;
  IsarUint8List? _modrNm;
  if (value20 != null) {
    _modrNm = IsarBinaryWriter.utf8Encoder.convert(value20);
  }
  dynamicSize += (_modrNm?.length ?? 0) as int;
  final value21 = object.name;
  final _name = IsarBinaryWriter.utf8Encoder.convert(value21);
  dynamicSize += (_name.length) as int;
  final value22 = object.orderId;
  final _orderId = value22;
  final value23 = object.orgnNatCd;
  IsarUint8List? _orgnNatCd;
  if (value23 != null) {
    _orgnNatCd = IsarBinaryWriter.utf8Encoder.convert(value23);
  }
  dynamicSize += (_orgnNatCd?.length ?? 0) as int;
  final value24 = object.pkg;
  IsarUint8List? _pkg;
  if (value24 != null) {
    _pkg = IsarBinaryWriter.utf8Encoder.convert(value24);
  }
  dynamicSize += (_pkg?.length ?? 0) as int;
  final value25 = object.pkgUnitCd;
  IsarUint8List? _pkgUnitCd;
  if (value25 != null) {
    _pkgUnitCd = IsarBinaryWriter.utf8Encoder.convert(value25);
  }
  dynamicSize += (_pkgUnitCd?.length ?? 0) as int;
  final value26 = object.prc;
  final _prc = value26;
  final value27 = object.price;
  final _price = value27;
  final value28 = object.qty;
  final _qty = value28;
  final value29 = object.qtyUnitCd;
  IsarUint8List? _qtyUnitCd;
  if (value29 != null) {
    _qtyUnitCd = IsarBinaryWriter.utf8Encoder.convert(value29);
  }
  dynamicSize += (_qtyUnitCd?.length ?? 0) as int;
  final value30 = object.regrId;
  IsarUint8List? _regrId;
  if (value30 != null) {
    _regrId = IsarBinaryWriter.utf8Encoder.convert(value30);
  }
  dynamicSize += (_regrId?.length ?? 0) as int;
  final value31 = object.regrNm;
  IsarUint8List? _regrNm;
  if (value31 != null) {
    _regrNm = IsarBinaryWriter.utf8Encoder.convert(value31);
  }
  dynamicSize += (_regrNm?.length ?? 0) as int;
  final value32 = object.remainingStock;
  final _remainingStock = value32;
  final value33 = object.reported;
  final _reported = value33;
  final value34 = object.splyAmt;
  final _splyAmt = value34;
  final value35 = object.taxAmt;
  final _taxAmt = value35;
  final value36 = object.taxTyCd;
  IsarUint8List? _taxTyCd;
  if (value36 != null) {
    _taxTyCd = IsarBinaryWriter.utf8Encoder.convert(value36);
  }
  dynamicSize += (_taxTyCd?.length ?? 0) as int;
  final value37 = object.taxblAmt;
  final _taxblAmt = value37;
  final value38 = object.tin;
  final _tin = value38;
  final value39 = object.totAmt;
  final _totAmt = value39;
  final value40 = object.type;
  IsarUint8List? _type;
  if (value40 != null) {
    _type = IsarBinaryWriter.utf8Encoder.convert(value40);
  }
  dynamicSize += (_type?.length ?? 0) as int;
  final value41 = object.updatedAt;
  final _updatedAt = IsarBinaryWriter.utf8Encoder.convert(value41);
  dynamicSize += (_updatedAt.length) as int;
  final value42 = object.useYn;
  IsarUint8List? _useYn;
  if (value42 != null) {
    _useYn = IsarBinaryWriter.utf8Encoder.convert(value42);
  }
  dynamicSize += (_useYn?.length ?? 0) as int;
  final value43 = object.variantId;
  final _variantId = value43;
  final size = staticSize + dynamicSize;

  cObj.buffer = alloc(size);
  cObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _addInfo);
  writer.writeBytes(offsets[1], _bcd);
  writer.writeBytes(offsets[2], _bhfId);
  writer.writeBytes(offsets[3], _createdAt);
  writer.writeDouble(offsets[4], _dcAmt);
  writer.writeDouble(offsets[5], _dcRt);
  writer.writeDouble(offsets[6], _dftPrc);
  writer.writeDouble(offsets[7], _discount);
  writer.writeBytes(offsets[8], _isrcAmt);
  writer.writeBytes(offsets[9], _isrcAplcbYn);
  writer.writeBytes(offsets[10], _isrcRt);
  writer.writeBytes(offsets[11], _isrccCd);
  writer.writeBytes(offsets[12], _isrccNm);
  writer.writeBytes(offsets[13], _itemCd);
  writer.writeBytes(offsets[14], _itemClsCd);
  writer.writeBytes(offsets[15], _itemNm);
  writer.writeBytes(offsets[16], _itemSeq);
  writer.writeBytes(offsets[17], _itemStdNm);
  writer.writeBytes(offsets[18], _itemTyCd);
  writer.writeBytes(offsets[19], _modrId);
  writer.writeBytes(offsets[20], _modrNm);
  writer.writeBytes(offsets[21], _name);
  writer.writeLong(offsets[22], _orderId);
  writer.writeBytes(offsets[23], _orgnNatCd);
  writer.writeBytes(offsets[24], _pkg);
  writer.writeBytes(offsets[25], _pkgUnitCd);
  writer.writeDouble(offsets[26], _prc);
  writer.writeDouble(offsets[27], _price);
  writer.writeDouble(offsets[28], _qty);
  writer.writeBytes(offsets[29], _qtyUnitCd);
  writer.writeBytes(offsets[30], _regrId);
  writer.writeBytes(offsets[31], _regrNm);
  writer.writeDouble(offsets[32], _remainingStock);
  writer.writeBool(offsets[33], _reported);
  writer.writeDouble(offsets[34], _splyAmt);
  writer.writeDouble(offsets[35], _taxAmt);
  writer.writeBytes(offsets[36], _taxTyCd);
  writer.writeDouble(offsets[37], _taxblAmt);
  writer.writeLong(offsets[38], _tin);
  writer.writeDouble(offsets[39], _totAmt);
  writer.writeBytes(offsets[40], _type);
  writer.writeBytes(offsets[41], _updatedAt);
  writer.writeBytes(offsets[42], _useYn);
  writer.writeLong(offsets[43], _variantId);
}

OrderItem _orderItemDeserializeNative(IsarCollection<OrderItem> collection,
    int id, IsarBinaryReader reader, List<int> offsets) {
  final object = OrderItem();
  object.addInfo = reader.readStringOrNull(offsets[0]);
  object.bcd = reader.readStringOrNull(offsets[1]);
  object.bhfId = reader.readStringOrNull(offsets[2]);
  object.createdAt = reader.readString(offsets[3]);
  object.dcAmt = reader.readDoubleOrNull(offsets[4]);
  object.dcRt = reader.readDoubleOrNull(offsets[5]);
  object.dftPrc = reader.readDoubleOrNull(offsets[6]);
  object.discount = reader.readDoubleOrNull(offsets[7]);
  object.id = id;
  object.isrcAmt = reader.readStringOrNull(offsets[8]);
  object.isrcAplcbYn = reader.readStringOrNull(offsets[9]);
  object.isrcRt = reader.readStringOrNull(offsets[10]);
  object.isrccCd = reader.readStringOrNull(offsets[11]);
  object.isrccNm = reader.readStringOrNull(offsets[12]);
  object.itemCd = reader.readStringOrNull(offsets[13]);
  object.itemClsCd = reader.readStringOrNull(offsets[14]);
  object.itemNm = reader.readStringOrNull(offsets[15]);
  object.itemSeq = reader.readStringOrNull(offsets[16]);
  object.itemStdNm = reader.readStringOrNull(offsets[17]);
  object.itemTyCd = reader.readStringOrNull(offsets[18]);
  object.modrId = reader.readStringOrNull(offsets[19]);
  object.modrNm = reader.readStringOrNull(offsets[20]);
  object.name = reader.readString(offsets[21]);
  object.orderId = reader.readLong(offsets[22]);
  object.orgnNatCd = reader.readStringOrNull(offsets[23]);
  object.pkg = reader.readStringOrNull(offsets[24]);
  object.pkgUnitCd = reader.readStringOrNull(offsets[25]);
  object.prc = reader.readDoubleOrNull(offsets[26]);
  object.price = reader.readDouble(offsets[27]);
  object.qty = reader.readDouble(offsets[28]);
  object.qtyUnitCd = reader.readStringOrNull(offsets[29]);
  object.regrId = reader.readStringOrNull(offsets[30]);
  object.regrNm = reader.readStringOrNull(offsets[31]);
  object.remainingStock = reader.readDouble(offsets[32]);
  object.reported = reader.readBoolOrNull(offsets[33]);
  object.splyAmt = reader.readDoubleOrNull(offsets[34]);
  object.taxAmt = reader.readDoubleOrNull(offsets[35]);
  object.taxTyCd = reader.readStringOrNull(offsets[36]);
  object.taxblAmt = reader.readDoubleOrNull(offsets[37]);
  object.tin = reader.readLongOrNull(offsets[38]);
  object.totAmt = reader.readDoubleOrNull(offsets[39]);
  object.type = reader.readStringOrNull(offsets[40]);
  object.updatedAt = reader.readString(offsets[41]);
  object.useYn = reader.readStringOrNull(offsets[42]);
  object.variantId = reader.readLong(offsets[43]);
  return object;
}

P _orderItemDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readLong(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readDoubleOrNull(offset)) as P;
    case 27:
      return (reader.readDouble(offset)) as P;
    case 28:
      return (reader.readDouble(offset)) as P;
    case 29:
      return (reader.readStringOrNull(offset)) as P;
    case 30:
      return (reader.readStringOrNull(offset)) as P;
    case 31:
      return (reader.readStringOrNull(offset)) as P;
    case 32:
      return (reader.readDouble(offset)) as P;
    case 33:
      return (reader.readBoolOrNull(offset)) as P;
    case 34:
      return (reader.readDoubleOrNull(offset)) as P;
    case 35:
      return (reader.readDoubleOrNull(offset)) as P;
    case 36:
      return (reader.readStringOrNull(offset)) as P;
    case 37:
      return (reader.readDoubleOrNull(offset)) as P;
    case 38:
      return (reader.readLongOrNull(offset)) as P;
    case 39:
      return (reader.readDoubleOrNull(offset)) as P;
    case 40:
      return (reader.readStringOrNull(offset)) as P;
    case 41:
      return (reader.readString(offset)) as P;
    case 42:
      return (reader.readStringOrNull(offset)) as P;
    case 43:
      return (reader.readLong(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _orderItemSerializeWeb(
    IsarCollection<OrderItem> collection, OrderItem object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'addInfo', object.addInfo);
  IsarNative.jsObjectSet(jsObj, 'bcd', object.bcd);
  IsarNative.jsObjectSet(jsObj, 'bhfId', object.bhfId);
  IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
  IsarNative.jsObjectSet(jsObj, 'dcAmt', object.dcAmt);
  IsarNative.jsObjectSet(jsObj, 'dcRt', object.dcRt);
  IsarNative.jsObjectSet(jsObj, 'dftPrc', object.dftPrc);
  IsarNative.jsObjectSet(jsObj, 'discount', object.discount);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'isrcAmt', object.isrcAmt);
  IsarNative.jsObjectSet(jsObj, 'isrcAplcbYn', object.isrcAplcbYn);
  IsarNative.jsObjectSet(jsObj, 'isrcRt', object.isrcRt);
  IsarNative.jsObjectSet(jsObj, 'isrccCd', object.isrccCd);
  IsarNative.jsObjectSet(jsObj, 'isrccNm', object.isrccNm);
  IsarNative.jsObjectSet(jsObj, 'itemCd', object.itemCd);
  IsarNative.jsObjectSet(jsObj, 'itemClsCd', object.itemClsCd);
  IsarNative.jsObjectSet(jsObj, 'itemNm', object.itemNm);
  IsarNative.jsObjectSet(jsObj, 'itemSeq', object.itemSeq);
  IsarNative.jsObjectSet(jsObj, 'itemStdNm', object.itemStdNm);
  IsarNative.jsObjectSet(jsObj, 'itemTyCd', object.itemTyCd);
  IsarNative.jsObjectSet(jsObj, 'modrId', object.modrId);
  IsarNative.jsObjectSet(jsObj, 'modrNm', object.modrNm);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  IsarNative.jsObjectSet(jsObj, 'orderId', object.orderId);
  IsarNative.jsObjectSet(jsObj, 'orgnNatCd', object.orgnNatCd);
  IsarNative.jsObjectSet(jsObj, 'pkg', object.pkg);
  IsarNative.jsObjectSet(jsObj, 'pkgUnitCd', object.pkgUnitCd);
  IsarNative.jsObjectSet(jsObj, 'prc', object.prc);
  IsarNative.jsObjectSet(jsObj, 'price', object.price);
  IsarNative.jsObjectSet(jsObj, 'qty', object.qty);
  IsarNative.jsObjectSet(jsObj, 'qtyUnitCd', object.qtyUnitCd);
  IsarNative.jsObjectSet(jsObj, 'regrId', object.regrId);
  IsarNative.jsObjectSet(jsObj, 'regrNm', object.regrNm);
  IsarNative.jsObjectSet(jsObj, 'remainingStock', object.remainingStock);
  IsarNative.jsObjectSet(jsObj, 'reported', object.reported);
  IsarNative.jsObjectSet(jsObj, 'splyAmt', object.splyAmt);
  IsarNative.jsObjectSet(jsObj, 'taxAmt', object.taxAmt);
  IsarNative.jsObjectSet(jsObj, 'taxTyCd', object.taxTyCd);
  IsarNative.jsObjectSet(jsObj, 'taxblAmt', object.taxblAmt);
  IsarNative.jsObjectSet(jsObj, 'tin', object.tin);
  IsarNative.jsObjectSet(jsObj, 'totAmt', object.totAmt);
  IsarNative.jsObjectSet(jsObj, 'type', object.type);
  IsarNative.jsObjectSet(jsObj, 'updatedAt', object.updatedAt);
  IsarNative.jsObjectSet(jsObj, 'useYn', object.useYn);
  IsarNative.jsObjectSet(jsObj, 'variantId', object.variantId);
  return jsObj;
}

OrderItem _orderItemDeserializeWeb(
    IsarCollection<OrderItem> collection, dynamic jsObj) {
  final object = OrderItem();
  object.addInfo = IsarNative.jsObjectGet(jsObj, 'addInfo');
  object.bcd = IsarNative.jsObjectGet(jsObj, 'bcd');
  object.bhfId = IsarNative.jsObjectGet(jsObj, 'bhfId');
  object.createdAt = IsarNative.jsObjectGet(jsObj, 'createdAt') ?? '';
  object.dcAmt = IsarNative.jsObjectGet(jsObj, 'dcAmt');
  object.dcRt = IsarNative.jsObjectGet(jsObj, 'dcRt');
  object.dftPrc = IsarNative.jsObjectGet(jsObj, 'dftPrc');
  object.discount = IsarNative.jsObjectGet(jsObj, 'discount');
  object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
  object.isrcAmt = IsarNative.jsObjectGet(jsObj, 'isrcAmt');
  object.isrcAplcbYn = IsarNative.jsObjectGet(jsObj, 'isrcAplcbYn');
  object.isrcRt = IsarNative.jsObjectGet(jsObj, 'isrcRt');
  object.isrccCd = IsarNative.jsObjectGet(jsObj, 'isrccCd');
  object.isrccNm = IsarNative.jsObjectGet(jsObj, 'isrccNm');
  object.itemCd = IsarNative.jsObjectGet(jsObj, 'itemCd');
  object.itemClsCd = IsarNative.jsObjectGet(jsObj, 'itemClsCd');
  object.itemNm = IsarNative.jsObjectGet(jsObj, 'itemNm');
  object.itemSeq = IsarNative.jsObjectGet(jsObj, 'itemSeq');
  object.itemStdNm = IsarNative.jsObjectGet(jsObj, 'itemStdNm');
  object.itemTyCd = IsarNative.jsObjectGet(jsObj, 'itemTyCd');
  object.modrId = IsarNative.jsObjectGet(jsObj, 'modrId');
  object.modrNm = IsarNative.jsObjectGet(jsObj, 'modrNm');
  object.name = IsarNative.jsObjectGet(jsObj, 'name') ?? '';
  object.orderId =
      IsarNative.jsObjectGet(jsObj, 'orderId') ?? double.negativeInfinity;
  object.orgnNatCd = IsarNative.jsObjectGet(jsObj, 'orgnNatCd');
  object.pkg = IsarNative.jsObjectGet(jsObj, 'pkg');
  object.pkgUnitCd = IsarNative.jsObjectGet(jsObj, 'pkgUnitCd');
  object.prc = IsarNative.jsObjectGet(jsObj, 'prc');
  object.price =
      IsarNative.jsObjectGet(jsObj, 'price') ?? double.negativeInfinity;
  object.qty = IsarNative.jsObjectGet(jsObj, 'qty') ?? double.negativeInfinity;
  object.qtyUnitCd = IsarNative.jsObjectGet(jsObj, 'qtyUnitCd');
  object.regrId = IsarNative.jsObjectGet(jsObj, 'regrId');
  object.regrNm = IsarNative.jsObjectGet(jsObj, 'regrNm');
  object.remainingStock = IsarNative.jsObjectGet(jsObj, 'remainingStock') ??
      double.negativeInfinity;
  object.reported = IsarNative.jsObjectGet(jsObj, 'reported');
  object.splyAmt = IsarNative.jsObjectGet(jsObj, 'splyAmt');
  object.taxAmt = IsarNative.jsObjectGet(jsObj, 'taxAmt');
  object.taxTyCd = IsarNative.jsObjectGet(jsObj, 'taxTyCd');
  object.taxblAmt = IsarNative.jsObjectGet(jsObj, 'taxblAmt');
  object.tin = IsarNative.jsObjectGet(jsObj, 'tin');
  object.totAmt = IsarNative.jsObjectGet(jsObj, 'totAmt');
  object.type = IsarNative.jsObjectGet(jsObj, 'type');
  object.updatedAt = IsarNative.jsObjectGet(jsObj, 'updatedAt') ?? '';
  object.useYn = IsarNative.jsObjectGet(jsObj, 'useYn');
  object.variantId =
      IsarNative.jsObjectGet(jsObj, 'variantId') ?? double.negativeInfinity;
  return object;
}

P _orderItemDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'addInfo':
      return (IsarNative.jsObjectGet(jsObj, 'addInfo')) as P;
    case 'bcd':
      return (IsarNative.jsObjectGet(jsObj, 'bcd')) as P;
    case 'bhfId':
      return (IsarNative.jsObjectGet(jsObj, 'bhfId')) as P;
    case 'createdAt':
      return (IsarNative.jsObjectGet(jsObj, 'createdAt') ?? '') as P;
    case 'dcAmt':
      return (IsarNative.jsObjectGet(jsObj, 'dcAmt')) as P;
    case 'dcRt':
      return (IsarNative.jsObjectGet(jsObj, 'dcRt')) as P;
    case 'dftPrc':
      return (IsarNative.jsObjectGet(jsObj, 'dftPrc')) as P;
    case 'discount':
      return (IsarNative.jsObjectGet(jsObj, 'discount')) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'isrcAmt':
      return (IsarNative.jsObjectGet(jsObj, 'isrcAmt')) as P;
    case 'isrcAplcbYn':
      return (IsarNative.jsObjectGet(jsObj, 'isrcAplcbYn')) as P;
    case 'isrcRt':
      return (IsarNative.jsObjectGet(jsObj, 'isrcRt')) as P;
    case 'isrccCd':
      return (IsarNative.jsObjectGet(jsObj, 'isrccCd')) as P;
    case 'isrccNm':
      return (IsarNative.jsObjectGet(jsObj, 'isrccNm')) as P;
    case 'itemCd':
      return (IsarNative.jsObjectGet(jsObj, 'itemCd')) as P;
    case 'itemClsCd':
      return (IsarNative.jsObjectGet(jsObj, 'itemClsCd')) as P;
    case 'itemNm':
      return (IsarNative.jsObjectGet(jsObj, 'itemNm')) as P;
    case 'itemSeq':
      return (IsarNative.jsObjectGet(jsObj, 'itemSeq')) as P;
    case 'itemStdNm':
      return (IsarNative.jsObjectGet(jsObj, 'itemStdNm')) as P;
    case 'itemTyCd':
      return (IsarNative.jsObjectGet(jsObj, 'itemTyCd')) as P;
    case 'modrId':
      return (IsarNative.jsObjectGet(jsObj, 'modrId')) as P;
    case 'modrNm':
      return (IsarNative.jsObjectGet(jsObj, 'modrNm')) as P;
    case 'name':
      return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
    case 'orderId':
      return (IsarNative.jsObjectGet(jsObj, 'orderId') ??
          double.negativeInfinity) as P;
    case 'orgnNatCd':
      return (IsarNative.jsObjectGet(jsObj, 'orgnNatCd')) as P;
    case 'pkg':
      return (IsarNative.jsObjectGet(jsObj, 'pkg')) as P;
    case 'pkgUnitCd':
      return (IsarNative.jsObjectGet(jsObj, 'pkgUnitCd')) as P;
    case 'prc':
      return (IsarNative.jsObjectGet(jsObj, 'prc')) as P;
    case 'price':
      return (IsarNative.jsObjectGet(jsObj, 'price') ?? double.negativeInfinity)
          as P;
    case 'qty':
      return (IsarNative.jsObjectGet(jsObj, 'qty') ?? double.negativeInfinity)
          as P;
    case 'qtyUnitCd':
      return (IsarNative.jsObjectGet(jsObj, 'qtyUnitCd')) as P;
    case 'regrId':
      return (IsarNative.jsObjectGet(jsObj, 'regrId')) as P;
    case 'regrNm':
      return (IsarNative.jsObjectGet(jsObj, 'regrNm')) as P;
    case 'remainingStock':
      return (IsarNative.jsObjectGet(jsObj, 'remainingStock') ??
          double.negativeInfinity) as P;
    case 'reported':
      return (IsarNative.jsObjectGet(jsObj, 'reported')) as P;
    case 'splyAmt':
      return (IsarNative.jsObjectGet(jsObj, 'splyAmt')) as P;
    case 'taxAmt':
      return (IsarNative.jsObjectGet(jsObj, 'taxAmt')) as P;
    case 'taxTyCd':
      return (IsarNative.jsObjectGet(jsObj, 'taxTyCd')) as P;
    case 'taxblAmt':
      return (IsarNative.jsObjectGet(jsObj, 'taxblAmt')) as P;
    case 'tin':
      return (IsarNative.jsObjectGet(jsObj, 'tin')) as P;
    case 'totAmt':
      return (IsarNative.jsObjectGet(jsObj, 'totAmt')) as P;
    case 'type':
      return (IsarNative.jsObjectGet(jsObj, 'type')) as P;
    case 'updatedAt':
      return (IsarNative.jsObjectGet(jsObj, 'updatedAt') ?? '') as P;
    case 'useYn':
      return (IsarNative.jsObjectGet(jsObj, 'useYn')) as P;
    case 'variantId':
      return (IsarNative.jsObjectGet(jsObj, 'variantId') ??
          double.negativeInfinity) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _orderItemAttachLinks(IsarCollection col, int id, OrderItem object) {}

extension OrderItemQueryWhereSort
    on QueryBuilder<OrderItem, OrderItem, QWhere> {
  QueryBuilder<OrderItem, OrderItem, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhere> anyOrderId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'orderId'));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhere> anyVariantIdOrderId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'variantId_orderId'));
  }
}

extension OrderItemQueryWhere
    on QueryBuilder<OrderItem, OrderItem, QWhereClause> {
  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> orderIdEqualTo(
      int orderId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'orderId',
      value: [orderId],
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> orderIdNotEqualTo(
      int orderId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'orderId',
        upper: [orderId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'orderId',
        lower: [orderId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'orderId',
        lower: [orderId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'orderId',
        upper: [orderId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> orderIdGreaterThan(
    int orderId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'orderId',
      lower: [orderId],
      includeLower: include,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> orderIdLessThan(
    int orderId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'orderId',
      upper: [orderId],
      includeUpper: include,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> orderIdBetween(
    int lowerOrderId,
    int upperOrderId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'orderId',
      lower: [lowerOrderId],
      includeLower: includeLower,
      upper: [upperOrderId],
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> variantIdEqualTo(
      int variantId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'variantId_orderId',
      value: [variantId],
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> variantIdNotEqualTo(
      int variantId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'variantId_orderId',
        upper: [variantId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'variantId_orderId',
        lower: [variantId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'variantId_orderId',
        lower: [variantId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'variantId_orderId',
        upper: [variantId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> variantIdGreaterThan(
    int variantId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'variantId_orderId',
      lower: [variantId],
      includeLower: include,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> variantIdLessThan(
    int variantId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'variantId_orderId',
      upper: [variantId],
      includeUpper: include,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> variantIdBetween(
    int lowerVariantId,
    int upperVariantId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'variantId_orderId',
      lower: [lowerVariantId],
      includeLower: includeLower,
      upper: [upperVariantId],
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> variantIdOrderIdEqualTo(
      int variantId, int orderId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'variantId_orderId',
      value: [variantId, orderId],
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdOrderIdNotEqualTo(int variantId, int orderId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'variantId_orderId',
        upper: [variantId, orderId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'variantId_orderId',
        lower: [variantId, orderId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'variantId_orderId',
        lower: [variantId, orderId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'variantId_orderId',
        upper: [variantId, orderId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdEqualToOrderIdGreaterThan(
    int variantId,
    int orderId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'variantId_orderId',
      lower: [variantId, orderId],
      includeLower: include,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdEqualToOrderIdLessThan(
    int variantId,
    int orderId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'variantId_orderId',
      upper: [variantId, orderId],
      includeUpper: include,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdEqualToOrderIdBetween(
    int variantId,
    int lowerOrderId,
    int upperOrderId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'variantId_orderId',
      lower: [variantId, lowerOrderId],
      includeLower: includeLower,
      upper: [variantId, upperOrderId],
      includeUpper: includeUpper,
    ));
  }
}

extension OrderItemQueryFilter
    on QueryBuilder<OrderItem, OrderItem, QFilterCondition> {
  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'addInfo',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'addInfo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'addInfo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'addInfo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'addInfo',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'addInfo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'addInfo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'addInfo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'addInfo',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'bcd',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'bcd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'bcd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'bcd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'bcd',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'bcd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'bcd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'bcd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'bcd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'bhfId',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'bhfId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'bhfId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      createdAtGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'createdAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'createdAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcAmtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'dcAmt',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcAmtGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'dcAmt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcAmtLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'dcAmt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcAmtBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'dcAmt',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcRtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'dcRt',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcRtGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'dcRt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcRtLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'dcRt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcRtBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'dcRt',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dftPrcIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'dftPrc',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dftPrcGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'dftPrc',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dftPrcLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'dftPrc',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dftPrcBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'dftPrc',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'discount',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'discount',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'discount',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'discount',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isrcAmt',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isrcAmt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'isrcAmt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'isrcAmt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'isrcAmt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'isrcAmt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'isrcAmt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'isrcAmt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'isrcAmt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isrcAplcbYnIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isrcAplcbYn',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isrcAplcbYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isrcAplcbYnGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'isrcAplcbYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'isrcAplcbYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'isrcAplcbYn',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isrcAplcbYnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'isrcAplcbYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'isrcAplcbYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'isrcAplcbYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'isrcAplcbYn',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isrcRt',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isrcRt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'isrcRt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'isrcRt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'isrcRt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'isrcRt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'isrcRt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'isrcRt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'isrcRt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isrccCd',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isrccCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'isrccCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'isrccCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'isrccCd',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'isrccCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'isrccCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'isrccCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'isrccCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isrccNm',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isrccNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'isrccNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'isrccNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'isrccNm',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'isrccNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'isrccNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'isrccNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'isrccNm',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemCd',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'itemCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'itemCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'itemCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'itemCd',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'itemCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'itemCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemClsCd',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'itemClsCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      itemClsCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'itemClsCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'itemClsCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'itemClsCd',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'itemClsCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'itemClsCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemClsCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemClsCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemNm',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'itemNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'itemNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'itemNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'itemNm',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'itemNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'itemNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemNm',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemSeq',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'itemSeq',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'itemSeq',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'itemSeq',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'itemSeq',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'itemSeq',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'itemSeq',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemSeq',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemSeq',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemStdNm',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'itemStdNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      itemStdNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'itemStdNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'itemStdNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'itemStdNm',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'itemStdNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'itemStdNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemStdNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemStdNm',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemTyCd',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'itemTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'itemTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'itemTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'itemTyCd',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'itemTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'itemTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemTyCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'modrId',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'modrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'modrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'modrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'modrId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'modrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'modrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'modrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'modrId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'modrNm',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'modrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'modrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'modrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'modrNm',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'modrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'modrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'modrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'modrNm',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orderIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orderIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orderIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orderIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'orderId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'orgnNatCd',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'orgnNatCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      orgnNatCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'orgnNatCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'orgnNatCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'orgnNatCd',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'orgnNatCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'orgnNatCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'orgnNatCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'orgnNatCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'pkg',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'pkg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'pkg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'pkg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'pkg',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'pkg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'pkg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'pkg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'pkg',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'pkgUnitCd',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'pkgUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      pkgUnitCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'pkgUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'pkgUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'pkgUnitCd',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'pkgUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'pkgUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'pkgUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'pkgUnitCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> prcIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'prc',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> prcGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'prc',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> prcLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'prc',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> prcBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'prc',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> priceGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> priceLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> priceBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'price',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'qty',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'qty',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'qty',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'qtyUnitCd',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'qtyUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      qtyUnitCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'qtyUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'qtyUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'qtyUnitCd',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'qtyUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'qtyUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'qtyUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'qtyUnitCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'regrId',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'regrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'regrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'regrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'regrId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'regrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'regrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'regrId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'regrId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'regrNm',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'regrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'regrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'regrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'regrNm',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'regrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'regrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'regrNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'regrNm',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      remainingStockGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'remainingStock',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      remainingStockLessThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'remainingStock',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      remainingStockBetween(double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'remainingStock',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> reportedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'reported',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> reportedEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'reported',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> splyAmtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'splyAmt',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> splyAmtGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'splyAmt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> splyAmtLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'splyAmt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> splyAmtBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'splyAmt',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxAmtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'taxAmt',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxAmtGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'taxAmt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxAmtLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'taxAmt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxAmtBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'taxAmt',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'taxTyCd',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'taxTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'taxTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'taxTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'taxTyCd',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'taxTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'taxTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'taxTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'taxTyCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxblAmtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'taxblAmt',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxblAmtGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'taxblAmt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxblAmtLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'taxblAmt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxblAmtBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'taxblAmt',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> tinIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'tin',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> tinEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'tin',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> tinGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'tin',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> tinLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'tin',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> tinBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'tin',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> totAmtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'totAmt',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> totAmtGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'totAmt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> totAmtLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'totAmt',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> totAmtBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'totAmt',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'type',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'type',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      updatedAtGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'updatedAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'updatedAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'useYn',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'useYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'useYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'useYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'useYn',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'useYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'useYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'useYn',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'useYn',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> variantIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'variantId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      variantIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'variantId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> variantIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'variantId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> variantIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'variantId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension OrderItemQueryLinks
    on QueryBuilder<OrderItem, OrderItem, QFilterCondition> {}

extension OrderItemQueryWhereSortBy
    on QueryBuilder<OrderItem, OrderItem, QSortBy> {
  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByAddInfo() {
    return addSortByInternal('addInfo', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByAddInfoDesc() {
    return addSortByInternal('addInfo', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByBcd() {
    return addSortByInternal('bcd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByBcdDesc() {
    return addSortByInternal('bcd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByBhfId() {
    return addSortByInternal('bhfId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByBhfIdDesc() {
    return addSortByInternal('bhfId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDcAmt() {
    return addSortByInternal('dcAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDcAmtDesc() {
    return addSortByInternal('dcAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDcRt() {
    return addSortByInternal('dcRt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDcRtDesc() {
    return addSortByInternal('dcRt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDftPrc() {
    return addSortByInternal('dftPrc', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDftPrcDesc() {
    return addSortByInternal('dftPrc', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDiscount() {
    return addSortByInternal('discount', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDiscountDesc() {
    return addSortByInternal('discount', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcAmt() {
    return addSortByInternal('isrcAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcAmtDesc() {
    return addSortByInternal('isrcAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcAplcbYn() {
    return addSortByInternal('isrcAplcbYn', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcAplcbYnDesc() {
    return addSortByInternal('isrcAplcbYn', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcRt() {
    return addSortByInternal('isrcRt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcRtDesc() {
    return addSortByInternal('isrcRt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrccCd() {
    return addSortByInternal('isrccCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrccCdDesc() {
    return addSortByInternal('isrccCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrccNm() {
    return addSortByInternal('isrccNm', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrccNmDesc() {
    return addSortByInternal('isrccNm', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemCd() {
    return addSortByInternal('itemCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemCdDesc() {
    return addSortByInternal('itemCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemClsCd() {
    return addSortByInternal('itemClsCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemClsCdDesc() {
    return addSortByInternal('itemClsCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemNm() {
    return addSortByInternal('itemNm', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemNmDesc() {
    return addSortByInternal('itemNm', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemSeq() {
    return addSortByInternal('itemSeq', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemSeqDesc() {
    return addSortByInternal('itemSeq', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemStdNm() {
    return addSortByInternal('itemStdNm', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemStdNmDesc() {
    return addSortByInternal('itemStdNm', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemTyCd() {
    return addSortByInternal('itemTyCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemTyCdDesc() {
    return addSortByInternal('itemTyCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByModrId() {
    return addSortByInternal('modrId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByModrIdDesc() {
    return addSortByInternal('modrId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByModrNm() {
    return addSortByInternal('modrNm', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByModrNmDesc() {
    return addSortByInternal('modrNm', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByOrderId() {
    return addSortByInternal('orderId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByOrderIdDesc() {
    return addSortByInternal('orderId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByOrgnNatCd() {
    return addSortByInternal('orgnNatCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByOrgnNatCdDesc() {
    return addSortByInternal('orgnNatCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPkg() {
    return addSortByInternal('pkg', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPkgDesc() {
    return addSortByInternal('pkg', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPkgUnitCd() {
    return addSortByInternal('pkgUnitCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPkgUnitCdDesc() {
    return addSortByInternal('pkgUnitCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPrc() {
    return addSortByInternal('prc', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPrcDesc() {
    return addSortByInternal('prc', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPrice() {
    return addSortByInternal('price', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPriceDesc() {
    return addSortByInternal('price', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByQty() {
    return addSortByInternal('qty', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByQtyDesc() {
    return addSortByInternal('qty', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByQtyUnitCd() {
    return addSortByInternal('qtyUnitCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByQtyUnitCdDesc() {
    return addSortByInternal('qtyUnitCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRegrId() {
    return addSortByInternal('regrId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRegrIdDesc() {
    return addSortByInternal('regrId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRegrNm() {
    return addSortByInternal('regrNm', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRegrNmDesc() {
    return addSortByInternal('regrNm', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRemainingStock() {
    return addSortByInternal('remainingStock', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRemainingStockDesc() {
    return addSortByInternal('remainingStock', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByReported() {
    return addSortByInternal('reported', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByReportedDesc() {
    return addSortByInternal('reported', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortBySplyAmt() {
    return addSortByInternal('splyAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortBySplyAmtDesc() {
    return addSortByInternal('splyAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxAmt() {
    return addSortByInternal('taxAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxAmtDesc() {
    return addSortByInternal('taxAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxTyCd() {
    return addSortByInternal('taxTyCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxTyCdDesc() {
    return addSortByInternal('taxTyCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxblAmt() {
    return addSortByInternal('taxblAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxblAmtDesc() {
    return addSortByInternal('taxblAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTin() {
    return addSortByInternal('tin', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTinDesc() {
    return addSortByInternal('tin', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTotAmt() {
    return addSortByInternal('totAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTotAmtDesc() {
    return addSortByInternal('totAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByUseYn() {
    return addSortByInternal('useYn', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByUseYnDesc() {
    return addSortByInternal('useYn', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByVariantId() {
    return addSortByInternal('variantId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByVariantIdDesc() {
    return addSortByInternal('variantId', Sort.desc);
  }
}

extension OrderItemQueryWhereSortThenBy
    on QueryBuilder<OrderItem, OrderItem, QSortThenBy> {
  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByAddInfo() {
    return addSortByInternal('addInfo', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByAddInfoDesc() {
    return addSortByInternal('addInfo', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByBcd() {
    return addSortByInternal('bcd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByBcdDesc() {
    return addSortByInternal('bcd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByBhfId() {
    return addSortByInternal('bhfId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByBhfIdDesc() {
    return addSortByInternal('bhfId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDcAmt() {
    return addSortByInternal('dcAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDcAmtDesc() {
    return addSortByInternal('dcAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDcRt() {
    return addSortByInternal('dcRt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDcRtDesc() {
    return addSortByInternal('dcRt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDftPrc() {
    return addSortByInternal('dftPrc', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDftPrcDesc() {
    return addSortByInternal('dftPrc', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDiscount() {
    return addSortByInternal('discount', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDiscountDesc() {
    return addSortByInternal('discount', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcAmt() {
    return addSortByInternal('isrcAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcAmtDesc() {
    return addSortByInternal('isrcAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcAplcbYn() {
    return addSortByInternal('isrcAplcbYn', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcAplcbYnDesc() {
    return addSortByInternal('isrcAplcbYn', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcRt() {
    return addSortByInternal('isrcRt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcRtDesc() {
    return addSortByInternal('isrcRt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrccCd() {
    return addSortByInternal('isrccCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrccCdDesc() {
    return addSortByInternal('isrccCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrccNm() {
    return addSortByInternal('isrccNm', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrccNmDesc() {
    return addSortByInternal('isrccNm', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemCd() {
    return addSortByInternal('itemCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemCdDesc() {
    return addSortByInternal('itemCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemClsCd() {
    return addSortByInternal('itemClsCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemClsCdDesc() {
    return addSortByInternal('itemClsCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemNm() {
    return addSortByInternal('itemNm', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemNmDesc() {
    return addSortByInternal('itemNm', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemSeq() {
    return addSortByInternal('itemSeq', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemSeqDesc() {
    return addSortByInternal('itemSeq', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemStdNm() {
    return addSortByInternal('itemStdNm', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemStdNmDesc() {
    return addSortByInternal('itemStdNm', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemTyCd() {
    return addSortByInternal('itemTyCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemTyCdDesc() {
    return addSortByInternal('itemTyCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByModrId() {
    return addSortByInternal('modrId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByModrIdDesc() {
    return addSortByInternal('modrId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByModrNm() {
    return addSortByInternal('modrNm', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByModrNmDesc() {
    return addSortByInternal('modrNm', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByOrderId() {
    return addSortByInternal('orderId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByOrderIdDesc() {
    return addSortByInternal('orderId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByOrgnNatCd() {
    return addSortByInternal('orgnNatCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByOrgnNatCdDesc() {
    return addSortByInternal('orgnNatCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPkg() {
    return addSortByInternal('pkg', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPkgDesc() {
    return addSortByInternal('pkg', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPkgUnitCd() {
    return addSortByInternal('pkgUnitCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPkgUnitCdDesc() {
    return addSortByInternal('pkgUnitCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPrc() {
    return addSortByInternal('prc', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPrcDesc() {
    return addSortByInternal('prc', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPrice() {
    return addSortByInternal('price', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPriceDesc() {
    return addSortByInternal('price', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByQty() {
    return addSortByInternal('qty', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByQtyDesc() {
    return addSortByInternal('qty', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByQtyUnitCd() {
    return addSortByInternal('qtyUnitCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByQtyUnitCdDesc() {
    return addSortByInternal('qtyUnitCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRegrId() {
    return addSortByInternal('regrId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRegrIdDesc() {
    return addSortByInternal('regrId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRegrNm() {
    return addSortByInternal('regrNm', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRegrNmDesc() {
    return addSortByInternal('regrNm', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRemainingStock() {
    return addSortByInternal('remainingStock', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRemainingStockDesc() {
    return addSortByInternal('remainingStock', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByReported() {
    return addSortByInternal('reported', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByReportedDesc() {
    return addSortByInternal('reported', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenBySplyAmt() {
    return addSortByInternal('splyAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenBySplyAmtDesc() {
    return addSortByInternal('splyAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxAmt() {
    return addSortByInternal('taxAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxAmtDesc() {
    return addSortByInternal('taxAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxTyCd() {
    return addSortByInternal('taxTyCd', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxTyCdDesc() {
    return addSortByInternal('taxTyCd', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxblAmt() {
    return addSortByInternal('taxblAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxblAmtDesc() {
    return addSortByInternal('taxblAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTin() {
    return addSortByInternal('tin', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTinDesc() {
    return addSortByInternal('tin', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTotAmt() {
    return addSortByInternal('totAmt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTotAmtDesc() {
    return addSortByInternal('totAmt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByUseYn() {
    return addSortByInternal('useYn', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByUseYnDesc() {
    return addSortByInternal('useYn', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByVariantId() {
    return addSortByInternal('variantId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByVariantIdDesc() {
    return addSortByInternal('variantId', Sort.desc);
  }
}

extension OrderItemQueryWhereDistinct
    on QueryBuilder<OrderItem, OrderItem, QDistinct> {
  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByAddInfo(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('addInfo', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByBcd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('bcd', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByBhfId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('bhfId', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('createdAt', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByDcAmt() {
    return addDistinctByInternal('dcAmt');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByDcRt() {
    return addDistinctByInternal('dcRt');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByDftPrc() {
    return addDistinctByInternal('dftPrc');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByDiscount() {
    return addDistinctByInternal('discount');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsrcAmt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('isrcAmt', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsrcAplcbYn(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('isrcAplcbYn', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsrcRt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('isrcRt', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsrccCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('isrccCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsrccNm(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('isrccNm', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemClsCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemClsCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemNm(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemNm', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemSeq(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemSeq', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemStdNm(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemStdNm', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemTyCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemTyCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByModrId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('modrId', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByModrNm(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('modrNm', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByOrderId() {
    return addDistinctByInternal('orderId');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByOrgnNatCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('orgnNatCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByPkg(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('pkg', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByPkgUnitCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('pkgUnitCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByPrc() {
    return addDistinctByInternal('prc');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByPrice() {
    return addDistinctByInternal('price');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByQty() {
    return addDistinctByInternal('qty');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByQtyUnitCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('qtyUnitCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByRegrId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('regrId', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByRegrNm(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('regrNm', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByRemainingStock() {
    return addDistinctByInternal('remainingStock');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByReported() {
    return addDistinctByInternal('reported');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctBySplyAmt() {
    return addDistinctByInternal('splyAmt');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByTaxAmt() {
    return addDistinctByInternal('taxAmt');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByTaxTyCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('taxTyCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByTaxblAmt() {
    return addDistinctByInternal('taxblAmt');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByTin() {
    return addDistinctByInternal('tin');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByTotAmt() {
    return addDistinctByInternal('totAmt');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('type', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByUpdatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('updatedAt', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByUseYn(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('useYn', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByVariantId() {
    return addDistinctByInternal('variantId');
  }
}

extension OrderItemQueryProperty
    on QueryBuilder<OrderItem, OrderItem, QQueryProperty> {
  QueryBuilder<OrderItem, String?, QQueryOperations> addInfoProperty() {
    return addPropertyNameInternal('addInfo');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> bcdProperty() {
    return addPropertyNameInternal('bcd');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> bhfIdProperty() {
    return addPropertyNameInternal('bhfId');
  }

  QueryBuilder<OrderItem, String, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> dcAmtProperty() {
    return addPropertyNameInternal('dcAmt');
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> dcRtProperty() {
    return addPropertyNameInternal('dcRt');
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> dftPrcProperty() {
    return addPropertyNameInternal('dftPrc');
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> discountProperty() {
    return addPropertyNameInternal('discount');
  }

  QueryBuilder<OrderItem, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> isrcAmtProperty() {
    return addPropertyNameInternal('isrcAmt');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> isrcAplcbYnProperty() {
    return addPropertyNameInternal('isrcAplcbYn');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> isrcRtProperty() {
    return addPropertyNameInternal('isrcRt');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> isrccCdProperty() {
    return addPropertyNameInternal('isrccCd');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> isrccNmProperty() {
    return addPropertyNameInternal('isrccNm');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemCdProperty() {
    return addPropertyNameInternal('itemCd');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemClsCdProperty() {
    return addPropertyNameInternal('itemClsCd');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemNmProperty() {
    return addPropertyNameInternal('itemNm');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemSeqProperty() {
    return addPropertyNameInternal('itemSeq');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemStdNmProperty() {
    return addPropertyNameInternal('itemStdNm');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemTyCdProperty() {
    return addPropertyNameInternal('itemTyCd');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> modrIdProperty() {
    return addPropertyNameInternal('modrId');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> modrNmProperty() {
    return addPropertyNameInternal('modrNm');
  }

  QueryBuilder<OrderItem, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<OrderItem, int, QQueryOperations> orderIdProperty() {
    return addPropertyNameInternal('orderId');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> orgnNatCdProperty() {
    return addPropertyNameInternal('orgnNatCd');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> pkgProperty() {
    return addPropertyNameInternal('pkg');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> pkgUnitCdProperty() {
    return addPropertyNameInternal('pkgUnitCd');
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> prcProperty() {
    return addPropertyNameInternal('prc');
  }

  QueryBuilder<OrderItem, double, QQueryOperations> priceProperty() {
    return addPropertyNameInternal('price');
  }

  QueryBuilder<OrderItem, double, QQueryOperations> qtyProperty() {
    return addPropertyNameInternal('qty');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> qtyUnitCdProperty() {
    return addPropertyNameInternal('qtyUnitCd');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> regrIdProperty() {
    return addPropertyNameInternal('regrId');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> regrNmProperty() {
    return addPropertyNameInternal('regrNm');
  }

  QueryBuilder<OrderItem, double, QQueryOperations> remainingStockProperty() {
    return addPropertyNameInternal('remainingStock');
  }

  QueryBuilder<OrderItem, bool?, QQueryOperations> reportedProperty() {
    return addPropertyNameInternal('reported');
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> splyAmtProperty() {
    return addPropertyNameInternal('splyAmt');
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> taxAmtProperty() {
    return addPropertyNameInternal('taxAmt');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> taxTyCdProperty() {
    return addPropertyNameInternal('taxTyCd');
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> taxblAmtProperty() {
    return addPropertyNameInternal('taxblAmt');
  }

  QueryBuilder<OrderItem, int?, QQueryOperations> tinProperty() {
    return addPropertyNameInternal('tin');
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> totAmtProperty() {
    return addPropertyNameInternal('totAmt');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> typeProperty() {
    return addPropertyNameInternal('type');
  }

  QueryBuilder<OrderItem, String, QQueryOperations> updatedAtProperty() {
    return addPropertyNameInternal('updatedAt');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> useYnProperty() {
    return addPropertyNameInternal('useYn');
  }

  QueryBuilder<OrderItem, int, QQueryOperations> variantIdProperty() {
    return addPropertyNameInternal('variantId');
  }
}
