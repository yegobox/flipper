import 'dart:async';

import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flipper_models/account_mode/account_mode_store.dart';
import 'package:flipper_models/sms_review/sms_review_providers.dart'
    show usableDittoProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountModeStoreProvider = Provider<AccountModeStore>(
  (ref) => AccountModeStore.instance,
);

/// The live [AccountMode] of [businessId] (`''` = the active business).
///
/// Starts from what the device cached, so the first frame opens the right
/// shell, then follows the server-written Ditto doc. No doc keeps the cached
/// (or pending-signup) value, and with neither it is business.
final accountModeProvider = StreamProvider.family<AccountMode, String>((
  ref,
  businessId,
) {
  final store = ref.watch(accountModeStoreProvider);
  final id = businessId.isEmpty ? store.activeBusinessId() : businessId;
  final fallback = store.cachedMode(businessId: id) ?? AccountMode.business;
  // No business, no Ditto: nothing to observe (signed out, tests).
  if (id == null) return Stream.value(fallback);
  final ditto = ref.watch(usableDittoProvider).value;
  if (ditto == null) return Stream.value(fallback);

  const query = 'SELECT * FROM $kAccountModesCollection WHERE _id = :id';
  final args = {'id': id};
  try {
    ditto.sync.registerSubscription(query, arguments: args);
  } catch (_) {
    // The observer still reads what is already on this device.
  }

  final controller = StreamController<AccountMode>();
  controller.add(fallback);
  final observer = ditto.store.registerObserver(
    query,
    arguments: args,
    onChange: (result) {
      if (controller.isClosed || result.items.isEmpty) return;
      final mode = localAccountMode(
        dittoDoc: Map<String, dynamic>.from(result.items.first.value),
        pending: null,
        cached: null,
      )!;
      unawaited(store.remember(id, mode));
      controller.add(mode);
    },
  );
  ref.onDispose(() async {
    observer.cancel();
    await controller.close();
  });
  return controller.stream.distinct();
});

/// Synchronous read for widgets: the provider's value, else the cache.
/// Keyed by the business active at build time, so a business switch (which
/// rebuilds the home) never shows the previous business's mode.
AccountMode watchAccountMode(WidgetRef ref, {String? businessId}) {
  final id =
      businessId ?? ref.read(accountModeStoreProvider).activeBusinessId() ?? '';
  final async = ref.watch(accountModeProvider(id));
  return async.value ??
      ref.read(accountModeStoreProvider).cachedMode() ??
      AccountMode.business;
}
