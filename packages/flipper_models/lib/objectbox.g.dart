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
import 'conversation.dart';
import 'customer.dart';
import 'discount.dart';
import 'message.dart';
import 'order.dart';
import 'order_item.dart';
import 'product.dart';
import 'queue_item.dart';
import 'setting.dart';
import 'stock.dart';
import 'unit.dart';
import 'variant_stock.dart';
import 'variants.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 4864448714320732391),
      name: 'Branch',
      lastPropertyId: const IdUid(8, 2952392917342526866),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 391353200972426069),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 3360850122243914619),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3855423874897767370),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1445859498689750628),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5963160911027895707),
            name: 'fbusinessId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 72354741350138443),
            name: 'longitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 1863989441339731502),
            name: 'latitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 2952392917342526866),
            name: 'table',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 2865100998343489519),
      name: 'Business',
      lastPropertyId: const IdUid(29, 1233285787693282103),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6899584005705309920),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 7446188222764846812),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1129869352289449940),
            name: 'currency',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 245127506432029189),
            name: 'fcategoryId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 6192820646280833149),
            name: 'latitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7678148692431630189),
            name: 'longitude',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7502319348689109437),
            name: 'userId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 5432779492653460309),
            name: 'typeId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 4998914939866376922),
            name: 'timeZone',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 7554971826203067126),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 6618164166361466925),
            name: 'country',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 8577392346534076859),
            name: 'businessUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 1308004300690162015),
            name: 'hexColor',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 7935104562269846262),
            name: 'imageUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 5989110326798299707),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 307297663923335262),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 9158620068473699373),
            name: 'lastSeen',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 5806007020145977170),
            name: 'metadata',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(19, 5463609435049086704),
            name: 'role',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(20, 1278202304031278496),
            name: 'firstName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(21, 2101408374380372529),
            name: 'lastName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(22, 5348406758024782343),
            name: 'createdAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(23, 3713089851155268736),
            name: 'deviceToken',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(24, 8392855964498574230),
            name: 'chatUid',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(25, 4546554080487738070),
            name: 'backUpEnabled',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(26, 3192194834539283051),
            name: 'subscriptionPlan',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(27, 2803303694211390632),
            name: 'nextBillingDate',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(28, 697434406173511171),
            name: 'previousBillingDate',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(29, 1233285787693282103),
            name: 'isLastSubscriptionPaymentSucceeded',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
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
      id: const IdUid(4, 1236114536079259166),
      name: 'OrderF',
      lastPropertyId: const IdUid(18, 8708948374178397045),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2258093142159938853),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 2300166293136834201),
            name: 'reference',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2888003912419385545),
            name: 'orderNumber',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7904465183088159069),
            name: 'fbranchId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 8237020161125066877),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 611157274690380379),
            name: 'orderType',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 8715641323900221077),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 3814381944437835608),
            name: 'draft',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 1374481480998901288),
            name: 'subTotal',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 1518902672174544810),
            name: 'paymentType',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 8655992809401730659),
            name: 'cashReceived',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 7116491184838322897),
            name: 'customerChangeDue',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 8969387789896710844),
            name: 'createdAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 86536299062929500),
            name: 'updatedAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 88706347221077565),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 195264200013359891),
            name: 'customerId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 4542730526473935887),
            name: 'note',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 8708948374178397045),
            name: 'reported',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'orderItems', srcEntity: 'OrderItem', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(5, 5013621342623573944),
      name: 'OrderItem',
      lastPropertyId: const IdUid(9, 3487905289932526524),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 60128949728398961),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 2005919781413990613),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 293479963573078369),
            name: 'forderId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 913492185094278993),
            name: 'fvariantId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2310912031409828321),
            name: 'count',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 1298444245831708717),
            name: 'price',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 531175659311498591),
            name: 'orderId',
            type: 11,
            flags: 520,
            indexId: const IdUid(1, 4465723091749037531),
            relationTarget: 'OrderF'),
        ModelProperty(
            id: const IdUid(8, 7320600146768266036),
            name: 'discount',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 3487905289932526524),
            name: 'type',
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
      lastPropertyId: const IdUid(20, 4617414251103113403),
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
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'variations', srcEntity: 'Variant', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(8, 3913061828474354395),
      name: 'Stock',
      lastPropertyId: const IdUid(13, 8484521273202230162),
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
      lastPropertyId: const IdUid(13, 1043896475241337197),
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
      id: const IdUid(12, 917808743332577379),
      name: 'Message',
      lastPropertyId: const IdUid(22, 115682919560546987),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1947394661997474338),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(6, 2), name: 'senderId', type: 6, flags: 0),
        ModelProperty(
            id: const IdUid(9, 8074429391081551579),
            name: 'receiverId',
            type: 6,
            flags: 0),
        ModelProperty(id: const IdUid(10, 1), name: 'text', type: 9, flags: 0),
        ModelProperty(
            id: const IdUid(11, 412268228015472147),
            name: 'senderName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 3550400819773032582),
            name: 'senderImage',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 6952405727114646126),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 1210769162470646879),
            name: 'dbAuthor',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 1832585454190011486),
            name: 'createdAt',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 2033045415914865953),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(19, 8949027605740184096),
            name: 'dbId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(20, 2393751583070263733),
            name: 'conversationId',
            type: 11,
            flags: 520,
            indexId: const IdUid(4, 4090710537214135983),
            relationTarget: 'Conversation'),
        ModelProperty(
            id: const IdUid(21, 5839353688525412021),
            name: 'convoId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(22, 115682919560546987),
            name: 'delivered',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(13, 8608507958994323678),
      name: 'Setting',
      lastPropertyId: const IdUid(9, 307198340603284020),
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
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(14, 5570813440444123608),
      name: 'Customer',
      lastPropertyId: const IdUid(8, 2869323377143838880),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2391486744497665525),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 8811824834752705077),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 573566445840738309),
            name: 'email',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 3291856998242083601),
            name: 'phone',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 4194968844165436425),
            name: 'address',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 2729430775340363747),
            name: 'orderId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4411823794679308743),
            name: 'updatedAt',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 2869323377143838880),
            name: 'branchId',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(15, 587125237409554238),
      name: 'Discount',
      lastPropertyId: const IdUid(4, 2114727522821621245),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2070918125028837887),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 4876468586823146665),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 8439964586178305954),
            name: 'amount',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2114727522821621245),
            name: 'branchId',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(16, 1485111935930131080),
      name: 'Conversation',
      lastPropertyId: const IdUid(16, 2728016189115657858),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1421381851867583644),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(6, 8062944332124432080),
            name: 'dbAvatars',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 8408422868540398686),
            name: 'dbInitials',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 3062323287516113608),
            name: 'lastMessage',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 24616322612662045),
            name: 'receiverId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 4131698414439769805),
            name: 'senderId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 8534919517047473024),
            name: 'senderName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 4533874225416609274),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 8694540896149095557),
            name: 'createdAt',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 2728016189115657858),
            name: 'delivered',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'messages', srcEntity: 'Message', srcField: '')
      ]),
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
      lastEntityId: const IdUid(17, 2390185527754733161),
      lastIndexId: const IdUid(4, 4090710537214135983),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [3253799497487419212],
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
        1419114602383354089
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
          final chatUidOffset =
              object.chatUid == null ? null : fbb.writeString(object.chatUid!);
          final subscriptionPlanOffset = object.subscriptionPlan == null
              ? null
              : fbb.writeString(object.subscriptionPlan!);
          final nextBillingDateOffset = object.nextBillingDate == null
              ? null
              : fbb.writeString(object.nextBillingDate!);
          final previousBillingDateOffset = object.previousBillingDate == null
              ? null
              : fbb.writeString(object.previousBillingDate!);
          fbb.startTable(30);
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
          fbb.addInt64(16, object.lastSeen);
          fbb.addOffset(17, metadataOffset);
          fbb.addOffset(18, roleOffset);
          fbb.addOffset(19, firstNameOffset);
          fbb.addOffset(20, lastNameOffset);
          fbb.addOffset(21, createdAtOffset);
          fbb.addOffset(22, deviceTokenOffset);
          fbb.addOffset(23, chatUidOffset);
          fbb.addBool(24, object.backUpEnabled);
          fbb.addOffset(25, subscriptionPlanOffset);
          fbb.addOffset(26, nextBillingDateOffset);
          fbb.addOffset(27, previousBillingDateOffset);
          fbb.addBool(28, object.isLastSubscriptionPaymentSucceeded);
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
              lastSeen: const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 36),
              firstName: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 42),
              lastName: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 44),
              deviceToken: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 48),
              chatUid: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 50),
              backUpEnabled: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 52),
              subscriptionPlan: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 54),
              nextBillingDate: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 56),
              previousBillingDate: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 58),
              isLastSubscriptionPaymentSucceeded: const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 60),
              role: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 40))
            ..createdAt = const fb.StringReader().vTableGetNullable(buffer, rootOffset, 46);

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
          fbb.addOffset(14, tableOffset);
          fbb.addInt64(15, object.customerId);
          fbb.addOffset(16, noteOffset);
          fbb.addBool(17, object.reported);
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
              reported: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 38),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 32, ''),
              note: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 36),
              customerId: const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 34));
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
          final typeOffset =
              object.type == null ? null : fbb.writeString(object.type!);
          fbb.startTable(10);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.forderId);
          fbb.addInt64(3, object.fvariantId);
          fbb.addFloat64(4, object.count);
          fbb.addFloat64(5, object.price);
          fbb.addInt64(6, object.order.targetId);
          fbb.addFloat64(7, object.discount);
          fbb.addOffset(8, typeOffset);
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
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0),
              discount: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              type: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20));
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
              fbranchId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 10),
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
          fbb.startTable(21);
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
          fbb.startTable(14);
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
        }),
    Message: EntityDefinition<Message>(
        model: _entities[11],
        toOneRelations: (Message object) => [object.conversation],
        toManyRelations: (Message object) => {},
        getId: (Message object) => object.id,
        setId: (Message object, int id) {
          object.id = id;
        },
        objectToFB: (Message object, fb.Builder fbb) {
          final textOffset = fbb.writeString(object.text);
          final senderNameOffset = object.senderName == null
              ? null
              : fbb.writeString(object.senderName!);
          final senderImageOffset = object.senderImage == null
              ? null
              : fbb.writeString(object.senderImage!);
          final typeOffset = fbb.writeString(object.type);
          final dbAuthorOffset = object.dbAuthor == null
              ? null
              : fbb.writeString(object.dbAuthor!);
          final statusOffset = fbb.writeString(object.status);
          final dbIdOffset = fbb.writeString(object.dbId);
          fbb.startTable(23);
          fbb.addInt64(0, object.id);
          fbb.addInt64(5, object.senderId);
          fbb.addInt64(8, object.receiverId);
          fbb.addOffset(9, textOffset);
          fbb.addOffset(10, senderNameOffset);
          fbb.addOffset(12, senderImageOffset);
          fbb.addOffset(14, typeOffset);
          fbb.addOffset(15, dbAuthorOffset);
          fbb.addInt64(16, object.createdAt);
          fbb.addOffset(17, statusOffset);
          fbb.addOffset(18, dbIdOffset);
          fbb.addInt64(19, object.conversation.targetId);
          fbb.addInt64(20, object.convoId);
          fbb.addBool(21, object.delivered);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Message(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              text:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 22, ''),
              createdAt:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 36, 0),
              receiverId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0),
              senderId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0),
              status:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 38, ''),
              type:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 32, ''),
              convoId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 44, 0),
              delivered: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 46, false),
              senderName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 24))
            ..senderImage = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 28)
            ..dbAuthor = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 34)
            ..dbId =
                const fb.StringReader().vTableGet(buffer, rootOffset, 40, '');
          object.conversation.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 42, 0);
          object.conversation.attach(store);
          return object;
        }),
    Setting: EntityDefinition<Setting>(
        model: _entities[12],
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
          fbb.startTable(10);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, emailOffset);
          fbb.addOffset(2, hasPinOffset);
          fbb.addInt64(3, object.userId);
          fbb.addBool(4, object.openReceiptFileOSaleComplete);
          fbb.addBool(5, object.autoPrint);
          fbb.addOffset(6, defaultLanguageOffset);
          fbb.addBool(7, object.sendDailyReport);
          fbb.addBool(8, object.googleSheetDocCreated);
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
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0));

          return object;
        }),
    Customer: EntityDefinition<Customer>(
        model: _entities[13],
        toOneRelations: (Customer object) => [],
        toManyRelations: (Customer object) => {},
        getId: (Customer object) => object.id,
        setId: (Customer object, int id) {
          object.id = id;
        },
        objectToFB: (Customer object, fb.Builder fbb) {
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
          fbb.addOffset(6, updatedAtOffset);
          fbb.addInt64(7, object.branchId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Customer(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              orderId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              address:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              phone:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              email:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              updatedAt: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16));

          return object;
        }),
    Discount: EntityDefinition<Discount>(
        model: _entities[14],
        toOneRelations: (Discount object) => [],
        toManyRelations: (Discount object) => {},
        getId: (Discount object) => object.id,
        setId: (Discount object, int id) {
          object.id = id;
        },
        objectToFB: (Discount object, fb.Builder fbb) {
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

          final object = Discount(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              amount: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              branchId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0));

          return object;
        }),
    Conversation: EntityDefinition<Conversation>(
        model: _entities[15],
        toOneRelations: (Conversation object) => [],
        toManyRelations: (Conversation object) => {
              RelInfo<Message>.toOneBacklink(20, object.id,
                      (Message srcObject) => srcObject.conversation):
                  object.messages
            },
        getId: (Conversation object) => object.id,
        setId: (Conversation object, int id) {
          object.id = id;
        },
        objectToFB: (Conversation object, fb.Builder fbb) {
          final dbAvatarsOffset = object.dbAvatars == null
              ? null
              : fbb.writeString(object.dbAvatars!);
          final dbInitialsOffset = object.dbInitials == null
              ? null
              : fbb.writeString(object.dbInitials!);
          final lastMessageOffset = object.lastMessage == null
              ? null
              : fbb.writeString(object.lastMessage!);
          final senderNameOffset = fbb.writeString(object.senderName);
          final statusOffset = fbb.writeString(object.status);
          fbb.startTable(17);
          fbb.addInt64(0, object.id);
          fbb.addOffset(5, dbAvatarsOffset);
          fbb.addOffset(6, dbInitialsOffset);
          fbb.addOffset(7, lastMessageOffset);
          fbb.addInt64(8, object.receiverId);
          fbb.addInt64(9, object.senderId);
          fbb.addOffset(10, senderNameOffset);
          fbb.addOffset(11, statusOffset);
          fbb.addInt64(14, object.createdAt);
          fbb.addBool(15, object.delivered);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Conversation(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              lastMessage: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              receiverId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0),
              senderId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0),
              senderName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 24, ''),
              status:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 26, ''),
              delivered: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 34, false),
              createdAt:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 32, 0))
            ..dbAvatars = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 14)
            ..dbInitials = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 16);
          InternalToManyAccess.setRelInfo(
              object.messages,
              store,
              RelInfo<Message>.toOneBacklink(
                  20, object.id, (Message srcObject) => srcObject.conversation),
              store.box<Conversation>());
          return object;
        }),
    QueueItem: EntityDefinition<QueueItem>(
        model: _entities[16],
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

  /// see [Business.imageUrl]
  static final imageUrl =
      QueryStringProperty<Business>(_entities[1].properties[13]);

  /// see [Business.type]
  static final type =
      QueryStringProperty<Business>(_entities[1].properties[14]);

  /// see [Business.active]
  static final active =
      QueryBooleanProperty<Business>(_entities[1].properties[15]);

  /// see [Business.lastSeen]
  static final lastSeen =
      QueryIntegerProperty<Business>(_entities[1].properties[16]);

  /// see [Business.metadata]
  static final metadata =
      QueryStringProperty<Business>(_entities[1].properties[17]);

  /// see [Business.role]
  static final role =
      QueryStringProperty<Business>(_entities[1].properties[18]);

  /// see [Business.firstName]
  static final firstName =
      QueryStringProperty<Business>(_entities[1].properties[19]);

  /// see [Business.lastName]
  static final lastName =
      QueryStringProperty<Business>(_entities[1].properties[20]);

  /// see [Business.createdAt]
  static final createdAt =
      QueryStringProperty<Business>(_entities[1].properties[21]);

  /// see [Business.deviceToken]
  static final deviceToken =
      QueryStringProperty<Business>(_entities[1].properties[22]);

  /// see [Business.chatUid]
  static final chatUid =
      QueryStringProperty<Business>(_entities[1].properties[23]);

  /// see [Business.backUpEnabled]
  static final backUpEnabled =
      QueryBooleanProperty<Business>(_entities[1].properties[24]);

  /// see [Business.subscriptionPlan]
  static final subscriptionPlan =
      QueryStringProperty<Business>(_entities[1].properties[25]);

  /// see [Business.nextBillingDate]
  static final nextBillingDate =
      QueryStringProperty<Business>(_entities[1].properties[26]);

  /// see [Business.previousBillingDate]
  static final previousBillingDate =
      QueryStringProperty<Business>(_entities[1].properties[27]);

  /// see [Business.isLastSubscriptionPaymentSucceeded]
  static final isLastSubscriptionPaymentSucceeded =
      QueryBooleanProperty<Business>(_entities[1].properties[28]);
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

  /// see [OrderF.customerId]
  static final customerId =
      QueryIntegerProperty<OrderF>(_entities[3].properties[15]);

  /// see [OrderF.note]
  static final note = QueryStringProperty<OrderF>(_entities[3].properties[16]);

  /// see [OrderF.reported]
  static final reported =
      QueryBooleanProperty<OrderF>(_entities[3].properties[17]);
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
      QueryRelationToOne<OrderItem, OrderF>(_entities[4].properties[6]);

  /// see [OrderItem.discount]
  static final discount =
      QueryDoubleProperty<OrderItem>(_entities[4].properties[7]);

  /// see [OrderItem.type]
  static final type =
      QueryStringProperty<OrderItem>(_entities[4].properties[8]);
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

  /// see [Product.expiryDate]
  static final expiryDate =
      QueryStringProperty<Product>(_entities[6].properties[18]);

  /// see [Product.barCode]
  static final barCode =
      QueryStringProperty<Product>(_entities[6].properties[19]);
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
  static final value = QueryStringProperty<Unit>(_entities[8].properties[3]);

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
      QueryRelationToOne<Variant, Product>(_entities[9].properties[10]);

  /// see [Variant.supplyPrice]
  static final supplyPrice =
      QueryDoubleProperty<Variant>(_entities[9].properties[11]);

  /// see [Variant.retailPrice]
  static final retailPrice =
      QueryDoubleProperty<Variant>(_entities[9].properties[12]);
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

/// [Message] entity fields to define ObjectBox queries.
class Message_ {
  /// see [Message.id]
  static final id = QueryIntegerProperty<Message>(_entities[11].properties[0]);

  /// see [Message.senderId]
  static final senderId =
      QueryIntegerProperty<Message>(_entities[11].properties[1]);

  /// see [Message.receiverId]
  static final receiverId =
      QueryIntegerProperty<Message>(_entities[11].properties[2]);

  /// see [Message.text]
  static final text = QueryStringProperty<Message>(_entities[11].properties[3]);

  /// see [Message.senderName]
  static final senderName =
      QueryStringProperty<Message>(_entities[11].properties[4]);

  /// see [Message.senderImage]
  static final senderImage =
      QueryStringProperty<Message>(_entities[11].properties[5]);

  /// see [Message.type]
  static final type = QueryStringProperty<Message>(_entities[11].properties[6]);

  /// see [Message.dbAuthor]
  static final dbAuthor =
      QueryStringProperty<Message>(_entities[11].properties[7]);

  /// see [Message.createdAt]
  static final createdAt =
      QueryIntegerProperty<Message>(_entities[11].properties[8]);

  /// see [Message.status]
  static final status =
      QueryStringProperty<Message>(_entities[11].properties[9]);

  /// see [Message.dbId]
  static final dbId =
      QueryStringProperty<Message>(_entities[11].properties[10]);

  /// see [Message.conversation]
  static final conversation =
      QueryRelationToOne<Message, Conversation>(_entities[11].properties[11]);

  /// see [Message.convoId]
  static final convoId =
      QueryIntegerProperty<Message>(_entities[11].properties[12]);

  /// see [Message.delivered]
  static final delivered =
      QueryBooleanProperty<Message>(_entities[11].properties[13]);
}

/// [Setting] entity fields to define ObjectBox queries.
class Setting_ {
  /// see [Setting.id]
  static final id = QueryIntegerProperty<Setting>(_entities[12].properties[0]);

  /// see [Setting.email]
  static final email =
      QueryStringProperty<Setting>(_entities[12].properties[1]);

  /// see [Setting.hasPin]
  static final hasPin =
      QueryStringProperty<Setting>(_entities[12].properties[2]);

  /// see [Setting.userId]
  static final userId =
      QueryIntegerProperty<Setting>(_entities[12].properties[3]);

  /// see [Setting.openReceiptFileOSaleComplete]
  static final openReceiptFileOSaleComplete =
      QueryBooleanProperty<Setting>(_entities[12].properties[4]);

  /// see [Setting.autoPrint]
  static final autoPrint =
      QueryBooleanProperty<Setting>(_entities[12].properties[5]);

  /// see [Setting.defaultLanguage]
  static final defaultLanguage =
      QueryStringProperty<Setting>(_entities[12].properties[6]);

  /// see [Setting.sendDailyReport]
  static final sendDailyReport =
      QueryBooleanProperty<Setting>(_entities[12].properties[7]);

  /// see [Setting.googleSheetDocCreated]
  static final googleSheetDocCreated =
      QueryBooleanProperty<Setting>(_entities[12].properties[8]);
}

/// [Customer] entity fields to define ObjectBox queries.
class Customer_ {
  /// see [Customer.id]
  static final id = QueryIntegerProperty<Customer>(_entities[13].properties[0]);

  /// see [Customer.name]
  static final name =
      QueryStringProperty<Customer>(_entities[13].properties[1]);

  /// see [Customer.email]
  static final email =
      QueryStringProperty<Customer>(_entities[13].properties[2]);

  /// see [Customer.phone]
  static final phone =
      QueryStringProperty<Customer>(_entities[13].properties[3]);

  /// see [Customer.address]
  static final address =
      QueryStringProperty<Customer>(_entities[13].properties[4]);

  /// see [Customer.orderId]
  static final orderId =
      QueryIntegerProperty<Customer>(_entities[13].properties[5]);

  /// see [Customer.updatedAt]
  static final updatedAt =
      QueryStringProperty<Customer>(_entities[13].properties[6]);

  /// see [Customer.branchId]
  static final branchId =
      QueryIntegerProperty<Customer>(_entities[13].properties[7]);
}

/// [Discount] entity fields to define ObjectBox queries.
class Discount_ {
  /// see [Discount.id]
  static final id = QueryIntegerProperty<Discount>(_entities[14].properties[0]);

  /// see [Discount.name]
  static final name =
      QueryStringProperty<Discount>(_entities[14].properties[1]);

  /// see [Discount.amount]
  static final amount =
      QueryIntegerProperty<Discount>(_entities[14].properties[2]);

  /// see [Discount.branchId]
  static final branchId =
      QueryIntegerProperty<Discount>(_entities[14].properties[3]);
}

/// [Conversation] entity fields to define ObjectBox queries.
class Conversation_ {
  /// see [Conversation.id]
  static final id =
      QueryIntegerProperty<Conversation>(_entities[15].properties[0]);

  /// see [Conversation.dbAvatars]
  static final dbAvatars =
      QueryStringProperty<Conversation>(_entities[15].properties[1]);

  /// see [Conversation.dbInitials]
  static final dbInitials =
      QueryStringProperty<Conversation>(_entities[15].properties[2]);

  /// see [Conversation.lastMessage]
  static final lastMessage =
      QueryStringProperty<Conversation>(_entities[15].properties[3]);

  /// see [Conversation.receiverId]
  static final receiverId =
      QueryIntegerProperty<Conversation>(_entities[15].properties[4]);

  /// see [Conversation.senderId]
  static final senderId =
      QueryIntegerProperty<Conversation>(_entities[15].properties[5]);

  /// see [Conversation.senderName]
  static final senderName =
      QueryStringProperty<Conversation>(_entities[15].properties[6]);

  /// see [Conversation.status]
  static final status =
      QueryStringProperty<Conversation>(_entities[15].properties[7]);

  /// see [Conversation.createdAt]
  static final createdAt =
      QueryIntegerProperty<Conversation>(_entities[15].properties[8]);

  /// see [Conversation.delivered]
  static final delivered =
      QueryBooleanProperty<Conversation>(_entities[15].properties[9]);
}

/// [QueueItem] entity fields to define ObjectBox queries.
class QueueItem_ {
  /// see [QueueItem.id]
  static final id =
      QueryIntegerProperty<QueueItem>(_entities[16].properties[0]);
}
