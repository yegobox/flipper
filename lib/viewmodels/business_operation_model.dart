import 'package:flipper/couchbase.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/util/logger.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

// ignore: always_specify_types
class BusinessOperation extends FutureViewModel{

  final Logger log = Logging.getLogger('Business Model ....');
  final AppDatabase appDatabase = locator<AppDatabase>();
    
  @override
  Future futureToRun() {

    throw UnimplementedError();
  }

}