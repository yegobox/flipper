#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  amplify_db_common
  connectivity_plus
  desktop_webview_auth
  device_type
  file_selector_windows
  firebase_auth
  firebase_core
  firebase_storage
  flutter_localization
  flutter_window_close
  geolocator_windows
  local_auth_windows
  local_notifier
  permission_handler_windows
  printing
  realm
  screen_retriever
  sentry_flutter
  share_plus
  smart_auth
  tray_manager
  url_launcher_windows
  window_manager
  window_size
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/windows plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)

foreach(ffi_plugin ${FLUTTER_FFI_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${ffi_plugin}/windows plugins/${ffi_plugin})
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${ffi_plugin}_bundled_libraries})
endforeach(ffi_plugin)
