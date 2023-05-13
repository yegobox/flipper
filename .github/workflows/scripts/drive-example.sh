.#!/bin/bash

ACTION=$1

if [ "$ACTION" == "android" ]
then
  # Sleep to allow emulator to settle.
  sleep 15
  melos exec -c 1 --fail-fast --scope="$PLUS_PLUGIN_SCOPE_EXAMPLE" --dir-exists=test_driver -- \
    flutter drive $FLUTTER_COMMAND_FLAGS --no-pub --target=./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "ios" ]
then
  SIMULATOR="iPhone 11"
  # Boot simulator and wait for System app to be ready.
  xcrun simctl bootstatus "$SIMULATOR" -b
  xcrun simctl logverbose "$SIMULATOR" enable
  # Sleep to allow simulator to settle.
  sleep 15
  # Uncomment following line to have simulator logs printed out for debugging purposes.
  # xcrun simctl spawn booted log stream --predicate 'eventMessage contains "flutter"' &
  melos exec -c 1 --fail-fast --scope="$PLUS_PLUGIN_SCOPE_EXAMPLE" --dir-exists=test_driver -- \
    flutter drive $FLUTTER_COMMAND_FLAGS -d \"$SIMULATOR\" --no-pub --target=./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart --dart-define=CI=true
  MELOS_EXIT_CODE=$?
  xcrun simctl shutdown "$SIMULATOR"
  exit $MELOS_EXIT_CODE
fi

if [ "$ACTION" == "macos" ]
then
  melos exec -c 1 --fail-fast --scope="$PLUS_PLUGIN_SCOPE_EXAMPLE" --dir-exists=test_driver -- \
    flutter drive $FLUTTER_COMMAND_FLAGS -d macos --no-pub --target=./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "linux" ]
then
  melos exec -c 1 --fail-fast --scope="$PLUS_PLUGIN_SCOPE_EXAMPLE" --dir-exists=test_driver -- \
    flutter drive $FLUTTER_COMMAND_FLAGS -d linux --no-pub --target=./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "windows" ]
then
  melos exec -c 1 --fail-fast --scope="$PLUS_PLUGIN_SCOPE_EXAMPLE" --dir-exists=test_driver -- \
    flutter drive $FLUTTER_COMMAND_FLAGS -d windows --no-pub --target=./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "web" ]
then
  melos bootstrap --scope="$PLUS_PLUGIN_SCOPE"
  chromedriver --port=4444 & melos exec -c 1 --scope="$PLUS_PLUGIN_SCOPE_EXAMPLE" --dir-exists=web -- \
    flutter drive $FLUTTER_COMMAND_FLAGS --no-pub --verbose-system-logs --device-id=web-server --target=./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart --dart-define=CI=true
  exit
fi