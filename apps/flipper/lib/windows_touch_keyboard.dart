import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:win32/win32.dart'
    show
        COINIT_APARTMENTTHREADED,
        COMObject,
        CoInitializeEx,
        GetDesktopWindow,
        RECT,
        SUCCEEDED,
        SW_SHOWNOACTIVATE,
        ShellExecute,
        VTablePointer;

import 'touch_keyboard.dart';

TouchKeyboard? createTouchKeyboard() =>
    Platform.isWindows ? WindowsTouchKeyboard() : null;

// Undocumented but stable since Windows 8; the same interfaces the taskbar
// keyboard button uses.
const _clsidUIHostNoLaunch = '{4CE576FA-83DC-4F88-951C-9D0782B4E376}';
const _iidITipInvocation = '{37C994E7-432B-4834-A2F7-DCE1F13B834B}';
const _clsidFrameworkInputPane = '{D5120AA3-46BA-44C5-822D-CA8092C1FC72}';
const _iidIFrameworkInputPane = '{5752238B-24F0-495A-82F1-2FD593056796}';

// vtable slots after IUnknown's QueryInterface/AddRef/Release.
const _iTipInvocationToggle = 3; // Toggle(HWND)
const _iFrameworkInputPaneLocation =
    6; // after Advise, AdviseWithHWND, Unadvise

typedef _ToggleNative = Int32 Function(VTablePointer self, IntPtr hwnd);
typedef _ToggleDart = int Function(VTablePointer self, int hwnd);
typedef _LocationNative = Int32 Function(VTablePointer self, Pointer<RECT> rc);
typedef _LocationDart = int Function(VTablePointer self, Pointer<RECT> rc);
typedef _ReleaseNative = Uint32 Function(VTablePointer self);
typedef _ReleaseDart = int Function(VTablePointer self);

/// The Windows touch keyboard (TabTip), driven through `ITipInvocation`.
///
/// `ITipInvocation` only toggles, so `IFrameworkInputPane` is read first to
/// learn whether the keyboard is already up. Every failure is swallowed: a
/// missing keyboard must never break typing.
class WindowsTouchKeyboard implements TouchKeyboard {
  bool _comReady = false;

  @override
  void show() {
    _guard(() {
      if (_isVisible()) return;
      if (_toggle()) return;
      // TabTip is not running yet; starting it usually opens the keyboard.
      _launchTabTip();
      Timer(const Duration(milliseconds: 400), () {
        _guard(() {
          if (!_isVisible()) _toggle();
        });
      });
    });
  }

  @override
  void hide() {
    _guard(() {
      if (_isVisible()) _toggle();
    });
  }

  void _guard(void Function() body) {
    try {
      _ensureCom();
      body();
    } catch (e) {
      debugPrint('Windows touch keyboard: $e');
    }
  }

  void _ensureCom() {
    if (_comReady) return;
    // S_FALSE / RPC_E_CHANGED_MODE both leave COM usable on this thread.
    CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
    _comReady = true;
  }

  bool _isVisible() {
    final pane = _create(_clsidFrameworkInputPane, _iidIFrameworkInputPane);
    if (pane == null) return false;
    final rect = calloc<RECT>();
    try {
      final location =
          _method<_LocationNative>(pane, _iFrameworkInputPaneLocation)
              .asFunction<_LocationDart>();
      if (!SUCCEEDED(location(pane.ref.lpVtbl, rect))) return false;
      return rect.ref.right > rect.ref.left && rect.ref.bottom > rect.ref.top;
    } finally {
      calloc.free(rect);
      _release(pane);
    }
  }

  bool _toggle() {
    final tip = _create(_clsidUIHostNoLaunch, _iidITipInvocation);
    if (tip == null) return false;
    try {
      final toggle = _method<_ToggleNative>(tip, _iTipInvocationToggle)
          .asFunction<_ToggleDart>();
      return SUCCEEDED(toggle(tip.ref.lpVtbl, GetDesktopWindow()));
    } finally {
      _release(tip);
    }
  }

  void _launchTabTip() {
    final common = Platform.environment['CommonProgramW6432'] ??
        Platform.environment['CommonProgramFiles'] ??
        r'C:\Program Files\Common Files';
    final operation = 'open'.toNativeUtf16(allocator: calloc);
    final file = '$common\\microsoft shared\\ink\\TabTip.exe'
        .toNativeUtf16(allocator: calloc);
    try {
      ShellExecute(0, operation, file, nullptr, nullptr, SW_SHOWNOACTIVATE);
    } finally {
      calloc.free(operation);
      calloc.free(file);
    }
  }

  static Pointer<COMObject>? _create(String clsid, String iid) {
    try {
      return COMObject.createFromID(clsid, iid);
    } catch (_) {
      return null;
    }
  }

  static Pointer<NativeFunction<T>> _method<T extends Function>(
    Pointer<COMObject> object,
    int slot,
  ) =>
      (object.ref.vtable + slot).cast<Pointer<NativeFunction<T>>>().value;

  static void _release(Pointer<COMObject> object) {
    _method<_ReleaseNative>(object, 2)
        .asFunction<_ReleaseDart>()(object.ref.lpVtbl);
    calloc.free(object);
  }
}
