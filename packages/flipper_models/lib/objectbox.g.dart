// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:flipper_models/unit.dart';
import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(2, 7970958753147336131),
      name: 'Unit',
      lastPropertyId: const IdUid(12, 6761960454475769515),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(3, 1695532608655701692),
            name: 'branchId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2540388201504042181),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 1167230280626204259),
            name: 'table',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 952224965517680920),
            name: 'active',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 1871501413937464452),
            name: 'id',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 8102018090207766631),
            name: 'tracker',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(11, 5709546796203739348),
            name: 'value',
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
      lastEntityId: const IdUid(2, 7970958753147336131),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [5483521795205110286],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        7628649928158405781,
        6455411222645067061,
        5984788302773550431,
        6369533780867337387,
        1971586393113747910,
        5683041231238859543,
        6175146774908960730,
        6761960454475769515
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
        getId: (Unit object) => object.tracker,
        setId: (Unit object, int id) {
          object.tracker = id;
        },
        objectToFB: (Unit object, fb.Builder fbb) {
          final branchIdOffset = fbb.writeString(object.branchId);
          final nameOffset = fbb.writeString(object.name);
          final tableOffset = fbb.writeString(object.table);
          final idOffset =
              object.id == null ? null : fbb.writeString(object.id!);
          final valueOffset =
              object.value == null ? null : fbb.writeString(object.value!);
          fbb.startTable(13);
          fbb.addOffset(2, branchIdOffset);
          fbb.addOffset(3, nameOffset);
          fbb.addOffset(4, tableOffset);
          fbb.addBool(5, object.active);
          fbb.addOffset(8, idOffset);
          fbb.addInt64(9, object.tracker);
          fbb.addOffset(10, valueOffset);
          fbb.finish(fbb.endTable());
          return object.tracker;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Unit(
              id: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              tracker:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0),
              branchId:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              value: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              table:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              active: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 14, false));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Unit] entity fields to define ObjectBox queries.
class Unit_ {
  /// see [Unit.branchId]
  static final branchId = QueryStringProperty<Unit>(_entities[0].properties[0]);

  /// see [Unit.name]
  static final name = QueryStringProperty<Unit>(_entities[0].properties[1]);

  /// see [Unit.table]
  static final table = QueryStringProperty<Unit>(_entities[0].properties[2]);

  /// see [Unit.active]
  static final active = QueryBooleanProperty<Unit>(_entities[0].properties[3]);

  /// see [Unit.id]
  static final id = QueryStringProperty<Unit>(_entities[0].properties[4]);

  /// see [Unit.tracker]
  static final tracker = QueryIntegerProperty<Unit>(_entities[0].properties[5]);

  /// see [Unit.value]
  static final value = QueryStringProperty<Unit>(_entities[0].properties[6]);
}
