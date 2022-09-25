library flipper_routing;

import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

// leave stacked for logging purposes
@StackedApp(
  routes: [],
  dependencies: [
    LazySingleton(classType: NavigationService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}

// ./flutterw packages pub run build_runner build --delete-conflicting-outputs
// flutter packages pub run build_runner build --delete-conflicting-outputs
//  firebase deploy --only hosting
//  firebase deploy --only functions
//  flutter build web --release
// NOTE:TODO: when rebuilding login_popup_view remember to add library flipper_login; in generated file
// firebase install https://firebase.flutter.dev/docs/installation/android/
// flutter create --template=package hello
// flutter run -d chrome --release
//  flutter pub add moor_flutter
// flutter pub run msix:create
//cheat code
//TODO: push notification service https://github.com/Pronto-AG/Pronto-MIA-App/blob/master/pronto_mia/lib/core/services/push_notification_service.dart
// find . -name '*.dart' | xargs wc -l
//  59153 + 550 +16564 = 76267
// sudo a2enmod proxy_wstunnel (enabling apache sockets)
// bb-operations-sql.database.windows.net
// 1433
// https://github.com/metrogistics/laravel-azure-ad-oauth

//TODO: The nex things in consumer app!
// https://github.com/JoshuaR503/Stock-Market-App
// https://www.youtube.com/watch?v=IbJt7tr8kL0
// https://developers.amadeus.com/self-service/category/air/api-doc/flight-offers-search/api-reference
// https://github.com/amadeus4dev/amadeus-java
// TODO: Qr code.!
// https://www.youtube.com/watch?v=hHehIGfX_yU

// TODO:changed data type of id from string to int, if go back to couchbase need to change that too where I am using uid;
//carefully look for where the ID is used while building object eg unit and turn back to Int when accessing data as when saved it was changed to int on couchbaseside.
// https://dev.to/ashishrawat2911/handling-network-calls-and-exceptions-in-flutter-54me
// https://docs.microsoft.com/en-us/windows/msix/package/signing-package-device-guard-signing
// https://github.com/marketplace/actions/windows-store-publish

// cameras to buy
// 1) go pro 9 black
// 2) https://snapmounts.com/

// share one tab of google sheets
// https://www.youtube.com/watch?v=Sj_uGLZqBmc

// dataModels update
// https://docs.objectbox.io/advanced/data-model-updates
// A/B Testing.
// https://firebase.google.com/docs/ab-testing/abtest-configjava

// on DeleteOfOrderItem call another func to update tickets this can be refreshing tickets..
// version.(1)
// TODO: implement geofancing of businesses and customers
// https://pub.dev/packages/geofence_service (if I am near a shop in 100 metters to receive advert of business willing to offer me deal)
// a user will set the price he is willing to pay and item then he get adverts related to the settings.

// masterting analytics
// https://medium.com/flutterdevs/firebase-analytics-2044e865efc4

// test pin:085214

// when adding new repo with other submodules
// git submodule add https://github.com/yegobox/flutter.widgets.git open-sources/flutter.widgets
// https://gist.github.com/myusuf3/7f645819ded92bda6677

// %AppData%
// This will not restart the server.!
// docker-compose up -d --no-deps --build app-server

// TODO:when want to calculate distance between points
// https://flutteragency.com/total-distance-from-latlng-list-in-flutter/
// git add . && git stash && git pull origin main && gradle build && docker-compose up --build -d

// TODO: use repeat ionicons in chat's fload button.

// debug key: when debugging
// https://stackoverflow.com/questions/12456491/i-dont-remember-my-android-debug-keystore-password

// https://stackoverflow.com/questions/15727912/sha-1-fingerprint-of-keystore-certificate
// keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android 

//when prod: when prod
// keytool -list -v -keystore

// ongoing: twitter bot experiment.
// https://www.socialseer.com/twitter-programming-in-java-with-twitter4j/authentication-with-twitter/pin-based-authentication-in-java-with-twitter4j/

//TODO: before using this:check if it works for browser too
// https://pub.dev/packages/nb_utils
// TODO: when making 5M per month, will switch to fluent UI as core UI of flipper
// https://pub.dev/packages/fluent_ui

//  List<FileSystemEntity> es =
// Directory(dir.path + '/db_1/data.mdb').listSync();
// for (FileSystemEntity e in es) {
// print(e.absolute);
// }
// more about fluent.
// https://itnext.io/flutter-building-beautiful-windows-apps-fluent-design-structure-and-navigation-e53a394988d2
// https://morioh.com/p/4993f57bd08f

// certbot certonly --manual --preferred-challenges=dns --email yegobox@gmail.com --server https://acme-v02.isarApi.letsencrypt.org/directory --agree-tos -d flipper.apihub
// https://stackoverflow.com/questions/32209897/class-illuminate-html-htmlserviceprovider-not-found
// https://medium.com/@saurabh6790/generate-wildcard-ssl-certificate-using-lets-encrypt-certbot-273e432794d7

// whatsapp bot
// https://www.facebook.com/business/help/456220311516626?id=2129163877102343
// https://developers.facebook.com/docs/whatsapp/api/account
// https://developers.facebook.com/docs/whatsapp/api/account

// Development
// https://developers.facebook.com/docs/whatsapp/installation/dev-single-instance

// https://github.com/FilledStacks/stacked/issues/449

// TODOuse backdrop the front will show the tickets instead of using the bottom sheet.
// https://pub.dev/packages/backdrop
// Integrate local report as option
// https://pub.dev/packages/excel

// dart define in case we need to use it.
// https://itnext.io/flutter-1-17-no-more-flavors-no-more-ios-schemas-command-argument-that-solves-everything-8b145ed4285d

// Back to testing shoule use this mock!
// https://github.com/VeryGoodOpenSource/mockingjay

// learn more about
// https://github.com/felangel/flow_builder/issues/36

// Read more about flank
// https://medium.com/swlh/scalable-gitlab-android-tests-configs-with-flank-for-firebase-test-lab-a1d743fc12c5
// https://github.com/Flank/flank/blob/master/docs/flank-github-action/store_documentation.md

// Read more about sylph suitable for flutter ui test.
// https://github.com/mmcc007/sylph
// https://blog.bitrise.io/post/5-tips-tricks-for-mobile-testing?utm_source=website&utm_medium=email&utm_campaign=MEP-ebook
// Contact service
// https://pub.dev/packages/contacts_service
// https://pub.dev/packages/flutter_contacts
// https://api.flutter.dev/flutter/cupertino/CupertinoTextFormFieldRow-class.html

// Implement a feature to advertize products products to consumers passing.
// https://github.com/VNAPNIC/UDP-TCP-Flutter
// https://pub.dev/packages/flutter_nearby_connections

// Customer support feature
// ability to auto record a call: https://pub.dev/packages/record

//TODOFirebase performance
// adb logcat -s FirebasePerformance
// FiXME: !D/, !I/
// https://pub.dev/packages/toggle_switch
// https://pub.dev/packages/auto_size_text

// docker run --rm -it -v $(pwd):/data --publish 0.0.0.0:908:9999 -d --publish 0.0.0.0:907:9980 --user $UID objectboxio/sync:21.5.14-server --model ./data/objectbox-model.json --unsecured-no-authentication --browser-bind 0.0.0.0:9980

// docker run --rm -it -v $(pwd):/data --publish 0.0.0.0:908:9999  --publish 0.0.0.0:907:9980 --user $UID objectboxio/sync:21.5.14-server --model ./data/objectbox-model.json --unsecured-no-authentication --browser-bind 0.0.0.0:9980

// use config file, the config file has model and password in it. so no need to add them below.
// docker run --rm -it -v $(pwd):/data --publish 0.0.0.0:908:9999  --publish 0.0.0.0:907:9980 -d --user $UID objectboxio/sync:21.5.14-server --browser-bind 0.0.0.0:9981

// push all branches to github
// git push origin --mirror

// Microsoft stuff.
// https://www.microsoft.com/en-us/microsoft-365/business/compare-all-microsoft-365-business-products
// https://admin.microsoft.com
// info@yegobox1.onmicrosoft.com
// User details
// Display name: info
// Username:info@apihub
// Password: :Love:is:good::

// https://verygood.ventures/blog/configuring-workflows-for-your-flutter-projects?utm_source=twitter&utm_medium=social&utm_campaign=workflows
// FIXMELaunching lib\main.dart on Android SDK built for x86 in debug mode...
// lib\main.dart:1
// Shrinking has been disabled for this build due to deferred components. Shrinking is not available for multi-apk applications. This limitation is expected to be removed when Gradle plugin 4.2+ is available in Flutter.
// openssl base64 -in key.jks -out ke

// git push --follow-tags
// Bluetooth print
// https://github.com/thon-ju/bluetooth_print
// wifi printer
// https://pub.dev/packages/esc_pos_printer

//  build better docs:
// https://docs.page/homepage
// https://github.com/csells/go_router/issues/356event-6045944024

// publishing package thought git action
// https://birju.dev/posts/publish-your-flutter-package-using-github-actions/

// Next blog post
// https://birju.dev/posts/burying-the-hatchet-of-build-runner-once-and-for-all/

// flutter run -t lib/demo.dart (run demo when we need to!)


// https://www.sandromaglione.com/dart-flutter-static-metaprogramming-macro-prototype/ learn more about macro
// https://www.vendhq.com/

// C:\Program Files\Microsoft\jdk-11.0.12.7-hotspot\bin
// C:\Program Files\AdoptOpenJDK\jdk-11.0.9.101-hotspot\bin
// C:\Program Files\AdoptOpenJDK\jdk-8.0.275.1-hotspot\bin
// git submodule  update --init --recursive --remote
// 1643362786389968

//TODO: Flutter pro tip: especially the search thing at the end of the video
// https://www.youtube.com/watch?v=mhxoXm8lWIo
//I am using flipper-prod folder in building uber jar file.
//sometime I need to shutdown the running app to gain memory to build new uber jar or shut down server!
// nohup java -jar flipper-1.0.0-SNAPSHOT-runner.jar & echo $! > save_pid.txt
// kill -9 "cat save_pid.txt"
// gradle   build -Dquarkus.package.type=uber-jar

// TODO:for rra server  /var/www/rra
//  nohup java -jar rra.war &  echo $! > rra_pid.txt
// kill -9 "cat rra_pid.txt"
// find . -name "*.bak" -type f -delete

// ngix stuff:
// certbot --nginx -d yegobox.com -d www.yegobox.com
// certbot --nginx -d blog.yegobox.com -d www.blog.yegobox.com
// https://lowendbox.com/blog/how-to-replace-apache-with-nginx-on-ubuntu-18-04/
// certbot certonly --manual -d *.$DOMAIN -d $DOMAIN --agree-tos --manual-public-ip-logging-ok --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --register-unsafely-without-email --rsa-key-size 4096
// sudo ln -s /etc/nginx/sites-available/yegobox.com.conf /etc/nginx/sites-enabled/
// https://gist.github.com/soheilhy/8b94347ff8336d971ad0

// wild card cert:
// https://codex.so/wildcard-ssl-certificate-by-let-s-encrypt
// https://codex.so/resolving-subdomains-dynamically-via-nginx

// TODOhttps://github.com/juliuscanute/qr_code_scanner/pull/512 check if this is merged and remove qr_code_scanner from open-source and use the upstream one!
 
// handle splash better than anyone!
// https://pub.dev/packages/flutter_native_splash

// TODO:format date cheat sheet
// shorturl.at/ijGU9
// https://github.com/DavBfr/dart_pdf/issues/870
// TODO:I need to learn this best way to write flipper product wiki. (roaa94khaddam@gmail.com) 
// https://github.com/Roaa94/flutter_cool_card_swiper/blob/main/README.md

// TODO:automate ios deployment
// https://dev.to/samadipour/flutter-automate-ios-deployment-5ghc?utm_source=dormosheio&utm_campaign=dormosheio

// TODO:ios CID
// https://medium.com/mindful-engineering/github-actions-ci-cd-and-automate-beta-deployments-for-your-flutter-ios-apps-c9cdc8dcf097
// Need to upgrade:
// 
// fl_chart
// flutter_form_bloc
// scrollable_positioned_list

// TODO:will use this for data mining etc..
// https://www.elastic.co/webinars/getting-started-elasticsearch
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under aurora.
// dependency_overrides: ffi: '>=2.0.0 <3.0.0'
//TODO:this bellow helped me to understand use of c++ in flutter using ffi
// https://levelup.gitconnected.com/port-an-existing-c-c-app-to-flutter-with-dart-ffi-8dc401a69fd7
// key hashes
// keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
// https://pub.dev/packages/flutter_carousel_slider

// AWS
// AWS Billing and Cost Management console
// https://resocoder.com/2021/01/02/flutter-integration-test-tutorial-firebase-test-lab-codemagic/
// flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart

// choco install NuGet.CommandLine

// Getting the path of the installed
// $p = (Get-packageProvider -name nuget);
// $p.ProviderPath