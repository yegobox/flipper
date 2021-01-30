import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cron/cron.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class FetchContactsService with ReactiveServiceMixin {
  void lazyLoadContacts() {
    final cron = Cron();
    final _contacts = [];
    ProxyService.firestore.globalContacts().then((QuerySnapshot querySnapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
        _contacts.add(doc);
      });
      print(_contacts);
      notifyListeners();
    });
    // cron.schedule(Schedule.parse('*/1 * * * *'), () {
    //   final Future<Iterable<Contact>> contacts = ContactsService.getContacts(
    //     withThumbnails: false,
    //     photoHighResolution: false,
    //   );
    //   contacts.then((Iterable<Contact> values) {
    //     for (Contact contact in values) {
    //       for (Item item in contact.phones) {
    //         // ignore: avoid_function_literals_in_foreach_calls
    //         _contacts.forEach((doc) {
    //           if (item.value != doc['phoneNumber']) {
    //             ProxyService.firestore.addContacts({'phoneNumber': item.value});
    //           }
    //         });
    //       }
    //     }
    //   });
    // });
  }
}
