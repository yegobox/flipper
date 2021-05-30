// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

import 'branch.dart';
import 'business.dart';
import 'category.dart';
import 'color.dart';
import 'order.dart';
import 'order_item.dart';
import 'product.dart';
import 'stock.dart';
import 'unit.dart';
import 'variant_stock.dart';
import 'variants.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 3310557683243588494),
      name: 'Branch',
      lastPropertyId: const IdUid(8, 275352735541790545),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7487346323712492714),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 875595489796053853),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 395652445881700975),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7408793322917332629),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2530374451006033954),
            name: 'fbusinessId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 1330108909128470886),
            name: 'longitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 2257634909222244006),
            name: 'latitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 275352735541790545),
            name: 'table',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 1869195467075032095),
      name: 'Business',
      lastPropertyId: const IdUid(16, 4594523583843622648),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8446112328803916753),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 2289182716969081116),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7702314073149928601),
            name: 'currency',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5141852856915658593),
            name: 'fcategoryId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 534711231654764527),
            name: 'latitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 2666941663607380737),
            name: 'longitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4984723590568398661),
            name: 'userId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 3478078010466444141),
            name: 'typeId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 3024313165984774780),
            name: 'timeZone',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 612794724499021812),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 839065655890345006),
            name: 'country',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 5123557141438405249),
            name: 'businessUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 8258637008133569039),
            name: 'hexColor',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 4686127134970533577),
            name: 'image',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 6091806076580760858),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 4594523583843622648),
            name: 'active',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 6338630762105848059),
      name: 'Category',
      lastPropertyId: const IdUid(6, 4480385582539414670),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7598335227886751075),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 6325884135153409874),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1996724526537126738),
            name: 'focused',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 3585947419564573944),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 9209627773055944587),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4480385582539414670),
            name: 'table',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(4, 2710541124100572269),
      name: 'OrderF',
      lastPropertyId: const IdUid(15, 882875848258672684),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1012904031622024822),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 2324212792532748961),
            name: 'reference',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7971035133496015376),
            name: 'orderNumber',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 9025751505844409922),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7313768056285889177),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3163921457990638371),
            name: 'orderType',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7046348534553276723),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 1139812585411000941),
            name: 'draft',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 4414608627921136498),
            name: 'subTotal',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 1378547006943743172),
            name: 'paymentType',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 2563613967435228074),
            name: 'cashReceived',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 1670462423892867608),
            name: 'customerChangeDue',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 3716531152213699181),
            name: 'createdAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 8181780965533833383),
            name: 'updatedAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 882875848258672684),
            name: 'table',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'orderItems', srcEntity: 'OrderItem', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(5, 3670290986751668141),
      name: 'OrderItem',
      lastPropertyId: const IdUid(7, 3663360959225867626),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 906765468118155880),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 2954778646586302744),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1365662211469701880),
            name: 'forderId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 3760380824808259173),
            name: 'fvariantId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5916706915711114304),
            name: 'count',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 697713908433594617),
            name: 'price',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 3663360959225867626),
            name: 'orderId',
            type: 11,
            flags: 520,
            indexId: const IdUid(1, 2975742069029725334),
            relationTarget: 'OrderF')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(6, 9090397440415118239),
      name: 'PColor',
      lastPropertyId: const IdUid(5, 1056267619821576016),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 3435339929967616277),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 4779185566070061531),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2266415134111390210),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2100576372454485054),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 1056267619821576016),
            name: 'active',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(7, 8396401621519426503),
      name: 'Product',
      lastPropertyId: const IdUid(18, 6640411826466366158),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 849860396239690843),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 8854004516741494252),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 910897831332759682),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 8278361803970227101),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2740350723828706317),
            name: 'ftaxId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7551448276122571479),
            name: 'hasPicture',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 2754270277569736073),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 4956909285479180941),
            name: 'color',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 4465088365201679679),
            name: 'fbusinessId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 4843797567420825431),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 9052904636489036947),
            name: 'fsupplierId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 7382765938502807160),
            name: 'fcategoryId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 2623123227683947102),
            name: 'createdAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 8670484384853043776),
            name: 'unit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 2100909907113604528),
            name: 'draft',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 398766507584669369),
            name: 'imageLocal',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 293854310869828919),
            name: 'currentUpdate',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 6640411826466366158),
            name: 'imageUrl',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'variations', srcEntity: 'Variant', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(8, 2903993051519029875),
      name: 'Stock',
      lastPropertyId: const IdUid(13, 4976896187804620058),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8469907107787078686),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 5342524438823787027),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 937433944852629117),
            name: 'fvariantId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1837629957673355511),
            name: 'lowStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7565249666321658162),
            name: 'currentStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 8999408261260348519),
            name: 'supplyPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 5318516261010202299),
            name: 'retailPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 6320931441775855210),
            name: 'canTrackingStock',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 523754181185549945),
            name: 'showLowStockAlert',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2580347958051713123),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 2257972739892225350),
            name: 'fproductId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 4594267754681295707),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 4976896187804620058),
            name: 'value',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(9, 4488171816142401074),
      name: 'Unit',
      lastPropertyId: const IdUid(6, 7553669539999483400),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5774279566945148922),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 5756575344864187965),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 173358259040662377),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7386938150291815505),
            name: 'value',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 1017241998133610977),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7553669539999483400),
            name: 'active',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(10, 5529312912060080648),
      name: 'Variant',
      lastPropertyId: const IdUid(11, 5370582406696692409),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5209305848477608585),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 3475916495144186427),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 4609076232812026948),
            name: 'sku',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2021078829669075483),
            name: 'fproductId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 4271242508898846190),
            name: 'unit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 1372757332265102331),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 1175447059269065664),
            name: 'productName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 371030549684754189),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 880613344402047913),
            name: 'taxName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 8308462653464878558),
            name: 'taxPercentage',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 5370582406696692409),
            name: 'productId',
            type: 11,
            flags: 520,
            indexId: const IdUid(2, 5469807090156265290),
            relationTarget: 'Product')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(11, 3857879636063781853),
      name: 'VariantStock',
      lastPropertyId: const IdUid(14, 4154898029735437731),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4889774909818394245),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 1641410721555949905),
            name: 'canTrackingStock',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 6424849498288256176),
            name: 'retailPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6535617468643361747),
            name: 'productName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7533777898893228321),
            name: 'variantName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 2161714891670830501),
            name: 'unit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 5622932025915465044),
            name: 'sku',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 2691879722417335798),
            name: 'fbranchId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 2585583037663273474),
            name: 'lowStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 3049809197470926369),
            name: 'currentStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 4629885019550148282),
            name: 'fvariantId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 1257182675753346228),
            name: 'taxName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 3788924691818107867),
            name: 'taxPercentage',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 4154898029735437731),
            name: 'value',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(11, 3857879636063781853),
      lastIndexId: const IdUid(2, 5469807090156265290),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Branch: EntityDefinition<Branch>(
        model: _entities[0],
        toOneRelations: (Branch object) => [],
        toManyRelations: (Branch object) => {},
        getId: (Branch object) => object.id,
        setId: (Branch object, int id) {
          object.id = id;
        },
        objectToFB: (Branch object, fb.Builder fbb) {
          final descriptionOffset = object.description == null
              ? null
              : fbb.writeString(object.description!);
          final nameOffset = fbb.writeString(object.name);
          final longitudeOffset = object.longitude == null
              ? null
              : fbb.writeString(object.longitude!);
          final latitudeOffset = object.latitude == null
              ? null
              : fbb.writeString(object.latitude!);
          final tableOffset = fbb.writeString(object.table);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addBool(1, object.active);
          fbb.addOffset(2, descriptionOffset);
          fbb.addOffset(3, nameOffset);
          fbb.addInt64(4, object.fbusinessId);
          fbb.addOffset(5, longitudeOffset);
          fbb.addOffset(6, latitudeOffset);
          fbb.addOffset(7, tableOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Branch(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              active: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              description: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              fbusinessId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              longitude: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 14),
              latitude: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              table: const fb.StringReader()
                  .vTableGet(buffer, rootOffset, 18, ''));

          return object;
        }),
    Business: EntityDefinition<Business>(
        model: _entities[1],
        toOneRelations: (Business object) => [],
        toManyRelations: (Business object) => {},
        getId: (Business object) => object.id,
        setId: (Business object, int id) {
          object.id = id;
        },
        objectToFB: (Business object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final currencyOffset = object.currency == null
              ? null
              : fbb.writeString(object.currency!);
          final latitudeOffset = fbb.writeString(object.latitude);
          final longitudeOffset = fbb.writeString(object.longitude);
          final userIdOffset =
              object.userId == null ? null : fbb.writeString(object.userId!);
          final typeIdOffset =
              object.typeId == null ? null : fbb.writeString(object.typeId!);
          final timeZoneOffset = object.timeZone == null
              ? null
              : fbb.writeString(object.timeZone!);
          final tableOffset = fbb.writeString(object.table);
          final countryOffset = fbb.writeString(object.country);
          final businessUrlOffset = object.businessUrl == null
              ? null
              : fbb.writeString(object.businessUrl!);
          final hexColorOffset = object.hexColor == null
              ? null
              : fbb.writeString(object.hexColor!);
          final imageOffset =
              object.image == null ? null : fbb.writeString(object.image!);
          final typeOffset = fbb.writeString(object.type);
          fbb.startTable(17);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, currencyOffset);
          fbb.addInt64(3, object.fcategoryId);
          fbb.addOffset(4, latitudeOffset);
          fbb.addOffset(5, longitudeOffset);
          fbb.addOffset(6, userIdOffset);
          fbb.addOffset(7, typeIdOffset);
          fbb.addOffset(8, timeZoneOffset);
          fbb.addOffset(9, tableOffset);
          fbb.addOffset(10, countryOffset);
          fbb.addOffset(11, businessUrlOffset);
          fbb.addOffset(12, hexColorOffset);
          fbb.addOffset(13, imageOffset);
          fbb.addOffset(14, typeOffset);
          fbb.addBool(15, object.active);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Business(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              currency: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              fcategoryId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              latitude:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              longitude:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              userId: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              typeId: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              timeZone: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 22, ''),
              country:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 24, ''),
              businessUrl: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 26),
              hexColor: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 28),
              image: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 30),
              type: const fb.StringReader().vTableGet(buffer, rootOffset, 32, ''),
              active: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 34));

          return object;
        }),
    Category: EntityDefinition<Category>(
        model: _entities[2],
        toOneRelations: (Category object) => [],
        toManyRelations: (Category object) => {},
        getId: (Category object) => object.id,
        setId: (Category object, int id) {
          object.id = id;
        },
        objectToFB: (Category object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final tableOffset = fbb.writeString(object.table);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addBool(1, object.active);
          fbb.addBool(2, object.focused);
          fbb.addOffset(3, nameOffset);
          fbb.addInt64(4, object.fbranchId);
          fbb.addOffset(5, tableOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Category(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              active:
                  const fb.BoolReader().vTableGet(buffer, rootOffset, 6, false),
              focused:
                  const fb.BoolReader().vTableGet(buffer, rootOffset, 8, false),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              fbranchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0),
              table: const fb.StringReader()
                  .vTableGet(buffer, rootOffset, 14, ''));

          return object;
        }),
    OrderF: EntityDefinition<OrderF>(
        model: _entities[3],
        toOneRelations: (OrderF object) => [],
        toManyRelations: (OrderF object) => {
              RelInfo<OrderItem>.toOneBacklink(
                      7, object.id, (OrderItem srcObject) => srcObject.order):
                  object.orderItems
            },
        getId: (OrderF object) => object.id,
        setId: (OrderF object, int id) {
          object.id = id;
        },
        objectToFB: (OrderF object, fb.Builder fbb) {
          final referenceOffset = fbb.writeString(object.reference);
          final orderNumberOffset = fbb.writeString(object.orderNumber);
          final statusOffset = fbb.writeString(object.status);
          final orderTypeOffset = fbb.writeString(object.orderType);
          final paymentTypeOffset = fbb.writeString(object.paymentType);
          final createdAtOffset = fbb.writeString(object.createdAt);
          final updatedAtOffset = object.updatedAt == null
              ? null
              : fbb.writeString(object.updatedAt!);
          final tableOffset = fbb.writeString(object.table);
          fbb.startTable(16);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, referenceOffset);
          fbb.addOffset(2, orderNumberOffset);
          fbb.addInt64(3, object.fbranchId);
          fbb.addOffset(4, statusOffset);
          fbb.addOffset(5, orderTypeOffset);
          fbb.addBool(6, object.active);
          fbb.addBool(7, object.draft);
          fbb.addFloat64(8, object.subTotal);
          fbb.addOffset(9, paymentTypeOffset);
          fbb.addFloat64(10, object.cashReceived);
          fbb.addFloat64(11, object.customerChangeDue);
          fbb.addOffset(12, createdAtOffset);
          fbb.addOffset(13, updatedAtOffset);
          fbb.addOffset(14, tableOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = OrderF(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              reference:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              orderNumber:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              fbranchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0),
              status:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              orderType:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 16, false),
              draft: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 18, false),
              subTotal:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 20, 0),
              paymentType:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 22, ''),
              cashReceived:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 24, 0),
              customerChangeDue:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 26, 0),
              createdAt:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 28, ''),
              updatedAt: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 30),
              table: const fb.StringReader()
                  .vTableGet(buffer, rootOffset, 32, ''));
          InternalToManyAccess.setRelInfo(
              object.orderItems,
              store,
              RelInfo<OrderItem>.toOneBacklink(
                  7, object.id, (OrderItem srcObject) => srcObject.order),
              store.box<OrderF>());
          return object;
        }),
    OrderItem: EntityDefinition<OrderItem>(
        model: _entities[4],
        toOneRelations: (OrderItem object) => [object.order],
        toManyRelations: (OrderItem object) => {},
        getId: (OrderItem object) => object.id,
        setId: (OrderItem object, int id) {
          object.id = id;
        },
        objectToFB: (OrderItem object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.forderId);
          fbb.addInt64(3, object.fvariantId);
          fbb.addFloat64(4, object.count);
          fbb.addFloat64(5, object.price);
          fbb.addInt64(6, object.order.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = OrderItem(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              fvariantId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0),
              count:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 12, 0),
              price:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 14, 0),
              forderId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          object.order.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0);
          object.order.attach(store);
          return object;
        }),
    PColor: EntityDefinition<PColor>(
        model: _entities[5],
        toOneRelations: (PColor object) => [],
        toManyRelations: (PColor object) => {},
        getId: (PColor object) => object.id,
        setId: (PColor object, int id) {
          object.id = id;
        },
        objectToFB: (PColor object, fb.Builder fbb) {
          final nameOffset =
              object.name == null ? null : fbb.writeString(object.name!);
          final tableOffset = fbb.writeString(object.table);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, tableOffset);
          fbb.addInt64(3, object.fbranchId);
          fbb.addBool(4, object.active);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = PColor(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              fbranchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 12, false));

          return object;
        }),
    Product: EntityDefinition<Product>(
        model: _entities[6],
        toOneRelations: (Product object) => [],
        toManyRelations: (Product object) => {
              RelInfo<Variant>.toOneBacklink(
                      11, object.id, (Variant srcObject) => srcObject.product):
                  object.variations
            },
        getId: (Product object) => object.id,
        setId: (Product object, int id) {
          object.id = id;
        },
        objectToFB: (Product object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final descriptionOffset = object.description == null
              ? null
              : fbb.writeString(object.description!);
          final ftaxIdOffset =
              object.ftaxId == null ? null : fbb.writeString(object.ftaxId!);
          final tableOffset = fbb.writeString(object.table);
          final colorOffset = fbb.writeString(object.color);
          final fsupplierIdOffset = object.fsupplierId == null
              ? null
              : fbb.writeString(object.fsupplierId!);
          final fcategoryIdOffset = fbb.writeString(object.fcategoryId);
          final createdAtOffset = object.createdAt == null
              ? null
              : fbb.writeString(object.createdAt!);
          final unitOffset = fbb.writeString(object.unit);
          final imageUrlOffset = object.imageUrl == null
              ? null
              : fbb.writeString(object.imageUrl!);
          fbb.startTable(19);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, descriptionOffset);
          fbb.addBool(3, object.active);
          fbb.addOffset(4, ftaxIdOffset);
          fbb.addBool(5, object.hasPicture);
          fbb.addOffset(6, tableOffset);
          fbb.addOffset(7, colorOffset);
          fbb.addInt64(8, object.fbusinessId);
          fbb.addInt64(9, object.fbranchId);
          fbb.addOffset(10, fsupplierIdOffset);
          fbb.addOffset(11, fcategoryIdOffset);
          fbb.addOffset(12, createdAtOffset);
          fbb.addOffset(13, unitOffset);
          fbb.addBool(14, object.draft);
          fbb.addBool(15, object.imageLocal);
          fbb.addBool(16, object.currentUpdate);
          fbb.addOffset(17, imageUrlOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Product(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              description: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 10, false),
              ftaxId: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              hasPicture: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 14, false),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              color:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 18, ''),
              fbusinessId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0),
              fbranchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0),
              fsupplierId: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              fcategoryId:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 26, ''),
              createdAt: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 28),
              unit:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 30, ''),
              draft: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 32),
              imageLocal: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 34),
              currentUpdate: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 36),
              imageUrl: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 38));
          InternalToManyAccess.setRelInfo(
              object.variations,
              store,
              RelInfo<Variant>.toOneBacklink(
                  11, object.id, (Variant srcObject) => srcObject.product),
              store.box<Product>());
          return object;
        }),
    Stock: EntityDefinition<Stock>(
        model: _entities[7],
        toOneRelations: (Stock object) => [],
        toManyRelations: (Stock object) => {},
        getId: (Stock object) => object.id,
        setId: (Stock object, int id) {
          object.id = id;
        },
        objectToFB: (Stock object, fb.Builder fbb) {
          final tableOffset = fbb.writeString(object.table);
          fbb.startTable(14);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.fbranchId);
          fbb.addInt64(2, object.fvariantId);
          fbb.addFloat64(3, object.lowStock);
          fbb.addFloat64(4, object.currentStock);
          fbb.addFloat64(5, object.supplyPrice);
          fbb.addFloat64(6, object.retailPrice);
          fbb.addBool(7, object.canTrackingStock);
          fbb.addBool(8, object.showLowStockAlert);
          fbb.addOffset(9, tableOffset);
          fbb.addInt64(10, object.fproductId);
          fbb.addBool(11, object.active);
          fbb.addFloat64(12, object.value);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Stock(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              fbranchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              fvariantId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0),
              lowStock:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0),
              currentStock:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 12, 0),
              supplyPrice:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 14, 0),
              retailPrice:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 16, 0),
              canTrackingStock: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 18, false),
              showLowStockAlert: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 20, false),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 22, ''),
              fproductId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 24, 0),
              active: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 26),
              value: const fb.Float64Reader()
                  .vTableGet(buffer, rootOffset, 28, 0));

          return object;
        }),
    Unit: EntityDefinition<Unit>(
        model: _entities[8],
        toOneRelations: (Unit object) => [],
        toManyRelations: (Unit object) => {},
        getId: (Unit object) => object.id,
        setId: (Unit object, int id) {
          object.id = id;
        },
        objectToFB: (Unit object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final tableOffset = fbb.writeString(object.table);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.fbranchId);
          fbb.addOffset(2, nameOffset);
          fbb.addFloat64(3, object.value);
          fbb.addOffset(4, tableOffset);
          fbb.addBool(5, object.active);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Unit(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              fbranchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              value: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 14, false));

          return object;
        }),
    Variant: EntityDefinition<Variant>(
        model: _entities[9],
        toOneRelations: (Variant object) => [object.product],
        toManyRelations: (Variant object) => {},
        getId: (Variant object) => object.id,
        setId: (Variant object, int id) {
          object.id = id;
        },
        objectToFB: (Variant object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final skuOffset = fbb.writeString(object.sku);
          final unitOffset = fbb.writeString(object.unit);
          final tableOffset = fbb.writeString(object.table);
          final productNameOffset = fbb.writeString(object.productName);
          final taxNameOffset =
              object.taxName == null ? null : fbb.writeString(object.taxName!);
          fbb.startTable(12);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, skuOffset);
          fbb.addInt64(3, object.fproductId);
          fbb.addOffset(4, unitOffset);
          fbb.addOffset(5, tableOffset);
          fbb.addOffset(6, productNameOffset);
          fbb.addInt64(7, object.fbranchId);
          fbb.addOffset(8, taxNameOffset);
          fbb.addFloat64(9, object.taxPercentage);
          fbb.addInt64(10, object.product.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Variant(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              sku: const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              fproductId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0),
              unit:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              productName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              fbranchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0),
              taxName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              taxPercentage: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 22));
          object.product.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 24, 0);
          object.product.attach(store);
          return object;
        }),
    VariantStock: EntityDefinition<VariantStock>(
        model: _entities[10],
        toOneRelations: (VariantStock object) => [],
        toManyRelations: (VariantStock object) => {},
        getId: (VariantStock object) => object.id,
        setId: (VariantStock object, int id) {
          object.id = id;
        },
        objectToFB: (VariantStock object, fb.Builder fbb) {
          final productNameOffset = fbb.writeString(object.productName);
          final variantNameOffset = fbb.writeString(object.variantName);
          final unitOffset = fbb.writeString(object.unit);
          final skuOffset = fbb.writeString(object.sku);
          final fbranchIdOffset = fbb.writeString(object.fbranchId);
          final fvariantIdOffset = fbb.writeString(object.fvariantId);
          final taxNameOffset =
              object.taxName == null ? null : fbb.writeString(object.taxName!);
          fbb.startTable(15);
          fbb.addInt64(0, object.id);
          fbb.addBool(1, object.canTrackingStock);
          fbb.addFloat64(2, object.retailPrice);
          fbb.addOffset(3, productNameOffset);
          fbb.addOffset(4, variantNameOffset);
          fbb.addOffset(5, unitOffset);
          fbb.addOffset(6, skuOffset);
          fbb.addOffset(7, fbranchIdOffset);
          fbb.addFloat64(8, object.lowStock);
          fbb.addFloat64(9, object.currentStock);
          fbb.addOffset(10, fvariantIdOffset);
          fbb.addOffset(11, taxNameOffset);
          fbb.addFloat64(12, object.taxPercentage);
          fbb.addFloat64(13, object.value);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = VariantStock(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              canTrackingStock:
                  const fb.BoolReader().vTableGet(buffer, rootOffset, 6, false),
              retailPrice:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0),
              productName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              variantName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              unit:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              sku:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              fbranchId:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 18, ''),
              lowStock: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              currentStock:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 22, 0),
              fvariantId:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 24, ''),
              taxName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 26),
              taxPercentage: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 28),
              value: const fb.Float64Reader()
                  .vTableGet(buffer, rootOffset, 30, 0));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Branch] entity fields to define ObjectBox queries.
class Branch_ {
  /// see [Branch.id]
  static final id = QueryIntegerProperty<Branch>(_entities[0].properties[0]);

  /// see [Branch.active]
  static final active =
      QueryBooleanProperty<Branch>(_entities[0].properties[1]);

  /// see [Branch.description]
  static final description =
      QueryStringProperty<Branch>(_entities[0].properties[2]);

  /// see [Branch.name]
  static final name = QueryStringProperty<Branch>(_entities[0].properties[3]);

  /// see [Branch.fbusinessId]
  static final fbusinessId =
      QueryIntegerProperty<Branch>(_entities[0].properties[4]);

  /// see [Branch.longitude]
  static final longitude =
      QueryStringProperty<Branch>(_entities[0].properties[5]);

  /// see [Branch.latitude]
  static final latitude =
      QueryStringProperty<Branch>(_entities[0].properties[6]);

  /// see [Branch.table]
  static final table = QueryStringProperty<Branch>(_entities[0].properties[7]);
}

/// [Business] entity fields to define ObjectBox queries.
class Business_ {
  /// see [Business.id]
  static final id = QueryIntegerProperty<Business>(_entities[1].properties[0]);

  /// see [Business.name]
  static final name = QueryStringProperty<Business>(_entities[1].properties[1]);

  /// see [Business.currency]
  static final currency =
      QueryStringProperty<Business>(_entities[1].properties[2]);

  /// see [Business.fcategoryId]
  static final fcategoryId =
      QueryIntegerProperty<Business>(_entities[1].properties[3]);

  /// see [Business.latitude]
  static final latitude =
      QueryStringProperty<Business>(_entities[1].properties[4]);

  /// see [Business.longitude]
  static final longitude =
      QueryStringProperty<Business>(_entities[1].properties[5]);

  /// see [Business.userId]
  static final userId =
      QueryStringProperty<Business>(_entities[1].properties[6]);

  /// see [Business.typeId]
  static final typeId =
      QueryStringProperty<Business>(_entities[1].properties[7]);

  /// see [Business.timeZone]
  static final timeZone =
      QueryStringProperty<Business>(_entities[1].properties[8]);

  /// see [Business.table]
  static final table =
      QueryStringProperty<Business>(_entities[1].properties[9]);

  /// see [Business.country]
  static final country =
      QueryStringProperty<Business>(_entities[1].properties[10]);

  /// see [Business.businessUrl]
  static final businessUrl =
      QueryStringProperty<Business>(_entities[1].properties[11]);

  /// see [Business.hexColor]
  static final hexColor =
      QueryStringProperty<Business>(_entities[1].properties[12]);

  /// see [Business.image]
  static final image =
      QueryStringProperty<Business>(_entities[1].properties[13]);

  /// see [Business.type]
  static final type =
      QueryStringProperty<Business>(_entities[1].properties[14]);

  /// see [Business.active]
  static final active =
      QueryBooleanProperty<Business>(_entities[1].properties[15]);
}

/// [Category] entity fields to define ObjectBox queries.
class Category_ {
  /// see [Category.id]
  static final id = QueryIntegerProperty<Category>(_entities[2].properties[0]);

  /// see [Category.active]
  static final active =
      QueryBooleanProperty<Category>(_entities[2].properties[1]);

  /// see [Category.focused]
  static final focused =
      QueryBooleanProperty<Category>(_entities[2].properties[2]);

  /// see [Category.name]
  static final name = QueryStringProperty<Category>(_entities[2].properties[3]);

  /// see [Category.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<Category>(_entities[2].properties[4]);

  /// see [Category.table]
  static final table =
      QueryStringProperty<Category>(_entities[2].properties[5]);
}

/// [OrderF] entity fields to define ObjectBox queries.
class OrderF_ {
  /// see [OrderF.id]
  static final id = QueryIntegerProperty<OrderF>(_entities[3].properties[0]);

  /// see [OrderF.reference]
  static final reference =
      QueryStringProperty<OrderF>(_entities[3].properties[1]);

  /// see [OrderF.orderNumber]
  static final orderNumber =
      QueryStringProperty<OrderF>(_entities[3].properties[2]);

  /// see [OrderF.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<OrderF>(_entities[3].properties[3]);

  /// see [OrderF.status]
  static final status = QueryStringProperty<OrderF>(_entities[3].properties[4]);

  /// see [OrderF.orderType]
  static final orderType =
      QueryStringProperty<OrderF>(_entities[3].properties[5]);

  /// see [OrderF.active]
  static final active =
      QueryBooleanProperty<OrderF>(_entities[3].properties[6]);

  /// see [OrderF.draft]
  static final draft = QueryBooleanProperty<OrderF>(_entities[3].properties[7]);

  /// see [OrderF.subTotal]
  static final subTotal =
      QueryDoubleProperty<OrderF>(_entities[3].properties[8]);

  /// see [OrderF.paymentType]
  static final paymentType =
      QueryStringProperty<OrderF>(_entities[3].properties[9]);

  /// see [OrderF.cashReceived]
  static final cashReceived =
      QueryDoubleProperty<OrderF>(_entities[3].properties[10]);

  /// see [OrderF.customerChangeDue]
  static final customerChangeDue =
      QueryDoubleProperty<OrderF>(_entities[3].properties[11]);

  /// see [OrderF.createdAt]
  static final createdAt =
      QueryStringProperty<OrderF>(_entities[3].properties[12]);

  /// see [OrderF.updatedAt]
  static final updatedAt =
      QueryStringProperty<OrderF>(_entities[3].properties[13]);

  /// see [OrderF.table]
  static final table = QueryStringProperty<OrderF>(_entities[3].properties[14]);
}

/// [OrderItem] entity fields to define ObjectBox queries.
class OrderItem_ {
  /// see [OrderItem.id]
  static final id = QueryIntegerProperty<OrderItem>(_entities[4].properties[0]);

  /// see [OrderItem.name]
  static final name =
      QueryStringProperty<OrderItem>(_entities[4].properties[1]);

  /// see [OrderItem.forderId]
  static final forderId =
      QueryIntegerProperty<OrderItem>(_entities[4].properties[2]);

  /// see [OrderItem.fvariantId]
  static final fvariantId =
      QueryIntegerProperty<OrderItem>(_entities[4].properties[3]);

  /// see [OrderItem.count]
  static final count =
      QueryDoubleProperty<OrderItem>(_entities[4].properties[4]);

  /// see [OrderItem.price]
  static final price =
      QueryDoubleProperty<OrderItem>(_entities[4].properties[5]);

  /// see [OrderItem.order]
  static final order =
      QueryRelationProperty<OrderItem, OrderF>(_entities[4].properties[6]);
}

/// [PColor] entity fields to define ObjectBox queries.
class PColor_ {
  /// see [PColor.id]
  static final id = QueryIntegerProperty<PColor>(_entities[5].properties[0]);

  /// see [PColor.name]
  static final name = QueryStringProperty<PColor>(_entities[5].properties[1]);

  /// see [PColor.table]
  static final table = QueryStringProperty<PColor>(_entities[5].properties[2]);

  /// see [PColor.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<PColor>(_entities[5].properties[3]);

  /// see [PColor.active]
  static final active =
      QueryBooleanProperty<PColor>(_entities[5].properties[4]);
}

/// [Product] entity fields to define ObjectBox queries.
class Product_ {
  /// see [Product.id]
  static final id = QueryIntegerProperty<Product>(_entities[6].properties[0]);

  /// see [Product.name]
  static final name = QueryStringProperty<Product>(_entities[6].properties[1]);

  /// see [Product.description]
  static final description =
      QueryStringProperty<Product>(_entities[6].properties[2]);

  /// see [Product.active]
  static final active =
      QueryBooleanProperty<Product>(_entities[6].properties[3]);

  /// see [Product.ftaxId]
  static final ftaxId =
      QueryStringProperty<Product>(_entities[6].properties[4]);

  /// see [Product.hasPicture]
  static final hasPicture =
      QueryBooleanProperty<Product>(_entities[6].properties[5]);

  /// see [Product.table]
  static final table = QueryStringProperty<Product>(_entities[6].properties[6]);

  /// see [Product.color]
  static final color = QueryStringProperty<Product>(_entities[6].properties[7]);

  /// see [Product.fbusinessId]
  static final fbusinessId =
      QueryIntegerProperty<Product>(_entities[6].properties[8]);

  /// see [Product.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<Product>(_entities[6].properties[9]);

  /// see [Product.fsupplierId]
  static final fsupplierId =
      QueryStringProperty<Product>(_entities[6].properties[10]);

  /// see [Product.fcategoryId]
  static final fcategoryId =
      QueryStringProperty<Product>(_entities[6].properties[11]);

  /// see [Product.createdAt]
  static final createdAt =
      QueryStringProperty<Product>(_entities[6].properties[12]);

  /// see [Product.unit]
  static final unit = QueryStringProperty<Product>(_entities[6].properties[13]);

  /// see [Product.draft]
  static final draft =
      QueryBooleanProperty<Product>(_entities[6].properties[14]);

  /// see [Product.imageLocal]
  static final imageLocal =
      QueryBooleanProperty<Product>(_entities[6].properties[15]);

  /// see [Product.currentUpdate]
  static final currentUpdate =
      QueryBooleanProperty<Product>(_entities[6].properties[16]);

  /// see [Product.imageUrl]
  static final imageUrl =
      QueryStringProperty<Product>(_entities[6].properties[17]);
}

/// [Stock] entity fields to define ObjectBox queries.
class Stock_ {
  /// see [Stock.id]
  static final id = QueryIntegerProperty<Stock>(_entities[7].properties[0]);

  /// see [Stock.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<Stock>(_entities[7].properties[1]);

  /// see [Stock.fvariantId]
  static final fvariantId =
      QueryIntegerProperty<Stock>(_entities[7].properties[2]);

  /// see [Stock.lowStock]
  static final lowStock =
      QueryDoubleProperty<Stock>(_entities[7].properties[3]);

  /// see [Stock.currentStock]
  static final currentStock =
      QueryDoubleProperty<Stock>(_entities[7].properties[4]);

  /// see [Stock.supplyPrice]
  static final supplyPrice =
      QueryDoubleProperty<Stock>(_entities[7].properties[5]);

  /// see [Stock.retailPrice]
  static final retailPrice =
      QueryDoubleProperty<Stock>(_entities[7].properties[6]);

  /// see [Stock.canTrackingStock]
  static final canTrackingStock =
      QueryBooleanProperty<Stock>(_entities[7].properties[7]);

  /// see [Stock.showLowStockAlert]
  static final showLowStockAlert =
      QueryBooleanProperty<Stock>(_entities[7].properties[8]);

  /// see [Stock.table]
  static final table = QueryStringProperty<Stock>(_entities[7].properties[9]);

  /// see [Stock.fproductId]
  static final fproductId =
      QueryIntegerProperty<Stock>(_entities[7].properties[10]);

  /// see [Stock.active]
  static final active =
      QueryBooleanProperty<Stock>(_entities[7].properties[11]);

  /// see [Stock.value]
  static final value = QueryDoubleProperty<Stock>(_entities[7].properties[12]);
}

/// [Unit] entity fields to define ObjectBox queries.
class Unit_ {
  /// see [Unit.id]
  static final id = QueryIntegerProperty<Unit>(_entities[8].properties[0]);

  /// see [Unit.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<Unit>(_entities[8].properties[1]);

  /// see [Unit.name]
  static final name = QueryStringProperty<Unit>(_entities[8].properties[2]);

  /// see [Unit.value]
  static final value = QueryDoubleProperty<Unit>(_entities[8].properties[3]);

  /// see [Unit.table]
  static final table = QueryStringProperty<Unit>(_entities[8].properties[4]);

  /// see [Unit.active]
  static final active = QueryBooleanProperty<Unit>(_entities[8].properties[5]);
}

/// [Variant] entity fields to define ObjectBox queries.
class Variant_ {
  /// see [Variant.id]
  static final id = QueryIntegerProperty<Variant>(_entities[9].properties[0]);

  /// see [Variant.name]
  static final name = QueryStringProperty<Variant>(_entities[9].properties[1]);

  /// see [Variant.sku]
  static final sku = QueryStringProperty<Variant>(_entities[9].properties[2]);

  /// see [Variant.fproductId]
  static final fproductId =
      QueryIntegerProperty<Variant>(_entities[9].properties[3]);

  /// see [Variant.unit]
  static final unit = QueryStringProperty<Variant>(_entities[9].properties[4]);

  /// see [Variant.table]
  static final table = QueryStringProperty<Variant>(_entities[9].properties[5]);

  /// see [Variant.productName]
  static final productName =
      QueryStringProperty<Variant>(_entities[9].properties[6]);

  /// see [Variant.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<Variant>(_entities[9].properties[7]);

  /// see [Variant.taxName]
  static final taxName =
      QueryStringProperty<Variant>(_entities[9].properties[8]);

  /// see [Variant.taxPercentage]
  static final taxPercentage =
      QueryDoubleProperty<Variant>(_entities[9].properties[9]);

  /// see [Variant.product]
  static final product =
      QueryRelationProperty<Variant, Product>(_entities[9].properties[10]);
}

/// [VariantStock] entity fields to define ObjectBox queries.
class VariantStock_ {
  /// see [VariantStock.id]
  static final id =
      QueryIntegerProperty<VariantStock>(_entities[10].properties[0]);

  /// see [VariantStock.canTrackingStock]
  static final canTrackingStock =
      QueryBooleanProperty<VariantStock>(_entities[10].properties[1]);

  /// see [VariantStock.retailPrice]
  static final retailPrice =
      QueryDoubleProperty<VariantStock>(_entities[10].properties[2]);

  /// see [VariantStock.productName]
  static final productName =
      QueryStringProperty<VariantStock>(_entities[10].properties[3]);

  /// see [VariantStock.variantName]
  static final variantName =
      QueryStringProperty<VariantStock>(_entities[10].properties[4]);

  /// see [VariantStock.unit]
  static final unit =
      QueryStringProperty<VariantStock>(_entities[10].properties[5]);

  /// see [VariantStock.sku]
  static final sku =
      QueryStringProperty<VariantStock>(_entities[10].properties[6]);

  /// see [VariantStock.fbranchId]
  static final fbranchId =
      QueryStringProperty<VariantStock>(_entities[10].properties[7]);

  /// see [VariantStock.lowStock]
  static final lowStock =
      QueryDoubleProperty<VariantStock>(_entities[10].properties[8]);

  /// see [VariantStock.currentStock]
  static final currentStock =
      QueryDoubleProperty<VariantStock>(_entities[10].properties[9]);

  /// see [VariantStock.fvariantId]
  static final fvariantId =
      QueryStringProperty<VariantStock>(_entities[10].properties[10]);

  /// see [VariantStock.taxName]
  static final taxName =
      QueryStringProperty<VariantStock>(_entities[10].properties[11]);

  /// see [VariantStock.taxPercentage]
  static final taxPercentage =
      QueryDoubleProperty<VariantStock>(_entities[10].properties[12]);

  /// see [VariantStock.value]
  static final value =
      QueryDoubleProperty<VariantStock>(_entities[10].properties[13]);
}
