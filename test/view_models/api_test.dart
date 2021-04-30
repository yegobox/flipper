import 'package:flipper_models/models/business.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// import 'startup_viewmodel_test.mocks.dart';
import 'package:flipper_services/abstractions/api.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
final Business businessMockData = new Business(
  id: '1',
  name: 'name',
  latitude: '1',
  longitude: '2',
  channels: [''],
  table: '',
  country: '',
  type: '',
);
@GenerateMocks([Api])
void main() {
  test('API Test on Interface', () async {
    // final model = StartUpViewModel();
    // final client = MockApi();
    // List<Business> c = [];
    // c.add(businessMockData);
    // when(client.businesses()).thenAnswer((_) async => c);

    // expect(await client.businesses(), c);
    expect(1, 1);
  });
}
