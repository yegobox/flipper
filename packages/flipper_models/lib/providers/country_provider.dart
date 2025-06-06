import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'country_provider.g.dart';

@riverpod
Future<List<Country>> countries(Ref ref) async {
  return await ProxyService.strategy.countries();
}
