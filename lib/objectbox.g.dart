// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

import 'objectBoxes/unit.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(2, 1085632613906874556),
      name: 'Unit',
      lastPropertyId: const IdUid(7, 3458552990229191164),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 3075717765372783850),
            name: 'ids',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 8389873262721696551),
            name: 'id',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3998032434978306868),
            name: 'branchId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 827493739366445200),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 6652315236723266449),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7937019431931046186),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 3458552990229191164),
            name: 'channels',
            type: 30,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(2, 1085632613906874556),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [21686609971235120],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        9165922652151926835,
        7435018457391551185,
        6858914786176429036
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Unit: EntityDefinition<Unit>(
        model: _entities[0],
        toOneRelations: (Unit object) => [],
        toManyRelations: (Unit object) => {},
        getId: (Unit object) => object.ids,
        setId: (Unit object, int id) {
          object.ids = id;
        },
        objectToFB: (Unit object, fb.Builder fbb) {
          final idOffset = fbb.writeString(object.id);
          final branchIdOffset = fbb.writeString(object.branchId);
          final nameOffset = fbb.writeString(object.name);
          final tableOffset = fbb.writeString(object.table);
          final channelsOffset = fbb.writeList(
              object.channels.map(fbb.writeString).toList(growable: false));
          fbb.startTable(8);
          fbb.addInt64(0, object.ids);
          fbb.addOffset(1, idOffset);
          fbb.addOffset(2, branchIdOffset);
          fbb.addOffset(3, nameOffset);
          fbb.addOffset(4, tableOffset);
          fbb.addBool(5, object.active);
          fbb.addOffset(6, channelsOffset);
          fbb.finish(fbb.endTable());
          return object.ids;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Unit(
              id: const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              branchId:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 14, false),
              channels: const EagerListReader<String>(fb.StringReader())
                  .vTableGet(buffer, rootOffset, 16, []),
              ids: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Unit] entity fields to define ObjectBox queries.
class Unit_ {
  /// see [Unit.ids]
  static final ids = QueryIntegerProperty<Unit>(_entities[0].properties[0]);

  /// see [Unit.id]
  static final id = QueryStringProperty<Unit>(_entities[0].properties[1]);

  /// see [Unit.branchId]
  static final branchId = QueryStringProperty<Unit>(_entities[0].properties[2]);

  /// see [Unit.name]
  static final name = QueryStringProperty<Unit>(_entities[0].properties[3]);

  /// see [Unit.table]
  static final table = QueryStringProperty<Unit>(_entities[0].properties[4]);

  /// see [Unit.active]
  static final active = QueryBooleanProperty<Unit>(_entities[0].properties[5]);

  /// see [Unit.channels]
  static final channels =
      QueryStringVectorProperty<Unit>(_entities[0].properties[6]);
}
