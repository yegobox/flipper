import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rubber/rubber.dart';

class FlipperDrawer extends StatelessWidget {
  FlipperDrawer({Key? key, required this.controller}) : super(key: key);

  Function controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _getLowerLayer(),
    );
  }

  Widget _getLowerLayer() {
    return Stack(
      children: [
        ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            const SizedBox(
              height: 60,
              child: DrawerHeader(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Text('Workspaces'),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
              title: const Text('SPENN'),
              subtitle: const Text('The name of space'),
              leading: Image.asset('assets/logo.png'),
              trailing: const Icon(
                Ionicons.people_outline,
              ),
              onTap: () {
                // Navigator.pop(context);
              },
            ),
          ],
        ),
        Positioned(
          bottom: 0.0,
          left: 20.0,
          right: 0.0,
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                title: const Text('Add a Workspace'),
                leading: const Icon(Icons.add),
                onTap: () {
                  // Navigator.pop(context);
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                title: const Text('Preferences'),
                leading: const Icon(Icons.settings),
                onTap: () {
                  controller();
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                title: const Text('help'),
                leading: Icon(
                  Icons.help,
                ),
                onTap: () {},
              ),
            ],
          ),
        )
      ],
    );
  }
}
