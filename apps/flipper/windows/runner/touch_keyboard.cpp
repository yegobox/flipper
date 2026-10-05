// WinRT ABI types live under the ABI:: namespace prefix.
#ifndef MIDL_NS_PREFIX
#define MIDL_NS_PREFIX
#endif

#include "touch_keyboard.h"

#include <flutter/standard_method_codec.h>
#include <flutter_windows.h>
#include <inputpaneinterop.h>
#include <roapi.h>
#include <windows.ui.viewmanagement.h>
#include <wrl/client.h>
#include <wrl/event.h>
#include <wrl/wrappers/corewrappers.h>

namespace {

using ABI::Windows::UI::ViewManagement::IInputPane;
using ABI::Windows::UI::ViewManagement::IInputPane2;
using ABI::Windows::UI::ViewManagement::IInputPaneVisibilityEventArgs;
using Microsoft::WRL::Callback;
using Microsoft::WRL::ComPtr;

using InputPaneEventHandler = ABI::Windows::Foundation::ITypedEventHandler<
    ABI::Windows::UI::ViewManagement::InputPane*,
    ABI::Windows::UI::ViewManagement::InputPaneVisibilityEventArgs*>;

constexpr char kChannelName[] = "flipper/touch_keyboard";

// Thread messages handled by the worker's message loop.
constexpr UINT kWorkerShow = WM_APP + 1;
constexpr UINT kWorkerHide = WM_APP + 2;

// Posted to the top-level window when the keyboard shows or hides.
constexpr UINT kPaneChanged = WM_APP + 0x0B42;  // stays below 0xC000

// A shrink this recent when `Showing` arrives is taken to be the keyboard
// docking, and undone.
constexpr ULONGLONG kSqueezeWindowMs = 1500;

int Width(const RECT& r) { return r.right - r.left; }
int Height(const RECT& r) { return r.bottom - r.top; }

}  // namespace

TouchKeyboard::TouchKeyboard(flutter::BinaryMessenger* messenger, HWND window,
                             HWND view)
    : window_(window), view_(view) {
  channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      messenger, kChannelName, &flutter::StandardMethodCodec::GetInstance());
  channel_->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
                 result) {
        if (call.method_name() == "show") {
          PostToWorker(kWorkerShow);
          result->Success();
        } else if (call.method_name() == "hide") {
          PostToWorker(kWorkerHide);
          result->Success();
        } else {
          result->NotImplemented();
        }
      });

  GetWindowRect(window_, &current_rect_);
  before_shrink_rect_ = current_rect_;

  HANDLE started = CreateEvent(nullptr, TRUE, FALSE, nullptr);
  worker_ = std::thread([this, started]() {
    MSG msg;
    // Create this thread's message queue before anyone posts to it.
    PeekMessage(&msg, nullptr, WM_USER, WM_USER, PM_NOREMOVE);
    worker_id_ = GetCurrentThreadId();
    SetEvent(started);
    WorkerMain();
  });
  if (started) {
    WaitForSingleObject(started, INFINITE);
    CloseHandle(started);
  }
}

TouchKeyboard::~TouchKeyboard() {
  channel_->SetMethodCallHandler(nullptr);
  if (worker_id_ != 0) {
    PostThreadMessage(worker_id_, WM_QUIT, 0, 0);
  }
  if (worker_.joinable()) {
    worker_.join();
  }
}

void TouchKeyboard::PostToWorker(UINT message) {
  if (worker_id_ != 0) {
    PostThreadMessage(worker_id_, message, 0, 0);
  }
}

void TouchKeyboard::WorkerMain() {
  const HRESULT co = CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  ComPtr<IInputPaneInterop> interop;
  ComPtr<IInputPane> pane;
  ComPtr<IInputPane2> pane2;
  EventRegistrationToken shown_token{};
  EventRegistrationToken hidden_token{};

  // Windows 10 1803+ (Chromium's threshold for InputPane). On anything older
  // this fails and Windows' own focus-driven keyboard is all there is.
  HRESULT hr = RoGetActivationFactory(
      Microsoft::WRL::Wrappers::HStringReference(
          RuntimeClass_Windows_UI_ViewManagement_InputPane)
          .Get(),
      IID_PPV_ARGS(&interop));
  if (SUCCEEDED(hr)) {
    hr = interop->GetForWindow(window_, IID_PPV_ARGS(&pane));
  }
  if (SUCCEEDED(hr)) {
    hr = pane.As(&pane2);
  }
  if (SUCCEEDED(hr)) {
    pane->add_Showing(
        Callback<InputPaneEventHandler>(
            [this](IInputPane* sender,
                   IInputPaneVisibilityEventArgs* args) -> HRESULT {
              // The app moves its own content; Windows must not.
              args->put_EnsuredFocusedElementInView(TRUE);
              ABI::Windows::Foundation::Rect r{};
              sender->get_OccludedRect(&r);
              const RECT dips{static_cast<LONG>(r.X), static_cast<LONG>(r.Y),
                              static_cast<LONG>(r.X + r.Width),
                              static_cast<LONG>(r.Y + r.Height)};
              OnPaneVisibility(true, dips);
              return S_OK;
            })
            .Get(),
        &shown_token);
    pane->add_Hiding(
        Callback<InputPaneEventHandler>(
            [this](IInputPane*, IInputPaneVisibilityEventArgs*) -> HRESULT {
              OnPaneVisibility(false, RECT{});
              return S_OK;
            })
            .Get(),
        &hidden_token);
  } else {
    pane.Reset();
    pane2.Reset();
  }

  MSG msg;
  while (GetMessage(&msg, nullptr, 0, 0) > 0) {
    if (msg.hwnd == nullptr &&
        (msg.message == kWorkerShow || msg.message == kWorkerHide)) {
      if (pane2) {
        boolean ignored = FALSE;
        if (msg.message == kWorkerShow) {
          pane2->TryShow(&ignored);
        } else {
          pane2->TryHide(&ignored);
        }
      }
      continue;
    }
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }

  if (pane) {
    pane->remove_Showing(shown_token);
    pane->remove_Hiding(hidden_token);
  }
  pane2.Reset();
  pane.Reset();
  interop.Reset();
  if (SUCCEEDED(co)) {
    CoUninitialize();
  }
}

void TouchKeyboard::OnPaneVisibility(bool visible,
                                     const RECT& screen_rect_dips) {
  {
    std::lock_guard<std::mutex> lock(rect_mutex_);
    occluded_dips_ = screen_rect_dips;
  }
  visible_ = visible;
  PostMessage(window_, kPaneChanged, 0, 0);
}

void TouchKeyboard::OnPaneChanged() {
  if (!visible_) {
    channel_->InvokeMethod("occluded", nullptr);
    return;
  }

  // The work area can shrink just before `Showing` reaches us, squeezing the
  // window before the veto below is armed. Put it back.
  if (IsZoomed(window_) &&
      GetTickCount64() - last_shrink_tick_ < kSqueezeWindowMs &&
      Height(current_rect_) < Height(before_shrink_rect_)) {
    restoring_ = true;
    SetWindowPos(window_, nullptr, before_shrink_rect_.left,
                 before_shrink_rect_.top, Width(before_shrink_rect_),
                 Height(before_shrink_rect_), SWP_NOZORDER | SWP_NOACTIVATE);
    restoring_ = false;
  }

  RECT dips;
  {
    std::lock_guard<std::mutex> lock(rect_mutex_);
    dips = occluded_dips_;
  }
  // OccludedRect is in screen DIPs; the Flutter view works in physical pixels.
  const double scale =
      FlutterDesktopGetDpiForMonitor(
          MonitorFromWindow(window_, MONITOR_DEFAULTTONEAREST)) /
      96.0;
  POINT corners[2] = {
      {static_cast<LONG>(dips.left * scale),
       static_cast<LONG>(dips.top * scale)},
      {static_cast<LONG>(dips.right * scale),
       static_cast<LONG>(dips.bottom * scale)},
  };
  MapWindowPoints(nullptr, view_, corners, 2);

  flutter::EncodableMap rect{
      {flutter::EncodableValue("left"),
       flutter::EncodableValue(static_cast<double>(corners[0].x))},
      {flutter::EncodableValue("top"),
       flutter::EncodableValue(static_cast<double>(corners[0].y))},
      {flutter::EncodableValue("right"),
       flutter::EncodableValue(static_cast<double>(corners[1].x))},
      {flutter::EncodableValue("bottom"),
       flutter::EncodableValue(static_cast<double>(corners[1].y))},
  };
  channel_->InvokeMethod("occluded",
                         std::make_unique<flutter::EncodableValue>(rect));
}

std::optional<LRESULT> TouchKeyboard::HandleMessage(HWND hwnd, UINT message,
                                                    WPARAM /*wparam*/,
                                                    LPARAM lparam) {
  if (hwnd != window_) {
    return std::nullopt;
  }
  switch (message) {
    case kPaneChanged:
      OnPaneChanged();
      return 0;

    case WM_WINDOWPOSCHANGING: {
      auto* pos = reinterpret_cast<WINDOWPOS*>(lparam);
      if (!visible_ || restoring_ || !IsZoomed(window_) ||
          (pos->flags & SWP_NOSIZE)) {
        break;
      }
      // Only the docking squeeze: same top-left and width, just shorter.
      // Minimize, restore and moves to another monitor all pass.
      const bool same_origin =
          (pos->flags & SWP_NOMOVE) ||
          (pos->x == current_rect_.left && pos->y == current_rect_.top);
      if (same_origin && pos->cx == Width(current_rect_) &&
          pos->cy < Height(current_rect_)) {
        pos->flags |= SWP_NOSIZE | SWP_NOMOVE;
      }
      break;
    }

    case WM_WINDOWPOSCHANGED: {
      RECT now{};
      GetWindowRect(window_, &now);
      if (!restoring_ && Width(now) == Width(current_rect_) &&
          Height(now) < Height(current_rect_)) {
        before_shrink_rect_ = current_rect_;
        last_shrink_tick_ = GetTickCount64();
      }
      current_rect_ = now;
      break;
    }
  }
  return std::nullopt;
}
