library flipper_services;

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future handleDynamicLink() async {
    // if the is opened with the link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDnamicLink(data);
    //app is opened from foreground
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
          _handleDnamicLink(dynamicLinkData);
        },
        onError: (OnLinkErrorException exception) async {});
  }

  void _handleDnamicLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_deepLink: $deepLink');
    }
  }

  Future<ShortDynamicLink> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://flipper.rw',
      link: Uri.parse('https://flipper.rw/open?DA'),
      androidParameters: AndroidParameters(
        packageName: 'rw.flipper',
        minimumVersion: 1,
      ),
    );
    final shortLink = await parameters.buildShortLink();
    return shortLink;
  }
}
