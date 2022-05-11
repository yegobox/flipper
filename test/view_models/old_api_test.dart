// // Generate a MockClient using the Mockito package.
// // Create new instances of this class in each test.
// final Business businessMockData = new Business(
//   id: 1,
//   name: 'name',
//   latitude: '1',
//   longitude: '2',
//   channels: [''],
//   table: '',
//   country: '',
//   type: '',
// );
// StartUpViewModel _getModel() => StartUpViewModel();
// @GenerateMocks([Api])
// void main() {
//   group('Start#2', () {
//     setUp(() {
//       registerServices();
//     });
//     tearDown(() => unregisterServices());
//     test('when logged in but not synced should take you to signup', () async {
//       List<Business> c = [];
//       final api = getAndRegisterApi(businesses: c);
//       final appService = getAndRegisterAppService(hasLoggedInUser: true);
//       
//       final model = _getModel();
//       appService.isLoggedIn();
//       model.runStartupLogic();
//       await api.businesses();
//       expect(model.didSync, false);
//       verify(navigationService.navigateTo(Routes.signup));
//     });
//     test('test get draft order', () async {
//       //code here
//       HttpApi api = new HttpApi();
//       // Variation variation = await api.getCustomProductVariant();

//       // api.createOrder(customAmount: 3.0, variation: variation, price: 4.0);
//       OrderF? order = await api.pendingOrderExist();
//       if (order == null) {
//         expect(order, isA<Null>());
//       } else {
//         expect(order, isA<OrderF>());
//       }
//     });
//     test('create units', () async {
//       HttpApi api = new HttpApi();
//       int id = DateTime.now().millisecondsSinceEpoch;
//       final units = new Unit(
//         name: 'sample',
//         active: false,
//         id: id,
//         table: AppTables.unit,
//         units: mockUnits,
//         fbranchId: 11,
//         channels: ['300'],
//       );
//       final result = await api.addUnits(data: units.toJson());
//       expect(result, 201);
//       List<Unit> unitss = await api.units(branchId: 11);
//       expect(unitss, isA<List<Unit>>());
//     });
//     test('test create color', () async {
//       HttpApi api = new HttpApi();
//       // Variation variation = await api.getCustomProductVariant();
//       // api.createOrder(customAmount: 3.0, variation: variation, price: 4.0);
//       final List<String> colors = [
//         '#d63031',
//         '#0984e3',
//         '#e84393',
//         '#2d3436',
//         '#6c5ce7',
//         '#74b9ff',
//         '#ff7675',
//         '#a29bfe'
//       ];
//       int id = DateTime.now().millisecondsSinceEpoch;
//       final PColor color = new PColor(
//         id: id,
//         colors: colors,
//         table: AppTables.color,
//         channels: ['300'],
//         active: false,
//         fbranchId: 11,
//         name: 'sample',
//       );

//       final result =
//           await api.create<PColor>(data: color.toJson(), endPoint: 'color');
//       expect(result, 201);
//       List<PColor> colorsi = await api.colors(branchId: 11);
//       expect(colorsi, isA<List<PColor>>());

//       // await api.delete(id: 'id', endPoint: 'colors');
//       // List<PColor> colorsi2 = await api.colors(branchId: 'XX');

//       // expect(colorsi2.isEmpty, true);
//     });
//     test('test create a temporal product', () async {
//       HttpApi api = new HttpApi();
//       Product product = await api.createProduct(product: productMock);

//       expect(product, isA<Product>());

//       List<Variant> variants =
//           await api.variants(branchId: 11, productId: product.id!);
//       expect(variants, isA<List<Variant>>());

//       Stock stock = await api.stockByVariantId(variantId: variants[0].id);

//       expect(stock, isA<Stock>());

//       final delete = await api.delete(id: product.id!, endPoint: 'product');
//       expect(delete, isA<bool>());
//       final delete1 = await api.delete(id: variants[0].id, endPoint: 'variant');
//       expect(delete1, isA<bool>());
//       final delete2 = await api.delete(id: stock.id, endPoint: 'stock');
//       expect(delete2, isA<bool>());
//     });
//   });
// }

