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

class MessageViewModel extends BusinessHomeViewModel {
  //save chat_data in a list
  List<String> chat_data = [];

  final log = getLogger('MessageViewModel');
  void messages() {
    ProxyService.api.messages();
  }

  void onNewOrder() {
    // chat_data.add(chat_data);
  }

  void delete(int id) {
    log.i(id);
    ProxyService.api.delete(id: id, endPoint: 'message');
  }

  void sendMessage({required int receiverId, required String message}) {
    ProxyService.api.sendMessage(receiverId: receiverId, message: message);
  }

  Stream<List<Message>> getMessages() async* {
    List<Message> messages = [
      Message(
          createdAt: new DateTime.now().toIso8601String(),
          id: 2000,
          message: 'test message',
          receiverId: 1,
          senderId: 1,
          lastActiveId: 1,
          senderName: 'Richie',
          status: true,
          senderImage:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU'),
      Message(
          createdAt: new DateTime.now().toIso8601String(),
          id: 2000,
          message: 'test message',
          receiverId: 1,
          senderId: 1,
          lastActiveId: 1,
          senderName: 'Aurore',
          senderImage:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU',
          status: false),
      Message(
        createdAt: new DateTime.now().toIso8601String(),
        id: 2000,
        message: 'test message',
        receiverId: 1,
        senderId: 1,
        lastActiveId: 1,
        senderImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU',
        senderName: 'Aurore',
        status: false,
      ),
      Message(
        createdAt: new DateTime.now().toIso8601String(),
        id: 2000,
        message: 'test message',
        receiverId: 1,
        senderId: 1,
        lastActiveId: 1,
        senderImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU',
        senderName: 'Aurore',
        status: false,
      ),
      Message(
        createdAt: new DateTime.now().toIso8601String(),
        id: 2000,
        message: 'test message',
        senderImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU',
        receiverId: 1,
        senderId: 1,
        lastActiveId: 1,
        senderName: 'Aurore',
        status: false,
      ),
      Message(
        createdAt: new DateTime.now().toIso8601String(),
        id: 2000,
        message: 'test message',
        receiverId: 1,
        senderId: 1,
        lastActiveId: 1,
        senderName: 'Aurore',
        senderImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU',
        status: false,
      ),
      Message(
        createdAt: new DateTime.now().toIso8601String(),
        id: 2000,
        message: 'test message',
        receiverId: 1,
        senderId: 1,
        lastActiveId: 1,
        senderImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU',
        senderName: 'Aurore',
        status: false,
      ),
      Message(
        createdAt: new DateTime.now().toIso8601String(),
        id: 2000,
        message: 'test message',
        receiverId: 1,
        senderId: 1,
        lastActiveId: 1,
        senderImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU',
        senderName: 'Aurore',
        status: false,
      ),
      Message(
        createdAt: new DateTime.now().toIso8601String(),
        id: 2000,
        message: 'test message',
        receiverId: 1,
        senderId: 1,
        lastActiveId: 1,
        senderImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU',
        senderName: 'Aurore',
        status: false,
      ),
      Message(
        createdAt: new DateTime.now().toIso8601String(),
        id: 2000,
        message: 'test message',
        senderImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU',
        receiverId: 1,
        senderId: 1,
        lastActiveId: 1,
        senderName: 'Aurore',
        status: false,
      ),
    ];
    yield messages;
    // return ProxyService.api.messages();
  }

  void receiveOrder({required int chatId}) {}

  List<Contact> originList = [];
  final appService = locator<AppService>();
  List<Contact> dataList = [];
  final ItemScrollController itemScrollController = ItemScrollController();

  void loadData() async {
    appService.loadContacts();
    originList = appService.contacts.map((v) {
      Contact model = Contact.fromJson(v.toJson());
      log.i(v.toJson());
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
      // setState(() {});
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
}
