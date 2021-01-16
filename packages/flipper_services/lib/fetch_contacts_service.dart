// import 'package:background_fetch/background_fetch.dart';
import 'package:contacts_service/contacts_service.dart';

class FetchContactsService {
  // handle loading contacts in background as it take too much time when loaded on demand.
  // ignore: always_declare_return_types
  // never have void method
  // loadContacts() {
  //   // Step 1:  Configure BackgroundFetch as usual.
  //   BackgroundFetch.configure(BackgroundFetchConfig(minimumFetchInterval: 5),
  //       (String taskId) async {
  //     // Use a switch statement to route task-handling.
  //     switch (taskId) {
  //       case 'com.transistorsoft.customtask':
  //        Iterable<Contact> _contact = await ContactsService.getContacts(
  //           withThumbnails: false,
  //           photoHighResolution: false,
  //         );
  //         _contact.map((Contact contact)=>[{'name':contact.displayName}]).toList();
  //         break;
  //     }
  //     // Finish, providing received taskId.
  //     BackgroundFetch.finish(taskId);
  //   });
  // }
}
