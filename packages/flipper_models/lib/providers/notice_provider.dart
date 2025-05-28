import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/notice.model.dart';
import 'package:flipper_services/proxy.dart';

part 'notice_provider.g.dart';

@riverpod
Future<List<Notice>> notices(Ref ref) async {
  return await ProxyService.tax.notices(
      branchId: (await ProxyService.strategy
              .branch(serverId: ProxyService.box.getBranchId()!))!
          .id);
}
