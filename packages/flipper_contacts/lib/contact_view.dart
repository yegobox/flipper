library flipper_contacts;

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flipper_models/fcontact.dart';
import 'package:flipper_services/dynamic_links_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';

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
  int numContacts;

  final DynamicLinkService _link = locator<DynamicLinkService>();

  @override
  void initState() {
    super.initState();

    _getNumContacts().then((int num) {
      setState(() {
        numContacts = num;
      });
    });
  }

  Future<int> _getNumContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    return contacts.length;
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
      FutureBuilder(
          future: _link.createDynamicLink(),
          builder: (context, snap) {
            if (snap.hasData) {
              final ShortDynamicLink uri = snap.data;
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.share),
                ),
                title: Text('Invite friends',
                    style: Theme.of(context).textTheme.headline5),
                onTap: () {
                  Share.share(uri.shortUrl.toString());
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
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
              onTap: () {
                ProxyService.inAppNav.navigateToChat(
                    {'path': 'chat', 'channels': data.elementAt(i).channels});
              });
        });
  }

  void onTapProfileContactItem(BuildContext context, FContact contact) {
    print(contact);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContactViewModel>.reactive(
      builder: (BuildContext context, ContactViewModel model, Widget child) {
        return Scaffold(body: buildContactList(model: model));
      },
      viewModelBuilder: () => ContactViewModel(),
    );
  }
}
