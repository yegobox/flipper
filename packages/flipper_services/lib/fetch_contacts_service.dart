import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cron/cron.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/fcontact.dart';

class FetchContactsService with ReactiveServiceMixin {
  final List<FContact> _contactsOnFlipper = <FContact>[];

  void heartBeatLoadContacts() {
    final cron = Cron();
    final _contacts = [];
    // ProxyService.firestore.globalContacts().then((QuerySnapshot querySnapshot) {
    //   // ignore: avoid_function_literals_in_foreach_calls
    //   querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
    //     _contacts.add(doc);
    //   });
    //   //at every 5 minutes update my contat match it with flipper contacts.
    //   cron.schedule(Schedule.parse('*/15 * * * *'), () {
    //     //
    //     final Future<Iterable<Contact>> contacts = ContactsService.getContacts(
    //       withThumbnails: false,
    //       photoHighResolution: false,
    //     );
    //     contacts.then((Iterable<Contact> values) {
    //       for (Contact contact in values) {
    //         for (Item item in contact.phones) {
    //           // ignore: avoid_function_literals_in_foreach_calls
    //           _contacts.forEach((doc) {
    //             final FContact c = FContact.fromMap({
    //               'phoneNumber': doc['phoneNumber'],
    //               'name': doc['name'],
    //               'channels': doc['channels']
    //             });
    //             if (item.value.replaceAll(RegExp(r'\s+\b|\b\s'), '') ==
    //                 c.phoneNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '')) {
    //               if (!_contactsOnFlipper.contains(c)) {
    //                 _contactsOnFlipper.add(c);
    //               }
    //             }
    //           });
    //         }
    //       }
    //       ProxyService.contacts.setContacts(contacts: _contactsOnFlipper);
    //     });
    //   });
    // });
  }

  void lazyLoadContacts() {
    final _contacts = [];
    // ProxyService.firestore.globalContacts().then((QuerySnapshot querySnapshot) {
    //   // ignore: avoid_function_literals_in_foreach_calls
    //   querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
    //     _contacts.add(doc);
    //   });

    //   final Future<Iterable<Contact>> contacts = ContactsService.getContacts(
    //     withThumbnails: false,
    //     photoHighResolution: false,
    //   );
    //   contacts.then((Iterable<Contact> values) {
    //     for (Contact contact in values) {
    //       for (Item item in contact.phones) {
    //         // ignore: avoid_function_literals_in_foreach_calls
    //         _contacts.forEach((doc) {
    //           final FContact c = FContact.fromMap({
    //             'phoneNumber': doc['phoneNumber'],
    //             'name': doc['name'],
    //             'channels': doc['channels']
    //           });

    //           if (item.value.replaceAll(RegExp(r'\s+\b|\b\s'), '') ==
    //               c.phoneNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '')) {
    //             if (!_contactsOnFlipper.contains(c)) {
    //               _contactsOnFlipper.add(c);
    //             }
    //           }
    //         });
    //       }
    //     }
    //     ProxyService.contacts.setContacts(contacts: _contactsOnFlipper);
    //   });
    // });
  }
}
