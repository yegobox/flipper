# fastlane-deploy:
#     name: "Google Deploy"
#     needs: [unit-testing, integration-testing-macos, android-integration-test]
#     if: github.event_name == 'push'  && contains(github.event.head_commit.message, 'build')
#     runs-on: ubuntu-22.04
#     steps:
#       - run: git config --global core.autocrlf false
#       # Set up Flutter.
#       - name: Clone Flutter repository with stable channel
#         uses: subosito/flutter-action@v2
#         with:
#           flutter-version: "3.24.3" #firebase_auth_desktop is broken with  3.10.6
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
#           dart pub global activate melos
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