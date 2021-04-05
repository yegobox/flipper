import 'package:flipper_models/chat.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:stacked/stacked.dart';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_services/locator.dart';
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
      // TODO:fix this
      // ProxyService.fetch.lazyLoadContacts(); //quick get contacts
      // ProxyService.fetch.heartBeatLoadContacts(); //start loading periodically
      notifyListeners();
    } else {
      _contactPermissionGrated = false;
      notifyListeners();
    }
  }

  void loadChatRooms() {
    final q = Query(
        _db.db, 'SELECT id,message,time,sendBy,channels WHERE table=\$VALUE');

    q.parameters = {'VALUE': AppTables.chats};

    q.addChangeListener((results) {
      for (Map map in results.allResults) {
        // TODO: should come up with how I will load chat heat not chat messages but from chat messages
        if (!_chats.contains(Chat.fromMap(map))) {
          _chats.add(Chat.fromMap(map));
          notifyListeners();
        }
      }
      results.dispose();
    });
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_state];
}
