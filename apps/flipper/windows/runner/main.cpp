#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <objbase.h>
#include <propsys.h>
#include <shellapi.h>

#include <cstring>
#include <cwchar>
#include <string>

#include "flutter_window.h"
#include "utils.h"

namespace {

// Single-instance guard name. Shared by the dev exe, the raw release exe, and
// the MSIX package so that only one Flipper ever runs — and therefore only one
// process holds the exclusive Turso/libsql lock on flipper.sqlite. The
// "Global\\" namespace makes the mutex visible across user sessions and from
// the full-trust packaged (MSIX) process.
constexpr wchar_t kSingleInstanceMutexName[] =
    L"Global\\yegobox.flipper.single-instance";

// Native window class registered by the Flutter runner (see win32_window.cpp).
constexpr wchar_t kFlutterWindowClassName[] = L"FLUTTER_RUNNER_WIN32_WINDOW";

// Brings an already-running Flipper window to the foreground so a second launch
// surfaces the existing instance instead of silently doing nothing.
void FocusExistingInstance() {
  HWND existing = ::FindWindowW(kFlutterWindowClassName, nullptr);
  if (existing == nullptr) {
    return;
  }
  if (::IsIconic(existing)) {
    ::ShowWindow(existing, SW_RESTORE);
  }
  ::SetForegroundWindow(existing);
}

// --- Taskbar identity when started by Atlas (the Yegobox launcher) ---------
//
// Atlas installs Flipper under ...\apps\flipper\versions\<ver>\ and deletes
// old versions. Pinning the running window used to pin that exe path, so after
// two updates the pin pointed at a deleted folder and stopped working. Atlas
// now passes an AppUserModelID and a relaunch command (its own
// "--launch flipper"), and the window carries them: Windows groups it with
// Atlas's Flipper shortcut, and a pin opens Flipper through Atlas, which
// always starts the current version. See flipper-launcher src/winshell.rs.
// Store (MSIX) installs and `flutter run` don't set these variables and keep
// Windows' default identity.

std::wstring EnvVar(const wchar_t* name) {
  DWORD size = ::GetEnvironmentVariableW(name, nullptr, 0);
  if (size == 0) {
    return std::wstring();
  }
  std::wstring value(size, L'\0');
  DWORD written = ::GetEnvironmentVariableW(name, value.data(), size);
  if (written == 0 || written >= size) {
    return std::wstring();
  }
  value.resize(written);
  return value;
}

// PKEY_AppUserModel_* from propkey.h, spelled out so this file needs neither
// INITGUID nor propsys.lib.
constexpr GUID kAppUserModelFmtid = {
    0x9F4C2855, 0x9F79, 0x4B39, {0xA8, 0xD0, 0xE1, 0xD4, 0x2D, 0xE1, 0xD5, 0xF3}};
const PROPERTYKEY kRelaunchCommand = {kAppUserModelFmtid, 2};
const PROPERTYKEY kRelaunchIconResource = {kAppUserModelFmtid, 3};
const PROPERTYKEY kRelaunchDisplayNameResource = {kAppUserModelFmtid, 4};
const PROPERTYKEY kAppUserModelId = {kAppUserModelFmtid, 5};

// Failures go to the debugger output (DebugView on a till), so a pin that
// still points at a version folder can be traced to the call that failed.
void LogTaskbarIdentityFailure(const wchar_t* step, HRESULT hr) {
  wchar_t message[160];
  std::swprintf(message, sizeof(message) / sizeof(message[0]),
                L"Flipper taskbar identity: %ls failed (HRESULT 0x%08lX)\n",
                step, static_cast<unsigned long>(hr));
  ::OutputDebugStringW(message);
}

// The shell wants VT_LPWSTR strings here.
void SetWindowString(IPropertyStore* store, const PROPERTYKEY& key,
                     const wchar_t* step, const std::wstring& value) {
  PROPVARIANT var;
  PropVariantInit(&var);
  const size_t bytes = (value.size() + 1) * sizeof(wchar_t);
  var.pwszVal = static_cast<LPWSTR>(::CoTaskMemAlloc(bytes));
  if (var.pwszVal == nullptr) {
    LogTaskbarIdentityFailure(step, E_OUTOFMEMORY);
    return;
  }
  std::memcpy(var.pwszVal, value.c_str(), bytes);
  var.vt = VT_LPWSTR;
  const HRESULT hr = store->SetValue(key, var);
  if (FAILED(hr)) {
    LogTaskbarIdentityFailure(step, hr);
  }
  ::PropVariantClear(&var);
}

void ApplyLauncherTaskbarIdentity(HWND window) {
  const std::wstring id = EnvVar(L"YEGOBOX_AUMID");
  if (id.empty()) {
    return;
  }
  IPropertyStore* store = nullptr;
  const HRESULT hr =
      ::SHGetPropertyStoreForWindow(window, IID_PPV_ARGS(&store));
  if (FAILED(hr)) {
    LogTaskbarIdentityFailure(L"SHGetPropertyStoreForWindow", hr);
    return;
  }
  // The relaunch command only counts with a display name. Set both before the
  // ID, so the shell reads a complete set when the ID arrives.
  const std::wstring command = EnvVar(L"YEGOBOX_RELAUNCH_COMMAND");
  const std::wstring name = EnvVar(L"YEGOBOX_RELAUNCH_NAME");
  if (!command.empty() && !name.empty()) {
    SetWindowString(store, kRelaunchCommand, L"RelaunchCommand", command);
    SetWindowString(store, kRelaunchDisplayNameResource,
                    L"RelaunchDisplayNameResource", name);
    const std::wstring icon = EnvVar(L"YEGOBOX_RELAUNCH_ICON");
    if (!icon.empty()) {
      SetWindowString(store, kRelaunchIconResource,
                      L"RelaunchIconResource", icon);
    }
  }
  SetWindowString(store, kAppUserModelId, L"AppUserModelID", id);
  store->Release();
}

}  // namespace

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Single-instance guard. Acquire BEFORE Flutter/Dart starts so a second
  // launch never reaches database initialization and never collides on the
  // flipper.sqlite lock. The OS releases the named mutex automatically when the
  // owning process exits, so a crashed instance leaves no stale lock.
  HANDLE instance_mutex =
      ::CreateMutexW(nullptr, TRUE, kSingleInstanceMutexName);
  if (instance_mutex != nullptr && ::GetLastError() == ERROR_ALREADY_EXISTS) {
    FocusExistingInstance();
    ::CloseHandle(instance_mutex);
    return EXIT_SUCCESS;
  }

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"flipper", origin, size)) {
    return EXIT_FAILURE;
  }
  // Before the window is shown, so the taskbar button starts with it.
  ApplyLauncherTaskbarIdentity(window.GetHandle());
  // Open maximized before Flutter draws its first frame, so the first frame is
  // rendered at full size. Maximizing later from Dart raced the first-frame
  // Show() and left a black border around a 1280x720 view.
  ::ShowWindow(window.GetHandle(), SW_MAXIMIZE);
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();

  if (instance_mutex != nullptr) {
    ::ReleaseMutex(instance_mutex);
    ::CloseHandle(instance_mutex);
  }
  return EXIT_SUCCESS;
}
