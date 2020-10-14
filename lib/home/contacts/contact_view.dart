import 'package:flipper/util/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

import 'contact_item.dart';

enum NewChatOptions {
  inviteAFriend,
  contacts,
  refresh,
  help,
}

class ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SelectContact();
  }
}

class SelectContact extends StatefulWidget {
  @override
  _SelectContact createState() => _SelectContact();
}

class _SelectContact extends State<SelectContact> {
  Future<Iterable<Contact>> _contacts;
  int numContacts;

  Future<int> _getNumContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    return contacts.length;
  }

  @override
  void initState() {
    super.initState();
    _contacts = _getContacts();

    _getNumContacts().then((int num) {
      setState(() {
        numContacts = num;
      });
    });
  }

  Future<Iterable<Contact>> _getContacts() async {
    return await ContactsService.getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 2.0),
              child: Text(
                'Select contact',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: numContacts == null
                  ? null
                  : Text(
                      '$numContacts contacts',
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton<NewChatOptions>(
            tooltip: 'More options',
            onSelected: _onSelectOption,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<NewChatOptions>(
                  child: Text('Invite a friend'),
                  value: NewChatOptions.inviteAFriend,
                ),
                const PopupMenuItem<NewChatOptions>(
                  child: Text('Contacts'),
                  value: NewChatOptions.contacts,
                ),
                const PopupMenuItem(
                  child: Text('Refresh'),
                  value: NewChatOptions.refresh,
                ),
                const PopupMenuItem(
                  child: Text('Help'),
                  value: NewChatOptions.help,
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<Iterable<Contact>>(
        future: _contacts,
        builder:
            (BuildContext context, AsyncSnapshot<Iterable<Contact>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              );
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              final List<dynamic> data = <dynamic>[];
              data.add(ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    color: AppColors.fabBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: const Icon(
                    Icons.group,
                    size: 32.0,
                    color: Colors.white,
                  ),
                ),
                title: const Text('New group',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
                onTap: () {},
              ));
              data.add(ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    color: AppColors.fabBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.person_add,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                title: const Text('New contact',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
                onTap: () {
                  // AndroidIntentHelpers.createContact(context);
                },
              ));
              data.addAll(snapshot.data);
              data.add(ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.share),
                ),
                title: const Text('Invite friends',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
                onTap: () {
                  // AndroidIntentHelpers.inviteFriend(context);
                },
              ));
              data.add(ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.help),
                ),
                title: const Text('Contacts help',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
                onTap: () {},
              ));
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int i) {
                    if (i < 2 || i > data.length - 3) {
                      return data[i];
                    }
                    return ContactItem(
                        contact: data.elementAt(i),
                        onProfileTap: () => onTapProfileContactItem(
                            context, snapshot.data.elementAt(i)),
                        onTap: () {});
                  });
          }
          return null; // unreachable
        },
      ),
    );
  }

  void onTapProfileContactItem(BuildContext context, Contact contact) {
    // Dialog profileDialog = DialogHelpers.getProfileDialog(
    //   context: context,
    //   id: 1,
    //   imageUrl: null,
    //   name: contact.displayName,
    // );
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) => profileDialog
    // );
  }

  void _onSelectOption(NewChatOptions option) {
    switch (option) {
      case NewChatOptions.inviteAFriend:
        // AndroidIntentHelpers.inviteFriend(context);
        break;
      case NewChatOptions.contacts:
        // AndroidIntentHelpers.openContactApp(context);
        break;
      case NewChatOptions.refresh:
        break;
      case NewChatOptions.help:
        break;
    }
  }
}
