//  appBar: AppBar(
//               title: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   const Padding(
//                     padding: EdgeInsets.only(bottom: 2.0),
//                     child: Text(
//                       'Select contact',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: numContacts == null
//                         ? null
//                         : Text(
//                             '$numContacts contacts',
//                             style: const TextStyle(
//                               fontSize: 12.0,
//                             ),
//                           ),
//                   )
//                 ],
//               ),
//               actions: <Widget>[
//                 IconButton(
//                   tooltip: 'Search',
//                   icon: const Icon(Icons.search),
//                   onPressed: () {},
//                 ),
//                 PopupMenuButton<NewChatOptions>(
//                   tooltip: 'More options',
//                   onSelected: _onSelectOption,
//                   itemBuilder: (BuildContext context) {
//                     return [
//                       const PopupMenuItem<NewChatOptions>(
//                         child: Text('Invite a friend'),
//                         value: NewChatOptions.inviteAFriend,
//                       ),
//                       const PopupMenuItem<NewChatOptions>(
//                         child: Text('Contacts'),
//                         value: NewChatOptions.contacts,
//                       ),
//                       // ignore: always_specify_types
//                       const PopupMenuItem(
//                         child: Text('Refresh'),
//                         value: NewChatOptions.refresh,
//                       ),
//                       // ignore: always_specify_types
//                       const PopupMenuItem(
//                         child: Text('Help'),
//                         value: NewChatOptions.help,
//                       ),
//                     ];
//                   },
//                 ),
//               ],
//             ),
