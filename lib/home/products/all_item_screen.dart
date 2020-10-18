import 'package:customappbar/customappbar.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flutter/material.dart';

class AllItemScreen extends StatefulWidget {
  const AllItemScreen({Key key}) : super(key: key);

  @override
  _AllItemScreenState createState() => _AllItemScreenState();
}

class _AllItemScreenState extends State<AllItemScreen> {
  final FlipperNavigationService _navigationService = ProxyService.nav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          onPop: () {
            Routing.navigator.pop();
          },
          title: 'Items',
          showActionButton: false,
          onPressedCallback: () async {},
          actionButtonName: 'Save',
          icon: Icons.close,
          multi: 1,
          bottomSpacer: 48,
        ),
        body: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _navigationService.navigateTo(Routing.viewItemsScreen);
              },
              child: ListTile(
                title:const Text('All Items', style: TextStyle(color: Colors.black)),
                trailing: Wrap(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[const Icon(Icons.arrow_forward_ios)],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                title:
                    const Text('Categories', style: TextStyle(color: Colors.black)),
                trailing: Wrap(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[const Icon(Icons.arrow_forward_ios)],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                title: Text('Units', style: const TextStyle(color: Colors.black)),
                trailing: Wrap(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[const Icon(Icons.arrow_forward_ios)],
                ),
              ),
            )
          ],
        ));
  }
}
