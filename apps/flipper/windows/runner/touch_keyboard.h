#ifndef RUNNER_TOUCH_KEYBOARD_H_
#define RUNNER_TOUCH_KEYBOARD_H_

#include <flutter/binary_messenger.h>
#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <windows.h>

#include <atomic>
#include <memory>
#include <mutex>
#include <optional>
#include <thread>

// Drives the Windows touch keyboard for the Flutter view over the
// `flipper/touch_keyboard` channel.
//
// - `show` / `hide` from Dart map to InputPane TryShow / TryHide, which are
//   idempotent, so they never fight the keyboard Windows opens by itself when
//   focus moves into a text field.
// - While the keyboard is up, a maximized window is not allowed to shrink to
//   the reduced work area (the "squeeze"); Dart is told which part of the view
//   the keyboard covers (`occluded`) and slides the focused field into view.
//
// InputPane calls run on a dedicated STA thread with its own message loop, as
// Chromium does, so a slow keyboard process never stalls the UI thread.
class TouchKeyboard {
 public:
  TouchKeyboard(flutter::BinaryMessenger* messenger, HWND window, HWND view);
  ~TouchKeyboard();

  TouchKeyboard(const TouchKeyboard&) = delete;
  TouchKeyboard& operator=(const TouchKeyboard&) = delete;

  // Call first from the top-level window procedure. Returns a value only for
  // messages it fully handles; other messages may be adjusted in place (resize
  // veto) and must still be passed on.
  std::optional<LRESULT> HandleMessage(HWND hwnd, UINT message, WPARAM wparam,
                                       LPARAM lparam);

 private:
  void WorkerMain();
  void PostToWorker(UINT message);

  // Worker thread: keyboard shown or hidden.
  void OnPaneVisibility(bool visible, const RECT& screen_rect_dips);

  // UI thread: tell Dart, and undo a squeeze that landed before `Showing`.
  void OnPaneChanged();

  HWND window_;
  HWND view_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;

  std::thread worker_;
  DWORD worker_id_ = 0;

  std::atomic<bool> visible_{false};
  std::mutex rect_mutex_;
  RECT occluded_dips_{};

  // Window size bookkeeping for the resize veto (UI thread only).
  bool restoring_ = false;
  RECT current_rect_{};
  RECT before_shrink_rect_{};
  ULONGLONG last_shrink_tick_ = 0;
};

#endif  // RUNNER_TOUCH_KEYBOARD_H_
