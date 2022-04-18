// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetVariantCollection on Isar {
  IsarCollection<Variant> get variants {
    return getCollection('Variant');
  }
}

final VariantSchema = CollectionSchema(
  name: 'Variant',
  schema:
      '{"name":"Variant","idName":"id","properties":[{"name":"bcd","type":"String"},{"name":"branchId","type":"Long"},{"name":"channels","type":"StringList"},{"name":"isrcAmt","type":"String"},{"name":"isrcRt","type":"String"},{"name":"isrccCd","type":"String"},{"name":"isrccNm","type":"String"},{"name":"itemCd","type":"String"},{"name":"itemClsCd","type":"String"},{"name":"itemNm","type":"String"},{"name":"itemSeq","type":"String"},{"name":"itemStdNm","type":"String"},{"name":"itemTyCd","type":"String"},{"name":"migrated","type":"Bool"},{"name":"name","type":"String"},{"name":"orgnNatCd","type":"String"},{"name":"pkg","type":"String"},{"name":"pkgUnitCd","type":"String"},{"name":"prc","type":"Double"},{"name":"productId","type":"Long"},{"name":"productName","type":"String"},{"name":"qty","type":"Double"},{"name":"qtyUnitCd","type":"String"},{"name":"retailPrice","type":"Double"},{"name":"sku","type":"String"},{"name":"splyAmt","type":"Double"},{"name":"supplyPrice","type":"Double"},{"name":"synced","type":"Bool"},{"name":"table","type":"String"},{"name":"taxName","type":"String"},{"name":"taxPercentage","type":"Double"},{"name":"taxTyCd","type":"String"},{"name":"unit","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _VariantNativeAdapter(),
  webAdapter: const _VariantWebAdapter(),
  idName: 'id',
  propertyIds: {
    'bcd': 0,
    'branchId': 1,
    'channels': 2,
    'isrcAmt': 3,
    'isrcRt': 4,
    'isrccCd': 5,
    'isrccNm': 6,
    'itemCd': 7,
    'itemClsCd': 8,
    'itemNm': 9,
    'itemSeq': 10,
    'itemStdNm': 11,
    'itemTyCd': 12,
    'migrated': 13,
    'name': 14,
    'orgnNatCd': 15,
    'pkg': 16,
    'pkgUnitCd': 17,
    'prc': 18,
    'productId': 19,
    'productName': 20,
    'qty': 21,
    'qtyUnitCd': 22,
    'retailPrice': 23,
    'sku': 24,
    'splyAmt': 25,
    'supplyPrice': 26,
    'synced': 27,
    'table': 28,
    'taxName': 29,
    'taxPercentage': 30,
    'taxTyCd': 31,
    'unit': 32
  },
  listProperties: {'channels'},
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) {
    if (obj.id == Isar.autoIncrement) {
      return null;
    } else {
      return obj.id;
    }
  },
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 2,
);

class _VariantWebAdapter extends IsarWebTypeAdapter<Variant> {
  const _VariantWebAdapter();

  @override
  Object serialize(IsarCollection<Variant> collection, Variant object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'bcd', object.bcd);
    IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
    IsarNative.jsObjectSet(jsObj, 'channels', object.channels);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'isrcAmt', object.isrcAmt);
    IsarNative.jsObjectSet(jsObj, 'isrcRt', object.isrcRt);
    IsarNative.jsObjectSet(jsObj, 'isrccCd', object.isrccCd);
    IsarNative.jsObjectSet(jsObj, 'isrccNm', object.isrccNm);
    IsarNative.jsObjectSet(jsObj, 'itemCd', object.itemCd);
    IsarNative.jsObjectSet(jsObj, 'itemClsCd', object.itemClsCd);
    IsarNative.jsObjectSet(jsObj, 'itemNm', object.itemNm);
    IsarNative.jsObjectSet(jsObj, 'itemSeq', object.itemSeq);
    IsarNative.jsObjectSet(jsObj, 'itemStdNm', object.itemStdNm);
    IsarNative.jsObjectSet(jsObj, 'itemTyCd', object.itemTyCd);
    IsarNative.jsObjectSet(jsObj, 'migrated', object.migrated);
    IsarNative.jsObjectSet(jsObj, 'name', object.name);
    IsarNative.jsObjectSet(jsObj, 'orgnNatCd', object.orgnNatCd);
    IsarNative.jsObjectSet(jsObj, 'pkg', object.pkg);
    IsarNative.jsObjectSet(jsObj, 'pkgUnitCd', object.pkgUnitCd);
    IsarNative.jsObjectSet(jsObj, 'prc', object.prc);
    IsarNative.jsObjectSet(jsObj, 'productId', object.productId);
    IsarNative.jsObjectSet(jsObj, 'productName', object.productName);
    IsarNative.jsObjectSet(jsObj, 'qty', object.qty);
    IsarNative.jsObjectSet(jsObj, 'qtyUnitCd', object.qtyUnitCd);
    IsarNative.jsObjectSet(jsObj, 'retailPrice', object.retailPrice);
    IsarNative.jsObjectSet(jsObj, 'sku', object.sku);
    IsarNative.jsObjectSet(jsObj, 'splyAmt', object.splyAmt);
    IsarNative.jsObjectSet(jsObj, 'supplyPrice', object.supplyPrice);
    IsarNative.jsObjectSet(jsObj, 'synced', object.synced);
    IsarNative.jsObjectSet(jsObj, 'table', object.table);
    IsarNative.jsObjectSet(jsObj, 'taxName', object.taxName);
    IsarNative.jsObjectSet(jsObj, 'taxPercentage', object.taxPercentage);
    IsarNative.jsObjectSet(jsObj, 'taxTyCd', object.taxTyCd);
    IsarNative.jsObjectSet(jsObj, 'unit', object.unit);
    return jsObj;
  }

  @override
  Variant deserialize(IsarCollection<Variant> collection, dynamic jsObj) {
    final object = Variant();
    object.bcd = IsarNative.jsObjectGet(jsObj, 'bcd');
    object.branchId =
        IsarNative.jsObjectGet(jsObj, 'branchId') ?? double.negativeInfinity;
    object.channels = (IsarNative.jsObjectGet(jsObj, 'channels') as List?)
        ?.map((e) => e ?? '')
        .toList()
        .cast<String>();
    object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
    object.isrcAmt = IsarNative.jsObjectGet(jsObj, 'isrcAmt');
    object.isrcRt = IsarNative.jsObjectGet(jsObj, 'isrcRt');
    object.isrccCd = IsarNative.jsObjectGet(jsObj, 'isrccCd');
    object.isrccNm = IsarNative.jsObjectGet(jsObj, 'isrccNm');
    object.itemCd = IsarNative.jsObjectGet(jsObj, 'itemCd');
    object.itemClsCd = IsarNative.jsObjectGet(jsObj, 'itemClsCd');
    object.itemNm = IsarNative.jsObjectGet(jsObj, 'itemNm');
    object.itemSeq = IsarNative.jsObjectGet(jsObj, 'itemSeq');
    object.itemStdNm = IsarNative.jsObjectGet(jsObj, 'itemStdNm');
    object.itemTyCd = IsarNative.jsObjectGet(jsObj, 'itemTyCd');
    object.migrated = IsarNative.jsObjectGet(jsObj, 'migrated');
    object.name = IsarNative.jsObjectGet(jsObj, 'name') ?? '';
    object.orgnNatCd = IsarNative.jsObjectGet(jsObj, 'orgnNatCd');
    object.pkg = IsarNative.jsObjectGet(jsObj, 'pkg');
    object.pkgUnitCd = IsarNative.jsObjectGet(jsObj, 'pkgUnitCd');
    object.prc = IsarNative.jsObjectGet(jsObj, 'prc');
    object.productId =
        IsarNative.jsObjectGet(jsObj, 'productId') ?? double.negativeInfinity;
    object.productName = IsarNative.jsObjectGet(jsObj, 'productName') ?? '';
    object.qty = IsarNative.jsObjectGet(jsObj, 'qty');
    object.qtyUnitCd = IsarNative.jsObjectGet(jsObj, 'qtyUnitCd');
    object.retailPrice =
        IsarNative.jsObjectGet(jsObj, 'retailPrice') ?? double.negativeInfinity;
    object.sku = IsarNative.jsObjectGet(jsObj, 'sku') ?? '';
    object.splyAmt = IsarNative.jsObjectGet(jsObj, 'splyAmt');
    object.supplyPrice =
        IsarNative.jsObjectGet(jsObj, 'supplyPrice') ?? double.negativeInfinity;
    object.synced = IsarNative.jsObjectGet(jsObj, 'synced');
    object.table = IsarNative.jsObjectGet(jsObj, 'table') ?? '';
    object.taxName = IsarNative.jsObjectGet(jsObj, 'taxName');
    object.taxPercentage = IsarNative.jsObjectGet(jsObj, 'taxPercentage');
    object.taxTyCd = IsarNative.jsObjectGet(jsObj, 'taxTyCd');
    object.unit = IsarNative.jsObjectGet(jsObj, 'unit') ?? '';
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'bcd':
        return (IsarNative.jsObjectGet(jsObj, 'bcd')) as P;
      case 'branchId':
        return (IsarNative.jsObjectGet(jsObj, 'branchId') ??
            double.negativeInfinity) as P;
      case 'channels':
        return ((IsarNative.jsObjectGet(jsObj, 'channels') as List?)
            ?.map((e) => e ?? '')
            .toList()
            .cast<String>()) as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'isrcAmt':
        return (IsarNative.jsObjectGet(jsObj, 'isrcAmt')) as P;
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
      case 'migrated':
        return (IsarNative.jsObjectGet(jsObj, 'migrated')) as P;
      case 'name':
        return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
      case 'orgnNatCd':
        return (IsarNative.jsObjectGet(jsObj, 'orgnNatCd')) as P;
      case 'pkg':
        return (IsarNative.jsObjectGet(jsObj, 'pkg')) as P;
      case 'pkgUnitCd':
        return (IsarNative.jsObjectGet(jsObj, 'pkgUnitCd')) as P;
      case 'prc':
        return (IsarNative.jsObjectGet(jsObj, 'prc')) as P;
      case 'productId':
        return (IsarNative.jsObjectGet(jsObj, 'productId') ??
            double.negativeInfinity) as P;
      case 'productName':
        return (IsarNative.jsObjectGet(jsObj, 'productName') ?? '') as P;
      case 'qty':
        return (IsarNative.jsObjectGet(jsObj, 'qty')) as P;
      case 'qtyUnitCd':
        return (IsarNative.jsObjectGet(jsObj, 'qtyUnitCd')) as P;
      case 'retailPrice':
        return (IsarNative.jsObjectGet(jsObj, 'retailPrice') ??
            double.negativeInfinity) as P;
      case 'sku':
        return (IsarNative.jsObjectGet(jsObj, 'sku') ?? '') as P;
      case 'splyAmt':
        return (IsarNative.jsObjectGet(jsObj, 'splyAmt')) as P;
      case 'supplyPrice':
        return (IsarNative.jsObjectGet(jsObj, 'supplyPrice') ??
            double.negativeInfinity) as P;
      case 'synced':
        return (IsarNative.jsObjectGet(jsObj, 'synced')) as P;
      case 'table':
        return (IsarNative.jsObjectGet(jsObj, 'table') ?? '') as P;
      case 'taxName':
        return (IsarNative.jsObjectGet(jsObj, 'taxName')) as P;
      case 'taxPercentage':
        return (IsarNative.jsObjectGet(jsObj, 'taxPercentage')) as P;
      case 'taxTyCd':
        return (IsarNative.jsObjectGet(jsObj, 'taxTyCd')) as P;
      case 'unit':
        return (IsarNative.jsObjectGet(jsObj, 'unit') ?? '') as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Variant object) {}
}

class _VariantNativeAdapter extends IsarNativeTypeAdapter<Variant> {
  const _VariantNativeAdapter();

  @override
  void serialize(IsarCollection<Variant> collection, IsarRawObject rawObj,
      Variant object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.bcd;
    IsarUint8List? _bcd;
    if (value0 != null) {
      _bcd = IsarBinaryWriter.utf8Encoder.convert(value0);
    }
    dynamicSize += (_bcd?.length ?? 0) as int;
    final value1 = object.branchId;
    final _branchId = value1;
    final value2 = object.channels;
    dynamicSize += (value2?.length ?? 0) * 8;
    List<IsarUint8List?>? bytesList2;
    if (value2 != null) {
      bytesList2 = [];
      for (var str in value2) {
        final bytes = IsarBinaryWriter.utf8Encoder.convert(str);
        bytesList2.add(bytes);
        dynamicSize += bytes.length as int;
      }
    }
    final _channels = bytesList2;
    final value3 = object.isrcAmt;
    IsarUint8List? _isrcAmt;
    if (value3 != null) {
      _isrcAmt = IsarBinaryWriter.utf8Encoder.convert(value3);
    }
    dynamicSize += (_isrcAmt?.length ?? 0) as int;
    final value4 = object.isrcRt;
    IsarUint8List? _isrcRt;
    if (value4 != null) {
      _isrcRt = IsarBinaryWriter.utf8Encoder.convert(value4);
    }
    dynamicSize += (_isrcRt?.length ?? 0) as int;
    final value5 = object.isrccCd;
    IsarUint8List? _isrccCd;
    if (value5 != null) {
      _isrccCd = IsarBinaryWriter.utf8Encoder.convert(value5);
    }
    dynamicSize += (_isrccCd?.length ?? 0) as int;
    final value6 = object.isrccNm;
    IsarUint8List? _isrccNm;
    if (value6 != null) {
      _isrccNm = IsarBinaryWriter.utf8Encoder.convert(value6);
    }
    dynamicSize += (_isrccNm?.length ?? 0) as int;
    final value7 = object.itemCd;
    IsarUint8List? _itemCd;
    if (value7 != null) {
      _itemCd = IsarBinaryWriter.utf8Encoder.convert(value7);
    }
    dynamicSize += (_itemCd?.length ?? 0) as int;
    final value8 = object.itemClsCd;
    IsarUint8List? _itemClsCd;
    if (value8 != null) {
      _itemClsCd = IsarBinaryWriter.utf8Encoder.convert(value8);
    }
    dynamicSize += (_itemClsCd?.length ?? 0) as int;
    final value9 = object.itemNm;
    IsarUint8List? _itemNm;
    if (value9 != null) {
      _itemNm = IsarBinaryWriter.utf8Encoder.convert(value9);
    }
    dynamicSize += (_itemNm?.length ?? 0) as int;
    final value10 = object.itemSeq;
    IsarUint8List? _itemSeq;
    if (value10 != null) {
      _itemSeq = IsarBinaryWriter.utf8Encoder.convert(value10);
    }
    dynamicSize += (_itemSeq?.length ?? 0) as int;
    final value11 = object.itemStdNm;
    IsarUint8List? _itemStdNm;
    if (value11 != null) {
      _itemStdNm = IsarBinaryWriter.utf8Encoder.convert(value11);
    }
    dynamicSize += (_itemStdNm?.length ?? 0) as int;
    final value12 = object.itemTyCd;
    IsarUint8List? _itemTyCd;
    if (value12 != null) {
      _itemTyCd = IsarBinaryWriter.utf8Encoder.convert(value12);
    }
    dynamicSize += (_itemTyCd?.length ?? 0) as int;
    final value13 = object.migrated;
    final _migrated = value13;
    final value14 = object.name;
    final _name = IsarBinaryWriter.utf8Encoder.convert(value14);
    dynamicSize += (_name.length) as int;
    final value15 = object.orgnNatCd;
    IsarUint8List? _orgnNatCd;
    if (value15 != null) {
      _orgnNatCd = IsarBinaryWriter.utf8Encoder.convert(value15);
    }
    dynamicSize += (_orgnNatCd?.length ?? 0) as int;
    final value16 = object.pkg;
    IsarUint8List? _pkg;
    if (value16 != null) {
      _pkg = IsarBinaryWriter.utf8Encoder.convert(value16);
    }
    dynamicSize += (_pkg?.length ?? 0) as int;
    final value17 = object.pkgUnitCd;
    IsarUint8List? _pkgUnitCd;
    if (value17 != null) {
      _pkgUnitCd = IsarBinaryWriter.utf8Encoder.convert(value17);
    }
    dynamicSize += (_pkgUnitCd?.length ?? 0) as int;
    final value18 = object.prc;
    final _prc = value18;
    final value19 = object.productId;
    final _productId = value19;
    final value20 = object.productName;
    final _productName = IsarBinaryWriter.utf8Encoder.convert(value20);
    dynamicSize += (_productName.length) as int;
    final value21 = object.qty;
    final _qty = value21;
    final value22 = object.qtyUnitCd;
    IsarUint8List? _qtyUnitCd;
    if (value22 != null) {
      _qtyUnitCd = IsarBinaryWriter.utf8Encoder.convert(value22);
    }
    dynamicSize += (_qtyUnitCd?.length ?? 0) as int;
    final value23 = object.retailPrice;
    final _retailPrice = value23;
    final value24 = object.sku;
    final _sku = IsarBinaryWriter.utf8Encoder.convert(value24);
    dynamicSize += (_sku.length) as int;
    final value25 = object.splyAmt;
    final _splyAmt = value25;
    final value26 = object.supplyPrice;
    final _supplyPrice = value26;
    final value27 = object.synced;
    final _synced = value27;
    final value28 = object.table;
    final _table = IsarBinaryWriter.utf8Encoder.convert(value28);
    dynamicSize += (_table.length) as int;
    final value29 = object.taxName;
    IsarUint8List? _taxName;
    if (value29 != null) {
      _taxName = IsarBinaryWriter.utf8Encoder.convert(value29);
    }
    dynamicSize += (_taxName?.length ?? 0) as int;
    final value30 = object.taxPercentage;
    final _taxPercentage = value30;
    final value31 = object.taxTyCd;
    IsarUint8List? _taxTyCd;
    if (value31 != null) {
      _taxTyCd = IsarBinaryWriter.utf8Encoder.convert(value31);
    }
    dynamicSize += (_taxTyCd?.length ?? 0) as int;
    final value32 = object.unit;
    final _unit = IsarBinaryWriter.utf8Encoder.convert(value32);
    dynamicSize += (_unit.length) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBytes(offsets[0], _bcd);
    writer.writeLong(offsets[1], _branchId);
    writer.writeStringList(offsets[2], _channels);
    writer.writeBytes(offsets[3], _isrcAmt);
    writer.writeBytes(offsets[4], _isrcRt);
    writer.writeBytes(offsets[5], _isrccCd);
    writer.writeBytes(offsets[6], _isrccNm);
    writer.writeBytes(offsets[7], _itemCd);
    writer.writeBytes(offsets[8], _itemClsCd);
    writer.writeBytes(offsets[9], _itemNm);
    writer.writeBytes(offsets[10], _itemSeq);
    writer.writeBytes(offsets[11], _itemStdNm);
    writer.writeBytes(offsets[12], _itemTyCd);
    writer.writeBool(offsets[13], _migrated);
    writer.writeBytes(offsets[14], _name);
    writer.writeBytes(offsets[15], _orgnNatCd);
    writer.writeBytes(offsets[16], _pkg);
    writer.writeBytes(offsets[17], _pkgUnitCd);
    writer.writeDouble(offsets[18], _prc);
    writer.writeLong(offsets[19], _productId);
    writer.writeBytes(offsets[20], _productName);
    writer.writeDouble(offsets[21], _qty);
    writer.writeBytes(offsets[22], _qtyUnitCd);
    writer.writeDouble(offsets[23], _retailPrice);
    writer.writeBytes(offsets[24], _sku);
    writer.writeDouble(offsets[25], _splyAmt);
    writer.writeDouble(offsets[26], _supplyPrice);
    writer.writeBool(offsets[27], _synced);
    writer.writeBytes(offsets[28], _table);
    writer.writeBytes(offsets[29], _taxName);
    writer.writeDouble(offsets[30], _taxPercentage);
    writer.writeBytes(offsets[31], _taxTyCd);
    writer.writeBytes(offsets[32], _unit);
  }

  @override
  Variant deserialize(IsarCollection<Variant> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = Variant();
    object.bcd = reader.readStringOrNull(offsets[0]);
    object.branchId = reader.readLong(offsets[1]);
    object.channels = reader.readStringList(offsets[2]);
    object.id = id;
    object.isrcAmt = reader.readStringOrNull(offsets[3]);
    object.isrcRt = reader.readStringOrNull(offsets[4]);
    object.isrccCd = reader.readStringOrNull(offsets[5]);
    object.isrccNm = reader.readStringOrNull(offsets[6]);
    object.itemCd = reader.readStringOrNull(offsets[7]);
    object.itemClsCd = reader.readStringOrNull(offsets[8]);
    object.itemNm = reader.readStringOrNull(offsets[9]);
    object.itemSeq = reader.readStringOrNull(offsets[10]);
    object.itemStdNm = reader.readStringOrNull(offsets[11]);
    object.itemTyCd = reader.readStringOrNull(offsets[12]);
    object.migrated = reader.readBoolOrNull(offsets[13]);
    object.name = reader.readString(offsets[14]);
    object.orgnNatCd = reader.readStringOrNull(offsets[15]);
    object.pkg = reader.readStringOrNull(offsets[16]);
    object.pkgUnitCd = reader.readStringOrNull(offsets[17]);
    object.prc = reader.readDoubleOrNull(offsets[18]);
    object.productId = reader.readLong(offsets[19]);
    object.productName = reader.readString(offsets[20]);
    object.qty = reader.readDoubleOrNull(offsets[21]);
    object.qtyUnitCd = reader.readStringOrNull(offsets[22]);
    object.retailPrice = reader.readDouble(offsets[23]);
    object.sku = reader.readString(offsets[24]);
    object.splyAmt = reader.readDoubleOrNull(offsets[25]);
    object.supplyPrice = reader.readDouble(offsets[26]);
    object.synced = reader.readBoolOrNull(offsets[27]);
    object.table = reader.readString(offsets[28]);
    object.taxName = reader.readStringOrNull(offsets[29]);
    object.taxPercentage = reader.readDoubleOrNull(offsets[30]);
    object.taxTyCd = reader.readStringOrNull(offsets[31]);
    object.unit = reader.readString(offsets[32]);
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readStringOrNull(offset)) as P;
      case 1:
        return (reader.readLong(offset)) as P;
      case 2:
        return (reader.readStringList(offset)) as P;
      case 3:
        return (reader.readStringOrNull(offset)) as P;
      case 4:
        return (reader.readStringOrNull(offset)) as P;
      case 5:
        return (reader.readStringOrNull(offset)) as P;
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
        return (reader.readBoolOrNull(offset)) as P;
      case 14:
        return (reader.readString(offset)) as P;
      case 15:
        return (reader.readStringOrNull(offset)) as P;
      case 16:
        return (reader.readStringOrNull(offset)) as P;
      case 17:
        return (reader.readStringOrNull(offset)) as P;
      case 18:
        return (reader.readDoubleOrNull(offset)) as P;
      case 19:
        return (reader.readLong(offset)) as P;
      case 20:
        return (reader.readString(offset)) as P;
      case 21:
        return (reader.readDoubleOrNull(offset)) as P;
      case 22:
        return (reader.readStringOrNull(offset)) as P;
      case 23:
        return (reader.readDouble(offset)) as P;
      case 24:
        return (reader.readString(offset)) as P;
      case 25:
        return (reader.readDoubleOrNull(offset)) as P;
      case 26:
        return (reader.readDouble(offset)) as P;
      case 27:
        return (reader.readBoolOrNull(offset)) as P;
      case 28:
        return (reader.readString(offset)) as P;
      case 29:
        return (reader.readStringOrNull(offset)) as P;
      case 30:
        return (reader.readDoubleOrNull(offset)) as P;
      case 31:
        return (reader.readStringOrNull(offset)) as P;
      case 32:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Variant object) {}
}

extension VariantQueryWhereSort on QueryBuilder<Variant, Variant, QWhere> {
  QueryBuilder<Variant, Variant, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension VariantQueryWhere on QueryBuilder<Variant, Variant, QWhereClause> {
  QueryBuilder<Variant, Variant, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension VariantQueryFilter
    on QueryBuilder<Variant, Variant, QFilterCondition> {
  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'bcd',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'bcd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'bcd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'branchId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> channelsIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> channelsAnyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> channelsAnyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> channelsAnyGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> channelsAnyLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> channelsAnyBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'channels',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> channelsAnyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> channelsAnyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> channelsAnyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> channelsAnyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'channels',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isrcAmt',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'isrcAmt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'isrcAmt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isrcRt',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'isrcRt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'isrcRt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isrccCd',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'isrccCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'isrccCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isrccNm',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'isrccNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'isrccNm',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemCd',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemClsCd',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemClsCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemClsCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemNm',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemNm',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemSeq',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemSeq',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemSeq',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemStdNm',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemStdNm',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemStdNm',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'itemTyCd',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemTyCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> migratedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'migrated',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> migratedEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'migrated',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'orgnNatCd',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'orgnNatCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'orgnNatCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'pkg',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'pkg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'pkg',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'pkgUnitCd',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'pkgUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'pkgUnitCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'prc',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'prc',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'prc',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'prc',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'productId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'productName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'productName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'qty',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'qty',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'qty',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'qty',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'qtyUnitCd',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'qtyUnitCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'qtyUnitCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> retailPriceGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'retailPrice',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> retailPriceLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'retailPrice',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> retailPriceBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'retailPrice',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'sku',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'sku',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'splyAmt',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'splyAmt',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'splyAmt',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'splyAmt',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> supplyPriceGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'supplyPrice',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> supplyPriceLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'supplyPrice',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> supplyPriceBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'supplyPrice',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> syncedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'synced',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> syncedEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'synced',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'table',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tableMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'table',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'taxName',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'taxName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'taxName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxPercentageIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'taxPercentage',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      taxPercentageGreaterThan(double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'taxPercentage',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxPercentageLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'taxPercentage',
      value: value,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxPercentageBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'taxPercentage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'taxTyCd',
      value: null,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdEqualTo(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdGreaterThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdLessThan(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdBetween(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdStartsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdEndsWith(
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

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'taxTyCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'taxTyCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'unit',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'unit',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension VariantQueryWhereSortBy on QueryBuilder<Variant, Variant, QSortBy> {
  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBcd() {
    return addSortByInternal('bcd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBcdDesc() {
    return addSortByInternal('bcd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcAmt() {
    return addSortByInternal('isrcAmt', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcAmtDesc() {
    return addSortByInternal('isrcAmt', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcRt() {
    return addSortByInternal('isrcRt', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcRtDesc() {
    return addSortByInternal('isrcRt', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccCd() {
    return addSortByInternal('isrccCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccCdDesc() {
    return addSortByInternal('isrccCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccNm() {
    return addSortByInternal('isrccNm', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccNmDesc() {
    return addSortByInternal('isrccNm', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemCd() {
    return addSortByInternal('itemCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemCdDesc() {
    return addSortByInternal('itemCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemClsCd() {
    return addSortByInternal('itemClsCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemClsCdDesc() {
    return addSortByInternal('itemClsCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemNm() {
    return addSortByInternal('itemNm', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemNmDesc() {
    return addSortByInternal('itemNm', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemSeq() {
    return addSortByInternal('itemSeq', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemSeqDesc() {
    return addSortByInternal('itemSeq', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemStdNm() {
    return addSortByInternal('itemStdNm', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemStdNmDesc() {
    return addSortByInternal('itemStdNm', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemTyCd() {
    return addSortByInternal('itemTyCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemTyCdDesc() {
    return addSortByInternal('itemTyCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByMigrated() {
    return addSortByInternal('migrated', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByMigratedDesc() {
    return addSortByInternal('migrated', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByOrgnNatCd() {
    return addSortByInternal('orgnNatCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByOrgnNatCdDesc() {
    return addSortByInternal('orgnNatCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkg() {
    return addSortByInternal('pkg', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkgDesc() {
    return addSortByInternal('pkg', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkgUnitCd() {
    return addSortByInternal('pkgUnitCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkgUnitCdDesc() {
    return addSortByInternal('pkgUnitCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPrc() {
    return addSortByInternal('prc', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPrcDesc() {
    return addSortByInternal('prc', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductId() {
    return addSortByInternal('productId', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductIdDesc() {
    return addSortByInternal('productId', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductName() {
    return addSortByInternal('productName', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductNameDesc() {
    return addSortByInternal('productName', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQty() {
    return addSortByInternal('qty', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQtyDesc() {
    return addSortByInternal('qty', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQtyUnitCd() {
    return addSortByInternal('qtyUnitCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQtyUnitCdDesc() {
    return addSortByInternal('qtyUnitCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRetailPrice() {
    return addSortByInternal('retailPrice', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRetailPriceDesc() {
    return addSortByInternal('retailPrice', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySku() {
    return addSortByInternal('sku', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySkuDesc() {
    return addSortByInternal('sku', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySplyAmt() {
    return addSortByInternal('splyAmt', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySplyAmtDesc() {
    return addSortByInternal('splyAmt', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySupplyPrice() {
    return addSortByInternal('supplyPrice', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySupplyPriceDesc() {
    return addSortByInternal('supplyPrice', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySynced() {
    return addSortByInternal('synced', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySyncedDesc() {
    return addSortByInternal('synced', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxName() {
    return addSortByInternal('taxName', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxNameDesc() {
    return addSortByInternal('taxName', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxPercentage() {
    return addSortByInternal('taxPercentage', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxPercentageDesc() {
    return addSortByInternal('taxPercentage', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxTyCd() {
    return addSortByInternal('taxTyCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxTyCdDesc() {
    return addSortByInternal('taxTyCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByUnit() {
    return addSortByInternal('unit', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByUnitDesc() {
    return addSortByInternal('unit', Sort.desc);
  }
}

extension VariantQueryWhereSortThenBy
    on QueryBuilder<Variant, Variant, QSortThenBy> {
  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBcd() {
    return addSortByInternal('bcd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBcdDesc() {
    return addSortByInternal('bcd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcAmt() {
    return addSortByInternal('isrcAmt', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcAmtDesc() {
    return addSortByInternal('isrcAmt', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcRt() {
    return addSortByInternal('isrcRt', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcRtDesc() {
    return addSortByInternal('isrcRt', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccCd() {
    return addSortByInternal('isrccCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccCdDesc() {
    return addSortByInternal('isrccCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccNm() {
    return addSortByInternal('isrccNm', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccNmDesc() {
    return addSortByInternal('isrccNm', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemCd() {
    return addSortByInternal('itemCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemCdDesc() {
    return addSortByInternal('itemCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemClsCd() {
    return addSortByInternal('itemClsCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemClsCdDesc() {
    return addSortByInternal('itemClsCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemNm() {
    return addSortByInternal('itemNm', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemNmDesc() {
    return addSortByInternal('itemNm', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemSeq() {
    return addSortByInternal('itemSeq', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemSeqDesc() {
    return addSortByInternal('itemSeq', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemStdNm() {
    return addSortByInternal('itemStdNm', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemStdNmDesc() {
    return addSortByInternal('itemStdNm', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemTyCd() {
    return addSortByInternal('itemTyCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemTyCdDesc() {
    return addSortByInternal('itemTyCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByMigrated() {
    return addSortByInternal('migrated', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByMigratedDesc() {
    return addSortByInternal('migrated', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByOrgnNatCd() {
    return addSortByInternal('orgnNatCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByOrgnNatCdDesc() {
    return addSortByInternal('orgnNatCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkg() {
    return addSortByInternal('pkg', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkgDesc() {
    return addSortByInternal('pkg', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkgUnitCd() {
    return addSortByInternal('pkgUnitCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkgUnitCdDesc() {
    return addSortByInternal('pkgUnitCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPrc() {
    return addSortByInternal('prc', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPrcDesc() {
    return addSortByInternal('prc', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductId() {
    return addSortByInternal('productId', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductIdDesc() {
    return addSortByInternal('productId', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductName() {
    return addSortByInternal('productName', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductNameDesc() {
    return addSortByInternal('productName', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQty() {
    return addSortByInternal('qty', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQtyDesc() {
    return addSortByInternal('qty', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQtyUnitCd() {
    return addSortByInternal('qtyUnitCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQtyUnitCdDesc() {
    return addSortByInternal('qtyUnitCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRetailPrice() {
    return addSortByInternal('retailPrice', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRetailPriceDesc() {
    return addSortByInternal('retailPrice', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySku() {
    return addSortByInternal('sku', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySkuDesc() {
    return addSortByInternal('sku', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySplyAmt() {
    return addSortByInternal('splyAmt', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySplyAmtDesc() {
    return addSortByInternal('splyAmt', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySupplyPrice() {
    return addSortByInternal('supplyPrice', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySupplyPriceDesc() {
    return addSortByInternal('supplyPrice', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySynced() {
    return addSortByInternal('synced', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySyncedDesc() {
    return addSortByInternal('synced', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxName() {
    return addSortByInternal('taxName', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxNameDesc() {
    return addSortByInternal('taxName', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxPercentage() {
    return addSortByInternal('taxPercentage', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxPercentageDesc() {
    return addSortByInternal('taxPercentage', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxTyCd() {
    return addSortByInternal('taxTyCd', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxTyCdDesc() {
    return addSortByInternal('taxTyCd', Sort.desc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByUnit() {
    return addSortByInternal('unit', Sort.asc);
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByUnitDesc() {
    return addSortByInternal('unit', Sort.desc);
  }
}

extension VariantQueryWhereDistinct
    on QueryBuilder<Variant, Variant, QDistinct> {
  QueryBuilder<Variant, Variant, QDistinct> distinctByBcd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('bcd', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByIsrcAmt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('isrcAmt', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByIsrcRt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('isrcRt', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByIsrccCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('isrccCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByIsrccNm(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('isrccNm', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemClsCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemClsCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemNm(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemNm', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemSeq(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemSeq', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemStdNm(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemStdNm', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByItemTyCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemTyCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByMigrated() {
    return addDistinctByInternal('migrated');
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByOrgnNatCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('orgnNatCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByPkg(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('pkg', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByPkgUnitCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('pkgUnitCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByPrc() {
    return addDistinctByInternal('prc');
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByProductId() {
    return addDistinctByInternal('productId');
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByProductName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('productName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByQty() {
    return addDistinctByInternal('qty');
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByQtyUnitCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('qtyUnitCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByRetailPrice() {
    return addDistinctByInternal('retailPrice');
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctBySku(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('sku', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctBySplyAmt() {
    return addDistinctByInternal('splyAmt');
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctBySupplyPrice() {
    return addDistinctByInternal('supplyPrice');
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctBySynced() {
    return addDistinctByInternal('synced');
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('table', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByTaxName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('taxName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByTaxPercentage() {
    return addDistinctByInternal('taxPercentage');
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByTaxTyCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('taxTyCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<Variant, Variant, QDistinct> distinctByUnit(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('unit', caseSensitive: caseSensitive);
  }
}

extension VariantQueryProperty
    on QueryBuilder<Variant, Variant, QQueryProperty> {
  QueryBuilder<Variant, String?, QQueryOperations> bcdProperty() {
    return addPropertyNameInternal('bcd');
  }

  QueryBuilder<Variant, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<Variant, List<String>?, QQueryOperations> channelsProperty() {
    return addPropertyNameInternal('channels');
  }

  QueryBuilder<Variant, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Variant, String?, QQueryOperations> isrcAmtProperty() {
    return addPropertyNameInternal('isrcAmt');
  }

  QueryBuilder<Variant, String?, QQueryOperations> isrcRtProperty() {
    return addPropertyNameInternal('isrcRt');
  }

  QueryBuilder<Variant, String?, QQueryOperations> isrccCdProperty() {
    return addPropertyNameInternal('isrccCd');
  }

  QueryBuilder<Variant, String?, QQueryOperations> isrccNmProperty() {
    return addPropertyNameInternal('isrccNm');
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemCdProperty() {
    return addPropertyNameInternal('itemCd');
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemClsCdProperty() {
    return addPropertyNameInternal('itemClsCd');
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemNmProperty() {
    return addPropertyNameInternal('itemNm');
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemSeqProperty() {
    return addPropertyNameInternal('itemSeq');
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemStdNmProperty() {
    return addPropertyNameInternal('itemStdNm');
  }

  QueryBuilder<Variant, String?, QQueryOperations> itemTyCdProperty() {
    return addPropertyNameInternal('itemTyCd');
  }

  QueryBuilder<Variant, bool?, QQueryOperations> migratedProperty() {
    return addPropertyNameInternal('migrated');
  }

  QueryBuilder<Variant, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Variant, String?, QQueryOperations> orgnNatCdProperty() {
    return addPropertyNameInternal('orgnNatCd');
  }

  QueryBuilder<Variant, String?, QQueryOperations> pkgProperty() {
    return addPropertyNameInternal('pkg');
  }

  QueryBuilder<Variant, String?, QQueryOperations> pkgUnitCdProperty() {
    return addPropertyNameInternal('pkgUnitCd');
  }

  QueryBuilder<Variant, double?, QQueryOperations> prcProperty() {
    return addPropertyNameInternal('prc');
  }

  QueryBuilder<Variant, int, QQueryOperations> productIdProperty() {
    return addPropertyNameInternal('productId');
  }

  QueryBuilder<Variant, String, QQueryOperations> productNameProperty() {
    return addPropertyNameInternal('productName');
  }

  QueryBuilder<Variant, double?, QQueryOperations> qtyProperty() {
    return addPropertyNameInternal('qty');
  }

  QueryBuilder<Variant, String?, QQueryOperations> qtyUnitCdProperty() {
    return addPropertyNameInternal('qtyUnitCd');
  }

  QueryBuilder<Variant, double, QQueryOperations> retailPriceProperty() {
    return addPropertyNameInternal('retailPrice');
  }

  QueryBuilder<Variant, String, QQueryOperations> skuProperty() {
    return addPropertyNameInternal('sku');
  }

  QueryBuilder<Variant, double?, QQueryOperations> splyAmtProperty() {
    return addPropertyNameInternal('splyAmt');
  }

  QueryBuilder<Variant, double, QQueryOperations> supplyPriceProperty() {
    return addPropertyNameInternal('supplyPrice');
  }

  QueryBuilder<Variant, bool?, QQueryOperations> syncedProperty() {
    return addPropertyNameInternal('synced');
  }

  QueryBuilder<Variant, String, QQueryOperations> tableProperty() {
    return addPropertyNameInternal('table');
  }

  QueryBuilder<Variant, String?, QQueryOperations> taxNameProperty() {
    return addPropertyNameInternal('taxName');
  }

  QueryBuilder<Variant, double?, QQueryOperations> taxPercentageProperty() {
    return addPropertyNameInternal('taxPercentage');
  }

  QueryBuilder<Variant, String?, QQueryOperations> taxTyCdProperty() {
    return addPropertyNameInternal('taxTyCd');
  }

  QueryBuilder<Variant, String, QQueryOperations> unitProperty() {
    return addPropertyNameInternal('unit');
  }
}
