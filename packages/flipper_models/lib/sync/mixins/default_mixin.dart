import 'package:flipper_models/sync/interfaces/default_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:supabase_models/brick/repository.dart';

mixin DefaultMixin implements DefaultInterface {
  Repository get repository;

  @override
  Future<Branch?> defaultBranch() async {
    return (await repository.get<Branch>(
      query: Query(where: [Where('isDefault').isExactly(true)]),
    )).firstOrNull;
  }

  @override
  Future<Business?> defaultBusiness() async {
    return (await repository.get<Business>(
      query: Query(where: [Where('isDefault').isExactly(true)]),
    )).firstOrNull;
  }
}
