import 'package:flipper_chat/lite/common/index.dart';
import 'package:flipper_chat/lite/pages/chat_page.dart';
import 'package:flipper_chat/lite/pages/right_to_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/conversation.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flipper_models/view_models/message_view_model.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/routes.logger.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({
    Key? key,
    this.fromType,
  }) : super(key: key);
  final int? fromType;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  /// Controller to scroll or jump to a particular item.

  final log = getLogger('_ContactPageState');

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Widget getSusItem(BuildContext context, String tag, {double susHeight = 40}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  Widget getListItem(BuildContext context, Contact contact,
      {double susHeight = 40, required MessageViewModel model}) {
    return ListTile(
      title: Text(contact.name),
      onTap: () {
        log.i(contact.id);
        String userId = ProxyService.box.read(key: 'userId');
        Conversation conversation = Conversation(
          createdAt: DateTime.now().microsecondsSinceEpoch,
          receiverId: contact.id,
          senderId: int.parse(userId),
          senderName: model.business!.name,
          lastMessage: 'text',
          status: 'online',
        );
        Navigator.of(context).push(
          RightToLeftRoute(
            page: ChatPage(conversation: conversation),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageViewModel>.reactive(
      onModelReady: (model) {
        model.loadData();
      },
      viewModelBuilder: () => MessageViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('New Chat'),
                      TextButton(
                        onPressed: () {
                          ProxyService.nav.back();
                        },
                        child: Text('Cancel'),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 225, 226, 230),
                        width: 0.33,
                      ),
                      color: Color.fromARGB(255, 239, 240, 244),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    autofocus: false,
                    onChanged: (value) {
                      model.search(value);
                    },
                    controller: textEditingController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colours.gray_33,
                        ),
                        suffixIcon: Offstage(
                          offstage: textEditingController.text.isEmpty,
                          child: InkWell(
                            onTap: () {
                              textEditingController.clear();
                              model.search('');
                            },
                            child: Icon(
                              Icons.cancel,
                              color: Colours.gray_99,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                        hintText: 'Search business and people',
                        hintStyle: TextStyle(color: Colours.gray_99)),
                  ),
                ),
                Expanded(
                  child: AzListView(
                    data: model.dataList,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: model.dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Contact contact = model.dataList[index];
                      return getListItem(context, contact, model: model);
                    },
                    itemScrollController: model.itemScrollController,
                    susItemBuilder: (BuildContext context, int index) {
                      Contact contact = model.dataList[index];
                      return getSusItem(context, contact.getSuspensionTag());
                    },
                    indexBarOptions: IndexBarOptions(
                      needRebuild: true,
                      selectTextStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                      selectItemDecoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFF333333)),
                      indexHintWidth: 96,
                      indexHintHeight: 97,
                      indexHintDecoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              Utils.getImgPath('ic_index_bar_bubble_white')),
                          fit: BoxFit.contain,
                        ),
                      ),
                      indexHintAlignment: Alignment.centerRight,
                      indexHintTextStyle:
                          TextStyle(fontSize: 24.0, color: Colors.black87),
                      indexHintOffset: Offset(-30, 0),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
