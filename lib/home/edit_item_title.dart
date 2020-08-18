import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/flipper_color.dart';
import 'package:flipper/model/image.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EditItemTitle extends StatefulWidget {
  EditItemTitle({Key key, this.productId}) : super(key: key);
  final String productId;

  @override
  _EditItemTitleState createState() => _EditItemTitleState();
}

class _EditItemTitleState extends State<EditItemTitle> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Routing.navigator.pop();
            },
            title: 'Edit item Tile',
            icon: Icons.keyboard_backspace,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: Wrap(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(
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
                              child: vm.image == null
                                  ? TextField(
                                      maxLines: 4,
                                      autofocus: false,
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          color: Color(0xFFbdc6cf)),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: HexColor(
                                            vm.currentColor == null
                                                ? '#0984e3'
                                                : vm.currentColor.hexCode),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : vm.image.isLocal
                                      ? Image.file(
                                          File(vm.image.path),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fitWidth,
                                        )
                                      : Image.network(
                                          vm.image.path,
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
                          Text('New Item')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 0, 0, 28.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('CHOOSE LABEL COLOR'),
                ),
              ),
              StreamBuilder(
                stream: vm.database.colorDao.getColors(),
                builder:
                    (context, AsyncSnapshot<List<ColorTableData>> snapshot) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 0, 0, 32.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        children: buildStack(context, snapshot.data, vm),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 0, 0, 28.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('PHOTO LABEL'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 0, 0, 28.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 180,
                        child: OutlineButton(
                          color: HexColor('#ecf0f1'),
                          child: Text('Choose Photo'),
                          onPressed: () async {
                            File image = await ImagePicker.pickImage(
                                source: ImageSource.gallery);

                            await handleImage(image, context);
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
                          child: Text('Take Photo'),
                          onPressed: () async {
                            File image = await ImagePicker.pickImage(
                                source: ImageSource.camera);

                            await handleImage(image, context);
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
    );
  }

  Future handleImage(File image, BuildContext context) async {
    if (image != null) {
      final store = StoreProvider.of<AppState>(context);

      String targetPath = (await getTemporaryDirectory()).path +
          '/' +
          DateTime.now().toIso8601String() +
          '.jpg';

      File compresedFile = await compress(image, targetPath);

      String fileName = compresedFile.path.split('/').removeLast();
      String storagePath = compresedFile.path.replaceAll('/' + fileName, '');

      ProductTableData product = await store.state.database.productDao
          .getItemById(productId: widget.productId);

      store.state.database.productDao.updateProduct(product.copyWith(
          picture: compresedFile.path, isImageLocal: true, hasPicture: true));

      ProductTableData productUpdated = await store.state.database.productDao
          .getItemById(productId: widget.productId);

      DataManager.dispatchProduct(store, productUpdated);

      store.dispatch(ImagePreview(
          image: ImageP((img) => img
            ..path = compresedFile.path
            ..isLocal = true)));

      store.state.database.productImageDao.insertImageProduct(
        //ignore: missing_required_param
        ProductImageTableData(
          localPath: compresedFile.path,
          productId: widget.productId,
        ),
      );

      bool internetAvailable = await DataManager.isInternetAvailable();
      if (internetAvailable) {
        DataManager.startUploading(
            store: store,
            fileName: fileName,
            productId: widget.productId,
            storagePath: storagePath);
      }
    }
  }

  List<Widget> buildStack(
      BuildContext context, List<ColorTableData> colors, CommonViewModel vm) {
    List<Widget> stacks = new List<Widget>();
    if (colors != null) {
      for (var i = 0; i < colors.length; i++) {
        //register a store for each and handle them later.
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
                    for (var y = 0; y < colors.length; y++) {
                      vm.database.colorDao
                          .updateColor(colors[y].copyWith(isActive: false));
                    }
                    vm.database.colorDao.updateColor(
                        colors[i].copyWith(isActive: !colors[i].isActive));
                    StoreProvider.of<AppState>(context).dispatch(
                      CurrentColor(
                        color: FlipperColor((c) => c..hexCode = colors[i].name),
                      ),
                    );
                  },
                ),
              ),
              colors[i].isActive
                  ? IconButton(
                      alignment: Alignment.center,
                      icon: Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () {
                        //reset all other color to not selected
                        for (var y = 0; y < colors.length; y++) {
                          vm.database.colorDao
                              .updateColor(colors[y].copyWith(isActive: false));
                        }
                        vm.database.colorDao.updateColor(
                            colors[i].copyWith(isActive: !colors[i].isActive));
                        StoreProvider.of<AppState>(context).dispatch(
                          CurrentColor(
                            color: FlipperColor(
                                (c) => c..hexCode = colors[i].name),
                          ),
                        );
                      },
                    )
                  : Visibility(
                      visible: false,
                      child: Text(''),
                    )
            ],
          ),
        );
      }
    }

    return stacks;
  }

  Future<File> compress(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minHeight: 80,
      minWidth: 80,
      quality: 95,
      rotate: 0,
    );

    return result;
  }
}
