// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetVariantCollection on Isar {
  IsarCollection<Variant> get variants => collection();
}

const VariantSchema = CollectionSchema(
  name: r'Variant',
  schema:
      r'{"name":"Variant","idName":"id","properties":[{"name":"addInfo","type":"String"},{"name":"bcd","type":"String"},{"name":"bhfId","type":"String"},{"name":"branchId","type":"Long"},{"name":"dftPrc","type":"Double"},{"name":"isTaxExempted","type":"Bool"},{"name":"isrcAmt","type":"String"},{"name":"isrcAplcbYn","type":"String"},{"name":"isrcRt","type":"String"},{"name":"isrccCd","type":"String"},{"name":"isrccNm","type":"String"},{"name":"itemCd","type":"String"},{"name":"itemClsCd","type":"String"},{"name":"itemNm","type":"String"},{"name":"itemSeq","type":"String"},{"name":"itemStdNm","type":"String"},{"name":"itemTyCd","type":"String"},{"name":"modrId","type":"String"},{"name":"modrNm","type":"String"},{"name":"name","type":"String"},{"name":"orgnNatCd","type":"String"},{"name":"pkg","type":"String"},{"name":"pkgUnitCd","type":"String"},{"name":"prc","type":"Double"},{"name":"productId","type":"Long"},{"name":"productName","type":"String"},{"name":"qty","type":"Double"},{"name":"qtyUnitCd","type":"String"},{"name":"regrId","type":"String"},{"name":"regrNm","type":"String"},{"name":"retailPrice","type":"Double"},{"name":"rsdQty","type":"Double"},{"name":"sku","type":"String"},{"name":"splyAmt","type":"Double"},{"name":"supplyPrice","type":"Double"},{"name":"table","type":"String"},{"name":"taxName","type":"String"},{"name":"taxPercentage","type":"Double"},{"name":"taxTyCd","type":"String"},{"name":"tin","type":"Long"},{"name":"unit","type":"String"},{"name":"useYn","type":"String"}],"indexes":[{"name":"name","unique":false,"replace":false,"properties":[{"name":"name","type":"Hash","caseSensitive":true}]},{"name":"productId","unique":false,"replace":false,"properties":[{"name":"productId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'addInfo': 0,
    r'bcd': 1,
    r'bhfId': 2,
    r'branchId': 3,
    r'dftPrc': 4,
    r'isTaxExempted': 5,
    r'isrcAmt': 6,
    r'isrcAplcbYn': 7,
    r'isrcRt': 8,
    r'isrccCd': 9,
    r'isrccNm': 10,
    r'itemCd': 11,
    r'itemClsCd': 12,
    r'itemNm': 13,
    r'itemSeq': 14,
    r'itemStdNm': 15,
    r'itemTyCd': 16,
    r'modrId': 17,
    r'modrNm': 18,
    r'name': 19,
    r'orgnNatCd': 20,
    r'pkg': 21,
    r'pkgUnitCd': 22,
    r'prc': 23,
    r'productId': 24,
    r'productName': 25,
    r'qty': 26,
    r'qtyUnitCd': 27,
    r'regrId': 28,
    r'regrNm': 29,
    r'retailPrice': 30,
    r'rsdQty': 31,
    r'sku': 32,
    r'splyAmt': 33,
    r'supplyPrice': 34,
    r'table': 35,
    r'taxName': 36,
    r'taxPercentage': 37,
    r'taxTyCd': 38,
    r'tin': 39,
    r'unit': 40,
    r'useYn': 41
  },
  listProperties: {},
  indexIds: {r'name': 0, r'productId': 1},
  indexValueTypes: {
    r'name': [
      IndexValueType.stringHash,
    ],
    r'productId': [
      IndexValueType.long,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _variantGetId,
  setId: _variantSetId,
  getLinks: _variantGetLinks,
  attachLinks: _variantAttachLinks,
  serializeNative: _variantSerializeNative,
  deserializeNative: _variantDeserializeNative,
  deserializePropNative: _variantDeserializePropNative,
  serializeWeb: _variantSerializeWeb,
  deserializeWeb: _variantDeserializeWeb,
  deserializePropWeb: _variantDeserializePropWeb,
  version: 4,
);

int? _variantGetId(Variant object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _variantSetId(Variant object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _variantGetLinks(Variant object) {
  return [];
}

void _variantSerializeNative(
    IsarCollection<Variant> collection,
    IsarCObject cObj,
    Variant object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  IsarUint8List? addInfo$Bytes;
  final addInfo$Value = object.addInfo;
  if (addInfo$Value != null) {
    addInfo$Bytes = IsarBinaryWriter.utf8Encoder.convert(addInfo$Value);
  }
  IsarUint8List? bcd$Bytes;
  final bcd$Value = object.bcd;
  if (bcd$Value != null) {
    bcd$Bytes = IsarBinaryWriter.utf8Encoder.convert(bcd$Value);
  }
  IsarUint8List? bhfId$Bytes;
  final bhfId$Value = object.bhfId;
  if (bhfId$Value != null) {
    bhfId$Bytes = IsarBinaryWriter.utf8Encoder.convert(bhfId$Value);
  }
  IsarUint8List? isrcAmt$Bytes;
  final isrcAmt$Value = object.isrcAmt;
  if (isrcAmt$Value != null) {
    isrcAmt$Bytes = IsarBinaryWriter.utf8Encoder.convert(isrcAmt$Value);
  }
  IsarUint8List? isrcAplcbYn$Bytes;
  final isrcAplcbYn$Value = object.isrcAplcbYn;
  if (isrcAplcbYn$Value != null) {
    isrcAplcbYn$Bytes = IsarBinaryWriter.utf8Encoder.convert(isrcAplcbYn$Value);
  }
  IsarUint8List? isrcRt$Bytes;
  final isrcRt$Value = object.isrcRt;
  if (isrcRt$Value != null) {
    isrcRt$Bytes = IsarBinaryWriter.utf8Encoder.convert(isrcRt$Value);
  }
  IsarUint8List? isrccCd$Bytes;
  final isrccCd$Value = object.isrccCd;
  if (isrccCd$Value != null) {
    isrccCd$Bytes = IsarBinaryWriter.utf8Encoder.convert(isrccCd$Value);
  }
  IsarUint8List? isrccNm$Bytes;
  final isrccNm$Value = object.isrccNm;
  if (isrccNm$Value != null) {
    isrccNm$Bytes = IsarBinaryWriter.utf8Encoder.convert(isrccNm$Value);
  }
  IsarUint8List? itemCd$Bytes;
  final itemCd$Value = object.itemCd;
  if (itemCd$Value != null) {
    itemCd$Bytes = IsarBinaryWriter.utf8Encoder.convert(itemCd$Value);
  }
  IsarUint8List? itemClsCd$Bytes;
  final itemClsCd$Value = object.itemClsCd;
  if (itemClsCd$Value != null) {
    itemClsCd$Bytes = IsarBinaryWriter.utf8Encoder.convert(itemClsCd$Value);
  }
  IsarUint8List? itemNm$Bytes;
  final itemNm$Value = object.itemNm;
  if (itemNm$Value != null) {
    itemNm$Bytes = IsarBinaryWriter.utf8Encoder.convert(itemNm$Value);
  }
  IsarUint8List? itemSeq$Bytes;
  final itemSeq$Value = object.itemSeq;
  if (itemSeq$Value != null) {
    itemSeq$Bytes = IsarBinaryWriter.utf8Encoder.convert(itemSeq$Value);
  }
  IsarUint8List? itemStdNm$Bytes;
  final itemStdNm$Value = object.itemStdNm;
  if (itemStdNm$Value != null) {
    itemStdNm$Bytes = IsarBinaryWriter.utf8Encoder.convert(itemStdNm$Value);
  }
  IsarUint8List? itemTyCd$Bytes;
  final itemTyCd$Value = object.itemTyCd;
  if (itemTyCd$Value != null) {
    itemTyCd$Bytes = IsarBinaryWriter.utf8Encoder.convert(itemTyCd$Value);
  }
  IsarUint8List? modrId$Bytes;
  final modrId$Value = object.modrId;
  if (modrId$Value != null) {
    modrId$Bytes = IsarBinaryWriter.utf8Encoder.convert(modrId$Value);
  }
  IsarUint8List? modrNm$Bytes;
  final modrNm$Value = object.modrNm;
  if (modrNm$Value != null) {
    modrNm$Bytes = IsarBinaryWriter.utf8Encoder.convert(modrNm$Value);
  }
  final name$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.name);
  IsarUint8List? orgnNatCd$Bytes;
  final orgnNatCd$Value = object.orgnNatCd;
  if (orgnNatCd$Value != null) {
    orgnNatCd$Bytes = IsarBinaryWriter.utf8Encoder.convert(orgnNatCd$Value);
  }
  IsarUint8List? pkg$Bytes;
  final pkg$Value = object.pkg;
  if (pkg$Value != null) {
    pkg$Bytes = IsarBinaryWriter.utf8Encoder.convert(pkg$Value);
  }
  IsarUint8List? pkgUnitCd$Bytes;
  final pkgUnitCd$Value = object.pkgUnitCd;
  if (pkgUnitCd$Value != null) {
    pkgUnitCd$Bytes = IsarBinaryWriter.utf8Encoder.convert(pkgUnitCd$Value);
  }
  final productName$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.productName);
  IsarUint8List? qtyUnitCd$Bytes;
  final qtyUnitCd$Value = object.qtyUnitCd;
  if (qtyUnitCd$Value != null) {
    qtyUnitCd$Bytes = IsarBinaryWriter.utf8Encoder.convert(qtyUnitCd$Value);
  }
  IsarUint8List? regrId$Bytes;
  final regrId$Value = object.regrId;
  if (regrId$Value != null) {
    regrId$Bytes = IsarBinaryWriter.utf8Encoder.convert(regrId$Value);
  }
  IsarUint8List? regrNm$Bytes;
  final regrNm$Value = object.regrNm;
  if (regrNm$Value != null) {
    regrNm$Bytes = IsarBinaryWriter.utf8Encoder.convert(regrNm$Value);
  }
  final sku$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.sku);
  final table$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.table);
  IsarUint8List? taxName$Bytes;
  final taxName$Value = object.taxName;
  if (taxName$Value != null) {
    taxName$Bytes = IsarBinaryWriter.utf8Encoder.convert(taxName$Value);
  }
  IsarUint8List? taxTyCd$Bytes;
  final taxTyCd$Value = object.taxTyCd;
  if (taxTyCd$Value != null) {
    taxTyCd$Bytes = IsarBinaryWriter.utf8Encoder.convert(taxTyCd$Value);
  }
  final unit$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.unit);
  IsarUint8List? useYn$Bytes;
  final useYn$Value = object.useYn;
  if (useYn$Value != null) {
    useYn$Bytes = IsarBinaryWriter.utf8Encoder.convert(useYn$Value);
  }
  final size = (staticSize +
      3 +
      (addInfo$Bytes?.length ?? 0) +
      3 +
      (bcd$Bytes?.length ?? 0) +
      3 +
      (bhfId$Bytes?.length ?? 0) +
      3 +
      (isrcAmt$Bytes?.length ?? 0) +
      3 +
      (isrcAplcbYn$Bytes?.length ?? 0) +
      3 +
      (isrcRt$Bytes?.length ?? 0) +
      3 +
      (isrccCd$Bytes?.length ?? 0) +
      3 +
      (isrccNm$Bytes?.length ?? 0) +
      3 +
      (itemCd$Bytes?.length ?? 0) +
      3 +
      (itemClsCd$Bytes?.length ?? 0) +
      3 +
      (itemNm$Bytes?.length ?? 0) +
      3 +
      (itemSeq$Bytes?.length ?? 0) +
      3 +
      (itemStdNm$Bytes?.length ?? 0) +
      3 +
      (itemTyCd$Bytes?.length ?? 0) +
      3 +
      (modrId$Bytes?.length ?? 0) +
      3 +
      (modrNm$Bytes?.length ?? 0) +
      3 +
      (name$Bytes.length) +
      3 +
      (orgnNatCd$Bytes?.length ?? 0) +
      3 +
      (pkg$Bytes?.length ?? 0) +
      3 +
      (pkgUnitCd$Bytes?.length ?? 0) +
      3 +
      (productName$Bytes.length) +
      3 +
      (qtyUnitCd$Bytes?.length ?? 0) +
      3 +
      (regrId$Bytes?.length ?? 0) +
      3 +
      (regrNm$Bytes?.length ?? 0) +
      3 +
      (sku$Bytes.length) +
      3 +
      (table$Bytes.length) +
      3 +
      (taxName$Bytes?.length ?? 0) +
      3 +
      (taxTyCd$Bytes?.length ?? 0) +
      3 +
      (unit$Bytes.length) +
      3 +
      (useYn$Bytes?.length ?? 0)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeByteList(offsets[0], addInfo$Bytes);
  writer.writeByteList(offsets[1], bcd$Bytes);
  writer.writeByteList(offsets[2], bhfId$Bytes);
  writer.writeLong(offsets[3], object.branchId);
  writer.writeDouble(offsets[4], object.dftPrc);
  writer.writeBool(offsets[5], object.isTaxExempted);
  writer.writeByteList(offsets[6], isrcAmt$Bytes);
  writer.writeByteList(offsets[7], isrcAplcbYn$Bytes);
  writer.writeByteList(offsets[8], isrcRt$Bytes);
  writer.writeByteList(offsets[9], isrccCd$Bytes);
  writer.writeByteList(offsets[10], isrccNm$Bytes);
  writer.writeByteList(offsets[11], itemCd$Bytes);
  writer.writeByteList(offsets[12], itemClsCd$Bytes);
  writer.writeByteList(offsets[13], itemNm$Bytes);
  writer.writeByteList(offsets[14], itemSeq$Bytes);
  writer.writeByteList(offsets[15], itemStdNm$Bytes);
  writer.writeByteList(offsets[16], itemTyCd$Bytes);
  writer.writeByteList(offsets[17], modrId$Bytes);
  writer.writeByteList(offsets[18], modrNm$Bytes);
  writer.writeByteList(offsets[19], name$Bytes);
  writer.writeByteList(offsets[20], orgnNatCd$Bytes);
  writer.writeByteList(offsets[21], pkg$Bytes);
  writer.writeByteList(offsets[22], pkgUnitCd$Bytes);
  writer.writeDouble(offsets[23], object.prc);
  writer.writeLong(offsets[24], object.productId);
  writer.writeByteList(offsets[25], productName$Bytes);
  writer.writeDouble(offsets[26], object.qty);
  writer.writeByteList(offsets[27], qtyUnitCd$Bytes);
  writer.writeByteList(offsets[28], regrId$Bytes);
  writer.writeByteList(offsets[29], regrNm$Bytes);
  writer.writeDouble(offsets[30], object.retailPrice);
  writer.writeDouble(offsets[31], object.rsdQty);
  writer.writeByteList(offsets[32], sku$Bytes);
  writer.writeDouble(offsets[33], object.splyAmt);
  writer.writeDouble(offsets[34], object.supplyPrice);
  writer.writeByteList(offsets[35], table$Bytes);
  writer.writeByteList(offsets[36], taxName$Bytes);
  writer.writeDouble(offsets[37], object.taxPercentage);
  writer.writeByteList(offsets[38], taxTyCd$Bytes);
  writer.writeLong(offsets[39], object.tin);
  writer.writeByteList(offsets[40], unit$Bytes);
  writer.writeByteList(offsets[41], useYn$Bytes);
}

Variant _variantDeserializeNative(IsarCollection<Variant> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Variant();
  object.addInfo = reader.readStringOrNull(offsets[0]);
  object.bcd = reader.readStringOrNull(offsets[1]);
  object.bhfId = reader.readStringOrNull(offsets[2]);
  object.branchId = reader.readLong(offsets[3]);
  object.dftPrc = reader.readDoubleOrNull(offsets[4]);
  object.id = id;
  object.isTaxExempted = reader.readBool(offsets[5]);
  object.isrcAmt = reader.readStringOrNull(offsets[6]);
  object.isrcAplcbYn = reader.readStringOrNull(offsets[7]);
  object.isrcRt = reader.readStringOrNull(offsets[8]);
  object.isrccCd = reader.readStringOrNull(offsets[9]);
  object.isrccNm = reader.readStringOrNull(offsets[10]);
  object.itemCd = reader.readStringOrNull(offsets[11]);
  object.itemClsCd = reader.readStringOrNull(offsets[12]);
  object.itemNm = reader.readStringOrNull(offsets[13]);
  object.itemSeq = reader.readStringOrNull(offsets[14]);
  object.itemStdNm = reader.readStringOrNull(offsets[15]);
  object.itemTyCd = reader.readStringOrNull(offsets[16]);
  object.modrId = reader.readStringOrNull(offsets[17]);
  object.modrNm = reader.readStringOrNull(offsets[18]);
  object.name = reader.readString(offsets[19]);
  object.orgnNatCd = reader.readStringOrNull(offsets[20]);
  object.pkg = reader.readStringOrNull(offsets[21]);
  object.pkgUnitCd = reader.readStringOrNull(offsets[22]);
  object.prc = reader.readDoubleOrNull(offsets[23]);
  object.productId = reader.readLong(offsets[24]);
  object.productName = reader.readString(offsets[25]);
  object.qty = reader.readDoubleOrNull(offsets[26]);
  object.qtyUnitCd = reader.readStringOrNull(offsets[27]);
  object.regrId = reader.readStringOrNull(offsets[28]);
  object.regrNm = reader.readStringOrNull(offsets[29]);
  object.retailPrice = reader.readDouble(offsets[30]);
  object.rsdQty = reader.readDoubleOrNull(offsets[31]);
  object.sku = reader.readString(offsets[32]);
  object.splyAmt = reader.readDoubleOrNull(offsets[33]);
  object.supplyPrice = reader.readDouble(offsets[34]);
  object.table = reader.readString(offsets[35]);
  object.taxName = reader.readStringOrNull(offsets[36]);
  object.taxPercentage = reader.readDoubleOrNull(offsets[37]);
  object.taxTyCd = reader.readStringOrNull(offsets[38]);
  object.tin = reader.readLongOrNull(offsets[39]);
  object.unit = reader.readString(offsets[40]);
  object.useYn = reader.readStringOrNull(offsets[41]);
  return object;
}

P _variantDeserializePropNative<P>(
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
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
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
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readDoubleOrNull(offset)) as P;
    case 24:
      return (reader.readLong(offset)) as P;
    case 25:
      return (reader.readString(offset)) as P;
    case 26:
      return (reader.readDoubleOrNull(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    case 28:
      return (reader.readStringOrNull(offset)) as P;
    case 29:
      return (reader.readStringOrNull(offset)) as P;
    case 30:
      return (reader.readDouble(offset)) as P;
    case 31:
      return (reader.readDoubleOrNull(offset)) as P;
    case 32:
      return (reader.readString(offset)) as P;
    case 33:
      return (reader.readDoubleOrNull(offset)) as P;
    case 34:
      return (reader.readDouble(offset)) as P;
    case 35:
      return (reader.readString(offset)) as P;
    case 36:
      return (reader.readStringOrNull(offset)) as P;
    case 37:
      return (reader.readDoubleOrNull(offset)) as P;
    case 38:
      return (reader.readStringOrNull(offset)) as P;
    case 39:
      return (reader.readLongOrNull(offset)) as P;
    case 40:
      return (reader.readString(offset)) as P;
    case 41:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _variantSerializeWeb(
    IsarCollection<Variant> collection, Variant object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'addInfo', object.addInfo);
  IsarNative.jsObjectSet(jsObj, r'bcd', object.bcd);
  IsarNative.jsObjectSet(jsObj, r'bhfId', object.bhfId);
  IsarNative.jsObjectSet(jsObj, r'branchId', object.branchId);
  IsarNative.jsObjectSet(jsObj, r'dftPrc', object.dftPrc);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'isTaxExempted', object.isTaxExempted);
  IsarNative.jsObjectSet(jsObj, r'isrcAmt', object.isrcAmt);
  IsarNative.jsObjectSet(jsObj, r'isrcAplcbYn', object.isrcAplcbYn);
  IsarNative.jsObjectSet(jsObj, r'isrcRt', object.isrcRt);
  IsarNative.jsObjectSet(jsObj, r'isrccCd', object.isrccCd);
  IsarNative.jsObjectSet(jsObj, r'isrccNm', object.isrccNm);
  IsarNative.jsObjectSet(jsObj, r'itemCd', object.itemCd);
  IsarNative.jsObjectSet(jsObj, r'itemClsCd', object.itemClsCd);
  IsarNative.jsObjectSet(jsObj, r'itemNm', object.itemNm);
  IsarNative.jsObjectSet(jsObj, r'itemSeq', object.itemSeq);
  IsarNative.jsObjectSet(jsObj, r'itemStdNm', object.itemStdNm);
  IsarNative.jsObjectSet(jsObj, r'itemTyCd', object.itemTyCd);
  IsarNative.jsObjectSet(jsObj, r'modrId', object.modrId);
  IsarNative.jsObjectSet(jsObj, r'modrNm', object.modrNm);
  IsarNative.jsObjectSet(jsObj, r'name', object.name);
  IsarNative.jsObjectSet(jsObj, r'orgnNatCd', object.orgnNatCd);
  IsarNative.jsObjectSet(jsObj, r'pkg', object.pkg);
  IsarNative.jsObjectSet(jsObj, r'pkgUnitCd', object.pkgUnitCd);
  IsarNative.jsObjectSet(jsObj, r'prc', object.prc);
  IsarNative.jsObjectSet(jsObj, r'productId', object.productId);
  IsarNative.jsObjectSet(jsObj, r'productName', object.productName);
  IsarNative.jsObjectSet(jsObj, r'qty', object.qty);
  IsarNative.jsObjectSet(jsObj, r'qtyUnitCd', object.qtyUnitCd);
  IsarNative.jsObjectSet(jsObj, r'regrId', object.regrId);
  IsarNative.jsObjectSet(jsObj, r'regrNm', object.regrNm);
  IsarNative.jsObjectSet(jsObj, r'retailPrice', object.retailPrice);
  IsarNative.jsObjectSet(jsObj, r'rsdQty', object.rsdQty);
  IsarNative.jsObjectSet(jsObj, r'sku', object.sku);
  IsarNative.jsObjectSet(jsObj, r'splyAmt', object.splyAmt);
  IsarNative.jsObjectSet(jsObj, r'supplyPrice', object.supplyPrice);
  IsarNative.jsObjectSet(jsObj, r'table', object.table);
  IsarNative.jsObjectSet(jsObj, r'taxName', object.taxName);
  IsarNative.jsObjectSet(jsObj, r'taxPercentage', object.taxPercentage);
  IsarNative.jsObjectSet(jsObj, r'taxTyCd', object.taxTyCd);
  IsarNative.jsObjectSet(jsObj, r'tin', object.tin);
  IsarNative.jsObjectSet(jsObj, r'unit', object.unit);
  IsarNative.jsObjectSet(jsObj, r'useYn', object.useYn);
  return jsObj;
}

Variant _variantDeserializeWeb(
    IsarCollection<Variant> collection, Object jsObj) {
  final object = Variant();
  object.addInfo = IsarNative.jsObjectGet(jsObj, r'addInfo');
  object.bcd = IsarNative.jsObjectGet(jsObj, r'bcd');
  object.bhfId = IsarNative.jsObjectGet(jsObj, r'bhfId');
  object.branchId = IsarNative.jsObjectGet(jsObj, r'branchId') ??
      (double.negativeInfinity as int);
  object.dftPrc = IsarNative.jsObjectGet(jsObj, r'dftPrc');
  object.id = IsarNative.jsObjectGet(jsObj, r'id');
  object.isTaxExempted =
      IsarNative.jsObjectGet(jsObj, r'isTaxExempted') ?? false;
  object.isrcAmt = IsarNative.jsObjectGet(jsObj, r'isrcAmt');
  object.isrcAplcbYn = IsarNative.jsObjectGet(jsObj, r'isrcAplcbYn');
  object.isrcRt = IsarNative.jsObjectGet(jsObj, r'isrcRt');
  object.isrccCd = IsarNative.jsObjectGet(jsObj, r'isrccCd');
  object.isrccNm = IsarNative.jsObjectGet(jsObj, r'isrccNm');
  object.itemCd = IsarNative.jsObjectGet(jsObj, r'itemCd');
  object.itemClsCd = IsarNative.jsObjectGet(jsObj, r'itemClsCd');
  object.itemNm = IsarNative.jsObjectGet(jsObj, r'itemNm');
  object.itemSeq = IsarNative.jsObjectGet(jsObj, r'itemSeq');
  object.itemStdNm = IsarNative.jsObjectGet(jsObj, r'itemStdNm');
  object.itemTyCd = IsarNative.jsObjectGet(jsObj, r'itemTyCd');
  object.modrId = IsarNative.jsObjectGet(jsObj, r'modrId');
  object.modrNm = IsarNative.jsObjectGet(jsObj, r'modrNm');
  object.name = IsarNative.jsObjectGet(jsObj, r'name') ?? '';
  object.orgnNatCd = IsarNative.jsObjectGet(jsObj, r'orgnNatCd');
  object.pkg = IsarNative.jsObjectGet(jsObj, r'pkg');
  object.pkgUnitCd = IsarNative.jsObjectGet(jsObj, r'pkgUnitCd');
  object.prc = IsarNative.jsObjectGet(jsObj, r'prc');
  object.productId = IsarNative.jsObjectGet(jsObj, r'productId') ??
      (double.negativeInfinity as int);
  object.productName = IsarNative.jsObjectGet(jsObj, r'productName') ?? '';
  object.qty = IsarNative.jsObjectGet(jsObj, r'qty');
  object.qtyUnitCd = IsarNative.jsObjectGet(jsObj, r'qtyUnitCd');
  object.regrId = IsarNative.jsObjectGet(jsObj, r'regrId');
  object.regrNm = IsarNative.jsObjectGet(jsObj, r'regrNm');
  object.retailPrice =
      IsarNative.jsObjectGet(jsObj, r'retailPrice') ?? double.negativeInfinity;
  object.rsdQty = IsarNative.jsObjectGet(jsObj, r'rsdQty');
  object.sku = IsarNative.jsObjectGet(jsObj, r'sku') ?? '';
  object.splyAmt = IsarNative.jsObjectGet(jsObj, r'splyAmt');
  object.supplyPrice =
      IsarNative.jsObjectGet(jsObj, r'supplyPrice') ?? double.negativeInfinity;
  object.table = IsarNative.jsObjectGet(jsObj, r'table') ?? '';
  object.taxName = IsarNative.jsObjectGet(jsObj, r'taxName');
  object.taxPercentage = IsarNative.jsObjectGet(jsObj, r'taxPercentage');
  object.taxTyCd = IsarNative.jsObjectGet(jsObj, r'taxTyCd');
  object.tin = IsarNative.jsObjectGet(jsObj, r'tin');
  object.unit = IsarNative.jsObjectGet(jsObj, r'unit') ?? '';
  object.useYn = IsarNative.jsObjectGet(jsObj, r'useYn');
  return object;
}

P _variantDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'addInfo':
      return (IsarNative.jsObjectGet(jsObj, r'addInfo')) as P;
    case r'bcd':
      return (IsarNative.jsObjectGet(jsObj, r'bcd')) as P;
    case r'bhfId':
      return (IsarNative.jsObjectGet(jsObj, r'bhfId')) as P;
    case r'branchId':
      return (IsarNative.jsObjectGet(jsObj, r'branchId') ??
          (double.negativeInfinity as int)) as P;
    case r'dftPrc':
      return (IsarNative.jsObjectGet(jsObj, r'dftPrc')) as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'isTaxExempted':
      return (IsarNative.jsObjectGet(jsObj, r'isTaxExempted') ?? false) as P;
    case r'isrcAmt':
      return (IsarNative.jsObjectGet(jsObj, r'isrcAmt')) as P;
    case r'isrcAplcbYn':
      return (IsarNative.jsObjectGet(jsObj, r'isrcAplcbYn')) as P;
    case r'isrcRt':
      return (IsarNative.jsObjectGet(jsObj, r'isrcRt')) as P;
    case r'isrccCd':
      return (IsarNative.jsObjectGet(jsObj, r'isrccCd')) as P;
    case r'isrccNm':
      return (IsarNative.jsObjectGet(jsObj, r'isrccNm')) as P;
    case r'itemCd':
      return (IsarNative.jsObjectGet(jsObj, r'itemCd')) as P;
    case r'itemClsCd':
      return (IsarNative.jsObjectGet(jsObj, r'itemClsCd')) as P;
    case r'itemNm':
      return (IsarNative.jsObjectGet(jsObj, r'itemNm')) as P;
    case r'itemSeq':
      return (IsarNative.jsObjectGet(jsObj, r'itemSeq')) as P;
    case r'itemStdNm':
      return (IsarNative.jsObjectGet(jsObj, r'itemStdNm')) as P;
    case r'itemTyCd':
      return (IsarNative.jsObjectGet(jsObj, r'itemTyCd')) as P;
    case r'modrId':
      return (IsarNative.jsObjectGet(jsObj, r'modrId')) as P;
    case r'modrNm':
      return (IsarNative.jsObjectGet(jsObj, r'modrNm')) as P;
    case r'name':
      return (IsarNative.jsObjectGet(jsObj, r'name') ?? '') as P;
    case r'orgnNatCd':
      return (IsarNative.jsObjectGet(jsObj, r'orgnNatCd')) as P;
    case r'pkg':
      return (IsarNative.jsObjectGet(jsObj, r'pkg')) as P;
    case r'pkgUnitCd':
      return (IsarNative.jsObjectGet(jsObj, r'pkgUnitCd')) as P;
    case r'prc':
      return (IsarNative.jsObjectGet(jsObj, r'prc')) as P;
    case r'productId':
      return (IsarNative.jsObjectGet(jsObj, r'productId') ??
          (double.negativeInfinity as int)) as P;
    case r'productName':
      return (IsarNative.jsObjectGet(jsObj, r'productName') ?? '') as P;
    case r'qty':
      return (IsarNative.jsObjectGet(jsObj, r'qty')) as P;
    case r'qtyUnitCd':
      return (IsarNative.jsObjectGet(jsObj, r'qtyUnitCd')) as P;
    case r'regrId':
      return (IsarNative.jsObjectGet(jsObj, r'regrId')) as P;
    case r'regrNm':
      return (IsarNative.jsObjectGet(jsObj, r'regrNm')) as P;
    case r'retailPrice':
      return (IsarNative.jsObjectGet(jsObj, r'retailPrice') ??
          double.negativeInfinity) as P;
    case r'rsdQty':
      return (IsarNative.jsObjectGet(jsObj, r'rsdQty')) as P;
    case r'sku':
      return (IsarNative.jsObjectGet(jsObj, r'sku') ?? '') as P;
    case r'splyAmt':
      return (IsarNative.jsObjectGet(jsObj, r'splyAmt')) as P;
    case r'supplyPrice':
      return (IsarNative.jsObjectGet(jsObj, r'supplyPrice') ??
          double.negativeInfinity) as P;
    case r'table':
      return (IsarNative.jsObjectGet(jsObj, r'table') ?? '') as P;
    case r'taxName':
      return (IsarNative.jsObjectGet(jsObj, r'taxName')) as P;
    case r'taxPercentage':
      return (IsarNative.jsObjectGet(jsObj, r'taxPercentage')) as P;
    case r'taxTyCd':
      return (IsarNative.jsObjectGet(jsObj, r'taxTyCd')) as P;
    case r'tin':
      return (IsarNative.jsObjectGet(jsObj, r'tin')) as P;
    case r'unit':
      return (IsarNative.jsObjectGet(jsObj, r'unit') ?? '') as P;
    case r'useYn':
      return (IsarNative.jsObjectGet(jsObj, r'useYn')) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _variantAttachLinks(IsarCollection<dynamic> col, int id, Variant object) {}

extension VariantQueryWhereSort on QueryBuilder<Variant, Variant, QWhere> {
  QueryBuilder<Variant, Variant, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhere> anyProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'productId'),
      );
    });
  }
}

extension VariantQueryWhere on QueryBuilder<Variant, Variant, QWhereClause> {
  QueryBuilder<Variant, Variant, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> idNotEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> nameNotEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> productIdEqualTo(
      int productId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'productId',
        value: [productId],
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> productIdNotEqualTo(
      int productId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [],
              upper: [productId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [productId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [productId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [],
              upper: [productId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> productIdGreaterThan(
    int productId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'productId',
        lower: [productId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> productIdLessThan(
    int productId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'productId',
        lower: [],
        upper: [productId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> productIdBetween(
    int lowerProductId,
    int upperProductId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'productId',
        lower: [lowerProductId],
        includeLower: includeLower,
        upper: [upperProductId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VariantQueryFilter
    on QueryBuilder<Variant, Variant, QFilterCondition> {
  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'addInfo',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'addInfo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'addInfo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bcd',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bcd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bcd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bhfId',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bhfId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bhfId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'branchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'branchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'branchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'branchId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> dftPrcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dftPrc',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> dftPrcGreaterThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dftPrc',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> dftPrcLessThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'dftPrc',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> dftPrcBetween(
      double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dftPrc',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isTaxExemptedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isTaxExempted',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrcAmt',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isrcAmt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrcAmt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrcAplcbYn',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isrcAplcbYn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrcAplcbYn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrcRt',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isrcRt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrcRt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrccCd',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isrccCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrccCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrccNm',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isrccNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrccNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemCd',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemClsCd',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemClsCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemClsCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemNm',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemSeq',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemSeq',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemSeq',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemStdNm',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemStdNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemStdNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemTyCd',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemTyCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemTyCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modrId',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modrId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modrId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modrNm',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modrNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modrNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orgnNatCd',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orgnNatCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orgnNatCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pkg',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pkg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pkg',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pkgUnitCd',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pkgUnitCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pkgUnitCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'prc',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcGreaterThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prc',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcLessThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'prc',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcBetween(
      double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prc',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'qty',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyGreaterThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'qty',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyLessThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'qty',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyBetween(
      double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qty',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'qtyUnitCd',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qtyUnitCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'qtyUnitCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'regrId',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'regrId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'regrId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'regrNm',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'regrNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'regrNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> retailPriceGreaterThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'retailPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> retailPriceLessThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'retailPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> retailPriceBetween(
      double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retailPrice',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> rsdQtyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rsdQty',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> rsdQtyGreaterThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rsdQty',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> rsdQtyLessThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'rsdQty',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> rsdQtyBetween(
      double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rsdQty',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sku',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sku',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'splyAmt',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtGreaterThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'splyAmt',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtLessThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'splyAmt',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtBetween(
      double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'splyAmt',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> supplyPriceGreaterThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supplyPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> supplyPriceLessThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'supplyPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> supplyPriceBetween(
      double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supplyPrice',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'table',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'table',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxName',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taxName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxPercentageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxPercentage',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      taxPercentageGreaterThan(double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taxPercentage',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxPercentageLessThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'taxPercentage',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxPercentageBetween(
      double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxPercentage',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxTyCd',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxTyCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taxTyCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tin',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tin',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tin',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tin',
        value: value,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'useYn',
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'useYn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'useYn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }
}

extension VariantQueryLinks
    on QueryBuilder<Variant, Variant, QFilterCondition> {}

extension VariantQueryWhereSortBy on QueryBuilder<Variant, Variant, QSortBy> {
  QueryBuilder<Variant, Variant, QAfterSortBy> sortByAddInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByAddInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBcd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBcdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByDftPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsTaxExemptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcAplcbYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcAplcbYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemClsCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemClsCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemSeq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemSeqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemStdNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemStdNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByModrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByModrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByModrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByOrgnNatCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByOrgnNatCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkgUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkgUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQtyUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQtyUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRegrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRegrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRegrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRetailPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRsdQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rsdQty', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRsdQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rsdQty', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySplyAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySupplyPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplyPrice', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySupplyPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplyPrice', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxName', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxName', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByUseYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByUseYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.desc);
    });
  }
}

extension VariantQueryWhereSortThenBy
    on QueryBuilder<Variant, Variant, QSortThenBy> {
  QueryBuilder<Variant, Variant, QAfterSortBy> thenByAddInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByAddInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBcd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBcdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByDftPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsTaxExemptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcAplcbYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcAplcbYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemClsCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemClsCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemSeq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemSeqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemStdNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemStdNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByModrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByModrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByModrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByOrgnNatCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByOrgnNatCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkgUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkgUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQtyUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQtyUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRegrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRegrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRegrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRetailPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRsdQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rsdQty', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRsdQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rsdQty', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySplyAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySupplyPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplyPrice', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySupplyPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplyPrice', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxName', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxName', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByUseYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.asc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByUseYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.desc);
    });
  }
}

extension VariantQueryWhereDistinct
    on QueryBuilder<Variant, Variant, QDistinct> {
  QueryBuilder<Variant, Variant, QDistinct> distinctByAddInfo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addInfo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByBcd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bcd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bhfId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'branchId');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dftPrc');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTaxExempted');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByIsrcAmt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrcAmt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByIsrcAplcbYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrcAplcbYn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByIsrcRt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrcRt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByIsrccCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrccCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByIsrccNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrccNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemClsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemClsCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemSeq(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemSeq', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemStdNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemStdNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemTyCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByModrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modrId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modrNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByOrgnNatCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orgnNatCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByPkg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pkg', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByPkgUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pkgUnitCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prc');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByProductName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qty');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByQtyUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qtyUnitCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByRegrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regrId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByRegrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regrNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retailPrice');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByRsdQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rsdQty');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctBySku(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sku', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'splyAmt');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctBySupplyPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supplyPrice');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'table', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByTaxName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxPercentage');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByTaxTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxTyCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tin');
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByUnit(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unit', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByUseYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useYn', caseSensitive: caseSensitive);
    });
  }
}

extension VariantQueryProperty
    on QueryBuilder<Variant, Variant, QQueryProperty> {
  QueryBuilder<Variant, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> addInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addInfo');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> bcdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bcd');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bhfId');
    });
  }

  QueryBuilder<Variant, int, QQueryOperations> branchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'branchId');
    });
  }

  QueryBuilder<Variant, double?, QQueryOperations> dftPrcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dftPrc');
    });
  }

  QueryBuilder<Variant, bool, QQueryOperations> isTaxExemptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTaxExempted');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> isrcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrcAmt');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> isrcAplcbYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrcAplcbYn');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> isrcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrcRt');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> isrccCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrccCd');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> isrccNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrccNm');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemCd');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemClsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemClsCd');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemNm');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemSeqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemSeq');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemStdNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemStdNm');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemTyCd');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modrId');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modrNm');
    });
  }

  QueryBuilder<Variant, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> orgnNatCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orgnNatCd');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> pkgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pkg');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> pkgUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pkgUnitCd');
    });
  }

  QueryBuilder<Variant, double?, QQueryOperations> prcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prc');
    });
  }

  QueryBuilder<Variant, int, QQueryOperations> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<Variant, String, QQueryOperations> productNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productName');
    });
  }

  QueryBuilder<Variant, double?, QQueryOperations> qtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qty');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> qtyUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qtyUnitCd');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regrId');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> regrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regrNm');
    });
  }

  QueryBuilder<Variant, double, QQueryOperations> retailPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retailPrice');
    });
  }

  QueryBuilder<Variant, double?, QQueryOperations> rsdQtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rsdQty');
    });
  }

  QueryBuilder<Variant, String, QQueryOperations> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sku');
    });
  }

  QueryBuilder<Variant, double?, QQueryOperations> splyAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'splyAmt');
    });
  }

  QueryBuilder<Variant, double, QQueryOperations> supplyPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supplyPrice');
    });
  }

  QueryBuilder<Variant, String, QQueryOperations> tableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'table');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> taxNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxName');
    });
  }

  QueryBuilder<Variant, double?, QQueryOperations> taxPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxPercentage');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> taxTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxTyCd');
    });
  }

  QueryBuilder<Variant, int?, QQueryOperations> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tin');
    });
  }

  QueryBuilder<Variant, String, QQueryOperations> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unit');
    });
  }

  QueryBuilder<Variant, String?, QQueryOperations> useYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useYn');
    });
  }
}
