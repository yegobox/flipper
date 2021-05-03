#!/usr/bin/env bash

# Fast fail the script on failures.
set -e

pub run test:test 	test/pusher_test.dart

# If the COVERALLS_TOKEN token is set on travis
# Install dart_coveralls
# Rerun tests with coverage and send to coveralls
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --exclude-test-files \
    --retry 2 \
    test/pusher_test.dart
fi
