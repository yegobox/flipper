// update existing model to support EBM API?
// -> if we update existing model then this means we are tied to one EBM or RW.
// -> then we need different way to adopt to every EBM of every country.
// -> It is important to know that the EBM data will be posted to respective EBM. of the country.
// -> so we need to know which EBM we are using.
// -> it is okey to use existing model but mapp key when posting to respective EBM.
// ->

import 'package:flipper_models/isar_models.dart';

abstract class TaxInterface {
  Future<bool> saveItem({required Variant product});
  Future<bool> saveStock({required Stock stock});
}
