import 'abstractions/share.dart';
import 'package:share/share.dart';

class ShareImplementation implements Shareble {
  @override
  void share(String shareble) {
    Share.share(shareble);
  }
}
