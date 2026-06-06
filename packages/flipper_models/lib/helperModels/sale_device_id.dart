import 'dart:async';

import 'package:flipper_services/DeviceIdService.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:uuid/uuid.dart';

/// SharedPreferences / local storage key for the resolved sale device id fallback.
const kSaleDeviceIdStorageKey = 'sale_device_id';

/// In-memory cache — park/resume paths call [resolveSaleDeviceId] many times per
/// action; avoid repeated async storage writes on the hot path.
String? _resolvedSaleDeviceIdMemory;

/// Stable id for scoping pending carts per physical install / Ditto peer.
///
/// Order: Ditto [identity] (sync configuration for this open instance), then
/// cached value, then [DeviceIdService], then a persisted random UUID.
Future<String> resolveSaleDeviceId() async {
  final mem = _resolvedSaleDeviceIdMemory;
  if (mem != null && mem.isNotEmpty) return mem;

  final ditto = DittoService.instance.dittoInstance;
  final rawKey = ditto == null ? null : ditto.deviceName;
  final dittoName = rawKey?.trim();
  if (dittoName != null && dittoName.isNotEmpty) {
    _resolvedSaleDeviceIdMemory = dittoName;
    unawaited(_persistSaleDeviceIdIfChanged(dittoName));
    return dittoName;
  }

  final cached = ProxyService.box.readString(key: kSaleDeviceIdStorageKey);
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
