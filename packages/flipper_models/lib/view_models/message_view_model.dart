import 'package:flipper_models/business.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/message.dart';
import 'package:flipper_models/conversation.dart';
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
    ProxyService.api.conversationStreamList();
  }

  void onNewOrder() {
    // chat_data.add(chat_data);
  }

  void delete(int id) {
    log.i(id);
    ProxyService.api.delete(id: id, endPoint: 'message');
  }

  /// get a list of [Conversation] a conversation is a list of [Message]
  /// a conversation can be a group or a private chat
  /// a conversation have a [Conversation.type]
  /// a conversation can be a [Conversation.type.private] or a [Conversation.type.group]
  /// a conversation have a list of last online images if is a group then it will have more than one image
  /// if no image then last online image will be null and the message is not empty
  /// then the Letter of people in the conversation will be shown, only top 3 people will be shown.
  /// TODOrename this to getConversations
  Stream<List<Conversation>> conversations() async* {
    Stream<List<Conversation>> conversations =
        await ProxyService.api.conversationStreamList();
    yield* conversations;
  }

  void receiveOrder({required int chatId}) {}

  List<Contact> originList = [];
  final appService = locator<AppService>();
  List<Contact> dataList = [];
  final ItemScrollController itemScrollController = ItemScrollController();
  Business? business = null;
  void loadData() async {
    //get the current business as the sender!
    int id = ProxyService.box.read(key: 'businessId');
    business = ProxyService.api.getBusinessById(id: id);
    notifyListeners();
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

  List<types.Message> conversationsList = [];

  /// the method expect to return a list of [types.Message] yet we have it frm [Message]
  /// to [types.Message] thanks to types.Message.fromJson we can easily convert it
  void getConversations({required int conversationId}) async {
    List<Message> messages = ProxyService.api
        .conversationsFutureList(conversationId: conversationId);
    for (Message message in messages) {
      conversationsList.add(types.Message.fromJson(message.toJson()));
    }
  }

  /// wait for database save, then insert the message in the conversation list
  /// one tick can be shown when the message has not been sent to http server
  /// but the message has been saved in the database
  /// sending a message we need to know the conversation Id to send message to the right conversation
  /// then if the conversation is null it create a conversation and insert the message in the conversation
  void sendMessage(
      {required String message,
      required String receiverId,
      required int conversationId}) async {
    int senderId = ProxyService.box.read(key: 'businessId');
    Business business = ProxyService.api.getBusinessById(id: senderId);

    Map<String, dynamic> author = types.User(id: senderId.toString()).toJson();
    Message kMessage = Message(
      status: 'online',
      senderImage: business.imageUrl,
      type: 'text',
      author: author,
      createdAt: DateTime.now().microsecondsSinceEpoch,
      lastActiveId: business.id,
      text: message,
      receiverId: int.parse(receiverId),
      senderId: senderId,
      senderName: business.name,
      convoId: conversationId,
    );

    ProxyService.api
        .sendMessage(receiverId: int.parse(receiverId), message: kMessage);

    final textMessage = types.TextMessage(
      // author: types.User(id: receiverId),
      author: types.User(id: senderId.toString()),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message,
    );
    conversationsList.insert(0, textMessage);
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
