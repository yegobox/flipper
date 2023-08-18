library flipper_services;

import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/cupertino.dart';
import 'abstractions/dynamic_link.dart';

class UnSupportedDynamicLink implements DynamicLink {
  @override
  Future<String> createDynamicLink() async {
    return "https://play.google.com/store/apps/details?id=rw.flipper";
  }

  @override
  Future handleDynamicLink(BuildContext context) async {}
}

class DynamicLinkService implements DynamicLink {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final _routerService = locator<RouterService>();
  @override
  Future handleDynamicLink(BuildContext context) async {
    // if the app is opened with the link
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (data != null) {
      _handleDnamicLink(data, context);
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _handleDnamicLink(dynamicLinkData, context);
    }).onError((error) {
      // Handle errors
    });
  }

  void _handleDnamicLink(PendingDynamicLinkData? data, BuildContext context) {
    if (data == null) return;
    final Uri deepLink = data.link;

    bool isRefer = deepLink.pathSegments.contains('refer');
    if (isRefer) {
      String? code = deepLink.queryParameters['code'];
      if (ProxyService.remoteConfig.isRemoteLoggingDynamicLinkEnabled()) {
        // FirebaseChatCore.instance.logDynamicLink(code!);
      }
      //save the code in localstorage to be used later
      ProxyService.box.write(key: 'referralCode', value: code.toString());

      _routerService.navigateTo(StartUpViewRoute());
    }
  }

  @override
  Future<String> createDynamicLink() async {
    // get minimum version from firestore to keep up with update
    final userId = ProxyService.box.getUserId();
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://flipper.page.link',
      link: Uri.parse("https://flipper.rw/refer?code=$userId"),
      androidParameters: const AndroidParameters(
        packageName: 'rw.flipper',
        minimumVersion: 1,
      ),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(
        campaign: 'referral',
        medium: 'social',
        source: 'app',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'flipper',
          description: 'flipper referral system',
          imageUrl: Uri.parse(
              'https://yegobox-flipper.s3.eu-west-2.amazonaws.com/logo.jpg')),
    );
    try {
      ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);

      return shortLink.shortUrl.toString(); //as ShortDynamicLink
    } catch (e) {
      return "https://play.google.com/store/apps/details?id=rw.flipper";
    }
  }
}
