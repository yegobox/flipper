import 'package:flipper_models/helperModels/ConversationAdapter.dart';

import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/widgets/list_of_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:stacked/stacked.dart';
import 'chat_list_viewmodel.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flipper_services/constants.dart';

class ChatListViewDesktop extends StatefulWidget {
  const ChatListViewDesktop({super.key});

  @override
  State<ChatListViewDesktop> createState() => _ChatListViewDesktopState();
}

class _ChatListViewDesktopState extends State<ChatListViewDesktop>
    with TickerProviderStateMixin {
  late AnimationController animationController; // use late modifier

  Conversation? latestConversation;
  final _scrollController = ScrollController();
  List<Conversation>? conversations;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      // initialize in initState
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;
    // Use a row widget to split the screen into two parts
    return ViewModelBuilder<ChatListViewModel>.reactive(
        viewModelBuilder: () => ChatListViewModel(),
        onViewModelReady: (model) {},
        builder: (build, viewModel, child) {
          return StreamBuilder<List<Conversation>>(
              stream: ProxyService.realm.conversations(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final conversations = snapshot.data ?? [];
                  return Scaffold(
                    body: Row(
                      children: [
                        // The left part with the list of messages
                        ListOfMessages(
                          size: size,
                          viewModel: viewModel,
                          conversations: conversations,
                        ),

                        // The right part with the selected chat details and messages
                        SizedBox(
                          width: size.width * 0.7,
                          child: Column(
                            children: [
                              // The app bar with profile picture, username, and status
                              viewModel.focusedConversation
                                  ? AppBar(
                                      automaticallyImplyLeading: false,
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 28.0),
                                        child: StreamBuilder<
                                                List<Conversation>>(
                                            stream: ProxyService.realm
                                                .conversations(
                                                    conversationId: viewModel
                                                        .conversationId!),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                latestConversation =
                                                    snapshot.data!.last;

                                                String userPhoneNumber =
                                                    ProxyService.box
                                                        .getUserPhone()!;
                                                final data = snapshot.data!
                                                    .where((item) =>
                                                        item.toNumber !=
                                                        userPhoneNumber)
                                                    .toList();
                                                return Row(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        // A circle avatar that shows the chat image
                                                        CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(data
                                                                      .first
                                                                      .avatar ??
                                                                  ""),
                                                          radius: 20,
                                                        ),
                                                        // A positioned widget that shows the channelType image at the bottom right corner
                                                        Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundImage:
                                                                AssetImage(
                                                              "assets/${data.first.channelType}.png",
                                                              package:
                                                                  'flipper_socials',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              } else {
                                                return const SizedBox.shrink();
                                              }
                                            }),
                                      ),
                                      actions: const [],
                                    )
                                  : const SizedBox.shrink(),
                              // The list of messages for the selected chat
                              viewModel.focusedConversation
                                  ? StreamBuilder<List<Conversation>>(
                                      stream: ProxyService.realm.conversations(
                                          conversationId:
                                              viewModel.conversationId!),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final data = snapshot.data;
                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) {
                                            _scrollController.jumpTo(
                                                _scrollController
                                                    .position.maxScrollExtent);
                                          });
                                          List<types.Message> messageList = [];

                                          for (Conversation conversation
                                              in data!) {
                                            types.Message message =
                                                ConversationAdapter(
                                                    conversation);
                                            messageList.add(message);
                                          }
                                          return Chat(
                                            messages: messageList,
                                            onSendPressed: _click,
                                            user: types.User(
                                                id: ProxyService.box
                                                    .getUserPhone()!),
                                          );
                                          // return Flexible(
                                          //   child: ListView.builder(
                                          //     controller:
                                          //         _scrollController, // Set the ScrollController
                                          //     itemCount: data!.length,
                                          //     itemBuilder: (context, index) {
                                          //       // Use the ChatWidget to display the message
                                          //       return ChatWidget(
                                          //           chat: data[index]);
                                          //     },
                                          //   ),
                                          // );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      })
                                  : const SizedBox.shrink(),
                              // The text field for sending messages
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       bottom: 8.0, right: 10),
                              //   child: TextFormField(
                              //       controller: _conversationController,
                              //       decoration: InputDecoration(
                              //         suffixIcon: AnimatedIconButton(
                              //           animationController:
                              //               animationController,
                              //           size: 20,
                              //           onPressed: () async {
                              //             if (_conversationController
                              //                 .text.isNotEmpty) {
                              //               await viewModel.sendMessage(
                              //                 message:
                              //                     _conversationController.text,
                              //                 latestConversation:
                              //                     latestConversation!,
                              //               );
                              //               // Scroll to the bottom of the ListView
                              //               _scrollController.animateTo(
                              //                 _scrollController
                              //                     .position.maxScrollExtent,
                              //                 duration: const Duration(
                              //                     milliseconds: 300),
                              //                 curve: Curves.fastOutSlowIn,
                              //                 // curve: Curves.easeOut,
                              //               );
                              //             }
                              //             _conversationController.clear();
                              //             // send message logic here
                              //           },
                              //           icons: const <AnimatedIconItem>[
                              //             AnimatedIconItem(
                              //               icon: Icon(
                              //                 FluentIcons.send_24_regular,
                              //                 color: Colors.grey,
                              //               ),
                              //             ),
                              //             AnimatedIconItem(
                              //               icon: Icon(
                              //                 FluentIcons.send_24_filled,
                              //                 color: Colors.blue,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //         border: const OutlineInputBorder(),
                              //         hintText: 'Type a message',
                              //       ),
                              //       keyboardType: TextInputType
                              //           .multiline, // enable multiline input
                              //       minLines:
                              //           1, // normal text input field will be displayed
                              //       maxLines: 100,
                              //       onChanged: (value) {
                              //         if (value.isNotEmpty) {
                              //           // animate the icon button to show it can be clicked
                              //           animationController.forward();
                              //         } else {
                              //           // animate the icon button back to its initial state
                              //           animationController.reverse();
                              //         }
                              //       }),
                              // )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            'No conversation yet! managing business has never been this easy'),
                        SizedBox(
                          width: 200,
                          child: OutlinedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Go To inventory app',
                                    style: primaryTextStyle.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12)),
                              ],
                            ),
                            style: primaryButtonStyle.copyWith(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              viewModel.navigateToAppCenter();
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }
              });
        });
  }

  void _click(types.PartialText message) {}
}
