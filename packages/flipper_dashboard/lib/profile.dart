import 'dart:developer';

import 'package:flipper_dashboard/letter.dart';
import 'package:flipper_dashboard/progress.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';

/// when the user upload image
/// we also update the business with the new image
/// and current tenant logged in which in most cases is the same as
/// the user logged in
class ProfileWidget extends StatefulWidget {
  const ProfileWidget({
    super.key,
    required this.tenant,
    this.showIcon = true,
    this.size = 50,
  });
  final ITenant tenant;
  final double? size;
  final bool showIcon;
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
    return ViewModelBuilder<UploadViewModel>.reactive(
        viewModelBuilder: () => UploadViewModel(),
        builder: (context, model, child) {
          return Stack(
            children: [
              !isDesktopOrWeb
                  ? PMobile(widget: widget, dialogService: _dialogService)
                  : PDesktop(
                      widget: widget,
                      dialogService: _dialogService,
                      routeService: _routerService),
              !isDesktopOrWeb
                  ? Positioned(
                      bottom: 0,
                      right: -10,
                      child: Visibility(
                        visible: widget.showIcon,
                        child: IconButton(
                          icon: Icon(Icons.camera),
                          color: Colors.red,
                          iconSize: 40,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.white,
                                duration: Duration(hours: 1),
                                content: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(8.0),
                                  child: UploadProgressWidget(
                                    progressStream: model.uploadProgress(),
                                  ),
                                ),
                              ),
                            );
                            model.uploadProgress().listen((progress) {
                              if (progress == 100) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              }
                            });
                            model.browsePictureFromGallery(
                              urlType: URLTYPE.BUSINESS,
                              callBack: (res) async {
                                if (res == "500") return;
                              },
                              id: widget.tenant.businessId,
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox.shrink()
            ],
          );
        });
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
    return StreamBuilder<Business>(
      stream: ProxyService.isar
          .businessStream(businessId: widget.tenant.businessId),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final hasImage = data?.imageUrl != null;

        Widget buildContent() {
          return PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logOut') {
                log('logout selected');
                await ProxyService.isar.logOut();
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
            ],
            child: hasImage
                ? SizedBox(
                    width: isDesktopOrWeb ? 50 : 100,
                    height: isDesktopOrWeb ? 50 : 100,
                    child: Container(
                      width: isDesktopOrWeb ? 50 : 100,
                      height: isDesktopOrWeb ? 50 : 100,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(
                          color: Colors.pink,
                          width: 2.0,
                        ),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: data!.imageUrl!,
                          placeholder: (context, url) => GmailLikeLetter(
                            tenant: widget.tenant,
                            size: widget.size,
                          ),
                          errorWidget: (context, url, error) => GmailLikeLetter(
                            tenant: widget.tenant,
                            size: widget.size,
                          ),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : GmailLikeLetter(
                    tenant: widget.tenant,
                    size: widget.size,
                  ),
          );
        }

        return buildContent();
      },
    );
  }
}

class PMobile extends StatelessWidget {
  const PMobile({
    super.key,
    required this.widget,
    required DialogService dialogService,
  }) : _dialogService = dialogService;

  final DialogService _dialogService;
  final ProfileWidget widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Business>(
      stream: ProxyService.isar
          .businessStream(businessId: widget.tenant.businessId),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final hasImage = data?.imageUrl != null;

        Widget buildContent() {
          final borderRadius = BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(10),
          );

          return GestureDetector(
            onTap: () {
              _dialogService.showCustomDialog(
                  variant: DialogType.logOut, title: 'Log out');
            },
            child: hasImage
                ? SizedBox(
                    width: isDesktopOrWeb ? 50 : 100,
                    height: isDesktopOrWeb ? 50 : 100,
                    child: Container(
                      width: isDesktopOrWeb ? 50 : 100,
                      height: isDesktopOrWeb ? 50 : 100,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the border radius value to your desired amount
                        border: Border.all(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            borderRadius, // Same border radius value as above
                        child: CachedNetworkImage(
                          imageUrl: data!.imageUrl!,
                          placeholder: (context, url) => GmailLikeLetter(
                            tenant: widget.tenant,
                            size: widget.size,
                          ),
                          errorWidget: (context, url, error) => GmailLikeLetter(
                            tenant: widget.tenant,
                            size: widget.size,
                          ),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : GmailLikeLetter(
                    tenant: widget.tenant,
                    size: widget.size,
                  ),
          );
        }

        return buildContent();
      },
    );
  }
}
