import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/views/chat_list/chat_list_viewmodel.dart';
import 'package:flipper_socials/ui/widgets/chat_widget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class ConversationHistory extends StatefulWidget {
  const ConversationHistory({super.key, required this.conversationId});
  final String conversationId;

  @override
  State<ConversationHistory> createState() => _ConversationHistoryState();
}

class _ConversationHistoryState extends State<ConversationHistory>
    with TickerProviderStateMixin {
  late AnimationController animationController; // use late modifier
  final TextEditingController _conversationController =
      TextEditingController(text: '');
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
    return ViewModelBuilder<ChatListViewModel>.reactive(
        viewModelBuilder: () => ChatListViewModel(),
        onViewModelReady: (model) {},
        builder: (build, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Conversation History',
                  style: GoogleFonts.poppins(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  )),
            ),
            body: Column(
              children: [
                StreamBuilder<List<Conversation>>(
                    stream: ProxyService.isarApi
                        .conversations(conversationId: widget.conversationId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        latestConversation = snapshot.data!.last;
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
                        });
                        return Flexible(
                          child: ListView.builder(
                            controller:
                                _scrollController, // Set the ScrollController
                            itemCount: data!.length,
                            itemBuilder: (context, index) {
                              // Use the ChatWidget to display the message
                              return ChatWidget(chat: data[index]);
                            },
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, right: 10, left: 10),
                  child: TextFormField(
                      controller: _conversationController,
                      decoration: InputDecoration(
                        suffixIcon: AnimatedIconButton(
                          animationController: animationController,
                          size: 20,
                          onPressed: () async {
                            if (_conversationController.text.isNotEmpty) {
                              await viewModel.sendMessage(
                                message: _conversationController.text,
                                latestConversation: latestConversation!,
                              );
                              // Scroll to the bottom of the ListView
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.fastOutSlowIn,
                                // curve: Curves.easeOut,
                              );
                            }
                            _conversationController.clear();
                            // send message logic here
                          },
                          icons: const <AnimatedIconItem>[
                            AnimatedIconItem(
                              icon: Icon(
                                FluentIcons.send_24_regular,
                                color: Colors.grey,
                              ),
                            ),
                            AnimatedIconItem(
                              icon: Icon(
                                FluentIcons.send_24_filled,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                        hintText: 'Type a message',
                      ),
                      keyboardType:
                          TextInputType.multiline, // enable multiline input
                      minLines: 1, // normal text input field will be displayed
                      maxLines: 100,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          // animate the icon button to show it can be clicked
                          animationController.forward();
                        } else {
                          // animate the icon button back to its initial state
                          animationController.reverse();
                        }
                      }),
                )
              ],
            ),
          );
        });
  }
}
