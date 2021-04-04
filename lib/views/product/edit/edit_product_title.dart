import 'package:customappbar/customappbar.dart';
import 'package:flipper_models/pcolor.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/views/product/edit/edit_product_viewmodel.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

// testing.
class EditItemTitle extends StatelessWidget {
  EditItemTitle({Key key}) : super(key: key);
  final Logger log = Logging.getLogger('Add Product:');

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProductViewModel>.reactive(
        builder:
            (BuildContext context, EditProductViewModel model, Widget child) {
          if (model.colors.isEmpty)
            return const SizedBox
                .shrink(); //a nice place to show loading screen.
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Edit product Tile',
              icon: Icons.keyboard_backspace,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: ListView(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 80,
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(splashColor: Colors.transparent),
                                child: model.product.picture == null
                                    ? TextField(
                                        maxLines: 4,
                                        autofocus: false,
                                        style: const TextStyle(
                                            fontSize: 22.0,
                                            color: Color(0xFFbdc6cf)),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: HexColor(
                                              model.currentColor == null
                                                  ? '#0984e3'
                                                  : model.currentColor.name),
                                          focusedBorder:
                                              const OutlineInputBorder(
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
                                    : Image.network(
                                        model.product.picture,
                                        frameBuilder: (BuildContext context,
                                            Widget child,
                                            int frame,
                                            bool wasSynchronouslyLoaded) {
                                          if (wasSynchronouslyLoaded) {
                                            return child;
                                          }
                                          return AnimatedOpacity(
                                            child: child,
                                            opacity: frame == null ? 0 : 1,
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.easeOut,
                                          );
                                        },
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(28.0, 0, 0, 28.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('CHOOSE LABEL COLOR'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 0, 0, 32.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      children: buildStack(context, model.colors, model),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(28.0, 0, 0, 28.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('PHOTO LABEL'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                          width: 180,
                          child: OutlineButton(
                            color: HexColor('#ecf0f1'),
                            child: const Text('Choose Photo'),
                            onPressed: () async {
                              model.browsePictureFromGallery(context: context);
                            },
                          ),
                        ),
                        Container(
                          width: 10,
                        ),
                        SizedBox(
                          height: 50,
                          width: 180,
                          child: OutlineButton(
                            color: HexColor('#ecf0f1'),
                            child: const Text('Take Photo'),
                            onPressed: () {
                              model.takePicture(context: context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        onModelReady: (EditProductViewModel model) {
          model.observeColors();
        },
        viewModelBuilder: () => EditProductViewModel());
  }

  List<Widget> buildStack(
      BuildContext context, List<PColor> colors, EditProductViewModel model) {
    final List<Widget> stacks = <Widget>[];

    if (colors.isNotEmpty) {
      for (var i = 0; i < 8; i++) {
        stacks.add(
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 80,
                width: 120,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: HexColor(colors[i].name),
                    ),
                  ),
                  color: HexColor(colors[i].name),
                  child: null,
                  onPressed: () {
                    //reset all other color to not selected
                    model.switchColor(color: colors[i], context: context);
                  },
                ),
              ),
              // FIXME: add checkmark on active color is not working propper.
              colors[i].isActive
                  ? IconButton(
                      alignment: Alignment.center,
                      icon: const Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () {
                        model.switchColor(color: colors[i], context: context);
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
