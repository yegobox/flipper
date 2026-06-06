# Project-level configuration.
cmake_minimum_required(VERSION 3.14)
project(flipper LANGUAGES CXX)

# MSVC 18.6+ (STL1011): plugins using /await + <experimental/coroutine> fail to compile.
# /await keeps one legacy coroutine ABI across app + WebView2/cppwinrt plugins (LNK4078 .voltbl).
add_compile_definitions(_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS /await /WX-")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /WX- /wd4100 /wd4189 /wd4244 /wd4245 /wd4456 /wd4459 /wd4701 /wd4702")

# The target_link_libraries call can stay the same since it will use
# whichever sqlite3 target exists

# The name of the executable created for the application. Change this to change
# the on-disk name of your application.
set(BINARY_NAME "flipper")


# Explicitly opt in to modern CMake behaviors to avoid warnings with recent
# versions of CMake.
cmake_policy(VERSION 3.14...3.25)
# CMP0175 (CMake 3.31+): desktop_webview_auth uses DEPENDS on add_custom_command(TARGET).
cmake_policy(SET CMP0175 OLD)

# Define build configuration option.
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release"
    CACHE STRING "" FORCE)
else()
  if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE
      STRING "Flutter build mode" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
      "Debug" "Profile" "Release")
  endif()
endif()

# Define settings for the Profile build mode.
set(CMAKE_EXE_LINKER_FLAGS_PROFILE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_RELEASE}")

# Use Unicode for all projects.
add_definitions(-DUNICODE -D_UNICODE)

# Compilation settings that should be applied to most targets.
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
  # No /WX: third-party plugins (flutter_soloud, stb_vorbis, etc.) fail on VS 2026.
  set_target_properties(${TARGET} PROPERTIES COMPILE_WARNING_AS_ERROR OFF)
  target_compile_options(${TARGET} PRIVATE /W4 /WX- /wd"4100" /wd"4189" /wd"4244" /wd"4245" /wd"4456" /wd"4459" /wd"4701" /wd"4702")
  target_compile_options(${TARGET} PRIVATE /EHsc "$<$<COMPILE_LANGUAGE:CXX>:/await>")
  target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=0")
  target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
endfunction()

# Flutter library and tool build rules.
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR})

# Application build; see runner/CMakeLists.txt.
add_subdirectory("runner")

# set(CMAKE_BUILD_TYPE "Release")
# Generated plugin build rules, which manage building the plugins and adding
# them to the application.
include(flutter/generated_plugins.cmake)

# VS 2026: flutter_soloud bundles stb_vorbis/miniaudio with many /W4 warnings. scripts/ci/
# patch-windows-plugins.ps1 also strips copy_pdbs, /GL, and /LTCG from the plugin CMake.
if(MSVC AND TARGET flutter_soloud_plugin)
  get_target_property(_soloud_type flutter_soloud_plugin TYPE)
  if(NOT _soloud_type STREQUAL "ALIAS")
    set_target_properties(flutter_soloud_plugin PROPERTIES COMPILE_WARNING_AS_ERROR OFF)
    target_compile_options(flutter_soloud_plugin PRIVATE /W0 /WX-)
  endif()
endif()

# === Installation ===
# Support files are copied into place next to the executable, so that it can
# run in place. This is done instead of making a separate bundle (as on Linux)
# so that building and running from within Visual Studio will work.
set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")
# Make the "install" step default, as it's required to run.
set(CMAKE_VS_INCLUDE_INSTALL_TO_DEFAULT_BUILD 1)
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

if(PLUGIN_BUNDLED_LIBRARIES)
  install(FILES "${PLUGIN_BUNDLED_LIBRARIES}"
    DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
endif()

# Copy the native assets provided by the build.dart from all packages.
# Flutter may skip native_assets when no FFI assets exist; install only if present.
set(NATIVE_ASSETS_DIR "${PROJECT_BUILD_DIR}native_assets/windows/")
if(EXISTS "${NATIVE_ASSETS_DIR}")
  install(DIRECTORY "${NATIVE_ASSETS_DIR}"
     DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
     COMPONENT Runtime)
endif()

# Fully re-copy the assets directory on each build to avoid having stale files
# from a previous install.
set(FLUTTER_ASSET_DIR_NAME "flutter_assets")
install(CODE "
  file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}\")
  " COMPONENT Runtime)
install(DIRECTORY "${PROJECT_BUILD_DIR}/${FLUTTER_ASSET_DIR_NAME}"
  DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)

# Install the AOT library on non-Debug builds only.
install(FILES "${AOT_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  CONFIGURATIONS Profile;Release
  COMPONENT Runtime)
