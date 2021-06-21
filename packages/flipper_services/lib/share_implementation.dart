import 'abstractions/share.dart';
import 'package:share_plus/share_plus.dart';

class ShareImplementation implements Shareble {
  @override
  void share(String shareble) {
    Share.share(shareble, subject: 'And you, you can enjoy flipper!');
  }
}
