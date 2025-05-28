import 'package:supabase_models/brick/models/notice.model.dart';

abstract class NoticeInterface {
  Future<List<Notice>> notices({required String branchId});
  // fetch notices from
  Future<List<Notice>> fetchNotices({required String URI});
}
