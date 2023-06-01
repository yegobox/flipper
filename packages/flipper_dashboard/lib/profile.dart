import 'package:flipper_dashboard/letter.dart';
import 'package:flipper_dashboard/progress.dart';
import 'package:flipper_models/isar_models.dart';
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
  const ProfileWidget({super.key, required this.tenant, this.size = 50});
  final ITenant tenant;
  final double? size;
  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _dialogService = locator<DialogService>();
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
              StreamBuilder<Business>(
                  stream: ProxyService.isar
                      .businessStream(businessId: widget.tenant.businessId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      if (data!.imageUrl == null) {
                        return GestureDetector(
                          onTap: () {
                            _dialogService.showCustomDialog(
                                variant: DialogType.logOut, title: 'Log out');
                          },
                          child: GmailLikeLetter(
                            tenant: widget.tenant,
                            size: widget.size,
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            _dialogService.showCustomDialog(
                                variant: DialogType.logOut, title: 'Log out');
                          },
                          child: SizedBox(
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
                                  imageUrl: data.imageUrl!,
                                  placeholder: (context, url) =>
                                      GmailLikeLetter(
                                    tenant: widget.tenant,
                                    size: widget.size,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      GmailLikeLetter(
                                    tenant: widget.tenant,
                                    size: widget.size,
                                  ),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    return GestureDetector(
                      onTap: () {
                        _dialogService.showCustomDialog(
                            variant: DialogType.logOut, title: 'Log out');
                      },
                      child: GmailLikeLetter(
                        tenant: widget.tenant,
                        size: widget.size,
                      ),
                    );
                  }),
              !isDesktopOrWeb
                  ? Positioned(
                      bottom: 0,
                      right: -10,
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
                                    progressStream: model.uploadProgress()),
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
                              id: widget.tenant.businessId);
                        },
                      ),
                    )
                  : SizedBox.shrink()
            ],
          );
        });
  }
}
