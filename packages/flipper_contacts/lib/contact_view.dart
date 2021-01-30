library flipper_contacts;

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/fcontact.dart';
import 'contact_item.dart';
import 'contact_viewmodel.dart';

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
    // FIXME(richard): fix the long wait on loading time,should load and save them locally on app start.
    return await ContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false,
    );
  }

  Widget buildContactList({ContactViewModel model}) {
    final List<dynamic> data = <dynamic>[];

    data.add(
      ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(4.0),
          child: const Icon(
            Icons.group,
            size: 32.0,
            color: Colors.white,
          ),
        ),
        title: Text(
          'New payroll',
          style: Theme.of(context).textTheme.headline5,
        ),
        onTap: () {},
      ),
    );
    data.add(
      ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: Theme.of(context)
                .copyWith(canvasColor: Colors.green)
                .canvasColor,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Icon(
            Icons.person_add,
            size: 24.0,
            color: Colors.white,
          ),
        ),
        title: Text(
          'New contact',
          style: Theme.of(context).textTheme.headline5,
        ),
        onTap: () {
          // AndroidIntentHelpers.createContact(context);
        },
      ),
    );
    data.addAll(model.contacts.contacts);
    data.add(
      ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Icon(Icons.share),
        ),
        title: Text('Invite friends',
            style: Theme.of(context).textTheme.headline5),
        onTap: () {
          // AndroidIntentHelpers.inviteFriend(context);
        },
      ),
    );
    data.add(
      ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Icon(Icons.help),
        ),
        title:
            Text('Contacts help', style: Theme.of(context).textTheme.headline5),
        onTap: () {},
      ),
    );
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int i) {
          if (i < 2 || i > data.length - 3) {
            return data[i];
          }
          return ContactItem(
              contact: data.elementAt(i),
              onProfileTap: () =>
                  onTapProfileContactItem(context, data.elementAt(i)),
              onTap: () {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContactViewModel>.reactive(
        builder: (BuildContext context, ContactViewModel model, Widget child) {
          return Scaffold(body: buildContactList(model: model));
        },
        viewModelBuilder: () => ContactViewModel());
  }

  void onTapProfileContactItem(BuildContext context, FContact contact) {
    print(contact);
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
