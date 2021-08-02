import 'package:flipper_routing/routes.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/message.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';

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

  @override
  List<ReactiveServiceMixin> get reactiveServices => [];
}
