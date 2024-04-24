import 'dart:developer';

import 'package:flipper_dashboard/letter.dart';
import 'package:flipper_dashboard/progress.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';

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
    return ViewModelBuilder<UploadViewModel>.reactive(
        viewModelBuilder: () => UploadViewModel(),
        builder: (context, model, child) {
          return Stack(
            children: [
              !isDesktopOrWeb
                  ? PMobile(
                      widget: widget,
                      dialogService: _dialogService,
                      sessionActive: widget.sessionActive)
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
                          color: Colors.white,
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
                              id: widget.branch.businessId,
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

  void showSnackBar(BuildContext context, String message,
      {required Color textColor, required Color backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 400,
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Business?>(
      future:
          ProxyService.isar.getBusiness(businessId: widget.branch.businessId),
      builder: (context, snapshot) {
        // final data = snapshot.data;
        // final hasImage = data?.imageUrl != null;

        Widget buildContent() {
          return PopupMenuButton<String>(
              color: Colors.white,
              onSelected: (value) async {
                if (value == 'logOut') {
                  log('logout selected');
                  await ProxyService.isar.logOut();
                  routeService.clearStackAndShow(LoginViewRoute());
                }
                if (value == "syncCounter") {
                  log('sync counter selected');

                  await ProxyService.realm.syncCounter();
                  showSnackBar(context, "Your counter is up to date",
                      textColor: Colors.white, backgroundColor: Colors.green);
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
              )
              // TODO: re-enable bellow coded once showing profile pic on client is fully supported
              // child: hasImage
              //     ? SizedBox(
              //         width: isDesktopOrWeb ? 50 : 100,
              //         height: isDesktopOrWeb ? 50 : 100,
              //         child: Container(
              //           width: isDesktopOrWeb ? 50 : 100,
              //           height: isDesktopOrWeb ? 50 : 100,
              //           decoration: BoxDecoration(
              //             color: Colors.pink,
              //             borderRadius: BorderRadius.circular(45),
              //             border: Border.all(
              //               color: Colors.pink,
              //               width: 2.0,
              //             ),
              //           ),
              //           child: ClipOval(
              //             child: CachedNetworkImage(
              //               imageUrl: data == null
              //                   ? 'https://yegobox-flipper.s3.eu-west-2.amazonaws.com/lRsBL.png'
              //                   : data.imageUrl == null
              //                       ? 'https://yegobox-flipper.s3.eu-west-2.amazonaws.com/lRsBL.png'
              //                       : data.imageUrl!,
              //               placeholder: (context, url) => GmailLikeLetter(
              //                 tenant: widget.tenant,
              //                 size: widget.size,
              //               ),
              //               errorWidget: (context, url, error) => GmailLikeLetter(
              //                 tenant: widget.tenant,
              //                 size: widget.size,
              //               ),
              //               width: 100,
              //               height: 100,
              //               fit: BoxFit.cover,
              //             ),
              //           ),
              //         ),
              //       )
              //     : GmailLikeLetter(
              //         tenant: widget.tenant,
              //         size: widget.size,
              //       ),
              );
        }

        return buildContent();
      },
    );
  }
}

class PMobile extends StatelessWidget {
  const PMobile(
      {super.key,
      required this.widget,
      required DialogService dialogService,
      required this.sessionActive})
      : _dialogService = dialogService;

  final DialogService _dialogService;
  final ProfileWidget widget;
  final bool sessionActive;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Business?>(
      future:
          ProxyService.isar.getBusiness(businessId: widget.branch.businessId),
      builder: (context, snapshot) {
        final data = snapshot.data;
        // ignore: unused_local_variable
        final hasImage = data?.imageUrl != null;
        Widget buildContent() {
          // ignore: unused_local_variable
          final borderRadius = BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          );

          return GestureDetector(
            onTap: () {
              _dialogService.showCustomDialog(
                  variant: DialogType.logOut, title: 'Log out');
            },
            //TODO: remove negation from !hasImage if profile image is fully supported
            // removed if from showing it because it need more work to follow ContinuousRectangleBorder specs
            child: GmailLikeLetter(
              key: Key(widget.branch.id.toString()),
              branch: widget.branch,
              sessionActive: sessionActive,
              size: widget.size,
            ),
            // child: !hasImage
            //     ? SizedBox(
            //         width: isDesktopOrWeb ? 50 : 100,
            //         height: isDesktopOrWeb ? 50 : 100,
            //         child: Container(
            //           width: isDesktopOrWeb ? 50 : 100,
            //           height: isDesktopOrWeb ? 50 : 100,
            //           decoration: ShapeDecoration(
            //               shape: ContinuousRectangleBorder(
            //                   side: BorderSide(width: 1, color: Colors.white),
            //                   borderRadius: BorderRadius.circular(80.0)),
            //               color: Colors.amberAccent,
            //               shadows: []),
            //           child: ClipRRect(
            //             borderRadius:
            //                 borderRadius, // Same border radius value as above
            //             child: CachedNetworkImage(
            //               imageUrl: data == null
            //                   ? 'https://yegobox-flipper.s3.eu-west-2.amazonaws.com/lRsBL.png'
            //                   : data.imageUrl == null
            //                       ? 'https://yegobox-flipper.s3.eu-west-2.amazonaws.com/lRsBL.png'
            //                       : data.imageUrl!,
            //               placeholder: (context, url) => GmailLikeLetter(
            //                 tenant: widget.tenant,
            //                 size: widget.size,
            //               ),
            //               errorWidget: (context, url, error) => GmailLikeLetter(
            //                 tenant: widget.tenant,
            //                 size: widget.size,
            //               ),
            //               width: 100,
            //               height: 100,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
            //       )
            //     : GmailLikeLetter(
            //         tenant: widget.tenant,
            //         size: widget.size,
            //       ),
          );
        }

        return buildContent();
      },
    );
  }
}
