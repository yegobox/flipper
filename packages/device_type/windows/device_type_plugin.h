#ifndef FLUTTER_PLUGIN_DEVICE_TYPE_PLUGIN_H_
#define FLUTTER_PLUGIN_DEVICE_TYPE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace device_type {

class DeviceTypePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DeviceTypePlugin();

  virtual ~DeviceTypePlugin();

  // Disallow copy and assign.
  DeviceTypePlugin(const DeviceTypePlugin&) = delete;
  DeviceTypePlugin& operator=(const DeviceTypePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace device_type

#endif  // FLUTTER_PLUGIN_DEVICE_TYPE_PLUGIN_H_
