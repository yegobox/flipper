import 'package:flipper_chat/omni/common/index.dart';
// import 'package:flipper_chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:go_router/go_router.dart';
import 'omni_conversation.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class OmniContacts extends StatefulWidget {
  const OmniContacts({
    Key? key,
    this.fromType,
  }) : super(key: key);
  final int? fromType;

  @override
  _OmniContactsState createState() => _OmniContactsState();
}

class _OmniContactsState extends State<OmniContacts> {
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
      padding: const EdgeInsets.only(left: 16.0),
      color: const Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: const TextStyle(
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
        /// first add this business to firestore bd as user we are bout to chat with
        _handlePressed(
          contact.userId!,
          contact.name,
          types.User(
            firstName: contact.name,
            lastName: '',
            id: contact.chatUid!,
            imageUrl: 'https://dummyimage.com/300/09f.png/fff',
          ),
          context,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageViewModel>.reactive(
      onModelReady: (model) {
        model.loadContacts();
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
                          GoRouter.of(context).pop();
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

  void _handlePressed(String userId, String name, types.User otherUser,
      BuildContext context) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OmniConversation(
          room: room,
        ),
      ),
    );
  }
}
