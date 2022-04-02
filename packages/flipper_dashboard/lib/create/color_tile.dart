import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_rw/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:stacked/stacked.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'list_divider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:go_router/go_router.dart';
import 'package:google_ui/google_ui.dart';

class ColorTile extends StatelessWidget {
  const ColorTile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              GoRouter.of(context).pop();
            },
            title: 'Edit product Tile',
            icon: Icons.keyboard_backspace,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(splashColor: Colors.transparent),
                              child: model.product == null ||
                                      model.product.imageUrl == null
                                  ? TextField(
                                      maxLines: 4,
                                      autofocus: false,
                                      style: const TextStyle(
                                          fontSize: 22.0,
                                          color: Color(0xFFbdc6cf)),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: HexColor(
                                            model.currentColor ?? '#0984e3'),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: model.product.imageUrl!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                            ),
                          ),
                          const Text('New Item')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const ListDivider(
                height: 10,
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: Text('CHOOSE LABEL COLOR'),
              ),
              const ListDivider(
                height: 10,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Wrap(
                  children: colorsStack(context, model.colors, model),
                ),
              ),
              const ListDivider(
                height: 10,
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: Text('PHOTO LABEL'),
              ),
              const ListDivider(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 140,
                      child: GOutlinedButton(
                        'Choose Photo',
                        color: Colors.black,
                        onPressed: () async {
                          model.browsePictureFromGallery(
                              productId: model.product.id,
                              callBack: (int res) {
                                // show error if any
                              });
                        },
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: 140,
                      child: GOutlinedButton(
                        'Take Photo',
                        color: Colors.black,
                        onPressed: () {
                          model.takePicture(
                            productId: model.product.id,
                            callBack: (int res) {
                              if (res == 500) {
                                showSimpleNotification(
                                  const Text('Error try again'),
                                  background: Colors.red,
                                  position: NotificationPosition.bottom,
                                );
                              }
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => ProductViewModel(),
    );
  }

  List<Widget> colorsStack(
      BuildContext context, List<PColor> colors, ProductViewModel model) {
    final List<Widget> stacks = [];

    if (colors.isNotEmpty) {
      for (var i = 0; i < colors.length; i++) {
        stacks.add(
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 120,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: HexColor(colors[i].name!),
                    backgroundColor: HexColor(colors[i].name!),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: HexColor(colors[i].name!),
                      ),
                    ),
                  ),
                  child: const Text(''),
                  onPressed: () {
                    model.switchColor(color: colors[i]);
                  },
                ),
              ),
              colors[i].active
                  ? IconButton(
                      alignment: Alignment.center,
                      icon: const Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () {
                        model.switchColor(color: colors[i]);
                      },
                    )
                  : const Visibility(
                      visible: false,
                      child: SizedBox.shrink(),
                    )
            ],
          ),
        );
      }
    }
    return stacks;
  }
}
