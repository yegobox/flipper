import 'package:flipper_chat/lite/data.dart';
import 'package:flipper_chat/lite/helpers.dart';
import 'package:flipper_chat/lite/pages/chat_page.dart';
import 'package:flipper_chat/lite/pages/right_to_left_route.dart';
import 'package:flipper_chat/lite/widgets/button_circle.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/message_view_model.dart';

class GroupsPage extends StatelessWidget {
  GroupsPage({Key? key, required this.model}) : super(key: key);
  MessageViewModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            // itemExtent: 180,
            physics: const BouncingScrollPhysics(),
            itemCount: DataW.listGroups.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (BuildContext context, int index) {
              final groupChat = DataW.listGroups[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    //tit
                    Row(
                      children: [
                        Container(
                          width: 60,
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            maxRadius: 25,
                            minRadius: 25,
                            backgroundImage: AssetImage(groupChat.img),
                            backgroundColor: Helpers.greyLigthColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            groupChat.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: Helpers.txtDefault.copyWith(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        ButtonCircle(
                          onPressed: () {},
                          icon: Icons.more_vert_outlined,
                          backgroundColor: Colors.transparent,
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              ...List.generate(
                                DataW.listGroups[index].users.length,
                                (itemUser) {
                                  final user =
                                      DataW.listGroups[index].users[itemUser];
                                  final p =
                                      itemUser >= 3 ? 75.0 : (25.0 * itemUser);

                                  final others =
                                      DataW.listGroups[index].users.length - 3;

                                  return Padding(
                                    padding: EdgeInsets.only(left: p),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Helpers.greenColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: itemUser >= 3
                                            ? Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '+$others',
                                                  style: Helpers.txtDefault
                                                      .copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : Image.asset(
                                                user.img,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${DataW.listGroups[index].users.length} Participantes',
                            style: Helpers.txtDefault.copyWith(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 2,
                      color: Helpers.greyLigthColor,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          RightToLeftRoute(
                            page: ChatPage(),
                          ),
                        );
                      },
                      title: Text(
                        'Brayan Cantos',
                        style: Helpers.txtDefault.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Alguien quiere que le pase el código?',
                          style: Helpers.txtDefault),
                      contentPadding: EdgeInsets.zero,
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Helpers.greenColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '5',
                          style: Helpers.txtDefault.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
