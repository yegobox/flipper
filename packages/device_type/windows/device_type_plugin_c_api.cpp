#include "include/device_type/device_type_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "device_type_plugin.h"

void DeviceTypePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  device_type::DeviceTypePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
