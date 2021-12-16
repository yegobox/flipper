#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  connectivity_plus_windows
  flutter_acrylic
  nb_utils
  objectbox_sync_flutter_libs
  printing
  sentry_flutter
  system_theme
  url_launcher_windows
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/windows plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)
