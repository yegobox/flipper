import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_ui/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'list_divider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:go_router/go_router.dart';

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
            title: 'Edit product Tiles',
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
                                        fillColor:
                                            HexColor(model.app.currentColor),
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
                          Text('New Item',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const ListDivider(
                height: 10,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Text('CHOOSE LABEL COLOR',
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.w600)),
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
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'PHOTO LABEL',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                ),
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
                      height: 64,
                      width: 180,
                      child: OutlinedButton(
                        child: Text('Choose Photo',
                            style: GoogleFonts.poppins(
                                color: Color(0xff006AFE),
                                fontSize: 19,
                                fontWeight: FontWeight.w600)),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.grey.withOpacity(0.04);
                              }
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return Colors.grey.withOpacity(0.12);
                              }
                              return null;
                            },
                          ),
                        ),
                        onPressed: () async {
                          model.browsePictureFromGallery(
                              productId: model.product.id!!,
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
                      height: 64,
                      width: 180,
                      child: OutlinedButton(
                        child: Text('Take Photo',
                            style: GoogleFonts.poppins(
                                color: Color(0xff006AFE),
                                fontSize: 19,
                                fontWeight: FontWeight.w600)),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.grey.withOpacity(0.04);
                              }
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return Colors.grey.withOpacity(0.12);
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          model.takePicture(
                            productId: model.product.id!!,
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
                    foregroundColor: HexColor(colors[i].name!),
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
