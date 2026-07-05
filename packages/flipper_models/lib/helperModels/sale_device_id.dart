import 'dart:async';

import 'package:flipper_services/DeviceIdService.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/core/flipper_web_host.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:uuid/uuid.dart';

/// SharedPreferences / local storage key for the resolved sale device id fallback.
const kSaleDeviceIdStorageKey = 'sale_device_id';

/// Stable per-install suffix for Ditto [deviceName] on native (web uses ephemeral).
const kDittoInstallSuffixStorageKey = 'ditto_install_suffix';

/// In-memory cache — park/resume paths call [resolveSaleDeviceId] many times per
/// action; avoid repeated async storage writes on the hot path.
String? _resolvedSaleDeviceIdMemory;

bool _proxyBoxReady() {
  try {
    return getIt.isRegistered<LocalStorage>();
  } catch (_) {
    return false;
  }
}

Future<String?> _readStoredString(String key) async {
  if (flipperWebIsHostApp) {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key)?.trim();
    return value == null || value.isEmpty ? null : value;
  }
  if (!_proxyBoxReady()) return null;
  return ProxyService.box.readString(key: key);
}

Future<void> _writeStoredString(String key, String value) async {
  if (flipperWebIsHostApp) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    return;
  }
  if (!_proxyBoxReady()) return;
  await ProxyService.box.writeString(key: key, value: value);
}

Future<void> _removeStoredString(String key) async {
  if (flipperWebIsHostApp) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    return;
  }
  if (!_proxyBoxReady()) return;
  ProxyService.box.remove(key: key);
}

Future<String?> _userIdForDeviceMatch() async {
  if (flipperWebIsHostApp) {
    return _readStoredString('flipper_web_api_user_id');
  }
  if (!_proxyBoxReady()) return null;
  return ProxyService.box.getUserId();
}

/// Clears cached sale device id so the next [resolveSaleDeviceId] uses the
/// current Ditto [deviceName] (after userId change, logout, or Ditto re-init).
Future<void> resetSaleDeviceIdCache() async {
  _resolvedSaleDeviceIdMemory = null;
  await _removeStoredString(kSaleDeviceIdStorageKey);
}

/// One suffix per native app install (stable across sessions). Web tabs get a
/// fresh suffix each Ditto init so peers and pending carts stay isolated.
Future<String> resolveDittoInstallSuffix() async {
  if (kIsWeb) {
    return DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  }

  final cached = flipperWebIsHostApp
      ? await _readStoredString(kDittoInstallSuffixStorageKey)
      : (_proxyBoxReady()
          ? ProxyService.box.readString(key: kDittoInstallSuffixStorageKey)
          : null);
  if (cached != null && cached.isNotEmpty) return cached;

  final suffix = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  if (flipperWebIsHostApp) {
    await _writeStoredString(kDittoInstallSuffixStorageKey, suffix);
  } else if (_proxyBoxReady()) {
    await ProxyService.box.writeString(
      key: kDittoInstallSuffixStorageKey,
      value: suffix,
    );
  }
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
  final boxUserId = await _userIdForDeviceMatch();

  final mem = _resolvedSaleDeviceIdMemory;
  if (mem != null && mem.isNotEmpty) {
    if (_saleDeviceIdMatchesUser(mem, boxUserId)) {
      return mem;
    }
    await resetSaleDeviceIdCache();
  }

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

  var cached = await _readStoredString(kSaleDeviceIdStorageKey);
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
      unawaited(_writeStoredString(kSaleDeviceIdStorageKey, hw));
      return hw;
    }
  } catch (_) {}

  final fallback = const Uuid().v4();
  _resolvedSaleDeviceIdMemory = fallback;
  unawaited(_writeStoredString(kSaleDeviceIdStorageKey, fallback));
  return fallback;
}

Future<void> _persistSaleDeviceIdIfChanged(String value) async {
  final existing = await _readStoredString(kSaleDeviceIdStorageKey);
  if (existing != value) {
    await _writeStoredString(kSaleDeviceIdStorageKey, value);
  }
}
