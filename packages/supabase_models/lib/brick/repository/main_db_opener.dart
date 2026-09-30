import 'dart:async';
import 'dart:io';

import 'package:sqflite_common/sqlite_api.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';

final _logger = Logger('MainDbOpener');

/// One way of opening a local database. [openFirstWorkingTier] tries tiers in
/// order until one opens and migrates, so a device that cannot use the
/// preferred engine or file still boots on a lesser one.
class LocalDbTier {
  const LocalDbTier({
    required this.name,
    required this.path,
    required this.factory,
    this.timeout = const Duration(seconds: 15),
    this.prepare,
  });

  /// Short, stable label reported to diagnostics (e.g. `sqflite-fresh`).
  final String name;
  final String path;
  final DatabaseFactory Function() factory;
  final Duration timeout;

  /// Runs before the attempt with the failures of the earlier tiers. Returning
  /// false skips this tier (e.g. a "fresh file" tier after a lock error, where
  /// moving the file aside would throw away a healthy database).
  final Future<bool> Function(List<LocalDbTierFailure> previous)? prepare;
}

class LocalDbTierFailure {
  const LocalDbTierFailure(this.tier, this.error, this.stackTrace);

  final String tier;
  final Object error;
  final StackTrace stackTrace;

  @override
  String toString() => '$tier: $error';
}

class LocalDbOpenResult<T> {
  const LocalDbOpenResult(this.value, this.tier, this.failures);

  final T value;
  final LocalDbTier tier;

  /// Tiers that were tried and failed before [tier] worked. Empty on a
  /// healthy device.
  final List<LocalDbTierFailure> failures;
}

/// Tries each tier's [attempt] in order and returns the first that succeeds.
///
/// [attempt] must clean up after itself when it throws. If a tier times out
/// its attempt may still finish later; [discardLate] closes that orphan so it
/// does not keep a connection open next to the tier that won.
Future<LocalDbOpenResult<T>> openFirstWorkingTier<T>({
  required List<LocalDbTier> tiers,
  required Future<T> Function(LocalDbTier tier) attempt,
  Future<void> Function(T lateValue)? discardLate,
}) async {
  final failures = <LocalDbTierFailure>[];
  for (final tier in tiers) {
    try {
      final prepare = tier.prepare;
      if (prepare != null && !await prepare(List.unmodifiable(failures))) {
        _logger.info('Skipping local DB tier ${tier.name}');
        continue;
      }
      final pending = attempt(tier);
      final value = await pending.timeout(
        tier.timeout,
        onTimeout: () {
          if (discardLate != null) {
            unawaited(pending.then(discardLate, onError: (_) {}));
          } else {
            unawaited(pending.then((_) {}, onError: (_) {}));
          }
          throw TimeoutException(
            'Local DB tier ${tier.name} timed out after '
            '${tier.timeout.inSeconds}s',
            tier.timeout,
          );
        },
      );
      if (failures.isNotEmpty) {
        _logger.warning(
          'Local DB opened on fallback tier ${tier.name} after: '
          '${failures.join('; ')}',
        );
      }
      return LocalDbOpenResult(value, tier, List.unmodifiable(failures));
    } catch (e, s) {
      _logger.severe('Local DB tier ${tier.name} failed: $e', e, s);
      failures.add(LocalDbTierFailure(tier.name, e, s));
    }
  }
  throw StateError(
    'No local database could be opened. Tried: ${failures.join('; ')}',
  );
}

/// True for errors that mean "someone else has the file open", as opposed to
/// "the file is broken". Moving a locked file aside would discard good data.
bool isLocalDbLockError(Object error) {
  final message = error.toString();
  return message.contains('locked') ||
      message.contains('Locked') ||
      message.contains('SQLITE_BUSY');
}

/// Prepare hook for a "same engine, fresh file" tier: moves the database at
/// [path] aside so the next open starts empty, unless the earlier failure was
/// a lock or a timeout (the file may be healthy, just busy or slow).
Future<bool> Function(List<LocalDbTierFailure>) freshFileAfterCorruption(
  String path, {
  List<String> extraSidecars = const [],
  void Function()? beforeMove,
}) {
  return (previous) async {
    if (previous.isEmpty) {
      return false;
    }
    final last = previous.last.error;
    if (isLocalDbLockError(last) || last is TimeoutException) {
      return false;
    }
    beforeMove?.call();
    await quarantineDatabaseFiles(path, extraSidecars: extraSidecars);
    return true;
  };
}

const _sqliteSidecarSuffixes = ['-wal', '-shm', '-journal'];

/// Renames [path] and its sidecar files to `<name>.corrupt-<timestamp>` so a
/// broken database can still be recovered by hand. Falls back to deleting a
/// file that cannot be renamed. Never throws.
Future<void> quarantineDatabaseFiles(
  String path, {
  List<String> extraSidecars = const [],
}) async {
  final stamp = DateTime.now().millisecondsSinceEpoch;
  final paths = <String>{
    path,
    ..._sqliteSidecarSuffixes.map((suffix) => '$path$suffix'),
    ...extraSidecars,
  };
  for (final p in paths) {
    final file = File(p);
    try {
      if (!await file.exists()) {
        continue;
      }
      await file.rename('$p.corrupt-$stamp');
      _logger.warning('Moved unusable database file aside: $p');
    } catch (e) {
      _logger.warning('Could not move $p aside ($e); deleting it instead');
      try {
        await file.delete();
      } catch (e) {
        _logger.severe('Could not delete $p: $e');
      }
    }
  }
}

/// Deletes [path] and [sidecars] if present. Never throws.
Future<void> deleteDatabaseFilesQuietly(
  String path, {
  List<String> sidecars = const [],
}) async {
  for (final p in <String>{
    path,
    ..._sqliteSidecarSuffixes.map((suffix) => '$path$suffix'),
    ...sidecars,
  }) {
    try {
      final file = File(p);
      if (await file.exists()) {
        await file.delete();
        _logger.info('Removed unused database file $p');
      }
    } catch (e) {
      _logger.warning('Could not remove $p: $e');
    }
  }
}
