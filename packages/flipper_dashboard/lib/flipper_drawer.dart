import 'dart:ui';

import 'package:flipper_dashboard/atoms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flipper_models/isar_models.dart' as model;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class FlipperDrawer extends StatefulWidget {
  const FlipperDrawer(
      {Key? key,
      required this.preferenceController,
      required this.inviteController,
      required this.businesses,
      required this.addWorkSpace})
      : super(key: key);

  final Function preferenceController;
  final Function inviteController;
  final Function addWorkSpace;
  final List<model.Business> businesses;

  @override
  State<FlipperDrawer> createState() => _FlipperDrawerState();
}

class _FlipperDrawerState extends State<FlipperDrawer> {
  final _routerService = locator<RouterService>();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _getLowerLayer(),
    );
  }

  Widget _getLowerLayer() {
    final Color _circleColor =
        Theme.of(context).copyWith(canvasColor: Colors.cyan).canvasColor;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
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
              ...widget.businesses
                  .map(
                    (business) => ListTile(
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                      title: Text(business.name!),
                      subtitle: Text(business.businessUrl ?? ''),
                      leading: avatarBuilder(business, _circleColor),
                      trailing: const Icon(
                        Ionicons.ellipsis_horizontal,
                      ),
                      onTap: () {
                        showCupertinoModalPopup(
                          barrierColor: Colors.black.withOpacity(0.5),
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 0.9, sigmaY: 0.9),
                                  child: Material(
                                    // color: Colors.transparent,
                                    child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      color: Colors.white.withOpacity(0.8),
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.symmetric(
                                          //       vertical: 12),
                                          //   child: Text(
                                          //     'Invite members',
                                          //     style:
                                          //         Helpers.txtDefault.copyWith(
                                          //       fontSize: 18,
                                          //       fontWeight: FontWeight.bold,
                                          //     ),
                                          //   ),
                                          // ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 40.0),
                                                child: InkWell(
                                                  onTap: () async {
                                                    await ProxyService.isar
                                                        .logOut();
                                                    _routerService.navigateTo(
                                                        StartUpViewRoute());
                                                  },
                                                  child:
                                                      const BoxButton.outline(
                                                    onTap: null,
                                                    borderRadius: 2,
                                                    title: 'Log out',
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                  .toList(),
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: 20.0,
            right: 0.0,
            child: Column(
              children: [
                if (ProxyService.remoteConfig.isAInvitingMembersAvailable())
                  ListTile(
                    contentPadding:
                        const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                    title: const Text('Invite members'),
                    leading: const Icon(Icons.add),
                    onTap: () {
                      widget.inviteController();
                    },
                  ),
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                  title: const Text('Preferences'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    widget.preferenceController();
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                  title: const Text('help'),
                  leading: const Icon(
                    Icons.help,
                  ),
                  onTap: () async {
                    _routerService.navigateTo(InAppBrowserRoute());
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
