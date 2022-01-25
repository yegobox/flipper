// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

import 'models/io/attendance.dart';
import 'models/io/branch.dart';
import 'models/io/business.dart';
import 'models/io/category.dart';
import 'models/io/color.dart';
import 'models/io/customer.dart';
import 'models/io/discount.dart';
import 'models/io/feature.dart';
import 'models/io/menu.dart';
import 'models/io/menu_item.dart';
import 'models/io/messages/custom_message.dart';
import 'models/io/messages/file_message.dart';
import 'models/io/messages/image_message.dart';
import 'models/io/messages/text_message.dart';
import 'models/io/messages/unsupported_message.dart';
import 'models/io/order.dart';
import 'models/io/order_item.dart';
import 'models/io/permission.dart';
import 'models/io/points.dart';
import 'models/io/preview_data.dart';
import 'models/io/product.dart';
import 'models/io/product_sync.dart';
import 'models/io/profile.dart';
import 'models/io/queue_item.dart';
import 'models/io/room.dart';
import 'models/io/setting.dart';
import 'models/io/stock.dart';
import 'models/io/stock_sync.dart';
import 'models/io/subscription.dart';
import 'models/io/tenant.dart';
import 'models/io/unit.dart';
import 'models/io/user.dart';
import 'models/io/variant_stock.dart';
import 'models/io/variant_sync.dart';
import 'models/io/variants.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(3, 5565423827255398075),
      name: 'Category',
      lastPropertyId: const IdUid(6, 839494488930608489),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6166572844524838835),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 8497512475182988358),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 6013333269584782663),
            name: 'focused',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 226114923875988557),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 1452010770421762862),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 839494488930608489),
            name: 'table',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(6, 8923567203123143651),
      name: 'PColor',
      lastPropertyId: const IdUid(5, 8005312114838542673),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4938798915940775456),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 348969485833069981),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2559163111316590335),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5651005776674096158),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 8005312114838542673),
            name: 'active',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(7, 5845890317736708113),
      name: 'Product',
      lastPropertyId: const IdUid(22, 1006106377658805161),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8798820273869671283),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 7542554784794042423),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 921348977390564592),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6404605458329017975),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 988439133313179158),
            name: 'ftaxId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 8430846763619320487),
            name: 'hasPicture',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 5330951299649593925),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 3057427747011242324),
            name: 'color',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 2301753229530404939),
            name: 'fbusinessId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 4827485842564699165),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 2062975815810014056),
            name: 'fsupplierId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 7793898291358509479),
            name: 'fcategoryId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 3471030317286893475),
            name: 'createdAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 5416824713785770777),
            name: 'unit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 1204072950635681412),
            name: 'draft',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 5815720181229144018),
            name: 'imageLocal',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 4483487117614849385),
            name: 'currentUpdate',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 2874519832511923203),
            name: 'imageUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(19, 2367454108669958312),
            name: 'expiryDate',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(20, 4617414251103113403),
            name: 'barCode',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(21, 4849804124017233997),
            name: 'synced',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(22, 1006106377658805161),
            name: 'migrated',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(
            name: 'variations', srcEntity: 'Variant', srcField: 'product')
      ]),
  ModelEntity(
      id: const IdUid(8, 3913061828474354395),
      name: 'Stock',
      lastPropertyId: const IdUid(14, 4271932446860601576),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7933007739731069298),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 279770456867354145),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5423425402156617768),
            name: 'fvariantId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 8730970020748244800),
            name: 'lowStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3046407343974529960),
            name: 'currentStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 6673064127538828624),
            name: 'supplyPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 9078626669537010016),
            name: 'retailPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 4727202225484733877),
            name: 'canTrackingStock',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 41802606774617008),
            name: 'showLowStockAlert',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 8208213832563252700),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 8608034359792943596),
            name: 'fproductId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 1694206421268878275),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 8484521273202230162),
            name: 'value',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 4271932446860601576),
            name: 'migrated',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(9, 6565019670427776366),
      name: 'Unit',
      lastPropertyId: const IdUid(6, 5440869568878919547),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7402814090082366244),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 5886659743636202542),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2349653859584695779),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4902096954545063927),
            name: 'value',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 6910950920926091598),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 5440869568878919547),
            name: 'active',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(10, 4933657307635535076),
      name: 'Variant',
      lastPropertyId: const IdUid(16, 5731850409193919206),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6092087835847795173),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 9116931223574764000),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 8866937771904078289),
            name: 'sku',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6801784912515094997),
            name: 'fproductId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2141021167645892525),
            name: 'unit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4369893654969447742),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 1351559757012857628),
            name: 'productName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 6592893514153131068),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 1075929375413519648),
            name: 'taxName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 6090170047436464350),
            name: 'taxPercentage',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 7423269862003968090),
            name: 'productId',
            type: 11,
            flags: 520,
            indexId: const IdUid(2, 6401461376584828673),
            relationTarget: 'Product'),
        ModelProperty(
            id: const IdUid(12, 5142256970933196722),
            name: 'supplyPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 1043896475241337197),
            name: 'retailPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 1974517013766893630),
            name: 'synced',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 8205981515119724550),
            name: 'stockId',
            type: 11,
            flags: 520,
            indexId: const IdUid(7, 6537004545399249492),
            relationTarget: 'Stock'),
        ModelProperty(
            id: const IdUid(16, 5731850409193919206),
            name: 'migrated',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(11, 2850625522985710545),
      name: 'VariantStock',
      lastPropertyId: const IdUid(14, 3411843467028367456),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 508642288984181675),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 4035502109140422554),
            name: 'canTrackingStock',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2265592653868618009),
            name: 'retailPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4552600859137616796),
            name: 'productName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 4439514124693109118),
            name: 'variantName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 9102513164874257751),
            name: 'unit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 3496235936795809378),
            name: 'sku',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 7090354643566702947),
            name: 'fbranchId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 8856131084091443914),
            name: 'lowStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2814929952456611208),
            name: 'currentStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 19409237494060672),
            name: 'fvariantId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 8807867336732515502),
            name: 'taxName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 7785748683738187325),
            name: 'taxPercentage',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 3411843467028367456),
            name: 'value',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(13, 8608507958994323678),
      name: 'Setting',
      lastPropertyId: const IdUid(11, 570612045079703572),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5526558824753817191),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 4338414048430854855),
            name: 'email',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 4812804212630200889),
            name: 'hasPin',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1351698244747760704),
            name: 'userId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7806383220631470553),
            name: 'openReceiptFileOSaleComplete',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 5349255448948390085),
            name: 'autoPrint',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 2340950397470773920),
            name: 'defaultLanguage',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 94075064098112918),
            name: 'sendDailyReport',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 307198340603284020),
            name: 'googleSheetDocCreated',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 3207544547056251243),
            name: 'attendnaceDocCreated',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 570612045079703572),
            name: 'isAttendanceEnabled',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(17, 2390185527754733161),
      name: 'QueueItem',
      lastPropertyId: const IdUid(1, 6844216237085553109),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6844216237085553109),
            name: 'id',
            type: 6,
            flags: 129)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(19, 4060796004711362923),
      name: 'Menu',
      lastPropertyId: const IdUid(3, 8373755108464158209),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7033523545742115010),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 9216256072430743771),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 8373755108464158209),
            name: 'branchId',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(20, 6437110131636401532),
      name: 'MenuItem',
      lastPropertyId: const IdUid(2, 4059165841206996481),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5787688085998986886),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 4059165841206996481),
            name: 'variantId',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(23, 4729158566260172312),
      name: 'ProductSync',
      lastPropertyId: const IdUid(21, 693205731424624908),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6339185210410956371),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 107669325564325685),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5816890588764576710),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 3725087692717103059),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7823621305624489135),
            name: 'ftaxId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 6406765597527339250),
            name: 'hasPicture',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 5180184257779774785),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 4690992392681313028),
            name: 'color',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 2624933069032764798),
            name: 'fbusinessId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2317629345752571519),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 5225457698013589089),
            name: 'fsupplierId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 1129373110264253617),
            name: 'fcategoryId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 713411519137066591),
            name: 'createdAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 23947504320187939),
            name: 'unit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 5604501427008238670),
            name: 'draft',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 57607148966805778),
            name: 'imageLocal',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 5179057285513040365),
            name: 'currentUpdate',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 6780973621751915299),
            name: 'imageUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(19, 8112358832461613702),
            name: 'expiryDate',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(20, 8169172510142978463),
            name: 'barCode',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(21, 693205731424624908),
            name: 'synced',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(
            name: 'variations', srcEntity: 'VariantSync', srcField: 'product')
      ]),
  ModelEntity(
      id: const IdUid(24, 1396016697734703537),
      name: 'StockSync',
      lastPropertyId: const IdUid(13, 4797764362978209872),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2697769551434015049),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 2074460137377407592),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1799482468554484273),
            name: 'fvariantId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4001505053855377624),
            name: 'lowStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 8937875330454499993),
            name: 'currentStock',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3525270587137485558),
            name: 'supplyPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7440464816573706567),
            name: 'retailPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 6994032162298493384),
            name: 'canTrackingStock',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 8191371888046217420),
            name: 'showLowStockAlert',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2599794254440514805),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 37278168888551647),
            name: 'fproductId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 6902660341504054974),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 4797764362978209872),
            name: 'value',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(25, 9008887382585791467),
      name: 'VariantSync',
      lastPropertyId: const IdUid(15, 1213441688315999773),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5123601892974785376),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 5330049888976232370),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5478312253148459279),
            name: 'sku',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2750191701270054875),
            name: 'fproductId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 417193544319274492),
            name: 'unit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 2174583247716547902),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4020564562884559947),
            name: 'productName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 6557910460490535975),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 3611003924343475372),
            name: 'taxName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 6366743503036371291),
            name: 'taxPercentage',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 2971660838247353856),
            name: 'supplyPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 4007855768560997627),
            name: 'retailPrice',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 2936582224490453603),
            name: 'synced',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 2419712225250287111),
            name: 'productId',
            type: 11,
            flags: 520,
            indexId: const IdUid(8, 2843132737733191500),
            relationTarget: 'ProductSync'),
        ModelProperty(
            id: const IdUid(15, 1213441688315999773),
            name: 'stockId',
            type: 11,
            flags: 520,
            indexId: const IdUid(9, 3601746456050886700),
            relationTarget: 'StockSync')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(26, 2116764938912507291),
      name: 'Feature',
      lastPropertyId: const IdUid(3, 6530558870427213088),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6922519101132307114),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 4651114097258884269),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 6530558870427213088),
            name: 'subscriptionId',
            type: 11,
            flags: 520,
            indexId: const IdUid(11, 6769334712297225923),
            relationTarget: 'Subscription')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(27, 7175266204906428737),
      name: 'Subscription',
      lastPropertyId: const IdUid(16, 85196549376690194),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8721479677986053881),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(10, 5938941329956727071),
            name: 'interval',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 964684634408740464),
            name: 'lastBillingDate',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 4410558633674731257),
            name: 'nextBillingDate',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 1137645434896005716),
            name: 'userId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 8441056501080193378),
            name: 'descriptor',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 85196549376690194),
            name: 'recurring',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'branches', srcEntity: 'BranchSync', srcField: ''),
        ModelBacklink(name: 'features', srcEntity: 'Feature', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(28, 104399846544354437),
      name: 'BranchSync',
      lastPropertyId: const IdUid(10, 261907296654790310),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6003503010851772295),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 5125863392402394333),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5180728642591923089),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7747262085663994021),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 1330115062605746065),
            name: 'fbusinessId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 5364789031328103960),
            name: 'longitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 5419355838090947878),
            name: 'latitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 9082860793792340027),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 512168291894143574),
            name: 'productId',
            type: 11,
            flags: 520,
            indexId: const IdUid(13, 8173889520882042993),
            relationTarget: 'TenantSync'),
        ModelProperty(
            id: const IdUid(10, 261907296654790310),
            name: 'subscriptionId',
            type: 11,
            flags: 520,
            indexId: const IdUid(14, 2093560324882664154),
            relationTarget: 'Subscription')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(29, 4623860672802378337),
      name: 'Permissionsync',
      lastPropertyId: const IdUid(3, 8799863659890958118),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8742265144645804977),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 8421549601017691346),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 8799863659890958118),
            name: 'productId',
            type: 11,
            flags: 520,
            indexId: const IdUid(15, 2319047401318798482),
            relationTarget: 'TenantSync')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(30, 8334935058405755889),
      name: 'TenantSync',
      lastPropertyId: const IdUid(4, 8438062617999299653),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1547311369728045257),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 4155189713327706644),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2819134341104762860),
            name: 'phoneNumber',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 8438062617999299653),
            name: 'email',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'branches', srcEntity: 'BranchSync', srcField: ''),
        ModelBacklink(
            name: 'permissions', srcEntity: 'Permissionsync', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(31, 6994104901086262107),
      name: 'AttendanceSync',
      lastPropertyId: const IdUid(11, 1694502577252255489),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2640383573719182913),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 822548587658468116),
            name: 'businessId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 213925938816827072),
            name: 'businessName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 8368809470830874996),
            name: 'fullName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 4972555424251359936),
            name: 'phoneNumber',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 2586290742259466189),
            name: 'checkInDate',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 896190511960795386),
            name: 'checkInTime',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 1843169140259193356),
            name: 'vaccinationCode',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 6952272943942028401),
            name: 'livingAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 193102567826107076),
            name: 'cell',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 1694502577252255489),
            name: 'district',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(32, 5710758997208968802),
      name: 'Profile',
      lastPropertyId: const IdUid(18, 3218071908631529341),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7932416325005162128),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 5527880548078915313),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7258674965583313236),
            name: 'email',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4664766468940196332),
            name: 'phone',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5785841186967996944),
            name: 'address',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7699046889302917411),
            name: 'city',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 6843057711303042603),
            name: 'state',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 4801170882871412445),
            name: 'country',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 4567512607347775298),
            name: 'pincode',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 7799877844942261098),
            name: 'profilePic',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 3546302283864069861),
            name: 'coverPic',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 8846406137701696082),
            name: 'about',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 6968061476804073955),
            name: 'vaccinationCode',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 8231683406389655804),
            name: 'livingAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 6992631414272172976),
            name: 'cell',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 5508883323886967228),
            name: 'district',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 2634109851192376616),
            name: 'businessId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 3218071908631529341),
            name: 'nationalId',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(33, 3537858605744422124),
      name: 'BusinessSync',
      lastPropertyId: const IdUid(33, 8899192020956900897),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7723083171213634466),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 5580393665509422728),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5913111378662474875),
            name: 'currency',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2459722284715628295),
            name: 'fcategoryId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 8423666441285824171),
            name: 'latitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 1591942368137375881),
            name: 'longitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4529376522265253051),
            name: 'userId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 1939111533578277831),
            name: 'typeId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 3707614668959979563),
            name: 'timeZone',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 973766159809940064),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 2336512808066034621),
            name: 'country',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 3093236128607765004),
            name: 'businessUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 6991256172049301479),
            name: 'hexColor',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 5500987326368576186),
            name: 'imageUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 1871221462192042432),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 6653295987432925995),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 850519381302093437),
            name: 'chatUid',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 8907776539412007933),
            name: 'metadata',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(19, 8179135668104941328),
            name: 'role',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(20, 3611102233803116064),
            name: 'lastSeen',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(21, 2199975136340602469),
            name: 'firstName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(22, 6572914686353135264),
            name: 'lastName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(23, 1553875324487335640),
            name: 'createdAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(24, 6836976043660356520),
            name: 'deviceToken',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(25, 897024330503634148),
            name: 'backUpEnabled',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(26, 8442442292693595710),
            name: 'subscriptionPlan',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(27, 5690515673681742758),
            name: 'nextBillingDate',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(28, 8487858701810847249),
            name: 'previousBillingDate',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(29, 3217316458127128104),
            name: 'isLastSubscriptionPaymentSucceeded',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(30, 5676895361323496379),
            name: 'backupFileId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(31, 6852940252031360213),
            name: 'email',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(32, 2497532726676108632),
            name: 'lastDbBackup',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(33, 8899192020956900897),
            name: 'fullName',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(34, 2010227379520065217),
      name: 'CustomerSync',
      lastPropertyId: const IdUid(8, 5966066383058134265),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1579692867507663996),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 8544445958336758086),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7457095083041952469),
            name: 'email',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4685939583090913659),
            name: 'phone',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5957618899926022571),
            name: 'address',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 8616584725274052155),
            name: 'orderId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 6382617148784104533),
            name: 'branchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 5966066383058134265),
            name: 'updatedAt',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(35, 3651953781902515209),
      name: 'DiscountSync',
      lastPropertyId: const IdUid(4, 3019707222472341277),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 3427481464446697479),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 1800895683925315889),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7884335484268918730),
            name: 'amount',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 3019707222472341277),
            name: 'branchId',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(36, 8300612590668121904),
      name: 'OrderFSync',
      lastPropertyId: const IdUid(18, 7282003458733039655),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7171927501030544852),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 5293196546757580794),
            name: 'reference',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 8762439467170688472),
            name: 'orderNumber',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7169856235194622664),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3154934110505449916),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 6285345585236645703),
            name: 'orderType',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 5351302479168840420),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 4901605509532004242),
            name: 'draft',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 2375812992962058511),
            name: 'subTotal',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 7394388341126911123),
            name: 'paymentType',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 397476342211646851),
            name: 'cashReceived',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 2694253059846961626),
            name: 'customerChangeDue',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 3700949680150273486),
            name: 'createdAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 4905737307244641576),
            name: 'updatedAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 8189043541478044903),
            name: 'reported',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 5431818895412167319),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 4245365781529466416),
            name: 'customerId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 7282003458733039655),
            name: 'note',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(
            name: 'orderItems', srcEntity: 'OrderItemSync', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(37, 7900717241085384382),
      name: 'OrderItemSync',
      lastPropertyId: const IdUid(13, 4268217569217528073),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 774243066468700097),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 3311259426492842424),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5076135189654145835),
            name: 'forderId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7223492804085271238),
            name: 'fvariantId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3423544430418143933),
            name: 'count',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 206220114557005778),
            name: 'price',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4955885149592402075),
            name: 'discount',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 3493237767333846648),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 8338249261634162869),
            name: 'reported',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 8758506536392346851),
            name: 'remainingStock',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 2036493952963612336),
            name: 'createdAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 6073404193101160016),
            name: 'updatedAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 4268217569217528073),
            name: 'orderId',
            type: 11,
            flags: 520,
            indexId: const IdUid(16, 8687850359067562101),
            relationTarget: 'OrderFSync')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(38, 5864147949600129001),
      name: 'PreviewData',
      lastPropertyId: const IdUid(4, 855042236157092587),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6127336819965838950),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 7588196427642802977),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5849406671766211717),
            name: 'link',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 855042236157092587),
            name: 'title',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(39, 7893332167285641887),
      name: 'PreviewDataImage',
      lastPropertyId: const IdUid(4, 7073265581529736937),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6285032625119161750),
            name: 'height',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(2, 2819094358319337663),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(3, 184012149744200265),
            name: 'url',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7073265581529736937),
            name: 'width',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(40, 4865456693420792793),
      name: 'TextMessage',
      lastPropertyId: const IdUid(3, 901170917895168557),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6172346381366546982),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 2142857935343247943),
            name: 'text',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 901170917895168557),
            name: 'authorId',
            type: 11,
            flags: 520,
            indexId: const IdUid(17, 5687507317945919259),
            relationTarget: 'User')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(41, 1714125418496949631),
      name: 'User',
      lastPropertyId: const IdUid(8, 2621378261166509455),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6712385899440820383),
            name: 'createdAt',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(2, 5806413000222455368),
            name: 'firstName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3450089860817585757),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(4, 2300699355259697135),
            name: 'imageUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2132506993287245279),
            name: 'lastName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 5302852606533722390),
            name: 'lastSeen',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 6079552169877417955),
            name: 'updatedAt',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 2621378261166509455),
            name: 'roleOB',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(42, 414435934238154790),
      name: 'UnsupportedMessage',
      lastPropertyId: const IdUid(2, 6235887728588116380),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 9121325195069065192),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 6235887728588116380),
            name: 'authorId',
            type: 11,
            flags: 520,
            indexId: const IdUid(18, 6577575286762513742),
            relationTarget: 'User')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(43, 8749364562486540267),
      name: 'ImageMessage',
      lastPropertyId: const IdUid(7, 6108075157618586459),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 9208808248765371729),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 6211445320976562188),
            name: 'authorId',
            type: 11,
            flags: 520,
            indexId: const IdUid(19, 3653128988915256862),
            relationTarget: 'User'),
        ModelProperty(
            id: const IdUid(3, 8816273344058262414),
            name: 'height',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1730686880223938213),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 6679003424415361709),
            name: 'uri',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3918917123981681097),
            name: 'width',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 6108075157618586459),
            name: 'size',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(44, 7250587449633592557),
      name: 'CustomMessage',
      lastPropertyId: const IdUid(2, 6161219169731528913),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 782107273252366566),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 6161219169731528913),
            name: 'authorId',
            type: 11,
            flags: 520,
            indexId: const IdUid(20, 7567374990672720261),
            relationTarget: 'User')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(45, 9212524460634426469),
      name: 'FileMessage',
      lastPropertyId: const IdUid(6, 8933162747665031179),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5616284763597004318),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 2218960873782545172),
            name: 'authorId',
            type: 11,
            flags: 520,
            indexId: const IdUid(21, 6996790652084639492),
            relationTarget: 'User'),
        ModelProperty(
            id: const IdUid(3, 7909015278468011828),
            name: 'mimeType',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5457063111312600996),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5401611648409347909),
            name: 'uri',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 8933162747665031179),
            name: 'size',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(46, 2111678833425351392),
      name: 'Room',
      lastPropertyId: const IdUid(6, 3118303428111428704),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 3203067045577904616),
            name: 'createdAt',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(2, 7807913623314123052),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(3, 3761175964788648431),
            name: 'imageUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 3042127263896772965),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 1005847665072727651),
            name: 'updatedAt',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3118303428111428704),
            name: 'roleOB',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(1, 7692477632100059163),
            name: 'users',
            targetId: const IdUid(41, 1714125418496949631))
      ],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(47, 6429820227051649226),
      name: 'Points',
      lastPropertyId: const IdUid(3, 3160516613104491437),
      flags: 2,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6789857518950182227),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 4543572951507226300),
            name: 'value',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3160516613104491437),
            name: 'userId',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Store openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) =>
    Store(getObjectBoxModel(),
        directory: directory,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(47, 6429820227051649226),
      lastIndexId: const IdUid(21, 6996790652084639492),
      lastRelationId: const IdUid(1, 7692477632100059163),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [
        4864448714320732391,
        4376661028792560785,
        3720718583109769721,
        5247681858792538860,
        2865100998343489519,
        1236114536079259166,
        5570813440444123608,
        587125237409554238,
        5013621342623573944,
        917808743332577379,
        1485111935930131080
      ],
      retiredIndexUids: const [3253799497487419212, 7175803068277656231],
      retiredPropertyUids: const [
        1718505003743814710,
        938205566050096652,
        6311916302122232138,
        6932238253732696423,
        3792350989547430964,
        1098149876836892244,
        329309886203959362,
        7387474418444201850,
        819227061083687997,
        55405895619852984,
        2670733005554439365,
        8331604158242099606,
        4796677840836439695,
        1419114602383354089,
        8363396674005275854,
        391353200972426069,
        3360850122243914619,
        3855423874897767370,
        1445859498689750628,
        5963160911027895707,
        72354741350138443,
        1863989441339731502,
        2952392917342526866,
        6810415352486148878,
        68989089854705585,
        2317708520044334047,
        6267003748452942371,
        3450587522083350737,
        4517554220088387833,
        395352926817028912,
        1972169772672690019,
        7662979715228083784,
        8845395444952707951,
        638707392482599773,
        4002028592029319231,
        7653326773485789521,
        1384377141074605577,
        3667099911727522740,
        4091547806216095032,
        1264742721127655554,
        4366583688005294356,
        7150709947764719255,
        7338918778262647527,
        6899584005705309920,
        7446188222764846812,
        1129869352289449940,
        245127506432029189,
        6192820646280833149,
        7678148692431630189,
        7502319348689109437,
        5432779492653460309,
        4998914939866376922,
        7554971826203067126,
        6618164166361466925,
        8577392346534076859,
        1308004300690162015,
        7935104562269846262,
        5989110326798299707,
        307297663923335262,
        9158620068473699373,
        5806007020145977170,
        5463609435049086704,
        1278202304031278496,
        2101408374380372529,
        5348406758024782343,
        3713089851155268736,
        8392855964498574230,
        4546554080487738070,
        3192194834539283051,
        2803303694211390632,
        697434406173511171,
        1233285787693282103,
        5778787744536565425,
        7089179496554694098,
        6547666586400288120,
        534507988579705009,
        2258093142159938853,
        2300166293136834201,
        2888003912419385545,
        7904465183088159069,
        8237020161125066877,
        611157274690380379,
        8715641323900221077,
        3814381944437835608,
        1374481480998901288,
        1518902672174544810,
        8655992809401730659,
        7116491184838322897,
        8969387789896710844,
        86536299062929500,
        88706347221077565,
        195264200013359891,
        4542730526473935887,
        8708948374178397045,
        2391486744497665525,
        8811824834752705077,
        573566445840738309,
        3291856998242083601,
        4194968844165436425,
        2729430775340363747,
        4411823794679308743,
        2869323377143838880,
        2070918125028837887,
        4876468586823146665,
        8439964586178305954,
        2114727522821621245,
        60128949728398961,
        2005919781413990613,
        293479963573078369,
        913492185094278993,
        2310912031409828321,
        1298444245831708717,
        531175659311498591,
        7320600146768266036,
        3487905289932526524,
        8344108078880967040,
        2397737952779016538,
        4566951035167016343,
        1390259137585875989,
        1947394661997474338,
        2,
        8074429391081551579,
        1,
        412268228015472147,
        3550400819773032582,
        6952405727114646126,
        1210769162470646879,
        1832585454190011486,
        2033045415914865953,
        8949027605740184096,
        2393751583070263733,
        5839353688525412021,
        115682919560546987,
        1421381851867583644,
        8062944332124432080,
        8408422868540398686,
        3062323287516113608,
        24616322612662045,
        4131698414439769805,
        8534919517047473024,
        4533874225416609274,
        8694540896149095557,
        2728016189115657858,
        2819440541363792116,
        7102121586274027735,
        1229882035248399785,
        7139870852818556577,
        4458200207503106106,
        1082266041306973956,
        8368534671796460515,
        5095827733765887974
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Category: EntityDefinition<Category>(
        model: _entities[0],
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
    PColor: EntityDefinition<PColor>(
        model: _entities[1],
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
              fbranchId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 12, false));

          return object;
        }),
    Product: EntityDefinition<Product>(
        model: _entities[2],
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
          final fcategoryIdOffset = object.fcategoryId == null
              ? null
              : fbb.writeString(object.fcategoryId!);
          final createdAtOffset = object.createdAt == null
              ? null
              : fbb.writeString(object.createdAt!);
          final unitOffset = fbb.writeString(object.unit);
          final imageUrlOffset = object.imageUrl == null
              ? null
              : fbb.writeString(object.imageUrl!);
          final expiryDateOffset = object.expiryDate == null
              ? null
              : fbb.writeString(object.expiryDate!);
          final barCodeOffset =
              object.barCode == null ? null : fbb.writeString(object.barCode!);
          fbb.startTable(23);
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
          fbb.addOffset(18, expiryDateOffset);
          fbb.addOffset(19, barCodeOffset);
          fbb.addBool(20, object.synced);
          fbb.addBool(21, object.migrated);
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
              fcategoryId: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 26),
              createdAt: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 28),
              unit:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 30, ''),
              draft: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 32),
              imageLocal:
                  const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 34),
              currentUpdate: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 36),
              expiryDate: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 40),
              barCode: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 42),
              synced: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 44),
              migrated: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 46),
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
        model: _entities[3],
        toOneRelations: (Stock object) => [],
        toManyRelations: (Stock object) => {},
        getId: (Stock object) => object.id,
        setId: (Stock object, int id) {
          object.id = id;
        },
        objectToFB: (Stock object, fb.Builder fbb) {
          final tableOffset = fbb.writeString(object.table);
          fbb.startTable(15);
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
          fbb.addBool(13, object.migrated);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Stock(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              fbranchId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 6),
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
              value:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 28, 0),
              migrated: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 30));

          return object;
        }),
    Unit: EntityDefinition<Unit>(
        model: _entities[4],
        toOneRelations: (Unit object) => [],
        toManyRelations: (Unit object) => {},
        getId: (Unit object) => object.id,
        setId: (Unit object, int id) {
          object.id = id;
        },
        objectToFB: (Unit object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final valueOffset = fbb.writeString(object.value);
          final tableOffset = fbb.writeString(object.table);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.fbranchId);
          fbb.addOffset(2, nameOffset);
          fbb.addOffset(3, valueOffset);
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
              fbranchId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              value:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 14, false));

          return object;
        }),
    Variant: EntityDefinition<Variant>(
        model: _entities[5],
        toOneRelations: (Variant object) => [object.product, object.stock],
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
          fbb.startTable(17);
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
          fbb.addFloat64(11, object.supplyPrice);
          fbb.addFloat64(12, object.retailPrice);
          fbb.addBool(13, object.synced);
          fbb.addInt64(14, object.stock.targetId);
          fbb.addBool(15, object.migrated);
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
              supplyPrice:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 26, 0),
              retailPrice:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 28, 0),
              productName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              fbranchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0),
              synced: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 30),
              migrated: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 34),
              taxName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              taxPercentage: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 22));
          object.product.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 24, 0);
          object.product.attach(store);
          object.stock.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 32, 0);
          object.stock.attach(store);
          return object;
        }),
    VariantStock: EntityDefinition<VariantStock>(
        model: _entities[6],
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
        }),
    Setting: EntityDefinition<Setting>(
        model: _entities[7],
        toOneRelations: (Setting object) => [],
        toManyRelations: (Setting object) => {},
        getId: (Setting object) => object.id,
        setId: (Setting object, int id) {
          object.id = id;
        },
        objectToFB: (Setting object, fb.Builder fbb) {
          final emailOffset = fbb.writeString(object.email);
          final hasPinOffset = fbb.writeString(object.hasPin);
          final defaultLanguageOffset = object.defaultLanguage == null
              ? null
              : fbb.writeString(object.defaultLanguage!);
          fbb.startTable(12);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, emailOffset);
          fbb.addOffset(2, hasPinOffset);
          fbb.addInt64(3, object.userId);
          fbb.addBool(4, object.openReceiptFileOSaleComplete);
          fbb.addBool(5, object.autoPrint);
          fbb.addOffset(6, defaultLanguageOffset);
          fbb.addBool(7, object.sendDailyReport);
          fbb.addBool(8, object.googleSheetDocCreated);
          fbb.addBool(9, object.attendnaceDocCreated);
          fbb.addBool(10, object.isAttendanceEnabled);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Setting(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              email:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              hasPin:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              autoPrint: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 14),
              openReceiptFileOSaleComplete: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              sendDailyReport: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              defaultLanguage: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              googleSheetDocCreated: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              userId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0),
              attendnaceDocCreated: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 22),
              isAttendanceEnabled: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 24));

          return object;
        }),
    QueueItem: EntityDefinition<QueueItem>(
        model: _entities[8],
        toOneRelations: (QueueItem object) => [],
        toManyRelations: (QueueItem object) => {},
        getId: (QueueItem object) => object.id,
        setId: (QueueItem object, int id) {
          object.id = id;
        },
        objectToFB: (QueueItem object, fb.Builder fbb) {
          fbb.startTable(2);
          fbb.addInt64(0, object.id);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = QueueItem(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));

          return object;
        }),
    Menu: EntityDefinition<Menu>(
        model: _entities[9],
        toOneRelations: (Menu object) => [],
        toManyRelations: (Menu object) => {},
        getId: (Menu object) => object.id,
        setId: (Menu object, int id) {
          object.id = id;
        },
        objectToFB: (Menu object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.branchId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Menu(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));

          return object;
        }),
    MenuItem: EntityDefinition<MenuItem>(
        model: _entities[10],
        toOneRelations: (MenuItem object) => [],
        toManyRelations: (MenuItem object) => {},
        getId: (MenuItem object) => object.id,
        setId: (MenuItem object, int id) {
          object.id = id;
        },
        objectToFB: (MenuItem object, fb.Builder fbb) {
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.variantId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = MenuItem(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              variantId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));

          return object;
        }),
    ProductSync: EntityDefinition<ProductSync>(
        model: _entities[11],
        toOneRelations: (ProductSync object) => [],
        toManyRelations: (ProductSync object) => {
              RelInfo<VariantSync>.toOneBacklink(14, object.id,
                      (VariantSync srcObject) => srcObject.product):
                  object.variations
            },
        getId: (ProductSync object) => object.id,
        setId: (ProductSync object, int id) {
          object.id = id;
        },
        objectToFB: (ProductSync object, fb.Builder fbb) {
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
          final fcategoryIdOffset = object.fcategoryId == null
              ? null
              : fbb.writeString(object.fcategoryId!);
          final createdAtOffset = object.createdAt == null
              ? null
              : fbb.writeString(object.createdAt!);
          final unitOffset = fbb.writeString(object.unit);
          final imageUrlOffset = object.imageUrl == null
              ? null
              : fbb.writeString(object.imageUrl!);
          final expiryDateOffset = object.expiryDate == null
              ? null
              : fbb.writeString(object.expiryDate!);
          final barCodeOffset =
              object.barCode == null ? null : fbb.writeString(object.barCode!);
          fbb.startTable(22);
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
          fbb.addOffset(18, expiryDateOffset);
          fbb.addOffset(19, barCodeOffset);
          fbb.addBool(20, object.synced);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ProductSync(
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
              fcategoryId: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 26),
              createdAt: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 28),
              unit:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 30, ''),
              draft: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 32),
              imageLocal:
                  const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 34),
              currentUpdate: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 36),
              expiryDate: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 40),
              barCode: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 42),
              synced: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 44),
              imageUrl: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 38));
          InternalToManyAccess.setRelInfo(
              object.variations,
              store,
              RelInfo<VariantSync>.toOneBacklink(
                  14, object.id, (VariantSync srcObject) => srcObject.product),
              store.box<ProductSync>());
          return object;
        }),
    StockSync: EntityDefinition<StockSync>(
        model: _entities[12],
        toOneRelations: (StockSync object) => [],
        toManyRelations: (StockSync object) => {},
        getId: (StockSync object) => object.id,
        setId: (StockSync object, int id) {
          object.id = id;
        },
        objectToFB: (StockSync object, fb.Builder fbb) {
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

          final object = StockSync(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              fbranchId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 6),
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
    VariantSync: EntityDefinition<VariantSync>(
        model: _entities[13],
        toOneRelations: (VariantSync object) => [object.product, object.stock],
        toManyRelations: (VariantSync object) => {},
        getId: (VariantSync object) => object.id,
        setId: (VariantSync object, int id) {
          object.id = id;
        },
        objectToFB: (VariantSync object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final skuOffset = fbb.writeString(object.sku);
          final unitOffset = fbb.writeString(object.unit);
          final tableOffset = fbb.writeString(object.table);
          final productNameOffset = fbb.writeString(object.productName);
          final taxNameOffset =
              object.taxName == null ? null : fbb.writeString(object.taxName!);
          fbb.startTable(16);
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
          fbb.addFloat64(10, object.supplyPrice);
          fbb.addFloat64(11, object.retailPrice);
          fbb.addBool(12, object.synced);
          fbb.addInt64(13, object.product.targetId);
          fbb.addInt64(14, object.stock.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = VariantSync(
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
              supplyPrice:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 24, 0),
              retailPrice:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 26, 0),
              productName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              fbranchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0),
              synced: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 28),
              taxName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              taxPercentage: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 22));
          object.product.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 30, 0);
          object.product.attach(store);
          object.stock.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 32, 0);
          object.stock.attach(store);
          return object;
        }),
    Feature: EntityDefinition<Feature>(
        model: _entities[14],
        toOneRelations: (Feature object) => [object.subscription],
        toManyRelations: (Feature object) => {},
        getId: (Feature object) => object.id,
        setId: (Feature object, int id) {
          object.id = id;
        },
        objectToFB: (Feature object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.subscription.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Feature(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''));
          object.subscription.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          object.subscription.attach(store);
          return object;
        }),
    Subscription: EntityDefinition<Subscription>(
        model: _entities[15],
        toOneRelations: (Subscription object) => [],
        toManyRelations: (Subscription object) => {
              RelInfo<BranchSync>.toOneBacklink(10, object.id,
                      (BranchSync srcObject) => srcObject.subscription):
                  object.branches,
              RelInfo<Feature>.toOneBacklink(3, object.id,
                      (Feature srcObject) => srcObject.subscription):
                  object.features
            },
        getId: (Subscription object) => object.id,
        setId: (Subscription object, int id) {
          object.id = id;
        },
        objectToFB: (Subscription object, fb.Builder fbb) {
          final lastBillingDateOffset = fbb.writeString(object.lastBillingDate);
          final nextBillingDateOffset = fbb.writeString(object.nextBillingDate);
          final descriptorOffset = fbb.writeString(object.descriptor);
          fbb.startTable(17);
          fbb.addInt64(0, object.id);
          fbb.addInt64(9, object.interval);
          fbb.addOffset(10, lastBillingDateOffset);
          fbb.addOffset(11, nextBillingDateOffset);
          fbb.addInt64(12, object.userId);
          fbb.addOffset(14, descriptorOffset);
          fbb.addFloat64(15, object.recurring);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Subscription(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              interval:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0),
              lastBillingDate:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 24, ''),
              nextBillingDate:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 26, ''),
              userId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 28, 0),
              recurring:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 34, 0),
              descriptor: const fb.StringReader()
                  .vTableGet(buffer, rootOffset, 32, ''));
          InternalToManyAccess.setRelInfo(
              object.branches,
              store,
              RelInfo<BranchSync>.toOneBacklink(10, object.id,
                  (BranchSync srcObject) => srcObject.subscription),
              store.box<Subscription>());
          InternalToManyAccess.setRelInfo(
              object.features,
              store,
              RelInfo<Feature>.toOneBacklink(
                  3, object.id, (Feature srcObject) => srcObject.subscription),
              store.box<Subscription>());
          return object;
        }),
    BranchSync: EntityDefinition<BranchSync>(
        model: _entities[16],
        toOneRelations: (BranchSync object) =>
            [object.product, object.subscription],
        toManyRelations: (BranchSync object) => {},
        getId: (BranchSync object) => object.id,
        setId: (BranchSync object, int id) {
          object.id = id;
        },
        objectToFB: (BranchSync object, fb.Builder fbb) {
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
          fbb.addInt64(0, object.id);
          fbb.addBool(1, object.active);
          fbb.addOffset(2, descriptionOffset);
          fbb.addOffset(3, nameOffset);
          fbb.addInt64(4, object.fbusinessId);
          fbb.addOffset(5, longitudeOffset);
          fbb.addOffset(6, latitudeOffset);
          fbb.addOffset(7, tableOffset);
          fbb.addInt64(8, object.product.targetId);
          fbb.addInt64(9, object.subscription.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = BranchSync(
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
          object.product.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0);
          object.product.attach(store);
          object.subscription.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0);
          object.subscription.attach(store);
          return object;
        }),
    Permissionsync: EntityDefinition<Permissionsync>(
        model: _entities[17],
        toOneRelations: (Permissionsync object) => [object.product],
        toManyRelations: (Permissionsync object) => {},
        getId: (Permissionsync object) => object.id,
        setId: (Permissionsync object, int id) {
          object.id = id;
        },
        objectToFB: (Permissionsync object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.product.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Permissionsync(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''));
          object.product.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          object.product.attach(store);
          return object;
        }),
    TenantSync: EntityDefinition<TenantSync>(
        model: _entities[18],
        toOneRelations: (TenantSync object) => [],
        toManyRelations: (TenantSync object) => {
              RelInfo<BranchSync>.toOneBacklink(9, object.id,
                  (BranchSync srcObject) => srcObject.product): object.branches,
              RelInfo<Permissionsync>.toOneBacklink(3, object.id,
                      (Permissionsync srcObject) => srcObject.product):
                  object.permissions
            },
        getId: (TenantSync object) => object.id,
        setId: (TenantSync object, int id) {
          object.id = id;
        },
        objectToFB: (TenantSync object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final phoneNumberOffset = fbb.writeString(object.phoneNumber);
          final emailOffset = fbb.writeString(object.email);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, phoneNumberOffset);
          fbb.addOffset(3, emailOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = TenantSync(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              phoneNumber:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              email: const fb.StringReader()
                  .vTableGet(buffer, rootOffset, 10, ''));
          InternalToManyAccess.setRelInfo(
              object.branches,
              store,
              RelInfo<BranchSync>.toOneBacklink(
                  9, object.id, (BranchSync srcObject) => srcObject.product),
              store.box<TenantSync>());
          InternalToManyAccess.setRelInfo(
              object.permissions,
              store,
              RelInfo<Permissionsync>.toOneBacklink(3, object.id,
                  (Permissionsync srcObject) => srcObject.product),
              store.box<TenantSync>());
          return object;
        }),
    AttendanceSync: EntityDefinition<AttendanceSync>(
        model: _entities[19],
        toOneRelations: (AttendanceSync object) => [],
        toManyRelations: (AttendanceSync object) => {},
        getId: (AttendanceSync object) => object.id,
        setId: (AttendanceSync object, int id) {
          object.id = id;
        },
        objectToFB: (AttendanceSync object, fb.Builder fbb) {
          final businessNameOffset = fbb.writeString(object.businessName);
          final fullNameOffset = fbb.writeString(object.fullName);
          final phoneNumberOffset = fbb.writeString(object.phoneNumber);
          final checkInDateOffset = fbb.writeString(object.checkInDate);
          final checkInTimeOffset = fbb.writeString(object.checkInTime);
          final vaccinationCodeOffset = fbb.writeString(object.vaccinationCode);
          final livingAtOffset = fbb.writeString(object.livingAt);
          final cellOffset = fbb.writeString(object.cell);
          final districtOffset = fbb.writeString(object.district);
          fbb.startTable(12);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.businessId);
          fbb.addOffset(2, businessNameOffset);
          fbb.addOffset(3, fullNameOffset);
          fbb.addOffset(4, phoneNumberOffset);
          fbb.addOffset(5, checkInDateOffset);
          fbb.addOffset(6, checkInTimeOffset);
          fbb.addOffset(7, vaccinationCodeOffset);
          fbb.addOffset(8, livingAtOffset);
          fbb.addOffset(9, cellOffset);
          fbb.addOffset(10, districtOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = AttendanceSync(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              businessId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              businessName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              fullName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              phoneNumber:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              checkInDate:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              checkInTime:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              vaccinationCode:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 18, ''),
              livingAt:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 20, ''),
              cell:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 22, ''),
              district: const fb.StringReader()
                  .vTableGet(buffer, rootOffset, 24, ''));

          return object;
        }),
    Profile: EntityDefinition<Profile>(
        model: _entities[20],
        toOneRelations: (Profile object) => [],
        toManyRelations: (Profile object) => {},
        getId: (Profile object) => object.id,
        setId: (Profile object, int id) {
          object.id = id;
        },
        objectToFB: (Profile object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final emailOffset = fbb.writeString(object.email);
          final phoneOffset = fbb.writeString(object.phone);
          final addressOffset =
              object.address == null ? null : fbb.writeString(object.address!);
          final cityOffset =
              object.city == null ? null : fbb.writeString(object.city!);
          final stateOffset =
              object.state == null ? null : fbb.writeString(object.state!);
          final countryOffset = fbb.writeString(object.country);
          final pincodeOffset =
              object.pincode == null ? null : fbb.writeString(object.pincode!);
          final profilePicOffset = object.profilePic == null
              ? null
              : fbb.writeString(object.profilePic!);
          final coverPicOffset = object.coverPic == null
              ? null
              : fbb.writeString(object.coverPic!);
          final aboutOffset =
              object.about == null ? null : fbb.writeString(object.about!);
          final vaccinationCodeOffset = fbb.writeString(object.vaccinationCode);
          final livingAtOffset = fbb.writeString(object.livingAt);
          final cellOffset = fbb.writeString(object.cell);
          final districtOffset = fbb.writeString(object.district);
          final nationalIdOffset = fbb.writeString(object.nationalId);
          fbb.startTable(19);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, emailOffset);
          fbb.addOffset(3, phoneOffset);
          fbb.addOffset(4, addressOffset);
          fbb.addOffset(5, cityOffset);
          fbb.addOffset(6, stateOffset);
          fbb.addOffset(7, countryOffset);
          fbb.addOffset(8, pincodeOffset);
          fbb.addOffset(9, profilePicOffset);
          fbb.addOffset(10, coverPicOffset);
          fbb.addOffset(11, aboutOffset);
          fbb.addOffset(12, vaccinationCodeOffset);
          fbb.addOffset(13, livingAtOffset);
          fbb.addOffset(14, cellOffset);
          fbb.addOffset(15, districtOffset);
          fbb.addInt64(16, object.businessId);
          fbb.addOffset(17, nationalIdOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Profile(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              email:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              phone:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              address: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              city: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 14),
              state: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              country:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 18, ''),
              pincode: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              profilePic: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 22),
              coverPic: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              about: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 26),
              vaccinationCode:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 28, ''),
              livingAt:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 30, ''),
              cell:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 32, ''),
              district:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 34, ''),
              businessId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 36, 0),
              nationalId: const fb.StringReader().vTableGet(buffer, rootOffset, 38, ''));

          return object;
        }),
    BusinessSync: EntityDefinition<BusinessSync>(
        model: _entities[21],
        toOneRelations: (BusinessSync object) => [],
        toManyRelations: (BusinessSync object) => {},
        getId: (BusinessSync object) => object.id,
        setId: (BusinessSync object, int id) {
          object.id = id;
        },
        objectToFB: (BusinessSync object, fb.Builder fbb) {
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
          final tableOffset =
              object.table == null ? null : fbb.writeString(object.table!);
          final countryOffset = fbb.writeString(object.country);
          final businessUrlOffset = object.businessUrl == null
              ? null
              : fbb.writeString(object.businessUrl!);
          final hexColorOffset = object.hexColor == null
              ? null
              : fbb.writeString(object.hexColor!);
          final imageUrlOffset = object.imageUrl == null
              ? null
              : fbb.writeString(object.imageUrl!);
          final typeOffset = fbb.writeString(object.type);
          final chatUidOffset =
              object.chatUid == null ? null : fbb.writeString(object.chatUid!);
          final metadataOffset = object.metadata == null
              ? null
              : fbb.writeString(object.metadata!);
          final roleOffset =
              object.role == null ? null : fbb.writeString(object.role!);
          final firstNameOffset = object.firstName == null
              ? null
              : fbb.writeString(object.firstName!);
          final lastNameOffset = object.lastName == null
              ? null
              : fbb.writeString(object.lastName!);
          final createdAtOffset = object.createdAt == null
              ? null
              : fbb.writeString(object.createdAt!);
          final deviceTokenOffset = object.deviceToken == null
              ? null
              : fbb.writeString(object.deviceToken!);
          final subscriptionPlanOffset = object.subscriptionPlan == null
              ? null
              : fbb.writeString(object.subscriptionPlan!);
          final nextBillingDateOffset = object.nextBillingDate == null
              ? null
              : fbb.writeString(object.nextBillingDate!);
          final previousBillingDateOffset = object.previousBillingDate == null
              ? null
              : fbb.writeString(object.previousBillingDate!);
          final backupFileIdOffset = object.backupFileId == null
              ? null
              : fbb.writeString(object.backupFileId!);
          final emailOffset =
              object.email == null ? null : fbb.writeString(object.email!);
          final lastDbBackupOffset = object.lastDbBackup == null
              ? null
              : fbb.writeString(object.lastDbBackup!);
          final fullNameOffset = object.fullName == null
              ? null
              : fbb.writeString(object.fullName!);
          fbb.startTable(34);
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
          fbb.addOffset(13, imageUrlOffset);
          fbb.addOffset(14, typeOffset);
          fbb.addBool(15, object.active);
          fbb.addOffset(16, chatUidOffset);
          fbb.addOffset(17, metadataOffset);
          fbb.addOffset(18, roleOffset);
          fbb.addInt64(19, object.lastSeen);
          fbb.addOffset(20, firstNameOffset);
          fbb.addOffset(21, lastNameOffset);
          fbb.addOffset(22, createdAtOffset);
          fbb.addOffset(23, deviceTokenOffset);
          fbb.addBool(24, object.backUpEnabled);
          fbb.addOffset(25, subscriptionPlanOffset);
          fbb.addOffset(26, nextBillingDateOffset);
          fbb.addOffset(27, previousBillingDateOffset);
          fbb.addBool(28, object.isLastSubscriptionPaymentSucceeded);
          fbb.addOffset(29, backupFileIdOffset);
          fbb.addOffset(30, emailOffset);
          fbb.addOffset(31, lastDbBackupOffset);
          fbb.addOffset(32, fullNameOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = BusinessSync(
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
              table: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 22),
              country:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 24, ''),
              businessUrl: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 26),
              hexColor: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 28),
              imageUrl: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 30),
              type: const fb.StringReader().vTableGet(buffer, rootOffset, 32, ''),
              active: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 34),
              metadata: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 38),
              lastSeen: const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 42),
              firstName: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 44),
              lastName: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 46),
              deviceToken: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 50),
              chatUid: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 36),
              backUpEnabled: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 52),
              subscriptionPlan: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 54),
              nextBillingDate: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 56),
              previousBillingDate: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 58),
              isLastSubscriptionPaymentSucceeded: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 60),
              backupFileId: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 62),
              email: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 64),
              lastDbBackup: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 66),
              fullName: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 68),
              role: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 40))
            ..createdAt = const fb.StringReader().vTableGetNullable(buffer, rootOffset, 48);

          return object;
        }),
    CustomerSync: EntityDefinition<CustomerSync>(
        model: _entities[22],
        toOneRelations: (CustomerSync object) => [],
        toManyRelations: (CustomerSync object) => {},
        getId: (CustomerSync object) => object.id,
        setId: (CustomerSync object, int id) {
          object.id = id;
        },
        objectToFB: (CustomerSync object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final emailOffset = fbb.writeString(object.email);
          final phoneOffset = fbb.writeString(object.phone);
          final addressOffset = fbb.writeString(object.address);
          final updatedAtOffset = object.updatedAt == null
              ? null
              : fbb.writeString(object.updatedAt!);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, emailOffset);
          fbb.addOffset(3, phoneOffset);
          fbb.addOffset(4, addressOffset);
          fbb.addInt64(5, object.orderId);
          fbb.addInt64(6, object.branchId);
          fbb.addOffset(7, updatedAtOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = CustomerSync(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              orderId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              address:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              phone:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              email:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              updatedAt: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 18));

          return object;
        }),
    DiscountSync: EntityDefinition<DiscountSync>(
        model: _entities[23],
        toOneRelations: (DiscountSync object) => [],
        toManyRelations: (DiscountSync object) => {},
        getId: (DiscountSync object) => object.id,
        setId: (DiscountSync object, int id) {
          object.id = id;
        },
        objectToFB: (DiscountSync object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.amount);
          fbb.addInt64(3, object.branchId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = DiscountSync(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              amount: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0));

          return object;
        }),
    OrderFSync: EntityDefinition<OrderFSync>(
        model: _entities[24],
        toOneRelations: (OrderFSync object) => [],
        toManyRelations: (OrderFSync object) => {
              RelInfo<OrderItemSync>.toOneBacklink(13, object.id,
                      (OrderItemSync srcObject) => srcObject.order):
                  object.orderItems
            },
        getId: (OrderFSync object) => object.id,
        setId: (OrderFSync object, int id) {
          object.id = id;
        },
        objectToFB: (OrderFSync object, fb.Builder fbb) {
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
          final noteOffset =
              object.note == null ? null : fbb.writeString(object.note!);
          fbb.startTable(19);
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
          fbb.addBool(14, object.reported);
          fbb.addOffset(15, tableOffset);
          fbb.addInt64(16, object.customerId);
          fbb.addOffset(17, noteOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = OrderFSync(
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
              reported: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 32),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 34, ''),
              note: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 38),
              customerId: const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 36));
          InternalToManyAccess.setRelInfo(
              object.orderItems,
              store,
              RelInfo<OrderItemSync>.toOneBacklink(
                  13, object.id, (OrderItemSync srcObject) => srcObject.order),
              store.box<OrderFSync>());
          return object;
        }),
    OrderItemSync: EntityDefinition<OrderItemSync>(
        model: _entities[25],
        toOneRelations: (OrderItemSync object) => [object.order],
        toManyRelations: (OrderItemSync object) => {},
        getId: (OrderItemSync object) => object.id,
        setId: (OrderItemSync object, int id) {
          object.id = id;
        },
        objectToFB: (OrderItemSync object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final typeOffset =
              object.type == null ? null : fbb.writeString(object.type!);
          final createdAtOffset = fbb.writeString(object.createdAt);
          final updatedAtOffset = fbb.writeString(object.updatedAt);
          fbb.startTable(14);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.forderId);
          fbb.addInt64(3, object.fvariantId);
          fbb.addFloat64(4, object.count);
          fbb.addFloat64(5, object.price);
          fbb.addFloat64(6, object.discount);
          fbb.addOffset(7, typeOffset);
          fbb.addBool(8, object.reported);
          fbb.addInt64(9, object.remainingStock);
          fbb.addOffset(10, createdAtOffset);
          fbb.addOffset(11, updatedAtOffset);
          fbb.addInt64(12, object.order.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = OrderItemSync(
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
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0),
              discount: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              createdAt:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 24, ''),
              updatedAt:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 26, ''),
              reported: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 20, false),
              remainingStock:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0),
              type: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 18));
          object.order.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 28, 0);
          object.order.attach(store);
          return object;
        }),
    PreviewData: EntityDefinition<PreviewData>(
        model: _entities[26],
        toOneRelations: (PreviewData object) => [],
        toManyRelations: (PreviewData object) => {},
        getId: (PreviewData object) => object.id,
        setId: (PreviewData object, int id) {
          object.id = id;
        },
        objectToFB: (PreviewData object, fb.Builder fbb) {
          final descriptionOffset = object.description == null
              ? null
              : fbb.writeString(object.description!);
          final linkOffset =
              object.link == null ? null : fbb.writeString(object.link!);
          final titleOffset =
              object.title == null ? null : fbb.writeString(object.title!);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, descriptionOffset);
          fbb.addOffset(2, linkOffset);
          fbb.addOffset(3, titleOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = PreviewData(
              description: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              link: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              title: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));

          return object;
        }),
    PreviewDataImage: EntityDefinition<PreviewDataImage>(
        model: _entities[27],
        toOneRelations: (PreviewDataImage object) => [],
        toManyRelations: (PreviewDataImage object) => {},
        getId: (PreviewDataImage object) => object.id,
        setId: (PreviewDataImage object, int id) {
          object.id = id;
        },
        objectToFB: (PreviewDataImage object, fb.Builder fbb) {
          final urlOffset = fbb.writeString(object.url);
          fbb.startTable(5);
          fbb.addFloat64(0, object.height);
          fbb.addInt64(1, object.id);
          fbb.addOffset(2, urlOffset);
          fbb.addFloat64(3, object.width);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = PreviewDataImage(
              height:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 4, 0),
              url: const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              width:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));

          return object;
        }),
    TextMessage: EntityDefinition<TextMessage>(
        model: _entities[28],
        toOneRelations: (TextMessage object) => [object.author],
        toManyRelations: (TextMessage object) => {},
        getId: (TextMessage object) => object.id,
        setId: (TextMessage object, int id) {
          object.id = id;
        },
        objectToFB: (TextMessage object, fb.Builder fbb) {
          final textOffset = fbb.writeString(object.text);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, textOffset);
          fbb.addInt64(2, object.author.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = TextMessage(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              text:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''));
          object.author.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          object.author.attach(store);
          return object;
        }),
    User: EntityDefinition<User>(
        model: _entities[29],
        toOneRelations: (User object) => [],
        toManyRelations: (User object) => {},
        getId: (User object) => object.id,
        setId: (User object, int id) {
          object.id = id;
        },
        objectToFB: (User object, fb.Builder fbb) {
          final firstNameOffset = object.firstName == null
              ? null
              : fbb.writeString(object.firstName!);
          final imageUrlOffset = object.imageUrl == null
              ? null
              : fbb.writeString(object.imageUrl!);
          final lastNameOffset = object.lastName == null
              ? null
              : fbb.writeString(object.lastName!);
          final roleOBOffset =
              object.roleOB == null ? null : fbb.writeString(object.roleOB!);
          fbb.startTable(9);
          fbb.addInt64(0, object.createdAt);
          fbb.addOffset(1, firstNameOffset);
          fbb.addInt64(2, object.id);
          fbb.addOffset(3, imageUrlOffset);
          fbb.addOffset(4, lastNameOffset);
          fbb.addInt64(5, object.lastSeen);
          fbb.addInt64(6, object.updatedAt);
          fbb.addOffset(7, roleOBOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = User(
              createdAt: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 4),
              firstName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0),
              imageUrl: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              lastName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              lastSeen: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 14),
              updatedAt: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 16))
            ..roleOB = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 18);

          return object;
        }),
    UnsupportedMessage: EntityDefinition<UnsupportedMessage>(
        model: _entities[30],
        toOneRelations: (UnsupportedMessage object) => [object.author],
        toManyRelations: (UnsupportedMessage object) => {},
        getId: (UnsupportedMessage object) => object.id,
        setId: (UnsupportedMessage object, int id) {
          object.id = id;
        },
        objectToFB: (UnsupportedMessage object, fb.Builder fbb) {
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.author.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = UnsupportedMessage(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));
          object.author.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          object.author.attach(store);
          return object;
        }),
    ImageMessage: EntityDefinition<ImageMessage>(
        model: _entities[31],
        toOneRelations: (ImageMessage object) => [object.author],
        toManyRelations: (ImageMessage object) => {},
        getId: (ImageMessage object) => object.id,
        setId: (ImageMessage object, int id) {
          object.id = id;
        },
        objectToFB: (ImageMessage object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final uriOffset = fbb.writeString(object.uri);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.author.targetId);
          fbb.addFloat64(2, object.height);
          fbb.addOffset(3, nameOffset);
          fbb.addOffset(4, uriOffset);
          fbb.addFloat64(5, object.width);
          fbb.addInt64(6, object.size);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ImageMessage(
              height: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              size: const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0),
              uri:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              width: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 14));
          object.author.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          object.author.attach(store);
          return object;
        }),
    CustomMessage: EntityDefinition<CustomMessage>(
        model: _entities[32],
        toOneRelations: (CustomMessage object) => [object.author],
        toManyRelations: (CustomMessage object) => {},
        getId: (CustomMessage object) => object.id,
        setId: (CustomMessage object, int id) {
          object.id = id;
        },
        objectToFB: (CustomMessage object, fb.Builder fbb) {
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.author.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = CustomMessage(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));
          object.author.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          object.author.attach(store);
          return object;
        }),
    FileMessage: EntityDefinition<FileMessage>(
        model: _entities[33],
        toOneRelations: (FileMessage object) => [object.author],
        toManyRelations: (FileMessage object) => {},
        getId: (FileMessage object) => object.id,
        setId: (FileMessage object, int id) {
          object.id = id;
        },
        objectToFB: (FileMessage object, fb.Builder fbb) {
          final mimeTypeOffset = object.mimeType == null
              ? null
              : fbb.writeString(object.mimeType!);
          final nameOffset = fbb.writeString(object.name);
          final uriOffset = fbb.writeString(object.uri);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.author.targetId);
          fbb.addOffset(2, mimeTypeOffset);
          fbb.addOffset(3, nameOffset);
          fbb.addOffset(4, uriOffset);
          fbb.addInt64(5, object.size);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = FileMessage(
              mimeType: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              size: const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0),
              uri:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));
          object.author.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          object.author.attach(store);
          return object;
        }),
    Room: EntityDefinition<Room>(
        model: _entities[34],
        toOneRelations: (Room object) => [],
        toManyRelations: (Room object) =>
            {RelInfo<Room>.toMany(1, object.id): object.users},
        getId: (Room object) => object.id,
        setId: (Room object, int id) {
          object.id = id;
        },
        objectToFB: (Room object, fb.Builder fbb) {
          final imageUrlOffset = object.imageUrl == null
              ? null
              : fbb.writeString(object.imageUrl!);
          final nameOffset =
              object.name == null ? null : fbb.writeString(object.name!);
          final roleOBOffset =
              object.roleOB == null ? null : fbb.writeString(object.roleOB!);
          fbb.startTable(7);
          fbb.addInt64(0, object.createdAt);
          fbb.addInt64(1, object.id);
          fbb.addOffset(2, imageUrlOffset);
          fbb.addOffset(3, nameOffset);
          fbb.addInt64(4, object.updatedAt);
          fbb.addOffset(5, roleOBOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Room(
              createdAt: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 4),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              imageUrl: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              name: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              updatedAt: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 12))
            ..roleOB = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 14);
          InternalToManyAccess.setRelInfo(object.users, store,
              RelInfo<Room>.toMany(1, object.id), store.box<Room>());
          return object;
        }),
    Points: EntityDefinition<Points>(
        model: _entities[35],
        toOneRelations: (Points object) => [],
        toManyRelations: (Points object) => {},
        getId: (Points object) => object.id,
        setId: (Points object, int id) {
          object.id = id;
        },
        objectToFB: (Points object, fb.Builder fbb) {
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.value);
          fbb.addInt64(2, object.userId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Points(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              value: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              userId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Category] entity fields to define ObjectBox queries.
class Category_ {
  /// see [Category.id]
  static final id = QueryIntegerProperty<Category>(_entities[0].properties[0]);

  /// see [Category.active]
  static final active =
      QueryBooleanProperty<Category>(_entities[0].properties[1]);

  /// see [Category.focused]
  static final focused =
      QueryBooleanProperty<Category>(_entities[0].properties[2]);

  /// see [Category.name]
  static final name = QueryStringProperty<Category>(_entities[0].properties[3]);

  /// see [Category.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<Category>(_entities[0].properties[4]);

  /// see [Category.table]
  static final table =
      QueryStringProperty<Category>(_entities[0].properties[5]);
}

/// [PColor] entity fields to define ObjectBox queries.
class PColor_ {
  /// see [PColor.id]
  static final id = QueryIntegerProperty<PColor>(_entities[1].properties[0]);

  /// see [PColor.name]
  static final name = QueryStringProperty<PColor>(_entities[1].properties[1]);

  /// see [PColor.table]
  static final table = QueryStringProperty<PColor>(_entities[1].properties[2]);

  /// see [PColor.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<PColor>(_entities[1].properties[3]);

  /// see [PColor.active]
  static final active =
      QueryBooleanProperty<PColor>(_entities[1].properties[4]);
}

/// [Product] entity fields to define ObjectBox queries.
class Product_ {
  /// see [Product.id]
  static final id = QueryIntegerProperty<Product>(_entities[2].properties[0]);

  /// see [Product.name]
  static final name = QueryStringProperty<Product>(_entities[2].properties[1]);

  /// see [Product.description]
  static final description =
      QueryStringProperty<Product>(_entities[2].properties[2]);

  /// see [Product.active]
  static final active =
      QueryBooleanProperty<Product>(_entities[2].properties[3]);

  /// see [Product.ftaxId]
  static final ftaxId =
      QueryStringProperty<Product>(_entities[2].properties[4]);

  /// see [Product.hasPicture]
  static final hasPicture =
      QueryBooleanProperty<Product>(_entities[2].properties[5]);

  /// see [Product.table]
  static final table = QueryStringProperty<Product>(_entities[2].properties[6]);

  /// see [Product.color]
  static final color = QueryStringProperty<Product>(_entities[2].properties[7]);

  /// see [Product.fbusinessId]
  static final fbusinessId =
      QueryIntegerProperty<Product>(_entities[2].properties[8]);

  /// see [Product.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<Product>(_entities[2].properties[9]);

  /// see [Product.fsupplierId]
  static final fsupplierId =
      QueryStringProperty<Product>(_entities[2].properties[10]);

  /// see [Product.fcategoryId]
  static final fcategoryId =
      QueryStringProperty<Product>(_entities[2].properties[11]);

  /// see [Product.createdAt]
  static final createdAt =
      QueryStringProperty<Product>(_entities[2].properties[12]);

  /// see [Product.unit]
  static final unit = QueryStringProperty<Product>(_entities[2].properties[13]);

  /// see [Product.draft]
  static final draft =
      QueryBooleanProperty<Product>(_entities[2].properties[14]);

  /// see [Product.imageLocal]
  static final imageLocal =
      QueryBooleanProperty<Product>(_entities[2].properties[15]);

  /// see [Product.currentUpdate]
  static final currentUpdate =
      QueryBooleanProperty<Product>(_entities[2].properties[16]);

  /// see [Product.imageUrl]
  static final imageUrl =
      QueryStringProperty<Product>(_entities[2].properties[17]);

  /// see [Product.expiryDate]
  static final expiryDate =
      QueryStringProperty<Product>(_entities[2].properties[18]);

  /// see [Product.barCode]
  static final barCode =
      QueryStringProperty<Product>(_entities[2].properties[19]);

  /// see [Product.synced]
  static final synced =
      QueryBooleanProperty<Product>(_entities[2].properties[20]);

  /// see [Product.migrated]
  static final migrated =
      QueryBooleanProperty<Product>(_entities[2].properties[21]);
}

/// [Stock] entity fields to define ObjectBox queries.
class Stock_ {
  /// see [Stock.id]
  static final id = QueryIntegerProperty<Stock>(_entities[3].properties[0]);

  /// see [Stock.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<Stock>(_entities[3].properties[1]);

  /// see [Stock.fvariantId]
  static final fvariantId =
      QueryIntegerProperty<Stock>(_entities[3].properties[2]);

  /// see [Stock.lowStock]
  static final lowStock =
      QueryDoubleProperty<Stock>(_entities[3].properties[3]);

  /// see [Stock.currentStock]
  static final currentStock =
      QueryDoubleProperty<Stock>(_entities[3].properties[4]);

  /// see [Stock.supplyPrice]
  static final supplyPrice =
      QueryDoubleProperty<Stock>(_entities[3].properties[5]);

  /// see [Stock.retailPrice]
  static final retailPrice =
      QueryDoubleProperty<Stock>(_entities[3].properties[6]);

  /// see [Stock.canTrackingStock]
  static final canTrackingStock =
      QueryBooleanProperty<Stock>(_entities[3].properties[7]);

  /// see [Stock.showLowStockAlert]
  static final showLowStockAlert =
      QueryBooleanProperty<Stock>(_entities[3].properties[8]);

  /// see [Stock.table]
  static final table = QueryStringProperty<Stock>(_entities[3].properties[9]);

  /// see [Stock.fproductId]
  static final fproductId =
      QueryIntegerProperty<Stock>(_entities[3].properties[10]);

  /// see [Stock.active]
  static final active =
      QueryBooleanProperty<Stock>(_entities[3].properties[11]);

  /// see [Stock.value]
  static final value = QueryDoubleProperty<Stock>(_entities[3].properties[12]);

  /// see [Stock.migrated]
  static final migrated =
      QueryBooleanProperty<Stock>(_entities[3].properties[13]);
}

/// [Unit] entity fields to define ObjectBox queries.
class Unit_ {
  /// see [Unit.id]
  static final id = QueryIntegerProperty<Unit>(_entities[4].properties[0]);

  /// see [Unit.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<Unit>(_entities[4].properties[1]);

  /// see [Unit.name]
  static final name = QueryStringProperty<Unit>(_entities[4].properties[2]);

  /// see [Unit.value]
  static final value = QueryStringProperty<Unit>(_entities[4].properties[3]);

  /// see [Unit.table]
  static final table = QueryStringProperty<Unit>(_entities[4].properties[4]);

  /// see [Unit.active]
  static final active = QueryBooleanProperty<Unit>(_entities[4].properties[5]);
}

/// [Variant] entity fields to define ObjectBox queries.
class Variant_ {
  /// see [Variant.id]
  static final id = QueryIntegerProperty<Variant>(_entities[5].properties[0]);

  /// see [Variant.name]
  static final name = QueryStringProperty<Variant>(_entities[5].properties[1]);

  /// see [Variant.sku]
  static final sku = QueryStringProperty<Variant>(_entities[5].properties[2]);

  /// see [Variant.fproductId]
  static final fproductId =
      QueryIntegerProperty<Variant>(_entities[5].properties[3]);

  /// see [Variant.unit]
  static final unit = QueryStringProperty<Variant>(_entities[5].properties[4]);

  /// see [Variant.table]
  static final table = QueryStringProperty<Variant>(_entities[5].properties[5]);

  /// see [Variant.productName]
  static final productName =
      QueryStringProperty<Variant>(_entities[5].properties[6]);

  /// see [Variant.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<Variant>(_entities[5].properties[7]);

  /// see [Variant.taxName]
  static final taxName =
      QueryStringProperty<Variant>(_entities[5].properties[8]);

  /// see [Variant.taxPercentage]
  static final taxPercentage =
      QueryDoubleProperty<Variant>(_entities[5].properties[9]);

  /// see [Variant.product]
  static final product =
      QueryRelationToOne<Variant, Product>(_entities[5].properties[10]);

  /// see [Variant.supplyPrice]
  static final supplyPrice =
      QueryDoubleProperty<Variant>(_entities[5].properties[11]);

  /// see [Variant.retailPrice]
  static final retailPrice =
      QueryDoubleProperty<Variant>(_entities[5].properties[12]);

  /// see [Variant.synced]
  static final synced =
      QueryBooleanProperty<Variant>(_entities[5].properties[13]);

  /// see [Variant.stock]
  static final stock =
      QueryRelationToOne<Variant, Stock>(_entities[5].properties[14]);

  /// see [Variant.migrated]
  static final migrated =
      QueryBooleanProperty<Variant>(_entities[5].properties[15]);
}

/// [VariantStock] entity fields to define ObjectBox queries.
class VariantStock_ {
  /// see [VariantStock.id]
  static final id =
      QueryIntegerProperty<VariantStock>(_entities[6].properties[0]);

  /// see [VariantStock.canTrackingStock]
  static final canTrackingStock =
      QueryBooleanProperty<VariantStock>(_entities[6].properties[1]);

  /// see [VariantStock.retailPrice]
  static final retailPrice =
      QueryDoubleProperty<VariantStock>(_entities[6].properties[2]);

  /// see [VariantStock.productName]
  static final productName =
      QueryStringProperty<VariantStock>(_entities[6].properties[3]);

  /// see [VariantStock.variantName]
  static final variantName =
      QueryStringProperty<VariantStock>(_entities[6].properties[4]);

  /// see [VariantStock.unit]
  static final unit =
      QueryStringProperty<VariantStock>(_entities[6].properties[5]);

  /// see [VariantStock.sku]
  static final sku =
      QueryStringProperty<VariantStock>(_entities[6].properties[6]);

  /// see [VariantStock.fbranchId]
  static final fbranchId =
      QueryStringProperty<VariantStock>(_entities[6].properties[7]);

  /// see [VariantStock.lowStock]
  static final lowStock =
      QueryDoubleProperty<VariantStock>(_entities[6].properties[8]);

  /// see [VariantStock.currentStock]
  static final currentStock =
      QueryDoubleProperty<VariantStock>(_entities[6].properties[9]);

  /// see [VariantStock.fvariantId]
  static final fvariantId =
      QueryStringProperty<VariantStock>(_entities[6].properties[10]);

  /// see [VariantStock.taxName]
  static final taxName =
      QueryStringProperty<VariantStock>(_entities[6].properties[11]);

  /// see [VariantStock.taxPercentage]
  static final taxPercentage =
      QueryDoubleProperty<VariantStock>(_entities[6].properties[12]);

  /// see [VariantStock.value]
  static final value =
      QueryDoubleProperty<VariantStock>(_entities[6].properties[13]);
}

/// [Setting] entity fields to define ObjectBox queries.
class Setting_ {
  /// see [Setting.id]
  static final id = QueryIntegerProperty<Setting>(_entities[7].properties[0]);

  /// see [Setting.email]
  static final email = QueryStringProperty<Setting>(_entities[7].properties[1]);

  /// see [Setting.hasPin]
  static final hasPin =
      QueryStringProperty<Setting>(_entities[7].properties[2]);

  /// see [Setting.userId]
  static final userId =
      QueryIntegerProperty<Setting>(_entities[7].properties[3]);

  /// see [Setting.openReceiptFileOSaleComplete]
  static final openReceiptFileOSaleComplete =
      QueryBooleanProperty<Setting>(_entities[7].properties[4]);

  /// see [Setting.autoPrint]
  static final autoPrint =
      QueryBooleanProperty<Setting>(_entities[7].properties[5]);

  /// see [Setting.defaultLanguage]
  static final defaultLanguage =
      QueryStringProperty<Setting>(_entities[7].properties[6]);

  /// see [Setting.sendDailyReport]
  static final sendDailyReport =
      QueryBooleanProperty<Setting>(_entities[7].properties[7]);

  /// see [Setting.googleSheetDocCreated]
  static final googleSheetDocCreated =
      QueryBooleanProperty<Setting>(_entities[7].properties[8]);

  /// see [Setting.attendnaceDocCreated]
  static final attendnaceDocCreated =
      QueryBooleanProperty<Setting>(_entities[7].properties[9]);

  /// see [Setting.isAttendanceEnabled]
  static final isAttendanceEnabled =
      QueryBooleanProperty<Setting>(_entities[7].properties[10]);
}

/// [QueueItem] entity fields to define ObjectBox queries.
class QueueItem_ {
  /// see [QueueItem.id]
  static final id = QueryIntegerProperty<QueueItem>(_entities[8].properties[0]);
}

/// [Menu] entity fields to define ObjectBox queries.
class Menu_ {
  /// see [Menu.id]
  static final id = QueryIntegerProperty<Menu>(_entities[9].properties[0]);

  /// see [Menu.name]
  static final name = QueryStringProperty<Menu>(_entities[9].properties[1]);

  /// see [Menu.branchId]
  static final branchId =
      QueryIntegerProperty<Menu>(_entities[9].properties[2]);
}

/// [MenuItem] entity fields to define ObjectBox queries.
class MenuItem_ {
  /// see [MenuItem.id]
  static final id = QueryIntegerProperty<MenuItem>(_entities[10].properties[0]);

  /// see [MenuItem.variantId]
  static final variantId =
      QueryIntegerProperty<MenuItem>(_entities[10].properties[1]);
}

/// [ProductSync] entity fields to define ObjectBox queries.
class ProductSync_ {
  /// see [ProductSync.id]
  static final id =
      QueryIntegerProperty<ProductSync>(_entities[11].properties[0]);

  /// see [ProductSync.name]
  static final name =
      QueryStringProperty<ProductSync>(_entities[11].properties[1]);

  /// see [ProductSync.description]
  static final description =
      QueryStringProperty<ProductSync>(_entities[11].properties[2]);

  /// see [ProductSync.active]
  static final active =
      QueryBooleanProperty<ProductSync>(_entities[11].properties[3]);

  /// see [ProductSync.ftaxId]
  static final ftaxId =
      QueryStringProperty<ProductSync>(_entities[11].properties[4]);

  /// see [ProductSync.hasPicture]
  static final hasPicture =
      QueryBooleanProperty<ProductSync>(_entities[11].properties[5]);

  /// see [ProductSync.table]
  static final table =
      QueryStringProperty<ProductSync>(_entities[11].properties[6]);

  /// see [ProductSync.color]
  static final color =
      QueryStringProperty<ProductSync>(_entities[11].properties[7]);

  /// see [ProductSync.fbusinessId]
  static final fbusinessId =
      QueryIntegerProperty<ProductSync>(_entities[11].properties[8]);

  /// see [ProductSync.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<ProductSync>(_entities[11].properties[9]);

  /// see [ProductSync.fsupplierId]
  static final fsupplierId =
      QueryStringProperty<ProductSync>(_entities[11].properties[10]);

  /// see [ProductSync.fcategoryId]
  static final fcategoryId =
      QueryStringProperty<ProductSync>(_entities[11].properties[11]);

  /// see [ProductSync.createdAt]
  static final createdAt =
      QueryStringProperty<ProductSync>(_entities[11].properties[12]);

  /// see [ProductSync.unit]
  static final unit =
      QueryStringProperty<ProductSync>(_entities[11].properties[13]);

  /// see [ProductSync.draft]
  static final draft =
      QueryBooleanProperty<ProductSync>(_entities[11].properties[14]);

  /// see [ProductSync.imageLocal]
  static final imageLocal =
      QueryBooleanProperty<ProductSync>(_entities[11].properties[15]);

  /// see [ProductSync.currentUpdate]
  static final currentUpdate =
      QueryBooleanProperty<ProductSync>(_entities[11].properties[16]);

  /// see [ProductSync.imageUrl]
  static final imageUrl =
      QueryStringProperty<ProductSync>(_entities[11].properties[17]);

  /// see [ProductSync.expiryDate]
  static final expiryDate =
      QueryStringProperty<ProductSync>(_entities[11].properties[18]);

  /// see [ProductSync.barCode]
  static final barCode =
      QueryStringProperty<ProductSync>(_entities[11].properties[19]);

  /// see [ProductSync.synced]
  static final synced =
      QueryBooleanProperty<ProductSync>(_entities[11].properties[20]);
}

/// [StockSync] entity fields to define ObjectBox queries.
class StockSync_ {
  /// see [StockSync.id]
  static final id =
      QueryIntegerProperty<StockSync>(_entities[12].properties[0]);

  /// see [StockSync.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<StockSync>(_entities[12].properties[1]);

  /// see [StockSync.fvariantId]
  static final fvariantId =
      QueryIntegerProperty<StockSync>(_entities[12].properties[2]);

  /// see [StockSync.lowStock]
  static final lowStock =
      QueryDoubleProperty<StockSync>(_entities[12].properties[3]);

  /// see [StockSync.currentStock]
  static final currentStock =
      QueryDoubleProperty<StockSync>(_entities[12].properties[4]);

  /// see [StockSync.supplyPrice]
  static final supplyPrice =
      QueryDoubleProperty<StockSync>(_entities[12].properties[5]);

  /// see [StockSync.retailPrice]
  static final retailPrice =
      QueryDoubleProperty<StockSync>(_entities[12].properties[6]);

  /// see [StockSync.canTrackingStock]
  static final canTrackingStock =
      QueryBooleanProperty<StockSync>(_entities[12].properties[7]);

  /// see [StockSync.showLowStockAlert]
  static final showLowStockAlert =
      QueryBooleanProperty<StockSync>(_entities[12].properties[8]);

  /// see [StockSync.table]
  static final table =
      QueryStringProperty<StockSync>(_entities[12].properties[9]);

  /// see [StockSync.fproductId]
  static final fproductId =
      QueryIntegerProperty<StockSync>(_entities[12].properties[10]);

  /// see [StockSync.active]
  static final active =
      QueryBooleanProperty<StockSync>(_entities[12].properties[11]);

  /// see [StockSync.value]
  static final value =
      QueryDoubleProperty<StockSync>(_entities[12].properties[12]);
}

/// [VariantSync] entity fields to define ObjectBox queries.
class VariantSync_ {
  /// see [VariantSync.id]
  static final id =
      QueryIntegerProperty<VariantSync>(_entities[13].properties[0]);

  /// see [VariantSync.name]
  static final name =
      QueryStringProperty<VariantSync>(_entities[13].properties[1]);

  /// see [VariantSync.sku]
  static final sku =
      QueryStringProperty<VariantSync>(_entities[13].properties[2]);

  /// see [VariantSync.fproductId]
  static final fproductId =
      QueryIntegerProperty<VariantSync>(_entities[13].properties[3]);

  /// see [VariantSync.unit]
  static final unit =
      QueryStringProperty<VariantSync>(_entities[13].properties[4]);

  /// see [VariantSync.table]
  static final table =
      QueryStringProperty<VariantSync>(_entities[13].properties[5]);

  /// see [VariantSync.productName]
  static final productName =
      QueryStringProperty<VariantSync>(_entities[13].properties[6]);

  /// see [VariantSync.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<VariantSync>(_entities[13].properties[7]);

  /// see [VariantSync.taxName]
  static final taxName =
      QueryStringProperty<VariantSync>(_entities[13].properties[8]);

  /// see [VariantSync.taxPercentage]
  static final taxPercentage =
      QueryDoubleProperty<VariantSync>(_entities[13].properties[9]);

  /// see [VariantSync.supplyPrice]
  static final supplyPrice =
      QueryDoubleProperty<VariantSync>(_entities[13].properties[10]);

  /// see [VariantSync.retailPrice]
  static final retailPrice =
      QueryDoubleProperty<VariantSync>(_entities[13].properties[11]);

  /// see [VariantSync.synced]
  static final synced =
      QueryBooleanProperty<VariantSync>(_entities[13].properties[12]);

  /// see [VariantSync.product]
  static final product = QueryRelationToOne<VariantSync, ProductSync>(
      _entities[13].properties[13]);

  /// see [VariantSync.stock]
  static final stock =
      QueryRelationToOne<VariantSync, StockSync>(_entities[13].properties[14]);
}

/// [Feature] entity fields to define ObjectBox queries.
class Feature_ {
  /// see [Feature.id]
  static final id = QueryIntegerProperty<Feature>(_entities[14].properties[0]);

  /// see [Feature.name]
  static final name = QueryStringProperty<Feature>(_entities[14].properties[1]);

  /// see [Feature.subscription]
  static final subscription =
      QueryRelationToOne<Feature, Subscription>(_entities[14].properties[2]);
}

/// [Subscription] entity fields to define ObjectBox queries.
class Subscription_ {
  /// see [Subscription.id]
  static final id =
      QueryIntegerProperty<Subscription>(_entities[15].properties[0]);

  /// see [Subscription.interval]
  static final interval =
      QueryIntegerProperty<Subscription>(_entities[15].properties[1]);

  /// see [Subscription.lastBillingDate]
  static final lastBillingDate =
      QueryStringProperty<Subscription>(_entities[15].properties[2]);

  /// see [Subscription.nextBillingDate]
  static final nextBillingDate =
      QueryStringProperty<Subscription>(_entities[15].properties[3]);

  /// see [Subscription.userId]
  static final userId =
      QueryIntegerProperty<Subscription>(_entities[15].properties[4]);

  /// see [Subscription.descriptor]
  static final descriptor =
      QueryStringProperty<Subscription>(_entities[15].properties[5]);

  /// see [Subscription.recurring]
  static final recurring =
      QueryDoubleProperty<Subscription>(_entities[15].properties[6]);
}

/// [BranchSync] entity fields to define ObjectBox queries.
class BranchSync_ {
  /// see [BranchSync.id]
  static final id =
      QueryIntegerProperty<BranchSync>(_entities[16].properties[0]);

  /// see [BranchSync.active]
  static final active =
      QueryBooleanProperty<BranchSync>(_entities[16].properties[1]);

  /// see [BranchSync.description]
  static final description =
      QueryStringProperty<BranchSync>(_entities[16].properties[2]);

  /// see [BranchSync.name]
  static final name =
      QueryStringProperty<BranchSync>(_entities[16].properties[3]);

  /// see [BranchSync.fbusinessId]
  static final fbusinessId =
      QueryIntegerProperty<BranchSync>(_entities[16].properties[4]);

  /// see [BranchSync.longitude]
  static final longitude =
      QueryStringProperty<BranchSync>(_entities[16].properties[5]);

  /// see [BranchSync.latitude]
  static final latitude =
      QueryStringProperty<BranchSync>(_entities[16].properties[6]);

  /// see [BranchSync.table]
  static final table =
      QueryStringProperty<BranchSync>(_entities[16].properties[7]);

  /// see [BranchSync.product]
  static final product =
      QueryRelationToOne<BranchSync, TenantSync>(_entities[16].properties[8]);

  /// see [BranchSync.subscription]
  static final subscription =
      QueryRelationToOne<BranchSync, Subscription>(_entities[16].properties[9]);
}

/// [Permissionsync] entity fields to define ObjectBox queries.
class Permissionsync_ {
  /// see [Permissionsync.id]
  static final id =
      QueryIntegerProperty<Permissionsync>(_entities[17].properties[0]);

  /// see [Permissionsync.name]
  static final name =
      QueryStringProperty<Permissionsync>(_entities[17].properties[1]);

  /// see [Permissionsync.product]
  static final product = QueryRelationToOne<Permissionsync, TenantSync>(
      _entities[17].properties[2]);
}

/// [TenantSync] entity fields to define ObjectBox queries.
class TenantSync_ {
  /// see [TenantSync.id]
  static final id =
      QueryIntegerProperty<TenantSync>(_entities[18].properties[0]);

  /// see [TenantSync.name]
  static final name =
      QueryStringProperty<TenantSync>(_entities[18].properties[1]);

  /// see [TenantSync.phoneNumber]
  static final phoneNumber =
      QueryStringProperty<TenantSync>(_entities[18].properties[2]);

  /// see [TenantSync.email]
  static final email =
      QueryStringProperty<TenantSync>(_entities[18].properties[3]);
}

/// [AttendanceSync] entity fields to define ObjectBox queries.
class AttendanceSync_ {
  /// see [AttendanceSync.id]
  static final id =
      QueryIntegerProperty<AttendanceSync>(_entities[19].properties[0]);

  /// see [AttendanceSync.businessId]
  static final businessId =
      QueryIntegerProperty<AttendanceSync>(_entities[19].properties[1]);

  /// see [AttendanceSync.businessName]
  static final businessName =
      QueryStringProperty<AttendanceSync>(_entities[19].properties[2]);

  /// see [AttendanceSync.fullName]
  static final fullName =
      QueryStringProperty<AttendanceSync>(_entities[19].properties[3]);

  /// see [AttendanceSync.phoneNumber]
  static final phoneNumber =
      QueryStringProperty<AttendanceSync>(_entities[19].properties[4]);

  /// see [AttendanceSync.checkInDate]
  static final checkInDate =
      QueryStringProperty<AttendanceSync>(_entities[19].properties[5]);

  /// see [AttendanceSync.checkInTime]
  static final checkInTime =
      QueryStringProperty<AttendanceSync>(_entities[19].properties[6]);

  /// see [AttendanceSync.vaccinationCode]
  static final vaccinationCode =
      QueryStringProperty<AttendanceSync>(_entities[19].properties[7]);

  /// see [AttendanceSync.livingAt]
  static final livingAt =
      QueryStringProperty<AttendanceSync>(_entities[19].properties[8]);

  /// see [AttendanceSync.cell]
  static final cell =
      QueryStringProperty<AttendanceSync>(_entities[19].properties[9]);

  /// see [AttendanceSync.district]
  static final district =
      QueryStringProperty<AttendanceSync>(_entities[19].properties[10]);
}

/// [Profile] entity fields to define ObjectBox queries.
class Profile_ {
  /// see [Profile.id]
  static final id = QueryIntegerProperty<Profile>(_entities[20].properties[0]);

  /// see [Profile.name]
  static final name = QueryStringProperty<Profile>(_entities[20].properties[1]);

  /// see [Profile.email]
  static final email =
      QueryStringProperty<Profile>(_entities[20].properties[2]);

  /// see [Profile.phone]
  static final phone =
      QueryStringProperty<Profile>(_entities[20].properties[3]);

  /// see [Profile.address]
  static final address =
      QueryStringProperty<Profile>(_entities[20].properties[4]);

  /// see [Profile.city]
  static final city = QueryStringProperty<Profile>(_entities[20].properties[5]);

  /// see [Profile.state]
  static final state =
      QueryStringProperty<Profile>(_entities[20].properties[6]);

  /// see [Profile.country]
  static final country =
      QueryStringProperty<Profile>(_entities[20].properties[7]);

  /// see [Profile.pincode]
  static final pincode =
      QueryStringProperty<Profile>(_entities[20].properties[8]);

  /// see [Profile.profilePic]
  static final profilePic =
      QueryStringProperty<Profile>(_entities[20].properties[9]);

  /// see [Profile.coverPic]
  static final coverPic =
      QueryStringProperty<Profile>(_entities[20].properties[10]);

  /// see [Profile.about]
  static final about =
      QueryStringProperty<Profile>(_entities[20].properties[11]);

  /// see [Profile.vaccinationCode]
  static final vaccinationCode =
      QueryStringProperty<Profile>(_entities[20].properties[12]);

  /// see [Profile.livingAt]
  static final livingAt =
      QueryStringProperty<Profile>(_entities[20].properties[13]);

  /// see [Profile.cell]
  static final cell =
      QueryStringProperty<Profile>(_entities[20].properties[14]);

  /// see [Profile.district]
  static final district =
      QueryStringProperty<Profile>(_entities[20].properties[15]);

  /// see [Profile.businessId]
  static final businessId =
      QueryIntegerProperty<Profile>(_entities[20].properties[16]);

  /// see [Profile.nationalId]
  static final nationalId =
      QueryStringProperty<Profile>(_entities[20].properties[17]);
}

/// [BusinessSync] entity fields to define ObjectBox queries.
class BusinessSync_ {
  /// see [BusinessSync.id]
  static final id =
      QueryIntegerProperty<BusinessSync>(_entities[21].properties[0]);

  /// see [BusinessSync.name]
  static final name =
      QueryStringProperty<BusinessSync>(_entities[21].properties[1]);

  /// see [BusinessSync.currency]
  static final currency =
      QueryStringProperty<BusinessSync>(_entities[21].properties[2]);

  /// see [BusinessSync.fcategoryId]
  static final fcategoryId =
      QueryIntegerProperty<BusinessSync>(_entities[21].properties[3]);

  /// see [BusinessSync.latitude]
  static final latitude =
      QueryStringProperty<BusinessSync>(_entities[21].properties[4]);

  /// see [BusinessSync.longitude]
  static final longitude =
      QueryStringProperty<BusinessSync>(_entities[21].properties[5]);

  /// see [BusinessSync.userId]
  static final userId =
      QueryStringProperty<BusinessSync>(_entities[21].properties[6]);

  /// see [BusinessSync.typeId]
  static final typeId =
      QueryStringProperty<BusinessSync>(_entities[21].properties[7]);

  /// see [BusinessSync.timeZone]
  static final timeZone =
      QueryStringProperty<BusinessSync>(_entities[21].properties[8]);

  /// see [BusinessSync.table]
  static final table =
      QueryStringProperty<BusinessSync>(_entities[21].properties[9]);

  /// see [BusinessSync.country]
  static final country =
      QueryStringProperty<BusinessSync>(_entities[21].properties[10]);

  /// see [BusinessSync.businessUrl]
  static final businessUrl =
      QueryStringProperty<BusinessSync>(_entities[21].properties[11]);

  /// see [BusinessSync.hexColor]
  static final hexColor =
      QueryStringProperty<BusinessSync>(_entities[21].properties[12]);

  /// see [BusinessSync.imageUrl]
  static final imageUrl =
      QueryStringProperty<BusinessSync>(_entities[21].properties[13]);

  /// see [BusinessSync.type]
  static final type =
      QueryStringProperty<BusinessSync>(_entities[21].properties[14]);

  /// see [BusinessSync.active]
  static final active =
      QueryBooleanProperty<BusinessSync>(_entities[21].properties[15]);

  /// see [BusinessSync.chatUid]
  static final chatUid =
      QueryStringProperty<BusinessSync>(_entities[21].properties[16]);

  /// see [BusinessSync.metadata]
  static final metadata =
      QueryStringProperty<BusinessSync>(_entities[21].properties[17]);

  /// see [BusinessSync.role]
  static final role =
      QueryStringProperty<BusinessSync>(_entities[21].properties[18]);

  /// see [BusinessSync.lastSeen]
  static final lastSeen =
      QueryIntegerProperty<BusinessSync>(_entities[21].properties[19]);

  /// see [BusinessSync.firstName]
  static final firstName =
      QueryStringProperty<BusinessSync>(_entities[21].properties[20]);

  /// see [BusinessSync.lastName]
  static final lastName =
      QueryStringProperty<BusinessSync>(_entities[21].properties[21]);

  /// see [BusinessSync.createdAt]
  static final createdAt =
      QueryStringProperty<BusinessSync>(_entities[21].properties[22]);

  /// see [BusinessSync.deviceToken]
  static final deviceToken =
      QueryStringProperty<BusinessSync>(_entities[21].properties[23]);

  /// see [BusinessSync.backUpEnabled]
  static final backUpEnabled =
      QueryBooleanProperty<BusinessSync>(_entities[21].properties[24]);

  /// see [BusinessSync.subscriptionPlan]
  static final subscriptionPlan =
      QueryStringProperty<BusinessSync>(_entities[21].properties[25]);

  /// see [BusinessSync.nextBillingDate]
  static final nextBillingDate =
      QueryStringProperty<BusinessSync>(_entities[21].properties[26]);

  /// see [BusinessSync.previousBillingDate]
  static final previousBillingDate =
      QueryStringProperty<BusinessSync>(_entities[21].properties[27]);

  /// see [BusinessSync.isLastSubscriptionPaymentSucceeded]
  static final isLastSubscriptionPaymentSucceeded =
      QueryBooleanProperty<BusinessSync>(_entities[21].properties[28]);

  /// see [BusinessSync.backupFileId]
  static final backupFileId =
      QueryStringProperty<BusinessSync>(_entities[21].properties[29]);

  /// see [BusinessSync.email]
  static final email =
      QueryStringProperty<BusinessSync>(_entities[21].properties[30]);

  /// see [BusinessSync.lastDbBackup]
  static final lastDbBackup =
      QueryStringProperty<BusinessSync>(_entities[21].properties[31]);

  /// see [BusinessSync.fullName]
  static final fullName =
      QueryStringProperty<BusinessSync>(_entities[21].properties[32]);
}

/// [CustomerSync] entity fields to define ObjectBox queries.
class CustomerSync_ {
  /// see [CustomerSync.id]
  static final id =
      QueryIntegerProperty<CustomerSync>(_entities[22].properties[0]);

  /// see [CustomerSync.name]
  static final name =
      QueryStringProperty<CustomerSync>(_entities[22].properties[1]);

  /// see [CustomerSync.email]
  static final email =
      QueryStringProperty<CustomerSync>(_entities[22].properties[2]);

  /// see [CustomerSync.phone]
  static final phone =
      QueryStringProperty<CustomerSync>(_entities[22].properties[3]);

  /// see [CustomerSync.address]
  static final address =
      QueryStringProperty<CustomerSync>(_entities[22].properties[4]);

  /// see [CustomerSync.orderId]
  static final orderId =
      QueryIntegerProperty<CustomerSync>(_entities[22].properties[5]);

  /// see [CustomerSync.branchId]
  static final branchId =
      QueryIntegerProperty<CustomerSync>(_entities[22].properties[6]);

  /// see [CustomerSync.updatedAt]
  static final updatedAt =
      QueryStringProperty<CustomerSync>(_entities[22].properties[7]);
}

/// [DiscountSync] entity fields to define ObjectBox queries.
class DiscountSync_ {
  /// see [DiscountSync.id]
  static final id =
      QueryIntegerProperty<DiscountSync>(_entities[23].properties[0]);

  /// see [DiscountSync.name]
  static final name =
      QueryStringProperty<DiscountSync>(_entities[23].properties[1]);

  /// see [DiscountSync.amount]
  static final amount =
      QueryIntegerProperty<DiscountSync>(_entities[23].properties[2]);

  /// see [DiscountSync.branchId]
  static final branchId =
      QueryIntegerProperty<DiscountSync>(_entities[23].properties[3]);
}

/// [OrderFSync] entity fields to define ObjectBox queries.
class OrderFSync_ {
  /// see [OrderFSync.id]
  static final id =
      QueryIntegerProperty<OrderFSync>(_entities[24].properties[0]);

  /// see [OrderFSync.reference]
  static final reference =
      QueryStringProperty<OrderFSync>(_entities[24].properties[1]);

  /// see [OrderFSync.orderNumber]
  static final orderNumber =
      QueryStringProperty<OrderFSync>(_entities[24].properties[2]);

  /// see [OrderFSync.fbranchId]
  static final fbranchId =
      QueryIntegerProperty<OrderFSync>(_entities[24].properties[3]);

  /// see [OrderFSync.status]
  static final status =
      QueryStringProperty<OrderFSync>(_entities[24].properties[4]);

  /// see [OrderFSync.orderType]
  static final orderType =
      QueryStringProperty<OrderFSync>(_entities[24].properties[5]);

  /// see [OrderFSync.active]
  static final active =
      QueryBooleanProperty<OrderFSync>(_entities[24].properties[6]);

  /// see [OrderFSync.draft]
  static final draft =
      QueryBooleanProperty<OrderFSync>(_entities[24].properties[7]);

  /// see [OrderFSync.subTotal]
  static final subTotal =
      QueryDoubleProperty<OrderFSync>(_entities[24].properties[8]);

  /// see [OrderFSync.paymentType]
  static final paymentType =
      QueryStringProperty<OrderFSync>(_entities[24].properties[9]);

  /// see [OrderFSync.cashReceived]
  static final cashReceived =
      QueryDoubleProperty<OrderFSync>(_entities[24].properties[10]);

  /// see [OrderFSync.customerChangeDue]
  static final customerChangeDue =
      QueryDoubleProperty<OrderFSync>(_entities[24].properties[11]);

  /// see [OrderFSync.createdAt]
  static final createdAt =
      QueryStringProperty<OrderFSync>(_entities[24].properties[12]);

  /// see [OrderFSync.updatedAt]
  static final updatedAt =
      QueryStringProperty<OrderFSync>(_entities[24].properties[13]);

  /// see [OrderFSync.reported]
  static final reported =
      QueryBooleanProperty<OrderFSync>(_entities[24].properties[14]);

  /// see [OrderFSync.table]
  static final table =
      QueryStringProperty<OrderFSync>(_entities[24].properties[15]);

  /// see [OrderFSync.customerId]
  static final customerId =
      QueryIntegerProperty<OrderFSync>(_entities[24].properties[16]);

  /// see [OrderFSync.note]
  static final note =
      QueryStringProperty<OrderFSync>(_entities[24].properties[17]);
}

/// [OrderItemSync] entity fields to define ObjectBox queries.
class OrderItemSync_ {
  /// see [OrderItemSync.id]
  static final id =
      QueryIntegerProperty<OrderItemSync>(_entities[25].properties[0]);

  /// see [OrderItemSync.name]
  static final name =
      QueryStringProperty<OrderItemSync>(_entities[25].properties[1]);

  /// see [OrderItemSync.forderId]
  static final forderId =
      QueryIntegerProperty<OrderItemSync>(_entities[25].properties[2]);

  /// see [OrderItemSync.fvariantId]
  static final fvariantId =
      QueryIntegerProperty<OrderItemSync>(_entities[25].properties[3]);

  /// see [OrderItemSync.count]
  static final count =
      QueryDoubleProperty<OrderItemSync>(_entities[25].properties[4]);

  /// see [OrderItemSync.price]
  static final price =
      QueryDoubleProperty<OrderItemSync>(_entities[25].properties[5]);

  /// see [OrderItemSync.discount]
  static final discount =
      QueryDoubleProperty<OrderItemSync>(_entities[25].properties[6]);

  /// see [OrderItemSync.type]
  static final type =
      QueryStringProperty<OrderItemSync>(_entities[25].properties[7]);

  /// see [OrderItemSync.reported]
  static final reported =
      QueryBooleanProperty<OrderItemSync>(_entities[25].properties[8]);

  /// see [OrderItemSync.remainingStock]
  static final remainingStock =
      QueryIntegerProperty<OrderItemSync>(_entities[25].properties[9]);

  /// see [OrderItemSync.createdAt]
  static final createdAt =
      QueryStringProperty<OrderItemSync>(_entities[25].properties[10]);

  /// see [OrderItemSync.updatedAt]
  static final updatedAt =
      QueryStringProperty<OrderItemSync>(_entities[25].properties[11]);

  /// see [OrderItemSync.order]
  static final order = QueryRelationToOne<OrderItemSync, OrderFSync>(
      _entities[25].properties[12]);
}

/// [PreviewData] entity fields to define ObjectBox queries.
class PreviewData_ {
  /// see [PreviewData.id]
  static final id =
      QueryIntegerProperty<PreviewData>(_entities[26].properties[0]);

  /// see [PreviewData.description]
  static final description =
      QueryStringProperty<PreviewData>(_entities[26].properties[1]);

  /// see [PreviewData.link]
  static final link =
      QueryStringProperty<PreviewData>(_entities[26].properties[2]);

  /// see [PreviewData.title]
  static final title =
      QueryStringProperty<PreviewData>(_entities[26].properties[3]);
}

/// [PreviewDataImage] entity fields to define ObjectBox queries.
class PreviewDataImage_ {
  /// see [PreviewDataImage.height]
  static final height =
      QueryDoubleProperty<PreviewDataImage>(_entities[27].properties[0]);

  /// see [PreviewDataImage.id]
  static final id =
      QueryIntegerProperty<PreviewDataImage>(_entities[27].properties[1]);

  /// see [PreviewDataImage.url]
  static final url =
      QueryStringProperty<PreviewDataImage>(_entities[27].properties[2]);

  /// see [PreviewDataImage.width]
  static final width =
      QueryDoubleProperty<PreviewDataImage>(_entities[27].properties[3]);
}

/// [TextMessage] entity fields to define ObjectBox queries.
class TextMessage_ {
  /// see [TextMessage.id]
  static final id =
      QueryIntegerProperty<TextMessage>(_entities[28].properties[0]);

  /// see [TextMessage.text]
  static final text =
      QueryStringProperty<TextMessage>(_entities[28].properties[1]);

  /// see [TextMessage.author]
  static final author =
      QueryRelationToOne<TextMessage, User>(_entities[28].properties[2]);
}

/// [User] entity fields to define ObjectBox queries.
class User_ {
  /// see [User.createdAt]
  static final createdAt =
      QueryIntegerProperty<User>(_entities[29].properties[0]);

  /// see [User.firstName]
  static final firstName =
      QueryStringProperty<User>(_entities[29].properties[1]);

  /// see [User.id]
  static final id = QueryIntegerProperty<User>(_entities[29].properties[2]);

  /// see [User.imageUrl]
  static final imageUrl =
      QueryStringProperty<User>(_entities[29].properties[3]);

  /// see [User.lastName]
  static final lastName =
      QueryStringProperty<User>(_entities[29].properties[4]);

  /// see [User.lastSeen]
  static final lastSeen =
      QueryIntegerProperty<User>(_entities[29].properties[5]);

  /// see [User.updatedAt]
  static final updatedAt =
      QueryIntegerProperty<User>(_entities[29].properties[6]);

  /// see [User.roleOB]
  static final roleOB = QueryStringProperty<User>(_entities[29].properties[7]);
}

/// [UnsupportedMessage] entity fields to define ObjectBox queries.
class UnsupportedMessage_ {
  /// see [UnsupportedMessage.id]
  static final id =
      QueryIntegerProperty<UnsupportedMessage>(_entities[30].properties[0]);

  /// see [UnsupportedMessage.author]
  static final author =
      QueryRelationToOne<UnsupportedMessage, User>(_entities[30].properties[1]);
}

/// [ImageMessage] entity fields to define ObjectBox queries.
class ImageMessage_ {
  /// see [ImageMessage.id]
  static final id =
      QueryIntegerProperty<ImageMessage>(_entities[31].properties[0]);

  /// see [ImageMessage.author]
  static final author =
      QueryRelationToOne<ImageMessage, User>(_entities[31].properties[1]);

  /// see [ImageMessage.height]
  static final height =
      QueryDoubleProperty<ImageMessage>(_entities[31].properties[2]);

  /// see [ImageMessage.name]
  static final name =
      QueryStringProperty<ImageMessage>(_entities[31].properties[3]);

  /// see [ImageMessage.uri]
  static final uri =
      QueryStringProperty<ImageMessage>(_entities[31].properties[4]);

  /// see [ImageMessage.width]
  static final width =
      QueryDoubleProperty<ImageMessage>(_entities[31].properties[5]);

  /// see [ImageMessage.size]
  static final size =
      QueryIntegerProperty<ImageMessage>(_entities[31].properties[6]);
}

/// [CustomMessage] entity fields to define ObjectBox queries.
class CustomMessage_ {
  /// see [CustomMessage.id]
  static final id =
      QueryIntegerProperty<CustomMessage>(_entities[32].properties[0]);

  /// see [CustomMessage.author]
  static final author =
      QueryRelationToOne<CustomMessage, User>(_entities[32].properties[1]);
}

/// [FileMessage] entity fields to define ObjectBox queries.
class FileMessage_ {
  /// see [FileMessage.id]
  static final id =
      QueryIntegerProperty<FileMessage>(_entities[33].properties[0]);

  /// see [FileMessage.author]
  static final author =
      QueryRelationToOne<FileMessage, User>(_entities[33].properties[1]);

  /// see [FileMessage.mimeType]
  static final mimeType =
      QueryStringProperty<FileMessage>(_entities[33].properties[2]);

  /// see [FileMessage.name]
  static final name =
      QueryStringProperty<FileMessage>(_entities[33].properties[3]);

  /// see [FileMessage.uri]
  static final uri =
      QueryStringProperty<FileMessage>(_entities[33].properties[4]);

  /// see [FileMessage.size]
  static final size =
      QueryIntegerProperty<FileMessage>(_entities[33].properties[5]);
}

/// [Room] entity fields to define ObjectBox queries.
class Room_ {
  /// see [Room.createdAt]
  static final createdAt =
      QueryIntegerProperty<Room>(_entities[34].properties[0]);

  /// see [Room.id]
  static final id = QueryIntegerProperty<Room>(_entities[34].properties[1]);

  /// see [Room.imageUrl]
  static final imageUrl =
      QueryStringProperty<Room>(_entities[34].properties[2]);

  /// see [Room.name]
  static final name = QueryStringProperty<Room>(_entities[34].properties[3]);

  /// see [Room.updatedAt]
  static final updatedAt =
      QueryIntegerProperty<Room>(_entities[34].properties[4]);

  /// see [Room.roleOB]
  static final roleOB = QueryStringProperty<Room>(_entities[34].properties[5]);

  /// see [Room.users]
  static final users =
      QueryRelationToMany<Room, User>(_entities[34].relations[0]);
}

/// [Points] entity fields to define ObjectBox queries.
class Points_ {
  /// see [Points.id]
  static final id = QueryIntegerProperty<Points>(_entities[35].properties[0]);

  /// see [Points.value]
  static final value =
      QueryIntegerProperty<Points>(_entities[35].properties[1]);

  /// see [Points.userId]
  static final userId =
      QueryIntegerProperty<Points>(_entities[35].properties[2]);
}
