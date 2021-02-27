
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:stacked/stacked.dart';

class CompleteSaleViewModel extends ReactiveViewModel{
  final _sharedState = locator<SharedStateService>();


  @override
  // TODO: implement reactiveServices
  List<ReactiveServiceMixin> get reactiveServices => [_sharedState];

}