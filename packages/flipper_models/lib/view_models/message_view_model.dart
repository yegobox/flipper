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
import 'package:flutter/services.dart' show rootBundle;

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
      // log.i(v.toJson());
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
  void getConversations() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messagess = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    conversations = messagess;
    notifyListeners();
  }

  // void sendMessage({required int receiverId, required String message}) {
  //   ProxyService.api.sendMessage(receiverId: receiverId, message: message);
  // }
  void sendMessage(types.Message message) {
    conversations.insert(0, message);
  }

  ///the mothod looks for the business that is arleady saved on local
  ///so we have to make sure before the user or business start to chat bot have arleady saved
  ///the business on local
  void loadSenderBusiness({required int senderId}) async {
    user = await ProxyService.api.getBusinessById(id: senderId);
    notifyListeners();
  }
}
