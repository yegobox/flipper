import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cron/cron.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class FetchContactsService with ReactiveServiceMixin {
  void lazyLoadContacts() {
    final cron = Cron();
    final _contacts = [];
    ProxyService.firestore.getContacts().then((QuerySnapshot querySnapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
        _contacts.add(doc);
      });
      notifyListeners();
    });
    cron.schedule(Schedule.parse('*/1 * * * *'), () {
      final Future<Iterable<Contact>> contacts = ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
      );
      contacts.then((Iterable<Contact> values) {
        for (Contact contact in values) {
          for (Item item in contact.phones) {
            _contacts.forEach((doc) {
              print(doc['phoneNumber']);
            });
            //  ProxyService.firestore
            //   .addContacts( {'phoneNumber': '+2507830'});
            // print(item.value);
            //todo: is this a user of flipper if yes, then add the contact to list of contacts
            // final q = Query(_db.db, 'SELECT * WHERE table=\$VALUE');
            // q.parameters = {'VALUE': AppTables.chats};
          }
        }
      });
    });
  }
}
