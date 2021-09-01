import 'package:flipper_models/business.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/message.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:flipper_chat/lite/common/index.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/app_service.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class MessageViewModel extends BusinessHomeViewModel {
  //save chat_data in a list
  List<String> chat_data = [];

  final log = getLogger('MessageViewModel');
  Business? user = null;
  void messages() {
    ProxyService.api.getChats();
  }

  void onNewOrder() {
    // chat_data.add(chat_data);
  }

  void delete(int id) {
    log.i(id);
    ProxyService.api.delete(id: id, endPoint: 'message');
  }

  Stream<List<Message>> getMessages() async* {
    Stream<List<Message>> messages = await ProxyService.api.getChats();
    yield* messages;
  }

  void receiveOrder({required int chatId}) {}

  List<Contact> originList = [];
  final appService = locator<AppService>();
  List<Contact> dataList = [];
  final ItemScrollController itemScrollController = ItemScrollController();

  void loadData() async {
    await appService.loadContacts();
    originList = appService.contacts.map((v) {
      Contact model = Contact.fromJson(v.toJson());
      log.i(model.id);
      String tag = model.name.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        model.tagIndex = tag;
      } else {
        model.tagIndex = "#";
      }
      return model;
    }).toList();
    _handleList(originList);
  }

  void _handleList(List<Contact> list) {
    dataList.clear();
    if (ObjectUtil.isEmpty(list)) {
      return;
    }
    dataList.addAll(list);

    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(dataList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(dataList);

    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: 0);
    }
    notifyListeners();
  }

  void search(String text) {
    if (ObjectUtil.isEmpty(text)) {
      _handleList(originList);
    } else {
      List<Contact> list = originList.where((v) {
        return v.name.toLowerCase().contains(text.toLowerCase());
      }).toList();
      _handleList(list);
    }
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [appService];

  List<types.Message> conversations = [];

  /// the method expect to return a list of [types.Message] yet we have it frm [Message]
  /// to [types.Message] thanks to types.Message.fromJson we can easily convert it
  void getConversations({required int senderId}) async {
    List<Message> messages =
        ProxyService.api.getConversations(authorId: senderId);
    for (Message message in messages) {
      conversations.add(types.Message.fromJson(message.toJson()));
    }
  }

  /// wait for database save, then insert the message in the conversation list
  /// one tick can be shown when the message has not been sent to http server
  /// but the message has been saved in the database
  void sendMessage({required String message, required String receiverId}) {
    // todo: create a new Object of message send it instead of a string.!
    log.i(receiverId);
    int senderId = ProxyService.box.read(key: 'businessId');
    Business business = ProxyService.api.getBusinessById(id: senderId);

    Map<String, dynamic> author = types.User(id: senderId.toString()).toJson();
    Message kMessage = Message(
      status: 'online',
      senderImage: business.imageUrl,
      // get type in best way!
      type: 'text',
      //TODOadd more data in sender object!.
      author: author,
      createdAt: DateTime.now().microsecondsSinceEpoch,
      lastActiveId: business.id,
      text: message,
      receiverId: int.parse(receiverId),
      senderId: senderId,
      senderName: business.name,
    );
    // log.i(kMessage.toJson());
    ProxyService.api
        .sendMessage(receiverId: int.parse(receiverId), message: kMessage);
    final textMessage = types.TextMessage(
      author: types.User(id: receiverId),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message,
    );
    conversations.insert(0, textMessage);
    notifyListeners();
  }

  ///the mothod looks for the business that is arleady saved on local
  ///so we have to make sure before the user or business start to chat bot have arleady saved
  ///the business on local
  void loadSenderBusiness({required int senderId}) async {
    user = await ProxyService.api.getBusinessById(id: senderId);
    notifyListeners();
  }
}
