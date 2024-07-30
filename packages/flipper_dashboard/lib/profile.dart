import 'dart:developer';

import 'package:flipper_dashboard/letter.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

/// when the user upload image
/// we also update the business with the new image
/// and current tenant logged in which in most cases is the same as
/// the user logged in

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({
    super.key,
    required this.branch,
    required this.sessionActive,
    this.showIcon = true,
    this.size = 50,
  });
  final Branch branch;
  final double? size;
  final bool showIcon;
  final bool sessionActive;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _dialogService = locator<DialogService>();
  final _routerService = locator<RouterService>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Desktop/Web View
        if (isDesktopOrWeb)
          PDesktop(
            widget: widget,
            dialogService: _dialogService,
            routeService: _routerService,
          )
        else
          // Mobile View
          PMobile(
            widget: widget,
            dialogService: _dialogService,
            sessionActive: widget.sessionActive,
          ),

        // Add Camera Icon (Only for Mobile)
        if (!isDesktopOrWeb && widget.showIcon)
          Positioned(
            bottom: 0,
            right: -10,
            child: IconButton(
              icon: const Icon(Icons.camera),
              color: Colors.white,
              iconSize: 40,
              onPressed: () {
                // Your upload logic here...
                // Example using a ViewModel
                // ViewModelBuilder<UploadViewModel>.reactive(
                //   viewModelBuilder: () => UploadViewModel(),
                //   builder: (context, model, child) {
                //     // ...
                //     model.browsePictureFromGallery(
                //       urlType: URLTYPE.BUSINESS,
                //       callBack: (res) async {
                //         if (res == "500") return;
                //       },
                //       id: widget.branch.businessId,
                //     );
                //   },
                // );
              },
            ),
          )
      ],
    );
  }
}

class PDesktop extends StatelessWidget {
  const PDesktop({
    Key? key,
    required this.widget,
    required this.dialogService,
    required this.routeService,
  });

  final DialogService dialogService;
  final RouterService routeService;
  final ProfileWidget widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Business?>(
      future: ProxyService.local
          .getBusinessFuture(businessId: widget.branch.businessId),
      builder: (context, snapshot) {
        return PopupMenuButton<String>(
          color: Colors.white,
          onSelected: (value) async {
            if (value == 'logOut') {
              log('logout selected');
              await ProxyService.realm.logOut();
              routeService.clearStackAndShow(LoginViewRoute());
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'logOut',
              child: Text(
                'Log out',
                style: primaryTextStyle,
              ),
            ),
            PopupMenuItem<String>(
              value: 'syncCounter',
              child: Text(
                'Sync counter',
                style: primaryTextStyle,
              ),
            ),
          ],
          child: GmailLikeLetter(
            key: Key(widget.branch.id.toString()),
            branch: widget.branch,
            size: widget.size,
            sessionActive: widget.sessionActive,
          ),
        );
      },
    );
  }
}

class PMobile extends StatelessWidget {
  const PMobile({
    super.key,
    required this.widget,
    required this.dialogService,
    required this.sessionActive,
  });

  final DialogService dialogService;
  final ProfileWidget widget;
  final bool sessionActive;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Business?>(
      future: ProxyService.local
          .getBusinessFuture(businessId: widget.branch.businessId),
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            dialogService.showCustomDialog(
                variant: DialogType.logOut, title: 'Log out');
          },
          child: GmailLikeLetter(
            key: Key(widget.branch.id.toString()),
            branch: widget.branch,
            size: widget.size,
            sessionActive: sessionActive,
          ),
        );
      },
    );
  }
}
