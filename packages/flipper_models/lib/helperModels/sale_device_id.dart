import 'dart:async';

import 'package:flipper_services/DeviceIdService.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:uuid/uuid.dart';

/// SharedPreferences / local storage key for the resolved sale device id fallback.
const kSaleDeviceIdStorageKey = 'sale_device_id';

/// Stable per-install suffix for Ditto [deviceName] on native (web uses ephemeral).
const kDittoInstallSuffixStorageKey = 'ditto_install_suffix';

/// In-memory cache — park/resume paths call [resolveSaleDeviceId] many times per
/// action; avoid repeated async storage writes on the hot path.
String? _resolvedSaleDeviceIdMemory;

/// Clears cached sale device id so the next [resolveSaleDeviceId] uses the
/// current Ditto [deviceName] (after userId change, logout, or Ditto re-init).
Future<void> resetSaleDeviceIdCache() async {
  _resolvedSaleDeviceIdMemory = null;
  ProxyService.box.remove(key: kSaleDeviceIdStorageKey);
}

/// One suffix per native app install (stable across sessions). Web tabs get a
/// fresh suffix each Ditto init so peers and pending carts stay isolated.
Future<String> resolveDittoInstallSuffix() async {
  if (kIsWeb) {
    return DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  }

  final cached = ProxyService.box.readString(key: kDittoInstallSuffixStorageKey);
  if (cached != null && cached.isNotEmpty) return cached;

  final suffix = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  await ProxyService.box.writeString(
    key: kDittoInstallSuffixStorageKey,
    value: suffix,
  );
  return suffix;
}

bool _saleDeviceIdMatchesUser(String deviceId, String? userId) {
  final id = userId?.trim();
  if (id == null || id.isEmpty) return true;
  return deviceId.contains(id);
}

/// Stable id for scoping pending carts per physical install / Ditto peer.
///
/// Order: Ditto [identity] (sync configuration for this open instance), then
/// cached value, then [DeviceIdService], then a persisted random UUID.
Future<String> resolveSaleDeviceId() async {
  final mem = _resolvedSaleDeviceIdMemory;
  if (mem != null && mem.isNotEmpty) {
    if (_saleDeviceIdMatchesUser(mem, ProxyService.box.getUserId())) {
      return mem;
    }
    await resetSaleDeviceIdCache();
  }

  final boxUserId = ProxyService.box.getUserId();
  final ditto = DittoService.instance.dittoInstance;
  final rawKey = ditto == null ? null : ditto.deviceName;
  final dittoName = rawKey?.trim();
  if (dittoName != null && dittoName.isNotEmpty) {
    if (_saleDeviceIdMatchesUser(dittoName, boxUserId)) {
      _resolvedSaleDeviceIdMemory = dittoName;
      unawaited(_persistSaleDeviceIdIfChanged(dittoName));
      return dittoName;
    }
  }

  var cached = ProxyService.box.readString(key: kSaleDeviceIdStorageKey);
  if (cached != null && cached.isNotEmpty) {
    if (!_saleDeviceIdMatchesUser(cached, boxUserId)) {
      await resetSaleDeviceIdCache();
      cached = null;
    }
  }
  if (cached != null && cached.isNotEmpty) {
    _resolvedSaleDeviceIdMemory = cached;
    return cached;
  }

  try {
    final hw = await getIt<Device>().getDeviceId();
    if (hw != null && hw.isNotEmpty) {
      _resolvedSaleDeviceIdMemory = hw;
      unawaited(
        ProxyService.box.writeString(
          key: kSaleDeviceIdStorageKey,
          value: hw,
        ),
      );
      return hw;
    }
  } catch (_) {}

  final fallback = const Uuid().v4();
  _resolvedSaleDeviceIdMemory = fallback;
  unawaited(
    ProxyService.box.writeString(
      key: kSaleDeviceIdStorageKey,
      value: fallback,
    ),
  );
  return fallback;
}

Future<void> _persistSaleDeviceIdIfChanged(String value) async {
  final existing = ProxyService.box.readString(key: kSaleDeviceIdStorageKey);
  if (existing != value) {
    await ProxyService.box.writeString(
      key: kSaleDeviceIdStorageKey,
      value: value,
    );
  }
}
