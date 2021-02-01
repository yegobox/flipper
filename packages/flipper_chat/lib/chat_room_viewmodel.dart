import 'package:flipper_models/chat.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:stacked/stacked.dart';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_services/locator.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatRoomViewModel extends ReactiveViewModel {
  final _state = locator<SharedStateService>();
  final List<Chat> _chats = <Chat>[];

  List<Chat> get chats => _chats;

  bool _contactPermissionGrated = false;
  bool get contactPermissionGrated => _contactPermissionGrated;

  final DatabaseService _db = ProxyService.database;

  void contactPermissions() async {
    final Map<Permission, PermissionStatus> statuses =
        await [Permission.contacts].request();

    //update the user with permission grated and check on user object wheter the permission are granted:
    final Document user = _db.getById(id: _state.user.id);
    if (statuses[Permission.contacts].isGranted) {
      user.properties['permissions'] = 'contacts';
      _db.update(document: user);
      _contactPermissionGrated = true;
      ProxyService.fetch.lazyLoadContacts(); //start loading periodically
      notifyListeners();
    } else {
      _contactPermissionGrated = false;
      notifyListeners();
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_state];
}
