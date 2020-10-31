import 'dart:io';

import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/flipper_color.dart';
import 'package:flipper/model/image.dart';
import 'package:flipper/model/pcolor.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/tax.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/model/variation.dart';
import 'package:couchbase_lite/couchbase_lite.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/ui/product/product_viewmodel.dart';
import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/utils/upload_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddProductViewmodel extends ProductViewModel {
  Category _category;
  String _colorName;
  final List<PColor> _colors = <PColor>[];
  PColor _currentColor;
  // ignore: unused_field
  final DatabaseService _databaseService = ProxyService.database;

  TextEditingController _description;
  Unit _focusedUnit;
  // handle color and upload of image of product
  ImageP _image;

  bool _isLocked = true;
  TextEditingController _nameController;
  Product _product;
  String _productId;
  TextEditingController _retailPriceController;
  TextEditingController _supplierPriceController;
  final List<Unit> _units = <Unit>[];

  @override
  // ignore: overridden_fields
  final Logger log = Logging.getLogger('add product view model:)');

  // ActionsTableData get actions;

  String get productId {
    return _productId;
  }

  bool get isLocked {
    return _isLocked;
  }

  TextEditingController get supplierPriceController {
    return _supplierPriceController;
  }

  TextEditingController get description {
    return _description;
  }

  TextEditingController get retailPriceController {
    return _retailPriceController;
  }

  Future<bool> onWillPop({BuildContext context}) async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'Do you want to exit',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {},
                child: const Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  onClose(context);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  // ignore: always_declare_return_types
  onClose(BuildContext context) async {
    ProxyService.nav.pop();
  }

  Category get category{
    return _category;
  }

  Future<void> handleCreateItem() async {
    log.d(_productId);
    await updateProduct(
      productId: _productId, //productId
      categoryId: category == null ? '10' : category.id,
    );

    final List<Map<String, dynamic>> variations = await _databaseService.filter(
      equator: AppTables.variation,
      property: 'table',
      and: true, //define that this query is and type.
      andEquator: _productId,
      andProperty: 'productId',
    );

    final Document variation = await _databaseService.getById(
        id: Variation.fromMap(variations[0]['main']).id);

    await updateVariation(
      variation: Variation.fromMap(variation.toMap()),
      supplyPrice: double.parse(supplierPriceController.text),
      variantName: 'Regular',
      retailPrice: double.parse(retailPriceController.text),
    );

    _nameController.text = ''; //this will reset button to disabled

    notifyListeners();
  }

  Future<void> updateVariation({
    Variation variation,
    double retailPrice,
    double supplyPrice,
    String variantName,
  }) async {
    if (variation != null) {
      final Document stock = await _databaseService.getById(id: variation.id);

      final Document variant = await _databaseService.getById(id: variation.id);

      variant.toMutable().setString('name', variantName);
      _databaseService.update(document: variant.toMutable());

      stock
          .toMutable()
          .setDouble('retailPrice', retailPrice)
          .setDouble('supplyPrice', supplyPrice);
      _databaseService.update(document: stock.toMutable());
    }
  }

  Future<bool> updateProduct(
      {CommonViewModel vm, String productId, String categoryId}) async {
    log.i('new name for product:' + nameController.text);
    log.i('categoryId for product:' + categoryId);

    final Document product = await _databaseService.getById(id: productId);
    product
        .toMutable()
        .setString('name', nameController.text)
        .setString('categoryId', categoryId)
        .setString('updatedAt', DateTime.now().toIso8601String());

    _databaseService.update(document: product.toMutable());
    return true;
  }

  void createVariant({String productId}) {
    _isLocked = true;
    notifyListeners();

    ProxyService.nav.navigateTo(Routing.addVariationScreen,
        arguments: AddVariationScreenArguments(productId: productId));
  }

  TextEditingController get nameController {
    return _nameController;
  }

  void lock() {
    // ignore: prefer_is_empty
    log.i(_nameController.text.length);
    _nameController.text.isEmpty ? _isLocked = true : _isLocked = false;
    notifyListeners();
  }

  void initFields(TextEditingController name, TextEditingController supplier,
      TextEditingController retail, TextEditingController description) {
    _nameController = name;
    _supplierPriceController = supplier;
    _retailPriceController = retail;
    _description = description;
  }

  Product get product {
    return _product;
  }

  // once full refacored
  // ignore: always_specify_types
  Future getTemporalProduct({BuildContext context, CommonViewModel vm}) async {
    setBusy(true);

    final List<Map<String, dynamic>> products = await _databaseService.filter(
      equator: 'tmp',
      property: 'name',
      and: true,
      andProperty: 'table',
      andEquator: AppTables.product,
    );
    if (products.isNotEmpty) {
      final Product product = Product.fromMap(products[0]['main']);
      // StoreProvider.of<AppState>(context).dispatch(action);
      _productId = product.id;
      _product = product;
    }
    setBusy(false);
    notifyListeners();
    return productId;
  }

  void navigateAddProduct() {
    final FlipperNavigationService _navigationService = ProxyService.nav;
    _navigationService.navigateTo(Routing.addProduct);
  }

  // this is a product to edit later on and add variation on it.
  Future createTemporalProduct({String productName, String userId}) async {
    final Logger log = Logging.getLogger('Data manager   Model ....');

    final DatabaseService _databaseService = ProxyService.database;

    final category = await _databaseService.filter(
      equator: AppTables.category,
      property: 'table',
      and: true,
      andEquator: 'custom',
      andProperty: 'name',
    );

    final List<Map<String, dynamic>> product = await _databaseService.filter(
      equator: productName,
      property: 'name',
      and: true,
      andProperty: 'table',
      andEquator: AppTables.product,
    );

    final List<Map<String, dynamic>> gettax = await _databaseService.filter(
      equator: AppTables.tax,
      property: 'table',
      and: true,
      andEquator: 'Vat',
      andProperty: 'name',
    );
    log.d('categoryId:' + Category.fromMap(category[0]['main']).id);
    log.d('taxId:' + Tax.fromMap(gettax[0]['main']).id);

    if (product.isEmpty) {
      final Document productDoc = await _databaseService.insert(data: {
        'name': productName,
        'categoryId': Category.fromMap(category[0]['main']).id,
        'color': '#955be9',
        'id': Uuid().v1(),
        'active': true,
        'hasPicture': false,
        'channels': <String>[userId],
        'table': AppTables.product,
        'isCurrentUpdate': false,
        'isDraft': true,
        'taxId': Tax.fromMap(gettax[0]['main']).id,
        'businessId': businessId,
        'description': productName,
        'createdAt': DateTime.now().toIso8601String(),
      });

      final Document variant = await _databaseService.insert(data: {
        'isActive': false,
        'name': 'Regular',
        'unit': 'kg',
        'channels': <String>[userId],
        'table': AppTables.variation,
        'productId': productDoc.id,
        'sku': Uuid().v1().substring(0, 4),
        'id': Uuid().v1(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      await _databaseService.insert(data: {
        'variantId': variant.id,
        'supplyPrice': 0,
        'canTrackingStock': false,
        'showLowStockAlert': false,
        'retailPrice': 0,
        'channels': [userId],
        'isActive': true,
        'table': AppTables.stock,
        'lowStock': 0,
        'currentStock': 0,
        'id': Uuid().v1(),
        'productId': productDoc.id,
        'branchId': branchId,
        'createdAt': DateTime.now().toIso8601String(),
      });

      await _databaseService.insert(data: {
        'branchId': branchId,
        'productId': productDoc.id,
        'table': AppTables.branchProduct,
        'id': Uuid().v1()
      });

      return productDoc.id;
    } else {
      final Product pro = Product.fromMap(product[0]['main']);
      return pro.id;
    }
  }

  ImageP get image {
    return _image;
  }

  PColor get currentColor {
    return _currentColor;
  }

  Future takePicture({BuildContext context}) async {
    final File image = await ImagePicker.pickImage(source: ImageSource.camera);

    await handleImage(image, context);
  }

  Future browsePictureFromGallery({BuildContext context}) async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    await handleImage(image, context);
  }

  Future<File> compress(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minHeight: 80,
      minWidth: 80,
      quality: 95,
      rotate: 0,
    );

    return result;
  }

  Future<bool> isInternetAvailable() async {
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<void> upload(
      {String storagePath,
      String fileName,
      Store<AppState> store,
      String productId}) async {
    final FlutterUploader uploader = FlutterUploader();

    await uploader.enqueue(
        url: 'https://test.flipper.rw/api/upload',
        // ignore: always_specify_types
        files: [
          FileItem(
              filename: fileName, savedDir: storagePath, fieldname: 'image')
        ], // required: list of files that you want to upload
        method: UploadMethod.POST,
        // ignore: always_specify_types
        headers: {'Authorization': 'Bearer  ' + store.state.user.token},
        // ignore: always_specify_types
        data: {'product_id': productId},
        showNotification:
            true, // send local notification (android only) for upload status
        tag: 'Backup products images...'); // unique tag for upload task

    uploader.progress.listen((UploadTaskProgress progress) {
      //... code to handle progress
      print('uploadProgress:' + progress.toString());
    });
    uploader.result.listen((UploadTaskResponse result) async {
      final UploadResponse uploadResponse =
          uploadResponseFromJson(result.response);
      // final ProductTableData product = await store.state.database.productDao
      //     .getItemById(productId: uploadResponse.productId);
      final DatabaseService _databaseService = ProxyService.database;
      final Document productDoc =
          await _databaseService.getById(id: uploadResponse.productId);

      final Product product = Product.fromMap(productDoc.toMap());

      // TODO(richard): update url here
      // await store.state.database.productDao.updateProduct(
      //     pro.copyWith(picture: uploadResponse.url, isImageLocal: false));

      // List<ProductImageTableData> p = await store.state.database.productImageDao
      //     .getByid(productId: productId);
      // for (var i = 0; i < p.length; i++) {
      //   store.state.database.productImageDao.deleteImageProduct(p[i]);
      // }
      _product = product;
      // ignore: always_specify_types
    }, onError: (ex, stacktrace) {
      print('error' + stacktrace.toString());
    });
  }

  String get colorName {
    return _colorName;
  }

  void switchColor({PColor color}) async {
    //reset all other color to not selected
    setBusy(true);
    for (var y = 0; y < colors.length; y++) {
      //set all other color to active false then set one to active.
      final Document color = await _databaseService.getById(id: colors[y].id);

      _databaseService.update(document: color.toMutable().setBoolean('isActive', false));
    }
    final Document colordoc = await _databaseService.getById(id: color.id);


    _databaseService.update(document: colordoc.toMutable().setBoolean('isActive', true));

    _currentColor = color;

    setBusy(false);

    notifyListeners();
  }

  Future handleImage(File image, BuildContext context) async {
    if (image != null) {
      final store = StoreProvider.of<AppState>(context);

      final String targetPath = (await getTemporaryDirectory()).path +
          '/' +
          DateTime.now().toIso8601String() +
          '.jpg';

      final File compresedFile = await compress(image, targetPath);

      final String fileName = compresedFile.path.split('/').removeLast();
      final String storagePath =
          compresedFile.path.replaceAll('/' + fileName, '');

      // FIXME(richard): fix bellow code
      // ProductTableData product = await store.state.database.productDao
      //     .getItemById(productId: widget.productId);

      // store.state.database.productDao.updateProduct(product.copyWith(
      //     picture: compresedFile.path, isImageLocal: true, hasPicture: true));

      // ProductTableData productUpdated = await store.state.database.productDao
      //     .getItemById(productId: widget.productId);
      final Document productUpdated =
          await _databaseService.getById(id: productId);

      _product = Product.fromMap(productUpdated.toMap());

      store.dispatch(
        ImagePreview(
          image: ImageP(
            (ImagePBuilder img) => img
              ..path = compresedFile.path
              ..isLocal = true,
          ),
        ),
      );
      // FIXME(richard): fix bellow code
      // store.state.database.productImageDao.insertImageProduct(
      //   //ignore: missing_required_param
      //   ProductImageTableData(
      //     localPath: compresedFile.path,
      //     productId: widget.productId,
      //   ),
      // );

      final bool internetAvailable = await isInternetAvailable();
      if (internetAvailable) {
        upload(
            store: store,
            fileName: fileName,
            productId: productId,
            storagePath: storagePath);
      }
    }
  }

  List<PColor> get colors => _colors;

  void observeColors() {
    setBusy(true);

    _databaseService
        .observer(equator: AppTables.color, property: 'table')
        .stream
        .listen((ResultSet event) {
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();

      // remove unnecessarry nesting "main"appended on each map value
      for (Map<String, dynamic> map in model) {
        map.forEach((String key, value) {
          //log.i(value);
          _colors.add(PColor.fromMap(value));
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }

  List<Unit> get units => _units;

  void loadUnits() {
    setBusy(true);

    _databaseService
        .observer(equator: AppTables.unit, property: 'table')
        .stream
        .listen((ResultSet event) {
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();

      // remove unnecessarry nesting "main"appended on each map value
      for (Map<String, dynamic> map in model) {
        map.forEach((String key, value) {
          log.i(value);
          _units.add(Unit.fromMap(value));
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }

  void updateProductWithCurrentUnit({Unit unit}) async { //NOTE: we update product variation not actual product as the unit is associated with variation.
    final List<Map<String, dynamic>> variants = await _databaseService.filter(
      and: true,
      property: 'table',
      equator: AppTables.variation,
      andProperty: 'productId',
      andEquator: product.id,
    );
    for (var i = 0; i < variants.length; i++) {
      final Variation variation = Variation.fromMap(variants[i]);
      final Document variationDocument =
          await _databaseService.getById(id: variation.id);
      variationDocument.toMutable().setString('unit', unit.name);
      _databaseService.update(document: variationDocument);
    }
  }

  Unit get focusedUnit {
    return _focusedUnit;
  }

  void saveFocusedUnit({Unit unit}) async {
    // reset other focused if any!
    for (Unit unit in units) {
      final Document unitDoc = await _databaseService.getById(id: unit.id);
      if (unit.focused) {
        unitDoc.toMutable().setBoolean('focused', false);
        _databaseService.update(document: unitDoc);
      }
    }
    _focusedUnit = unit;
    final Document unitDoc = await _databaseService.getById(id: unit.id);
    unitDoc.toMutable().setBoolean('focused', false);
    _databaseService.update(document: unitDoc);
    notifyListeners();
  }
}
