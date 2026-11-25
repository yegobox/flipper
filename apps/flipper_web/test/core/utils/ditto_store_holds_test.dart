import 'package:flipper_web/core/utils/ditto_store_holds.dart';
import 'package:flipper_web/core/utils/lock_mechanism.dart';
import 'package:flutter_test/flutter_test.dart';

class _Store {
  _Store(this.name);
  final String name;
  int closeFailuresLeft = 0;
  int closes = 0;
}

class _Lock implements LockMechanism {
  _Lock({this.free = true});
  final bool free;
  String? acquiredPath;
  bool released = false;

  @override
  Future<bool> acquire(String path) async {
    acquiredPath = path;
    return free;
  }

  @override
  Future<void> release() async => released = true;
}

const _dir = '/data/data/rw.flipper/databases';

DittoStoreHolds<_Store> _holds({
  Duration waitTimeout = const Duration(seconds: 2),
}) => DittoStoreHolds<_Store>(
  closeStore: (store) async {
    store.closes++;
    if (store.closeFailuresLeft > 0) {
      store.closeFailuresLeft--;
      throw StateError('close failed');
    }
  },
  waitTimeout: waitTimeout,
  pollInterval: const Duration(milliseconds: 5),
);

Future<_Store?> _open(
  DittoStoreHolds<_Store> holds,
  _Store store, {
  LockMechanism? lock,
  bool Function()? stillWanted,
}) => holds.open(
  _dir,
  open: () async => store,
  stillWanted: stillWanted ?? () => true,
  lock: lock,
);

void main() {
  test('an open holds the directory and its lock until the close', () async {
    final holds = _holds();
    final lock = _Lock();
    final store = _Store('main');

    expect(await _open(holds, store, lock: lock), same(store));
    expect(holds.isHeld(_dir), isTrue);
    expect(lock.acquiredPath, '$_dir/.ditto_lock');

    expect(await holds.close(_dir, store, settle: Duration.zero), isTrue);
    expect(holds.isHeld(_dir), isFalse);
    expect(lock.released, isTrue);
  });

  test('an open of a directory that is closing waits, then opens', () async {
    final holds = _holds();
    final first = _Store('first');
    await _open(holds, first);

    final second = _Store('second');
    var opened = false;
    final pending = _open(holds, second).then((s) {
      opened = true;
      return s;
    });
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(opened, isFalse, reason: 'must not open while the store is held');

    await holds.close(_dir, first, settle: Duration.zero);
    expect(await pending, same(second));
    expect(holds.isHeld(_dir), isTrue);
  });

  test(
    'a failed close keeps the lock; the next open retries the close',
    () async {
      final holds = _holds();
      final lock = _Lock();
      final stuck = _Store('stuck')..closeFailuresLeft = 1;
      await _open(holds, stuck, lock: lock);

      expect(await holds.close(_dir, stuck, settle: Duration.zero), isFalse);
      expect(holds.isHeld(_dir), isTrue);
      expect(lock.released, isFalse);

      final next = _Store('next');
      expect(await _open(holds, next), same(next));
      expect(stuck.closes, 2);
      expect(lock.released, isTrue);
    },
  );

  test('a retried close that fails again throws, naming the store', () async {
    final holds = _holds();
    final stuck = _Store('stuck')..closeFailuresLeft = 2;
    await _open(holds, stuck);
    await holds.close(_dir, stuck, settle: Duration.zero);

    await expectLater(
      _open(holds, _Store('next')),
      throwsA(
        isA<DittoStoreHeldException>()
            .having((e) => e.closeFailed, 'closeFailed', isTrue)
            .having((e) => e.directory, 'directory', _dir)
            .having((e) => '$e', 'message', contains('close failed again')),
      ),
    );
    expect(holds.isHeld(_dir), isTrue);
  });

  test('a hold that never clears throws after the wait', () async {
    final holds = _holds(waitTimeout: const Duration(milliseconds: 20));
    await _open(holds, _Store('held'));

    await expectLater(
      _open(holds, _Store('next')),
      throwsA(
        isA<DittoStoreHeldException>()
            .having((e) => e.closeFailed, 'closeFailed', isFalse)
            .having((e) => '$e', 'message', contains('still held')),
      ),
    );
  });

  test('an init aborted during open closes the store it opened', () async {
    final holds = _holds();
    final lock = _Lock();
    final store = _Store('orphan');
    var wanted = true;

    final result = await holds.open(
      _dir,
      lock: lock,
      stillWanted: () => wanted,
      open: () async {
        wanted = false; // aborted while Ditto.open runs
        return store;
      },
    );

    expect(result, isNull);
    expect(store.closes, 1);
    expect(holds.isHeld(_dir), isFalse);
    expect(lock.released, isTrue);
  });

  test('an init aborted while waiting opens nothing', () async {
    final holds = _holds();
    var opens = 0;
    final result = await holds.open(
      _dir,
      stillWanted: () => false,
      open: () async {
        opens++;
        return _Store('never');
      },
    );

    expect(result, isNull);
    expect(opens, 0);
    expect(holds.isHeld(_dir), isFalse);
  });

  test('a lock taken by another process opens nothing', () async {
    final holds = _holds();
    var opens = 0;
    final result = await holds.open(
      _dir,
      lock: _Lock(free: false),
      stillWanted: () => true,
      open: () async {
        opens++;
        return _Store('never');
      },
    );

    expect(result, isNull);
    expect(opens, 0);
    expect(holds.isHeld(_dir), isFalse);
  });

  test('an open that throws frees the directory and its lock', () async {
    final holds = _holds();
    final lock = _Lock();

    await expectLater(
      holds.open(
        _dir,
        lock: lock,
        stillWanted: () => true,
        open: () async => throw StateError('File already locked'),
      ),
      throwsStateError,
    );
    expect(holds.isHeld(_dir), isFalse);
    expect(lock.released, isTrue);
  });

  test(
    'a failed close of an unheld store still blocks its directory',
    () async {
      final holds = _holds(waitTimeout: Duration.zero);
      final stray = _Store('stray')..closeFailuresLeft = 2;

      expect(await holds.close(_dir, stray, settle: Duration.zero), isFalse);
      expect(holds.isHeld(_dir), isTrue);
    },
  );
}
