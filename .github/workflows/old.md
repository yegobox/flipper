# name: CI/CD

# on:
#   # Enable manual run
#   workflow_dispatch:
#     inputs:
#       lane:
#         description: "Fastlane lane"
#         required: true
#         default: "internal"
#         type: choice
#         options:
#           - beta
#           - promote_to_production
#           - production
#   pull_request:
#     branches: 
#       - main

# env:
#   URL: ${{ secrets.DB_URL }}
#   PASSWORD: ${{ secrets.DB_PASSWORD }}
#   SHOREBIRD_TOKEN: ${{ secrets.SHOREBIRD_TOKEN }}

# jobs:
#   # code-coverage:
#   #   name: Check Code Coverage
#   #   runs-on: macOS-12
#   #   steps:
#   #     - name: Checkout Repository
#   #       uses: actions/checkout@v3

#   #     - name: Install Flutter
#   #       uses: subosito/flutter-action@v2
#   #       with:
#   #         channel: 'stable'

#   #     - run: git submodule update --init

#   #     - name: Configure Missing files
#   #       shell: bash
#   #       run: |
#   #         echo "$INDEX" >> apps/flipper/web/index.html
#   #         echo "$CONFIGDART" >> packages/flipper_login/lib/config.dart
#   #         echo "$SECRETS" >> packages/flipper_models/lib/secrets.dart
#   #         echo "$FIREBASEOPTIONS" >> apps/flipper/lib/firebase_options.dart
#   #         echo "$AMPLIFY_CONFIG" >> apps/flipper/lib/amplifyconfiguration.dart
#   #         echo "$FIREBASEOPTIONS" >> packages/flipper_models/lib/firebase_options.dart
#   #         git config --global core.autocrlf false
#   #         echo "$AMPLIFY_TEAM_PROVIDER" >> apps/flipper/amplify/team-provider-info.json 
#   #       env:
#   #         INDEX: ${{ secrets.INDEX }}
#   #         CONFIGDART: ${{ secrets.CONFIGDART }}
#   #         SECRETS: ${{ secrets.SECRETS }}
#   #         FIREBASEOPTIONS: ${{ secrets.FIREBASEOPTIONS }}
#   #         AMPLIFY_CONFIG: ${{ secrets.AMPLIFY_CONFIG }}
#   #         AMPLIFY_TEAM_PROVIDER: ${{ secrets.AMPLIFY_TEAM_PROVIDER }}
#   #     - name: Run Flutter Tests
#   #       run: |
#   #         dart pub global activate melos 6.3.2
#   #         melos bootstrap
#   #         cd apps/flipper
#   #         dart run realm install
#   #         flutter test --coverage --dart-define=FLUTTER_TEST_ENV=true 
        
#   #     - name: Setup LCOV
#   #       uses: hrishikesh-kadam/setup-lcov@v1
#   #     - name: Generate Code Coverage Report
#   #       run: |
#   #         cd apps/flipper
#   #         # Navigate to the directory containing filtered.lcov.info
#   #         # Generate the HTML report
#   #         genhtml --branch-coverage --output-directory html filtered.lcov.info
          
#   #     - name: Upload test results to Codecov
#   #       if: ${{ !cancelled() }}
#   #       uses: codecov/test-results-action@v1
#   #       with:
#   #         token: ${{ secrets.CODECOV_TOKEN }}

      


#       # - name: Report Code Coverage
#       #   uses: zgosalvez/github-actions-report-lcov@v3
#       #   with:
#       #     coverage-files: coverage/filtered.lcov.info
#       #     minimum-coverage: 45
#       #     artifact-name: code-coverage-report
#       #     github-token: ${{ secrets.ACCESS_TOKEN }}
#   unit-testing:
#     # runs-on: ubuntu-22.04
#     name: Unit Testing
#     # runs-on: [self-hosted, macOS, richard]
#     runs-on: windows-2022
#     # if: github.event_name == 'push' && github.ref == 'refs/heads/dev' && contains(github.event.head_commit.message, 'test')
#     # needs: [code-coverage]
#     steps:
#       - uses: actions/checkout@c85c95e3d7251135ab7dc9ce3241c5835cc595a9 # v3.5.3
#         with:
#           submodules: recursive
#           token: ${{ secrets.ACCESS_TOKEN }}
#           persist-credentials: true

#       - uses: actions/setup-java@v4
#         with:
#           distribution: "zulu"
#           java-version: "17"

#       - uses: subosito/flutter-action@v2
#         with:
#           flutter-version: "3.29.3"
#           channel: "stable"

#       - run: git submodule update --init

#       - name: Configure Missing files
#         shell: bash
#         run: |
#           echo "$INDEX" >> apps/flipper/web/index.html
#           echo "$CONFIGDART" >> packages/flipper_login/lib/config.dart
#           echo "$SECRETS" >> packages/flipper_models/lib/secrets.dart
#           echo "$FIREBASEOPTIONS" >> apps/flipper/lib/firebase_options.dart
#           echo "$AMPLIFY_CONFIG" >> apps/flipper/lib/amplifyconfiguration.dart
#           echo "$FIREBASEOPTIONS" >> packages/flipper_models/lib/firebase_options.dart
#           git config --global core.autocrlf false
#           echo "$AMPLIFY_TEAM_PROVIDER" >> apps/flipper/amplify/team-provider-info.json 
#         env:
#           INDEX: ${{ secrets.INDEX }}
#           CONFIGDART: ${{ secrets.CONFIGDART }}
#           SECRETS: ${{ secrets.SECRETS }}
#           FIREBASEOPTIONS: ${{ secrets.FIREBASEOPTIONS }}
#           AMPLIFY_CONFIG: ${{ secrets.AMPLIFY_CONFIG }}
#           AMPLIFY_TEAM_PROVIDER: ${{ secrets.AMPLIFY_TEAM_PROVIDER }}

#       - run: |
#           dart pub global activate melos 6.3.2
#           melos clean
#           melos bootstrap
#           cd packages/flipper_dashboard
#           dart run realm install
#           flutter test --dart-define=FLUTTER_TEST_ENV=true

#   integration-testing-windows:
#     name: "Integration Testing Windows"
#     # if: github.event_name == 'push' && github.ref == 'refs/heads/dev' && contains(github.event.head_commit.message, 'test')
#     runs-on: windows-2022
#     # runs-on: [self-hosted, macOS, richard]
#     needs: [unit-testing,android-integration-test]
#     #     https://github.com/subosito/flutter-action/issues/278 isse of windows failing to build
#     #   https://github.com/subosito/flutter-action/issues/277#issuecomment-1974628019
#     steps:
#       - name: Export pub environment variable on Windows
#         run: |
#           if [ "$RUNNER_OS" == "Windows" ]; then
#             echo "PUB_CACHE=$LOCALAPPDATA\\Pub\\Cache" >> $GITHUB_ENV
#           fi
#         shell: bash
#       - run: git config --global core.autocrlf false
#       - uses: actions/checkout@v4
#         with:
#           submodules: recursive
#           token: ${{ secrets.ACCESS_TOKEN }}
#           persist-credentials: true
#       - name: Clone Flutter repository with stable channel
#         uses: subosito/flutter-action@v2
#         with:
#           flutter-version: "3.29.3"
#           channel: stable
#       - run: flutter doctor -v

#       - uses: actions/setup-java@v4
#         with:
#           distribution: "zulu"
#           java-version: "17"

#       - name: submodule init
#         run: git submodule update --init
#       - name: Configure Missing files
#         shell: bash
#         run: |
#           echo "$INDEX" >> apps/flipper/web/index.html
#           echo "$CONFIGDART" >> packages/flipper_login/lib/config.dart
#           echo "$SECRETS" >> packages/flipper_models/lib/secrets.dart
#           echo "$FIREBASEOPTIONS" >> apps/flipper/lib/firebase_options.dart
#           echo "$FIREBASEOPTIONS" >> packages/flipper_models/lib/firebase_options.dart
#           echo "$AMPLIFY_CONFIG" >> apps/flipper/lib/amplifyconfiguration.dart
#           echo "$AMPLIFY_TEAM_PROVIDER" >> apps/flipper/amplify/team-provider-info.json
#         env:
#           INDEX: ${{ secrets.INDEX }}
#           CONFIGDART: ${{ secrets.CONFIGDART }}
#           SECRETS: ${{ secrets.SECRETS }}
#           FIREBASEOPTIONS: ${{ secrets.FIREBASEOPTIONS }}
#           AMPLIFY_CONFIG: ${{ secrets.AMPLIFY_CONFIG }}  
#           AMPLIFY_TEAM_PROVIDER: ${{ secrets.AMPLIFY_TEAM_PROVIDER }}
#       - run: |
#           dart pub global activate melos 6.3.2
#           melos bootstrap
#           cd apps/flipper
#           dart run realm install
#           flutter test --dart-define=FLUTTER_TEST_ENV=false -d windows integration_test/smoke_windows_test.dart
#   build-and-release-windows:
#     name: "Build windows app"
#     needs: [unit-testing, android-integration-test,integration-testing-windows]
#     # if: github.event_name == 'push'  && contains(github.event.head_commit.message, 'build')
#     runs-on: windows-2022
#     #     https://github.com/subosito/flutter-action/issues/278 isse of windows failing to builss
#     #   https://github.com/subosito/flutter-action/issues/277#issuecomment-1974628019
#     steps:
#       - name: Export pub environment variable on Windows
#         run: |
#           if [ "$RUNNER_OS" == "Windows" ]; then
#             echo "PUB_CACHE=$LOCALAPPDATA\\Pub\\Cache" >> $GITHUB_ENV
#           fi
#         shell: bash
#       - run: git config --global core.autocrlf false
#       - uses: actions/checkout@v4
#         with:
#           submodules: recursive
#           token: ${{ secrets.ACCESS_TOKEN }}
#           persist-credentials: true
#       - name: Clone Flutter repository with stable channel
#         uses: subosito/flutter-action@v2
#         with:
#           flutter-version: "3.29.3"
#           channel: stable
#       - run: flutter doctor -v

#       - name: submodule init
#         run: git submodule update --init
#       - name: Configure Missing files
#         shell: bash
#         run: |
#           echo "$INDEX" >> apps/flipper/web/index.html
#           echo "$CONFIGDART" >> packages/flipper_login/lib/config.dart
#           echo "$SECRETS" >> packages/flipper_models/lib/secrets.dart
#           echo "$FIREBASEOPTIONS" >> apps/flipper/lib/firebase_options.dart
#           echo "$FIREBASEOPTIONS" >> packages/flipper_models/lib/firebase_options.dart
#           echo "$AMPLIFY_CONFIG" >> apps/flipper/lib/amplifyconfiguration.dart
#           echo "$AMPLIFY_TEAM_PROVIDER" >> apps/flipper/amplify/team-provider-info.json
#         env:
#           INDEX: ${{ secrets.INDEX }}
#           CONFIGDART: ${{ secrets.CONFIGDART }}
#           SECRETS: ${{ secrets.SECRETS }}
#           FIREBASEOPTIONS: ${{ secrets.FIREBASEOPTIONS }}
#           AMPLIFY_CONFIG: ${{ secrets.AMPLIFY_CONFIG }} 
#           AMPLIFY_TEAM_PROVIDER: ${{ secrets.AMPLIFY_TEAM_PROVIDER }}
#           # --store
#           # --install-certificate false
#           # https://github.com/YehudaKremer/msix/issues/126
#       - run: |
#           dart pub global activate melos 6.3.2
#           melos bootstrap
#           cd apps/flipper
#           dart run msix:create -v --install-certificate false
#       - name: Configure Release (optional)
#         env:
#           VERSION: ${{ github.sha }} # Or use a semantic versioning scheme
#         run: |
#           echo "## Release Notes" >> release_notes.txt
#           echo " - New features..." >> release_notes.txt
#           echo " - Bug fixes..." >> release_notes.txt

#       - name: Extract msix_version
#         id: get_version
#         shell: powershell
#         run: |
#           $MSIX_VERSION = (Get-Content -Path "apps/flipper/pubspec.yaml" -Raw) -match 'msix_config:\s*([\s\S]*?)\bmsix_version:\s*(\d+\.\d+\.\d+\.\d+)\b' | ForEach-Object { if ($matches.Count -ge 2) { $matches[2] } else { Write-Output "No msix_version found"; exit 1 } }; echo "::set-output name=version::$MSIX_VERSION"

#       # - name: Create Release
#       #   uses: actions/create-release@v1.0.0
#       #   env:
#       #     GITHUB_TOKEN: ${{ secrets.ACCESS_TOKEN }}
#       #   with:
#       #     tag_name: ${{ steps.get_version.outputs.version }}
#       #     release_name: Windows Release ${{ steps.get_version.outputs.version }}
#       #     draft: false
#       #     prerelease: false
#       #     body: |
#       #       Changes in this Release
#       #       - First Change
#       #       - Second Change
#       - name: Upload .msix to Release
#         uses: actions/upload-artifact@v4
#         env:
#           GITHUB_TOKEN: ${{ secrets.ACCESS_TOKEN }}
#         with:
#           name: windows-build
#           path: apps/flipper/build/windows/x64/runner/Release/flipper_rw.msix
#           upload_release_asset: false


#   android-integration-test:
#     name: integration on Android
#     # if: github.event_name == 'push' && github.ref == 'refs/heads/dev' && contains(github.event.head_commit.message, 'test')
#     needs: [unit-testing]
#     runs-on: macOS-12
#     strategy:
#       matrix:
#         # using api 29 from reading comment from https://github.com/ReactiveCircus/android-emulator-runner/issues/324
#         api-level: [31]
#         target: [playstore]
#       fail-fast: false
#     steps:
#       - uses: actions/checkout@v4
#       - uses: actions/setup-java@v4
#         with:
#           distribution: "zulu"
#           java-version: "17"
#       - name: Clone Flutter repository with stable channel
#         uses: subosito/flutter-action@v2
#         with:
#           flutter-version: "3.29.3"
#           channel: stable
#       - name: Configure Git with PAT
#         env:
#           PAT_TOKEN: ${{ secrets.PAT_TOKEN }}
#         run: |
#           git config --global user.email "info@yegobox.com"
#           git config --global user.name "YEGOBOX"
#           git config --global credential.helper store
#           echo "https://github.com:${PAT_TOKEN}@github.com" > ~/.git-credentials
#       - name: submodule init
#         run: git submodule update --init
#       - name: Configure Missing files
#         run: |
#           echo "$INDEX" >> apps/flipper/web/index.html
#           echo "$CONFIGDART" >> packages/flipper_login/lib/config.dart
#           echo "$SECRETS" >> packages/flipper_models/lib/secrets.dart
#           echo "$FIREBASEOPTIONS" >> apps/flipper/lib/firebase_options.dart
#           echo "$FIREBASEOPTIONS" >> packages/flipper_models/lib/firebase_options.dart
#           git config --global core.autocrlf false
#           echo "$AMPLIFY_CONFIG" >> apps/flipper/lib/amplifyconfiguration.dart
#           echo "$AMPLIFY_TEAM_PROVIDER" >> apps/flipper/amplify/team-provider-info.json
#         env:
#           INDEX: ${{ secrets.INDEX }}
#           CONFIGDART: ${{ secrets.CONFIGDART }}
#           SECRETS: ${{ secrets.SECRETS }}
#           FIREBASEOPTIONS: ${{ secrets.FIREBASEOPTIONS }}
#           AMPLIFY_CONFIG: ${{ secrets.AMPLIFY_CONFIG }} 
#           AMPLIFY_TEAM_PROVIDER: ${{ secrets.AMPLIFY_TEAM_PROVIDER }}
#       - name: Configure Keystore
#         run: |
#           echo "$GOOGLE_SERVICE_JSON" > app/google-services.json
#           echo "$PLAY_STORE_UPLOAD_KEY" | base64 --decode > app/key.jks
#           echo "storeFile=key.jks" >> key.properties
#           echo "keyAlias=$KEYSTORE_KEY_ALIAS" >> key.properties
#           echo "storePassword=$KEYSTORE_STORE_PASSWORD" >> key.properties
#           echo "keyPassword=$KEYSTORE_KEY_PASSWORD" >> key.properties
#         env:
#           PLAY_STORE_UPLOAD_KEY: ${{ secrets.PLAY_STORE_UPLOAD_KEY }}
#           KEYSTORE_KEY_ALIAS: ${{ secrets.KEYSTORE_KEY_ALIAS }}
#           KEYSTORE_KEY_PASSWORD: ${{ secrets.KEYSTORE_KEY_PASSWORD }}
#           KEYSTORE_STORE_PASSWORD: ${{ secrets.KEYSTORE_STORE_PASSWORD }}
#           GOOGLE_SERVICE_JSON: ${{ secrets.GOOGLE_SERVICE_JSON }}
#         working-directory: apps/flipper/android
#       - run: |
#           dart pub global activate melos 6.3.2
#           melos bootstrap
#       - name: Install Android SDK
#         uses: malinskiy/action-android/install-sdk@release/0.1.7
#       - run: echo $ANDROID_HOME
#       - run: sdkmanager --install "ndk;23.1.7779620"
#       - run: sdkmanager --install "build-tools;30.0.3"
#       - uses: malinskiy/action-android/emulator-run-cmd@release/0.1.7
#         with:
#           cmd: dart run realm install && cd apps/flipper &&  flutter test --dart-define=FLUTTER_TEST_ENV=true  integration_test/smoke_android_test.dart
#           api: 33
#           cmdOptions: -no-snapshot-save -noaudio -no-boot-anim -cores 2 -memory 3072 -no-window
#           tag: google_apis
#           abi: x86_64
#           bootTimeout: 820
#       - run: sleep 30
#   # shorebird-deploy:
#   #   name: "Shorebird Deploy to Google Play"
#   #   needs: [unit-testing, android-integration-test,integration-testing-windows]
#   #   runs-on: ubuntu-latest

#   #   steps:
#   #     - name: Checkout code
#   #       uses: actions/checkout@v3

#   #     - name: Setup Flutter
#   #       uses: subosito/flutter-action@v2
#   #       with:
#   #         flutter-version: "3.29.3"
#   #         channel: stable

#   #     - name: Flutter doctor
#   #       run: flutter doctor -v

#   #     - name: Setup Java
#   #       uses: actions/setup-java@v4
#   #       with:
#   #         distribution: "zulu"
#   #         java-version: "17"

#   #     - name: Configure Git
#   #       env:
#   #         PAT_TOKEN: ${{ secrets.PAT_TOKEN }}
#   #       run: |
#   #         git config --global user.email "info@yegobox.com"
#   #         git config --global user.name "YEGOBOX"
#   #         git config --global credential.helper store
#   #         echo "https://github.com:${PAT_TOKEN}@github.com" > ~/.git-credentials

#   #     - name: Initialize submodules
#   #       run: git submodule update --init

#   #     - name: Configure missing files
#   #       env:
#   #         INDEX: ${{ secrets.INDEX }}
#   #         CONFIGDART: ${{ secrets.CONFIGDART }}
#   #         SECRETS: ${{ secrets.SECRETS }}
#   #         FIREBASEOPTIONS: ${{ secrets.FIREBASEOPTIONS }}
#   #         AMPLIFY_CONFIG: ${{ secrets.AMPLIFY_CONFIG }} 
#   #         AMPLIFY_TEAM_PROVIDER: ${{ secrets.AMPLIFY_TEAM_PROVIDER }}
#   #       run: |
#   #         echo "$INDEX" >> apps/flipper/web/index.html
#   #         echo "$CONFIGDART" >> packages/flipper_login/lib/config.dart
#   #         echo "$SECRETS" >> packages/flipper_models/lib/secrets.dart
#   #         echo "$FIREBASEOPTIONS" >> apps/flipper/lib/firebase_options.dart
#   #         echo "$FIREBASEOPTIONS" >> packages/flipper_models/lib/firebase_options.dart
#   #         echo "$AMPLIFY_CONFIG" >> apps/flipper/lib/amplifyconfiguration.dart
#   #         echo "$AMPLIFY_TEAM_PROVIDER" >> apps/flipper/amplify/team-provider-info.json

#   #     - name: Setup Melos
#   #       run: |
#   #         dart pub global activate melos 6.3.2
#   #         melos bootstrap

#   #     - name: Configure Keystore
#   #       env:
#   #         PLAY_STORE_UPLOAD_KEY: ${{ secrets.PLAY_STORE_UPLOAD_KEY }}
#   #         KEYSTORE_KEY_ALIAS: ${{ secrets.KEYSTORE_KEY_ALIAS }}
#   #         KEYSTORE_KEY_PASSWORD: ${{ secrets.KEYSTORE_KEY_PASSWORD }}
#   #         KEYSTORE_STORE_PASSWORD: ${{ secrets.KEYSTORE_STORE_PASSWORD }}
#   #         GOOGLE_SERVICE_JSON: ${{ secrets.GOOGLE_SERVICE_JSON }}
#   #       working-directory: apps/flipper/android
#   #       run: |
#   #         echo "$GOOGLE_SERVICE_JSON" > app/google-services.json
#   #         echo "$PLAY_STORE_UPLOAD_KEY" | base64 --decode > app/key.jks
#   #         echo "storeFile=key.jks" >> key.properties
#   #         echo "keyAlias=$KEYSTORE_KEY_ALIAS" >> key.properties
#   #         echo "storePassword=$KEYSTORE_STORE_PASSWORD" >> key.properties
#   #         echo "keyPassword=$KEYSTORE_KEY_PASSWORD" >> key.properties

#   #     - name: Setup Shorebird
#   #       uses: shorebirdtech/setup-shorebird@v1
#   #     - name: Shorebird Release
#   #       if: startsWith(github.ref, 'refs/heads/dev/')
#   #       run: |
#   #         shorebird release android
#   #       working-directory: apps/flipper
#   fastlane-deploy:
#     name: "Google Deploy"
#     needs: [unit-testing,android-integration-test, integration-testing-windows]
#     if: github.event_name == 'push'  && contains(github.event.head_commit.message, 'build')
#     runs-on: ubuntu-22.04
#     steps:
#       - run: git config --global core.autocrlf false
#       # Set up Flutter.
#       - name: Clone Flutter repository with stable channel
#         uses: subosito/flutter-action@v2
#         with:
#           flutter-version: "3.29.3" #firebase_auth_desktop is broken with  3.10.6
#           channel: stable
#       - run: flutter doctor -v

#       # Checkout flipper code
#       - name: Checkout flipper code
#         uses: actions/checkout@4 # v3.5.3
#       - uses: actions/setup-java@v4 #plugin for setting up the java
#         with:
#           distribution: "zulu"
#           java-version: "17" #defines the java version
#       - name: Configure Git with PAT
#         env:
#           PAT_TOKEN: ${{ secrets.PAT_TOKEN }}
#         run: |
#           git config --global user.email "info@yegobox.com"
#           git config --global user.name "YEGOBOX"
#           git config --global credential.helper store
#           echo "https://github.com:${PAT_TOKEN}@github.com" > ~/.git-credentials
#       - name: submodule init
#         run: git submodule update --init
#       - name: Configure Missing files
#         run: |
#           echo "$INDEX" >> apps/flipper/web/index.html
#           echo "$CONFIGDART" >> packages/flipper_login/lib/config.dart
#           echo "$SECRETS" >> packages/flipper_models/lib/secrets.dart
#           echo "$FIREBASEOPTIONS" >> apps/flipper/lib/firebase_options.dart
#           echo "$FIREBASEOPTIONS" >> packages/flipper_models/lib/firebase_options.dart
#           git config --global core.autocrlf false
#           echo "$AMPLIFY_CONFIG" >> apps/flipper/lib/amplifyconfiguration.dart
#           echo "$AMPLIFY_TEAM_PROVIDER" >> apps/flipper/amplify/team-provider-info.json
          
#         env:
#           INDEX: ${{ secrets.INDEX }}
#           CONFIGDART: ${{ secrets.CONFIGDART }}
#           SECRETS: ${{ secrets.SECRETS }}
#           FIREBASEOPTIONS: ${{ secrets.FIREBASEOPTIONS }}
#           AMPLIFY_CONFIG: ${{ secrets.AMPLIFY_CONFIG }} 
#           AMPLIFY_TEAM_PROVIDER: ${{ secrets.AMPLIFY_TEAM_PROVIDER }}
#       - run: |
#           dart pub global activate melos 6.3.2
#           melos bootstrap
#       # Setup Ruby, Bundler, and Gemfile dependencies
#       - name: Setup Fastlane
#         uses: ruby/setup-ruby@v1
#         with:
#           ruby-version: "3.0"
#           bundler-cache: true
#           # cache-version: 1
#           working-directory: apps/flipper/android
#       - name: Configure Keystore
#         run: |
#           echo "$GOOGLE_SERVICE_JSON" > app/google-services.json
#           echo "$PLAY_STORE_UPLOAD_KEY" | base64 --decode > app/key.jks
#           echo "$PLAY_STORE_UPLOAD_KEY" | base64 --decode  > play_store_upload_key.txt
#           cat play_store_upload_key.txt
#           echo "storeFile=key.jks" >> key.properties
#           echo "keyAlias=$KEYSTORE_KEY_ALIAS" >> key.properties
#           echo "storePassword=$KEYSTORE_STORE_PASSWORD" >> key.properties
#           echo "keyPassword=$KEYSTORE_KEY_PASSWORD" >> key.properties
#         env:
#           PLAY_STORE_UPLOAD_KEY: ${{ secrets.PLAY_STORE_UPLOAD_KEY }}
#           KEYSTORE_KEY_ALIAS: ${{ secrets.KEYSTORE_KEY_ALIAS }}
#           KEYSTORE_KEY_PASSWORD: ${{ secrets.KEYSTORE_KEY_PASSWORD }}
#           KEYSTORE_STORE_PASSWORD: ${{ secrets.KEYSTORE_STORE_PASSWORD }}
#           GOOGLE_SERVICE_JSON: ${{ secrets.GOOGLE_SERVICE_JSON }}
#         working-directory: apps/flipper/android

#       # Build and deploy with Fastlane (by default, to beta track) 🚀.
#       # Naturally, promote_to_production only deploys
#       # https://stackoverflow.com/questions/22301956/error-with-gradlew-usr-bin-env-bash-no-such-file-or-directory
#       - run: |
#           bundle exec fastlane ${{ github.event.inputs.lane || 'internal' }}
#         env:
#           PLAY_STORE_CONFIG_JSON: ${{ secrets.PLAYSTORE_ACCOUNT_KEY }}
#           DB_URL: ${{ secrets.DB_URL }}
#           DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
#         working-directory: apps/flipper/android
#   # build_and_preview:
#   #   if: "${{ github.event.pull_request.head.repo.full_name == github.repository }}"
#   #   runs-on: ubuntu-latest
#   #   needs: [code-coverage]
#   #   steps:
#   #     - uses: actions/checkout@v3
#   #     - uses: actions/setup-java@v2
#   #       with:
#   #         distribution: "zulu"
#   #         java-version: "11" #defines the java version
#   #     - uses: subosito/flutter-action@v2
#   #       with:
#   #         # issue with latest flutter 3.13 https://github.com/flutter/flutter/issues/132711
#   #         flutter-version: '3.13.6' #firebase_auth_desktop is broken with  3.10.6
#   #         channel: stable
#   #     - name: Configure Git with PAT
#   #       env:
#   #         PAT_TOKEN: ${{ secrets.PAT_TOKEN }}
#   #       run: |
#   #         git config --global user.email "info@yegobox.com"
#   #         git config --global user.name "YEGOBOX"
#   #         git config --global credential.helper store
#   #         echo "https://github.com:${PAT_TOKEN}@github.com" > ~/.git-credentials
#   #     - run: git submodule update --init

#   #     - run: dart pub global activate melos 6.3.2 2.9.0
#   #     - name: "Run Melos bootstrap"
#   #       run: melos bootstrap
#   #     - name: Configure Missing files
#   #     # echo "$INDEX" >> web/index.html
#   #       run: |
#   #         echo "$CONFIGDART" >> packages/flipper_login/lib/config.dart
#   #         echo "$SECRETS" >> packages/flipper_models/lib/secrets.dart
#   #         echo "$FIREBASEOPTIONS" >> lib/firebase_options.dart
#   #       env:
#   #         INDEX: ${{ secrets.INDEX }}
#   #         CONFIGDART: ${{ secrets.CONFIGDART }}
#   #         SECRETS: ${{ secrets.SECRETS }}
#   #         FIREBASEOPTIONS: ${{ secrets.FIREBASEOPTIONS }}
#   #     - name: "Build Web App"
#   #       run: flutter build web
#   #     - uses: FirebaseExtended/action-hosting-deploy@v0
#   #       with:
#   #         repoToken: '${{ secrets.GITHUB_TOKEN }}'
#   #         firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT_YEGOBOX_2EE43 }}'
#   #         projectId: yegobox-2ee43 
#   slackNotification:
#     name: Slack Notification
#     needs: [fastlane-deploy, build-and-release-windows]
#     runs-on: ubuntu-22.04
#     steps:
#       - uses: actions/checkout@c85c95e3d7251135ab7dc9ce3241c5835cc595a9 # v3.5.3
#       - name: Slack Notification
#         uses: rtCamp/action-slack-notify@v2
#         env:
#           SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
