// import 'package:flipper_chat/lite/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/models/view_models/message_view_model.dart';

class CallsPage extends StatelessWidget {
  CallsPage({Key? key, required this.model}) : super(key: key);
  MessageViewModel model;
  @override
  Widget build(BuildContext context) {
    late bool callStatus = false;
    return ListView.builder(
      itemCount: 9,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, index) {
        callStatus = !callStatus;
        return Text('hello world');
        // return ListTile(
        //   leading: CircleAvatar(
        //     backgroundColor: Helpers.greyLigthColor,
        //     backgroundImage: AssetImage(User.listUser[index].img),
        //   ),
        //   title: Text(
        //     '${User.listUser[index].name} ${User.listUser[index].surname}',
        //     style: Helpers.txtDefault,
        //   ),
        //   subtitle: Row(
        //     children: [
        //       Icon(
        //         callStatus
        //             ? Icons.call_made_rounded
        //             : Icons.call_received_rounded,
        //         color: callStatus ? Helpers.greenColor : Colors.red,
        //         size: 18,
        //       ),
        //       Text(
        //         'Ayer 2:44 p.p',
        //         style: Helpers.txtDefault.copyWith(
        //           color: Helpers.principalColor.withOpacity(0.5),
        //         ),
        //       )
        //     ],
        //   ),
        //   trailing: Icon(
        //     Icons.call,
        //     color: Helpers.greenColor,
        //   ),
        // );
      },
    );
  }
}
