import 'package:stacked/stacked.dart';
import 'package:flipper_services/locator.dart';

import 'package:flipper_services/shared_state_service.dart';
import 'package:flipper_models/chat.dart';
import 'package:flipper_services/constant.dart';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:uuid/uuid.dart';
import 'package:built_collection/built_collection.dart';

class ChatViewModel extends ReactiveViewModel {
  final List<Chat> _chats = <Chat>[];

  List<Chat> get chats => _chats;

  final _state = locator<SharedStateService>();
  final DatabaseService _db = ProxyService.database;

  void loadMessages() {
    final q = Query(
        _db.db, 'SELECT id,message,time,sendBy,channels WHERE table=\$VALUE');

    q.parameters = {'VALUE': AppTables.chats};

    q.addChangeListener((results) {
      for (Map map in results.allResults) {
        if (!_chats.contains(Chat.fromMap(map))) {
          _chats.add(Chat.fromMap(map));
          notifyListeners();
        }
      }
      results.dispose();
    });
  }

  void sendMessage({Map message, BuiltList channels}) {
    final id = Uuid().v1();
    // print(message['sendBy']);
    _db.insert(id: id, data: {
      'id': id,
      'message': message['message'],
      'sendBy': message['sendBy'].toString(),
      'table': AppTables.chats,
      'time': DateTime.now().millisecondsSinceEpoch.toString(),
      'channels': [_state.user.id, channels[0]]
    });
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_state];
}
