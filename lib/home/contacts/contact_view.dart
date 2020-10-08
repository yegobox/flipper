import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: always_specify_types
  List<Contact> contacts = [];
  // ignore: always_specify_types
  List<Contact> contactsFiltered = [];
  // ignore: always_specify_types
  Map<String, Color> contactsColorMap = {};
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  Future<void> getPermissions() async {
    final PermissionStatus locationStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    final PermissionStatus contactStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);

    final PermissionStatus smsStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);

    if (locationStatus == PermissionStatus.granted &&
        contactStatus == PermissionStatus.granted &&
        smsStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      // ignore: prefer_single_quotes
      return m[0] == "+" ? "+" : "";
    });
  }

  Future<void> getAllContacts() async {
    // ignore: always_specify_types
    final List colors = [
      Colors.green,
      Colors.indigo,
      Colors.yellow,
      Colors.orange
    ];
    int colorIndex = 0;
    final List<Contact> _contacts =
        (await ContactsService.getContacts()).toList();
    // ignore: avoid_function_literals_in_foreach_calls
    _contacts.forEach((Contact contact) {
      final Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName] = baseColor;
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });
    setState(() {
      contacts = _contacts;
    });
  }

  // ignore: always_declare_return_types
  filterContacts() {
    final List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((Contact contact) {
        final String searchTerm = searchController.text.toLowerCase();
        final String searchTermFlatten = flattenPhoneNumber(searchTerm);
        final String contactName = contact.displayName.toLowerCase();
        final bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        final Item phone = contact.phones.firstWhere((phn) {
          final String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).primaryColor)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: isSearching == true
                    ? contactsFiltered.length
                    : contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  final Contact contact = isSearching == true
                      ? contactsFiltered[index]
                      : contacts[index];

                  // ignore: always_specify_types
                  final baseColor =
                      contactsColorMap[contact.displayName] as dynamic;

                  final Color color1 = baseColor[800];
                  final Color color2 = baseColor[400];
                  return ListTile(
                    title: Text(contact.displayName),
                    subtitle: Text(contact.phones.isNotEmpty
                        ? contact.phones.elementAt(0).value
                        : ''),
                    leading: (contact.avatar != null &&
                            contact.avatar.isNotEmpty)
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(contact.avatar),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    colors: <Color>[
                                      color1,
                                      color2,
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight)),
                            child: CircleAvatar(
                              child: Text(contact.initials(),
                                  style: const TextStyle(color: Colors.white)),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
