import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/sku/sku_format.dart';

/// An inclusive range of SKU numbers reserved for this device.
class SkuNumberRange {
  const SkuNumberRange(this.start, this.end);

  final int start;
  final int end;
}

/// Where the allocator keeps its state between runs: one JSON string.
abstract interface class SkuAllocatorStore {
  String? read();
  Future<void> write(String value);
}

/// Everything the allocator needs from the outside world, so it can be tested
/// without Ditto, the network or the preference store.
abstract interface class SkuAllocatorEnv {
  /// Local Mode keeps the store on this one device, so a plain local counter
  /// is safe and no network is used.
  bool get isLocalMode;

  /// Reserve [size] numbers on the server (`POST /api/skus/reserve`).
  Future<SkuNumberRange> reserve({
    required String businessId,
    required int size,
  });

  /// Highest SKU number the business already has on this device (see
  /// [legacySkuNumber]). Seeds the Local Mode counter.
  Future<int> localMax({required String businessId});
}

/// Hands out SKU numbers without ever computing "highest + 1" across devices.
///
/// Each device reserves a block of numbers from the server (the server's
/// counter is row-locked, so two blocks never overlap) and spends it offline.
///
/// **Saving never waits for the network.** [next] reads only the block kept
/// in local storage. When fewer than [refillBelow] numbers remain it starts a
/// background refill (fire-and-forget, short timeout, errors swallowed) and
/// returns at once. If the block is empty, [next] returns null: the caller
/// saves the item with no SKU and `skuPending: true`, the item sells exactly
/// as before, and data-connector assigns the SKU on sync.
///
/// Local Mode never touches the network: it counts locally. A block reserved
/// before (or kept through) Local Mode never hands out a number the local
/// counter already used: the block cursor skips past it.
///
/// A number is handed out only once the new cursor is stored. If the store
/// write fails, [next] returns null (the item saves as SKU pending): a cursor
/// that did not reach disk would hand the same number out again after a
/// restart.
///
/// Calls are serialised, so two items saved at once never get the same number.
class SkuAllocator {
  SkuAllocator({
    required SkuAllocatorStore store,
    required SkuAllocatorEnv env,
    this.blockSize = 50,
    this.refillBelow = 10,
    this.reserveTimeout = const Duration(seconds: 6),
  }) : _store = store,
       _env = env;

  final SkuAllocatorStore _store;
  final SkuAllocatorEnv _env;
  final int blockSize;
  final int refillBelow;
  final Duration reserveTimeout;

  /// Told about a failed background refill (offline, server down). Logging
  /// only: a failed refill changes nothing for the user.
  void Function(Object error)? onRefillError;

  /// Told when the new cursor could not be stored. The number is not handed
  /// out; the item saves as SKU pending.
  void Function(Object error)? onWriteError;

  Future<void> _tail = Future.value();
  final Map<String, Future<void>> _refills = {};

  /// The next number for [businessId], or null when none can be had right now.
  Future<int?> next({required String businessId}) {
    final completer = Completer<int?>();
    _tail = _tail.then((_) async {
      try {
        completer.complete(await _next(businessId));
      } catch (e, s) {
        completer.completeError(e, s);
      }
    });
    return completer.future;
  }

  /// The number [next] would hand out, without taking it (for showing a
  /// preview in a form). Null when none is available on this device yet.
  int? peek({required String businessId}) {
    final state = _readState()[businessId];
    if (state == null) return null;
    if (_env.isLocalMode) return state.localNext;
    return state.usable.peek;
  }

  /// Numbers left on this device for [businessId], queued block included.
  int remaining({required String businessId}) {
    final state = _readState()[businessId];
    if (state == null) return 0;
    return state.usable.remaining;
  }

  /// Start a background refill if this device holds fewer than
  /// [refillBelow] numbers. Call at app start / login once the business is
  /// known, so offline work has numbers to spend. Never throws, never blocks.
  void topUp({required String businessId}) {
    if (_env.isLocalMode || businessId.isEmpty) return;
    if (remaining(businessId: businessId) >= refillBelow) return;
    _refillInBackground(businessId);
  }

  /// Wait for any background refill (tests).
  Future<void> settle() async {
    await _tail;
    await Future.wait(_refills.values);
  }

  Future<int?> _next(String businessId) async {
    if (_env.isLocalMode) return _nextLocal(businessId);

    final state = (_readState()[businessId] ?? const _BlockState()).usable;
    if (state.isEmpty) {
      // Never wait for the server here: the item saves as SKU pending.
      _refillInBackground(businessId);
      return null;
    }

    final (number, taken) = state.take();
    // Keep the Local Mode counter past every number issued online, so going
    // back into Local Mode never hands one of them out again.
    final local = taken.localNext;
    final rest = local != null && local <= number
        ? taken.copyWith(localNext: number + 1)
        : taken;
    if (!await _tryWriteState(businessId, rest)) return null;
    if (rest.remaining < refillBelow) _refillInBackground(businessId);
    return number;
  }

  Future<int?> _nextLocal(String businessId) async {
    final state = _readState()[businessId];
    var next = state?.localNext;
    next ??= (await _env.localMax(businessId: businessId)) + 1;
    final stored = await _tryWriteState(
      businessId,
      (state ?? const _BlockState()).copyWith(localNext: next + 1),
    );
    return stored ? next : null;
  }

  /// [_writeState], reporting a failed store write instead of throwing.
  Future<bool> _tryWriteState(String businessId, _BlockState state) async {
    try {
      await _writeState(businessId, state);
      return true;
    } catch (e) {
      onWriteError?.call(e);
      return false;
    }
  }

  void _refillInBackground(String businessId) {
    unawaited(
      _refill(businessId).catchError((Object e) {
        onRefillError?.call(e);
      }),
    );
  }

  /// Single-flight per business: concurrent callers share one request.
  Future<void> _refill(String businessId) {
    return _refills[businessId] ??= () async {
      try {
        final range = await _env
            .reserve(businessId: businessId, size: blockSize)
            .timeout(reserveTimeout);
        // Drop blocks already behind the Local Mode counter first: kept,
        // they would make withBlock discard every new block and the device
        // would stay SKU-pending for good.
        final current =
            (_readState()[businessId] ?? const _BlockState()).usable;
        await _writeState(businessId, current.withBlock(range));
      } finally {
        _refills.remove(businessId);
      }
    }();
  }

  Map<String, _BlockState> _readState() {
    final raw = _store.read();
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};
      return {
        for (final entry in decoded.entries)
          if (entry.value is Map)
            entry.key.toString(): _BlockState.fromJson(
              Map<String, dynamic>.from(entry.value as Map),
            ),
      };
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeState(String businessId, _BlockState state) async {
    final all = _readState()..[businessId] = state;
    await _store.write(
      jsonEncode({for (final e in all.entries) e.key: e.value.toJson()}),
    );
  }
}

/// One business's numbers on this device: the block being spent
/// (`next..end`), the block queued behind it, and the Local Mode counter.
class _BlockState {
  const _BlockState({
    this.next,
    this.end,
    this.queuedStart,
    this.queuedEnd,
    this.localNext,
  });

  factory _BlockState.fromJson(Map<String, dynamic> json) => _BlockState(
    next: _int(json['next']),
    end: _int(json['end']),
    queuedStart: _int(json['queuedStart']),
    queuedEnd: _int(json['queuedEnd']),
    localNext: _int(json['localNext']),
  );

  final int? next;
  final int? end;
  final int? queuedStart;
  final int? queuedEnd;
  final int? localNext;

  static int? _int(Object? v) => v is num ? v.toInt() : null;

  int get _current =>
      (next != null && end != null && next! <= end!) ? end! - next! + 1 : 0;
  int get _queued => (queuedStart != null && queuedEnd != null)
      ? queuedEnd! - queuedStart! + 1
      : 0;

  int get remaining => _current + _queued;

  int? get peek => _current > 0 ? next : (_queued > 0 ? queuedStart : null);

  /// This state with every block number below [localNext] dropped: those
  /// numbers may already have gone to items made in Local Mode.
  _BlockState get usable {
    final floor = localNext;
    if (floor == null) return this;
    final keepCurrent = _current > 0 && end! >= floor;
    final keepQueued = _queued > 0 && queuedEnd! >= floor;
    return _BlockState(
      next: keepCurrent ? (next! < floor ? floor : next) : null,
      end: keepCurrent ? end : null,
      queuedStart: keepQueued
          ? (queuedStart! < floor ? floor : queuedStart)
          : null,
      queuedEnd: keepQueued ? queuedEnd : null,
      localNext: localNext,
    );
  }

  bool get isEmpty => remaining == 0;

  /// Take one number, rolling over to the queued block when the current one
  /// is spent. Only call when not [isEmpty].
  (int, _BlockState) take() {
    if (_current > 0) {
      return (next!, copyWith(next: next! + 1));
    }
    return (
      queuedStart!,
      _BlockState(next: queuedStart! + 1, end: queuedEnd, localNext: localNext),
    );
  }

  /// Add a freshly reserved block: it becomes current if nothing is left,
  /// otherwise it waits in the queue (an already queued block is kept and the
  /// new one discarded, since the server will never issue those numbers again
  /// anyway and gaps are harmless).
  _BlockState withBlock(SkuNumberRange range) {
    if (_current == 0 && _queued == 0) {
      return _BlockState(
        next: range.start,
        end: range.end,
        localNext: localNext,
      );
    }
    if (_current == 0) {
      return _BlockState(
        next: queuedStart,
        end: queuedEnd,
        queuedStart: range.start,
        queuedEnd: range.end,
        localNext: localNext,
      );
    }
    if (_queued > 0) return this;
    return copyWith(queuedStart: range.start, queuedEnd: range.end);
  }

  _BlockState copyWith({
    int? next,
    int? queuedStart,
    int? queuedEnd,
    int? localNext,
  }) => _BlockState(
    next: next ?? this.next,
    end: end,
    queuedStart: queuedStart ?? this.queuedStart,
    queuedEnd: queuedEnd ?? this.queuedEnd,
    localNext: localNext ?? this.localNext,
  );

  Map<String, dynamic> toJson() => {
    if (next != null) 'next': next,
    if (end != null) 'end': end,
    if (queuedStart != null) 'queuedStart': queuedStart,
    if (queuedEnd != null) 'queuedEnd': queuedEnd,
    if (localNext != null) 'localNext': localNext,
  };
}

/// Format helper that pairs [SkuAllocator] with a prefix.
extension SkuAllocatorFormat on SkuAllocator {
  /// A formatted SKU (`BEV-00042`) for a new item, or null when no number is
  /// available right now (save with `skuPending: true`).
  Future<String?> nextSku({
    required String businessId,
    String? skuPrefix,
    String? categoryName,
  }) async {
    final number = await next(businessId: businessId);
    if (number == null) return null;
    return formatSku(
      deriveSkuPrefix(skuPrefix: skuPrefix, categoryName: categoryName),
      number,
    );
  }
}
