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
import 'product.dart';
import 'stock.dart';
import 'unit.dart';
import 'variant_stock.dart';
import 'variation.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 2511968030780235419),
      name: 'Branch',
      lastPropertyId: const IdUid(10, 2760766931932819697),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(2, 4920460509961190403),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(3, 8634837250438440348),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5595250534435524710),
            name: 'channels',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 6255090155310487872),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7549758807806453354),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 8892066695080586997),
            name: 'businessId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 340003718970230444),
            name: 'longitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 2578318226119876621),
            name: 'latitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2760766931932819697),
            name: 'table',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 7837495273200655489),
      name: 'Business',
      lastPropertyId: const IdUid(11, 3559852432035422191),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(2, 1531293597453735504),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(3, 7890695988617289978),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4327752206308700050),
            name: 'latitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 9150710287883177358),
            name: 'longitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4221775309218396395),
            name: 'channels',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 695451918454346399),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 5834905746872400457),
            name: 'country',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 8054153165383826996),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2521545717922877081),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 3559852432035422191),
            name: 'categoryId',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 3383523393190802747),
      name: 'OrderF',
      lastPropertyId: const IdUid(17, 4371899251185058067),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(2, 7632852281173346747),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(3, 4443550631098437994),
            name: 'reference',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6572044248570070163),
            name: 'orderNumber',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 565674456265282732),
            name: 'branchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7291789005590509839),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4540947748788830473),
            name: 'orderType',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 7338548821314366673),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 7186729519303186342),
            name: 'draft',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 7108569206534576470),
            name: 'subTotal',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 1756189575966692591),
            name: 'paymentType',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 1758502560498322609),
            name: 'cashReceived',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 4322686201478121093),
            name: 'customerChangeDue',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 6243950921641981683),
            name: 'createdAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 7922077873800554363),
            name: 'updatedAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 5961292628544392955),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 4371899251185058067),
            name: 'channels',
            type: 30,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(4, 2396877293490595070),
      name: 'PColor',
      lastPropertyId: const IdUid(8, 1896851581104991088),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(2, 6247229369745145167),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(3, 3596443623440777391),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 9066178018393409616),
            name: 'colors',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 10576352302788210),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 1124894720250168458),
            name: 'branchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 1896851581104991088),
            name: 'active',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(5, 7835081799629458262),
      name: 'Product',
      lastPropertyId: const IdUid(18, 3599244628657204844),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(2, 1340763340572989269),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(3, 6701555805328260587),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1224708381713114333),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2079335337595650553),
            name: 'channels',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 887247511445101355),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 670610649854107630),
            name: 'hasPicture',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 3404462899657622290),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 5149617639195476576),
            name: 'color',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 6506143422281940180),
            name: 'businessId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 2983264857274050463),
            name: 'branchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 5004749005653548805),
            name: 'categoryId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 1260154845843223274),
            name: 'createdAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 6354585637631758020),
            name: 'unit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 3162808566415195156),
            name: 'draft',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 2545118556173520580),
            name: 'imageLocal',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 5847349536269153038),
            name: 'currentUpdate',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 3599244628657204844),
            name: 'imageUrl',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(6, 8831841080811899504),
      name: 'Stock',
      lastPropertyId: const IdUid(15, 7343191869939174211),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(2, 2504885191690279412),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(3, 6620063373513971440),
            name: 'branchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5784804635981649419),
            name: 'variantId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 1147081411091215982),
            name: 'lowStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3445150052194126519),
            name: 'currentStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4370748144026738889),
            name: 'supplyPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 7708276835857518452),
            name: 'retailPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 6573757265046821618),
            name: 'canTrackingStock',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 4248403559280987941),
            name: 'showLowStockAlert',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 7572232656056008262),
            name: 'channels',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 9067719241792883468),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 7625455848626556248),
            name: 'productId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 3493540861059891447),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 7343191869939174211),
            name: 'value',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(7, 2757012941352128757),
      name: 'Unit',
      lastPropertyId: const IdUid(7, 8071567746792102834),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(2, 2292528716034359996),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(3, 708784323083006726),
            name: 'branchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4322101533511711097),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3218831859521997540),
            name: 'value',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4579234278250402602),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 8071567746792102834),
            name: 'active',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(8, 3834138012778686072),
      name: 'VariantStock',
      lastPropertyId: const IdUid(15, 818114695367854840),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(2, 3273110755766605146),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(3, 4740130924112217497),
            name: 'canTrackingStock',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7607873739591173509),
            name: 'retailPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5522955581334448997),
            name: 'productName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 5076067430751537446),
            name: 'variantName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4026016462510635195),
            name: 'unit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 5448077171305728953),
            name: 'sku',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 1060708734431166547),
            name: 'branchId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 8639008587056525111),
            name: 'lowStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 8655986519507712370),
            name: 'currentStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 7879376501773098230),
            name: 'variantId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 3062602460540103819),
            name: 'taxName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 3512779228416409229),
            name: 'taxPercentage',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 818114695367854840),
            name: 'value',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(9, 5058492263366215605),
      name: 'Variation',
      lastPropertyId: const IdUid(12, 3235155978810672502),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(2, 6074762231177790629),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(3, 3080737840663924952),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6002505458686352560),
            name: 'sku',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2780406377185816770),
            name: 'productId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4743428067072024940),
            name: 'unit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4796557792116038656),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 4966455113054439010),
            name: 'productName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 8128997454975075180),
            name: 'branchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 3416568704435219554),
            name: 'taxName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 3235155978810672502),
            name: 'taxPercentage',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(10, 6145777409938284646),
      name: 'Category',
      lastPropertyId: const IdUid(7, 1541673508084362222),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 882787230750623812),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 8428041550719048892),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 4654359218238663834),
            name: 'focused',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 979490356405837607),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7386208960121144593),
            name: 'channels',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4246271589191354890),
            name: 'branchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 1541673508084362222),
            name: 'table',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(10, 6145777409938284646),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        2430468931998216420,
        3474815612631716087,
        7621242845431524818,
        8377226275648768467,
        6319823147793408769,
        7410938646680965896,
        5219171270441335984,
        3661850016293327332,
        6751474555349772129,
        3952203911784196896,
        567518678801343409
      ],
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
          final channelsOffset = fbb.writeList(
              object.channels.map(fbb.writeString).toList(growable: false));
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
          fbb.startTable(11);
          fbb.addInt64(1, object.id);
          fbb.addBool(2, object.active);
          fbb.addOffset(3, channelsOffset);
          fbb.addOffset(4, descriptionOffset);
          fbb.addOffset(5, nameOffset);
          fbb.addInt64(6, object.businessId);
          fbb.addOffset(7, longitudeOffset);
          fbb.addOffset(8, latitudeOffset);
          fbb.addOffset(9, tableOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Branch(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              active: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              channels: const EagerListReader<String>(fb.StringReader())
                  .vTableGet(buffer, rootOffset, 10, []),
              description: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              businessId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              longitude: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              latitude: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              table: const fb.StringReader()
                  .vTableGet(buffer, rootOffset, 22, ''));

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
          final latitudeOffset = fbb.writeString(object.latitude);
          final longitudeOffset = fbb.writeString(object.longitude);
          final channelsOffset = fbb.writeList(
              object.channels.map(fbb.writeString).toList(growable: false));
          final tableOffset = fbb.writeString(object.table);
          final countryOffset = fbb.writeString(object.country);
          final typeOffset = fbb.writeString(object.type);
          fbb.startTable(12);
          fbb.addInt64(1, object.id);
          fbb.addOffset(2, nameOffset);
          fbb.addOffset(3, latitudeOffset);
          fbb.addOffset(4, longitudeOffset);
          fbb.addOffset(5, channelsOffset);
          fbb.addOffset(6, tableOffset);
          fbb.addOffset(7, countryOffset);
          fbb.addOffset(8, typeOffset);
          fbb.addBool(9, object.active);
          fbb.addInt64(10, object.categoryId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Business(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              categoryId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              latitude:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              longitude:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              channels: const EagerListReader<String>(fb.StringReader())
                  .vTableGet(buffer, rootOffset, 14, []),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              country:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 18, ''),
              type:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 20, ''),
              active: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 22));

          return object;
        }),
    OrderF: EntityDefinition<OrderF>(
        model: _entities[2],
        toOneRelations: (OrderF object) => [],
        toManyRelations: (OrderF object) => {},
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
          final channelsOffset = fbb.writeList(
              object.channels.map(fbb.writeString).toList(growable: false));
          fbb.startTable(18);
          fbb.addInt64(1, object.id);
          fbb.addOffset(2, referenceOffset);
          fbb.addOffset(3, orderNumberOffset);
          fbb.addInt64(4, object.branchId);
          fbb.addOffset(5, statusOffset);
          fbb.addOffset(6, orderTypeOffset);
          fbb.addBool(7, object.active);
          fbb.addBool(8, object.draft);
          fbb.addFloat64(9, object.subTotal);
          fbb.addOffset(10, paymentTypeOffset);
          fbb.addFloat64(11, object.cashReceived);
          fbb.addFloat64(12, object.customerChangeDue);
          fbb.addOffset(13, createdAtOffset);
          fbb.addOffset(14, updatedAtOffset);
          fbb.addOffset(15, tableOffset);
          fbb.addOffset(16, channelsOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = OrderF(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              reference:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              orderNumber:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0),
              status:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              orderType:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 18, false),
              draft: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 20, false),
              subTotal:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 22, 0),
              paymentType:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 24, ''),
              cashReceived:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 26, 0),
              customerChangeDue:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 28, 0),
              createdAt:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 30, ''),
              updatedAt: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 32),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 34, ''),
              channels: const EagerListReader<String>(fb.StringReader())
                  .vTableGet(buffer, rootOffset, 36, []));

          return object;
        }),
    PColor: EntityDefinition<PColor>(
        model: _entities[3],
        toOneRelations: (PColor object) => [],
        toManyRelations: (PColor object) => {},
        getId: (PColor object) => object.id,
        setId: (PColor object, int id) {
          object.id = id;
        },
        objectToFB: (PColor object, fb.Builder fbb) {
          final nameOffset =
              object.name == null ? null : fbb.writeString(object.name!);
          final colorsOffset = object.colors == null
              ? null
              : fbb.writeList(
                  object.colors!.map(fbb.writeString).toList(growable: false));
          final tableOffset = fbb.writeString(object.table);
          fbb.startTable(9);
          fbb.addInt64(1, object.id);
          fbb.addOffset(2, nameOffset);
          fbb.addOffset(4, colorsOffset);
          fbb.addOffset(5, tableOffset);
          fbb.addInt64(6, object.branchId);
          fbb.addBool(7, object.active);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = PColor(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              name: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              colors: const EagerListReader<String>(fb.StringReader())
                  .vTableGetNullable(buffer, rootOffset, 12),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 18, false));

          return object;
        }),
    Product: EntityDefinition<Product>(
        model: _entities[4],
        toOneRelations: (Product object) => [],
        toManyRelations: (Product object) => {},
        getId: (Product object) => object.id,
        setId: (Product object, int id) {
          object.id = id;
        },
        objectToFB: (Product object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final descriptionOffset = object.description == null
              ? null
              : fbb.writeString(object.description!);
          final channelsOffset = fbb.writeList(
              object.channels.map(fbb.writeString).toList(growable: false));
          final tableOffset = fbb.writeString(object.table);
          final colorOffset = fbb.writeString(object.color);
          final categoryIdOffset = fbb.writeString(object.categoryId);
          final createdAtOffset = object.createdAt == null
              ? null
              : fbb.writeString(object.createdAt!);
          final unitOffset = fbb.writeString(object.unit);
          final imageUrlOffset = object.imageUrl == null
              ? null
              : fbb.writeString(object.imageUrl!);
          fbb.startTable(19);
          fbb.addInt64(1, object.id);
          fbb.addOffset(2, nameOffset);
          fbb.addOffset(3, descriptionOffset);
          fbb.addOffset(4, channelsOffset);
          fbb.addBool(5, object.active);
          fbb.addBool(6, object.hasPicture);
          fbb.addOffset(7, tableOffset);
          fbb.addOffset(8, colorOffset);
          fbb.addInt64(9, object.businessId);
          fbb.addInt64(10, object.branchId);
          fbb.addOffset(11, categoryIdOffset);
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
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              description: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              channels: const EagerListReader<String>(fb.StringReader())
                  .vTableGet(buffer, rootOffset, 12, []),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 14, false),
              hasPicture: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 16, false),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 18, ''),
              color:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 20, ''),
              businessId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 24, 0),
              categoryId:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 26, ''),
              createdAt: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 28),
              unit:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 30, ''),
              draft: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 32),
              imageLocal: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 34),
              currentUpdate: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 36),
              imageUrl: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 38));

          return object;
        }),
    Stock: EntityDefinition<Stock>(
        model: _entities[5],
        toOneRelations: (Stock object) => [],
        toManyRelations: (Stock object) => {},
        getId: (Stock object) => object.id,
        setId: (Stock object, int id) {
          object.id = id;
        },
        objectToFB: (Stock object, fb.Builder fbb) {
          final channelsOffset = fbb.writeList(
              object.channels.map(fbb.writeString).toList(growable: false));
          final tableOffset = fbb.writeString(object.table);
          final productIdOffset = fbb.writeString(object.productId);
          fbb.startTable(16);
          fbb.addInt64(1, object.id);
          fbb.addInt64(2, object.branchId);
          fbb.addInt64(3, object.variantId);
          fbb.addFloat64(4, object.lowStock);
          fbb.addFloat64(5, object.currentStock);
          fbb.addFloat64(6, object.supplyPrice);
          fbb.addFloat64(7, object.retailPrice);
          fbb.addBool(8, object.canTrackingStock);
          fbb.addBool(9, object.showLowStockAlert);
          fbb.addOffset(10, channelsOffset);
          fbb.addOffset(11, tableOffset);
          fbb.addOffset(12, productIdOffset);
          fbb.addBool(13, object.active);
          fbb.addFloat64(14, object.value);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Stock(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0),
              variantId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0),
              lowStock:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 12, 0),
              currentStock:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 14, 0),
              supplyPrice:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 16, 0),
              retailPrice:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 18, 0),
              canTrackingStock: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 20, false),
              showLowStockAlert: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 22, false),
              channels: const EagerListReader<String>(fb.StringReader())
                  .vTableGet(buffer, rootOffset, 24, []),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 26, ''),
              productId:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 28, ''),
              active: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 30),
              value: const fb.Float64Reader()
                  .vTableGet(buffer, rootOffset, 32, 0));

          return object;
        }),
    Unit: EntityDefinition<Unit>(
        model: _entities[6],
        toOneRelations: (Unit object) => [],
        toManyRelations: (Unit object) => {},
        getId: (Unit object) => object.id,
        setId: (Unit object, int id) {
          object.id = id;
        },
        objectToFB: (Unit object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final valueOffset =
              object.value == null ? null : fbb.writeString(object.value!);
          final tableOffset = fbb.writeString(object.table);
          fbb.startTable(8);
          fbb.addInt64(1, object.id);
          fbb.addInt64(2, object.branchId);
          fbb.addOffset(3, nameOffset);
          fbb.addOffset(4, valueOffset);
          fbb.addOffset(5, tableOffset);
          fbb.addBool(6, object.active);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Unit(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              value: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 16, false));

          return object;
        }),
    VariantStock: EntityDefinition<VariantStock>(
        model: _entities[7],
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
          final branchIdOffset = fbb.writeString(object.branchId);
          final variantIdOffset = fbb.writeString(object.variantId);
          final taxNameOffset =
              object.taxName == null ? null : fbb.writeString(object.taxName!);
          fbb.startTable(16);
          fbb.addInt64(1, object.id);
          fbb.addBool(2, object.canTrackingStock);
          fbb.addFloat64(3, object.retailPrice);
          fbb.addOffset(4, productNameOffset);
          fbb.addOffset(5, variantNameOffset);
          fbb.addOffset(6, unitOffset);
          fbb.addOffset(7, skuOffset);
          fbb.addOffset(8, branchIdOffset);
          fbb.addFloat64(9, object.lowStock);
          fbb.addFloat64(10, object.currentStock);
          fbb.addOffset(11, variantIdOffset);
          fbb.addOffset(12, taxNameOffset);
          fbb.addFloat64(13, object.taxPercentage);
          fbb.addFloat64(14, object.value);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = VariantStock(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              canTrackingStock:
                  const fb.BoolReader().vTableGet(buffer, rootOffset, 8, false),
              retailPrice:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0),
              productName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              variantName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              unit:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              sku:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 18, ''),
              branchId:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 20, ''),
              lowStock: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 22),
              currentStock:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 24, 0),
              variantId:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 26, ''),
              taxName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 28),
              taxPercentage: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 30),
              value: const fb.Float64Reader()
                  .vTableGet(buffer, rootOffset, 32, 0));

          return object;
        }),
    Variation: EntityDefinition<Variation>(
        model: _entities[8],
        toOneRelations: (Variation object) => [],
        toManyRelations: (Variation object) => {},
        getId: (Variation object) => object.id,
        setId: (Variation object, int id) {
          object.id = id;
        },
        objectToFB: (Variation object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final skuOffset = fbb.writeString(object.sku);
          final unitOffset = fbb.writeString(object.unit);
          final tableOffset = fbb.writeString(object.table);
          final productNameOffset = fbb.writeString(object.productName);
          final taxNameOffset =
              object.taxName == null ? null : fbb.writeString(object.taxName!);
          fbb.startTable(13);
          fbb.addInt64(1, object.id);
          fbb.addOffset(2, nameOffset);
          fbb.addOffset(3, skuOffset);
          fbb.addInt64(4, object.productId);
          fbb.addOffset(5, unitOffset);
          fbb.addOffset(6, tableOffset);
          fbb.addOffset(8, productNameOffset);
          fbb.addInt64(9, object.branchId);
          fbb.addOffset(10, taxNameOffset);
          fbb.addFloat64(11, object.taxPercentage);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Variation(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              sku:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              productId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0),
              unit:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              productName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 20, ''),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0),
              taxName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              taxPercentage: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 26));

          return object;
        }),
    Category: EntityDefinition<Category>(
        model: _entities[9],
        toOneRelations: (Category object) => [],
        toManyRelations: (Category object) => {},
        getId: (Category object) => object.id,
        setId: (Category object, int id) {
          object.id = id;
        },
        objectToFB: (Category object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final channelsOffset = fbb.writeList(
              object.channels.map(fbb.writeString).toList(growable: false));
          final tableOffset = fbb.writeString(object.table);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addBool(1, object.active);
          fbb.addBool(2, object.focused);
          fbb.addOffset(3, nameOffset);
          fbb.addOffset(4, channelsOffset);
          fbb.addInt64(5, object.branchId);
          fbb.addOffset(6, tableOffset);
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
              channels: const EagerListReader<String>(fb.StringReader())
                  .vTableGet(buffer, rootOffset, 12, []),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0),
              table: const fb.StringReader()
                  .vTableGet(buffer, rootOffset, 16, ''));

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

  /// see [Branch.channels]
  static final channels =
      QueryStringVectorProperty<Branch>(_entities[0].properties[2]);

  /// see [Branch.description]
  static final description =
      QueryStringProperty<Branch>(_entities[0].properties[3]);

  /// see [Branch.name]
  static final name = QueryStringProperty<Branch>(_entities[0].properties[4]);

  /// see [Branch.businessId]
  static final businessId =
      QueryIntegerProperty<Branch>(_entities[0].properties[5]);

  /// see [Branch.longitude]
  static final longitude =
      QueryStringProperty<Branch>(_entities[0].properties[6]);

  /// see [Branch.latitude]
  static final latitude =
      QueryStringProperty<Branch>(_entities[0].properties[7]);

  /// see [Branch.table]
  static final table = QueryStringProperty<Branch>(_entities[0].properties[8]);
}

/// [Business] entity fields to define ObjectBox queries.
class Business_ {
  /// see [Business.id]
  static final id = QueryIntegerProperty<Business>(_entities[1].properties[0]);

  /// see [Business.name]
  static final name = QueryStringProperty<Business>(_entities[1].properties[1]);

  /// see [Business.latitude]
  static final latitude =
      QueryStringProperty<Business>(_entities[1].properties[2]);

  /// see [Business.longitude]
  static final longitude =
      QueryStringProperty<Business>(_entities[1].properties[3]);

  /// see [Business.channels]
  static final channels =
      QueryStringVectorProperty<Business>(_entities[1].properties[4]);

  /// see [Business.table]
  static final table =
      QueryStringProperty<Business>(_entities[1].properties[5]);

  /// see [Business.country]
  static final country =
      QueryStringProperty<Business>(_entities[1].properties[6]);

  /// see [Business.type]
  static final type = QueryStringProperty<Business>(_entities[1].properties[7]);

  /// see [Business.active]
  static final active =
      QueryBooleanProperty<Business>(_entities[1].properties[8]);

  /// see [Business.categoryId]
  static final categoryId =
      QueryIntegerProperty<Business>(_entities[1].properties[9]);
}

/// [OrderF] entity fields to define ObjectBox queries.
class OrderF_ {
  /// see [OrderF.id]
  static final id = QueryIntegerProperty<OrderF>(_entities[2].properties[0]);

  /// see [OrderF.reference]
  static final reference =
      QueryStringProperty<OrderF>(_entities[2].properties[1]);

  /// see [OrderF.orderNumber]
  static final orderNumber =
      QueryStringProperty<OrderF>(_entities[2].properties[2]);

  /// see [OrderF.branchId]
  static final branchId =
      QueryIntegerProperty<OrderF>(_entities[2].properties[3]);

  /// see [OrderF.status]
  static final status = QueryStringProperty<OrderF>(_entities[2].properties[4]);

  /// see [OrderF.orderType]
  static final orderType =
      QueryStringProperty<OrderF>(_entities[2].properties[5]);

  /// see [OrderF.active]
  static final active =
      QueryBooleanProperty<OrderF>(_entities[2].properties[6]);

  /// see [OrderF.draft]
  static final draft = QueryBooleanProperty<OrderF>(_entities[2].properties[7]);

  /// see [OrderF.subTotal]
  static final subTotal =
      QueryDoubleProperty<OrderF>(_entities[2].properties[8]);

  /// see [OrderF.paymentType]
  static final paymentType =
      QueryStringProperty<OrderF>(_entities[2].properties[9]);

  /// see [OrderF.cashReceived]
  static final cashReceived =
      QueryDoubleProperty<OrderF>(_entities[2].properties[10]);

  /// see [OrderF.customerChangeDue]
  static final customerChangeDue =
      QueryDoubleProperty<OrderF>(_entities[2].properties[11]);

  /// see [OrderF.createdAt]
  static final createdAt =
      QueryStringProperty<OrderF>(_entities[2].properties[12]);

  /// see [OrderF.updatedAt]
  static final updatedAt =
      QueryStringProperty<OrderF>(_entities[2].properties[13]);

  /// see [OrderF.table]
  static final table = QueryStringProperty<OrderF>(_entities[2].properties[14]);

  /// see [OrderF.channels]
  static final channels =
      QueryStringVectorProperty<OrderF>(_entities[2].properties[15]);
}

/// [PColor] entity fields to define ObjectBox queries.
class PColor_ {
  /// see [PColor.id]
  static final id = QueryIntegerProperty<PColor>(_entities[3].properties[0]);

  /// see [PColor.name]
  static final name = QueryStringProperty<PColor>(_entities[3].properties[1]);

  /// see [PColor.colors]
  static final colors =
      QueryStringVectorProperty<PColor>(_entities[3].properties[2]);

  /// see [PColor.table]
  static final table = QueryStringProperty<PColor>(_entities[3].properties[3]);

  /// see [PColor.branchId]
  static final branchId =
      QueryIntegerProperty<PColor>(_entities[3].properties[4]);

  /// see [PColor.active]
  static final active =
      QueryBooleanProperty<PColor>(_entities[3].properties[5]);
}

/// [Product] entity fields to define ObjectBox queries.
class Product_ {
  /// see [Product.id]
  static final id = QueryIntegerProperty<Product>(_entities[4].properties[0]);

  /// see [Product.name]
  static final name = QueryStringProperty<Product>(_entities[4].properties[1]);

  /// see [Product.description]
  static final description =
      QueryStringProperty<Product>(_entities[4].properties[2]);

  /// see [Product.channels]
  static final channels =
      QueryStringVectorProperty<Product>(_entities[4].properties[3]);

  /// see [Product.active]
  static final active =
      QueryBooleanProperty<Product>(_entities[4].properties[4]);

  /// see [Product.hasPicture]
  static final hasPicture =
      QueryBooleanProperty<Product>(_entities[4].properties[5]);

  /// see [Product.table]
  static final table = QueryStringProperty<Product>(_entities[4].properties[6]);

  /// see [Product.color]
  static final color = QueryStringProperty<Product>(_entities[4].properties[7]);

  /// see [Product.businessId]
  static final businessId =
      QueryIntegerProperty<Product>(_entities[4].properties[8]);

  /// see [Product.branchId]
  static final branchId =
      QueryIntegerProperty<Product>(_entities[4].properties[9]);

  /// see [Product.categoryId]
  static final categoryId =
      QueryStringProperty<Product>(_entities[4].properties[10]);

  /// see [Product.createdAt]
  static final createdAt =
      QueryStringProperty<Product>(_entities[4].properties[11]);

  /// see [Product.unit]
  static final unit = QueryStringProperty<Product>(_entities[4].properties[12]);

  /// see [Product.draft]
  static final draft =
      QueryBooleanProperty<Product>(_entities[4].properties[13]);

  /// see [Product.imageLocal]
  static final imageLocal =
      QueryBooleanProperty<Product>(_entities[4].properties[14]);

  /// see [Product.currentUpdate]
  static final currentUpdate =
      QueryBooleanProperty<Product>(_entities[4].properties[15]);

  /// see [Product.imageUrl]
  static final imageUrl =
      QueryStringProperty<Product>(_entities[4].properties[16]);
}

/// [Stock] entity fields to define ObjectBox queries.
class Stock_ {
  /// see [Stock.id]
  static final id = QueryIntegerProperty<Stock>(_entities[5].properties[0]);

  /// see [Stock.branchId]
  static final branchId =
      QueryIntegerProperty<Stock>(_entities[5].properties[1]);

  /// see [Stock.variantId]
  static final variantId =
      QueryIntegerProperty<Stock>(_entities[5].properties[2]);

  /// see [Stock.lowStock]
  static final lowStock =
      QueryDoubleProperty<Stock>(_entities[5].properties[3]);

  /// see [Stock.currentStock]
  static final currentStock =
      QueryDoubleProperty<Stock>(_entities[5].properties[4]);

  /// see [Stock.supplyPrice]
  static final supplyPrice =
      QueryDoubleProperty<Stock>(_entities[5].properties[5]);

  /// see [Stock.retailPrice]
  static final retailPrice =
      QueryDoubleProperty<Stock>(_entities[5].properties[6]);

  /// see [Stock.canTrackingStock]
  static final canTrackingStock =
      QueryBooleanProperty<Stock>(_entities[5].properties[7]);

  /// see [Stock.showLowStockAlert]
  static final showLowStockAlert =
      QueryBooleanProperty<Stock>(_entities[5].properties[8]);

  /// see [Stock.channels]
  static final channels =
      QueryStringVectorProperty<Stock>(_entities[5].properties[9]);

  /// see [Stock.table]
  static final table = QueryStringProperty<Stock>(_entities[5].properties[10]);

  /// see [Stock.productId]
  static final productId =
      QueryStringProperty<Stock>(_entities[5].properties[11]);

  /// see [Stock.active]
  static final active =
      QueryBooleanProperty<Stock>(_entities[5].properties[12]);

  /// see [Stock.value]
  static final value = QueryDoubleProperty<Stock>(_entities[5].properties[13]);
}

/// [Unit] entity fields to define ObjectBox queries.
class Unit_ {
  /// see [Unit.id]
  static final id = QueryIntegerProperty<Unit>(_entities[6].properties[0]);

  /// see [Unit.branchId]
  static final branchId =
      QueryIntegerProperty<Unit>(_entities[6].properties[1]);

  /// see [Unit.name]
  static final name = QueryStringProperty<Unit>(_entities[6].properties[2]);

  /// see [Unit.value]
  static final value = QueryStringProperty<Unit>(_entities[6].properties[3]);

  /// see [Unit.table]
  static final table = QueryStringProperty<Unit>(_entities[6].properties[4]);

  /// see [Unit.active]
  static final active = QueryBooleanProperty<Unit>(_entities[6].properties[5]);
}

/// [VariantStock] entity fields to define ObjectBox queries.
class VariantStock_ {
  /// see [VariantStock.id]
  static final id =
      QueryIntegerProperty<VariantStock>(_entities[7].properties[0]);

  /// see [VariantStock.canTrackingStock]
  static final canTrackingStock =
      QueryBooleanProperty<VariantStock>(_entities[7].properties[1]);

  /// see [VariantStock.retailPrice]
  static final retailPrice =
      QueryDoubleProperty<VariantStock>(_entities[7].properties[2]);

  /// see [VariantStock.productName]
  static final productName =
      QueryStringProperty<VariantStock>(_entities[7].properties[3]);

  /// see [VariantStock.variantName]
  static final variantName =
      QueryStringProperty<VariantStock>(_entities[7].properties[4]);

  /// see [VariantStock.unit]
  static final unit =
      QueryStringProperty<VariantStock>(_entities[7].properties[5]);

  /// see [VariantStock.sku]
  static final sku =
      QueryStringProperty<VariantStock>(_entities[7].properties[6]);

  /// see [VariantStock.branchId]
  static final branchId =
      QueryStringProperty<VariantStock>(_entities[7].properties[7]);

  /// see [VariantStock.lowStock]
  static final lowStock =
      QueryDoubleProperty<VariantStock>(_entities[7].properties[8]);

  /// see [VariantStock.currentStock]
  static final currentStock =
      QueryDoubleProperty<VariantStock>(_entities[7].properties[9]);

  /// see [VariantStock.variantId]
  static final variantId =
      QueryStringProperty<VariantStock>(_entities[7].properties[10]);

  /// see [VariantStock.taxName]
  static final taxName =
      QueryStringProperty<VariantStock>(_entities[7].properties[11]);

  /// see [VariantStock.taxPercentage]
  static final taxPercentage =
      QueryDoubleProperty<VariantStock>(_entities[7].properties[12]);

  /// see [VariantStock.value]
  static final value =
      QueryDoubleProperty<VariantStock>(_entities[7].properties[13]);
}

/// [Variation] entity fields to define ObjectBox queries.
class Variation_ {
  /// see [Variation.id]
  static final id = QueryIntegerProperty<Variation>(_entities[8].properties[0]);

  /// see [Variation.name]
  static final name =
      QueryStringProperty<Variation>(_entities[8].properties[1]);

  /// see [Variation.sku]
  static final sku = QueryStringProperty<Variation>(_entities[8].properties[2]);

  /// see [Variation.productId]
  static final productId =
      QueryIntegerProperty<Variation>(_entities[8].properties[3]);

  /// see [Variation.unit]
  static final unit =
      QueryStringProperty<Variation>(_entities[8].properties[4]);

  /// see [Variation.table]
  static final table =
      QueryStringProperty<Variation>(_entities[8].properties[5]);

  /// see [Variation.productName]
  static final productName =
      QueryStringProperty<Variation>(_entities[8].properties[6]);

  /// see [Variation.branchId]
  static final branchId =
      QueryIntegerProperty<Variation>(_entities[8].properties[7]);

  /// see [Variation.taxName]
  static final taxName =
      QueryStringProperty<Variation>(_entities[8].properties[8]);

  /// see [Variation.taxPercentage]
  static final taxPercentage =
      QueryDoubleProperty<Variation>(_entities[8].properties[9]);
}

/// [Category] entity fields to define ObjectBox queries.
class Category_ {
  /// see [Category.id]
  static final id = QueryIntegerProperty<Category>(_entities[9].properties[0]);

  /// see [Category.active]
  static final active =
      QueryBooleanProperty<Category>(_entities[9].properties[1]);

  /// see [Category.focused]
  static final focused =
      QueryBooleanProperty<Category>(_entities[9].properties[2]);

  /// see [Category.name]
  static final name = QueryStringProperty<Category>(_entities[9].properties[3]);

  /// see [Category.channels]
  static final channels =
      QueryStringVectorProperty<Category>(_entities[9].properties[4]);

  /// see [Category.branchId]
  static final branchId =
      QueryIntegerProperty<Category>(_entities[9].properties[5]);

  /// see [Category.table]
  static final table =
      QueryStringProperty<Category>(_entities[9].properties[6]);
}
