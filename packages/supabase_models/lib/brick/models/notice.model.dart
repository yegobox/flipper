import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'notices'),
)
class Notice extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  final int? noticeNo;
  final String? title;
  final String? cont;
  final String? dtlUrl;
  final String? regrNm;
  final String? regDt;
  final String? branchId;

  Notice({
    String? id,
    this.noticeNo,
    this.title,
    this.cont,
    this.dtlUrl,
    this.regrNm,
    this.regDt,
    this.branchId,
  }) : id = id ?? const Uuid().v4();

  Notice copyWith({
    String? id,
    int? noticeNo,
    String? title,
    String? cont,
    String? dtlUrl,
    String? regrNm,
    String? regDt,
    String? branchId,
  }) {
    return Notice(
      id: id ?? this.id,
      noticeNo: noticeNo ?? this.noticeNo,
      title: title ?? this.title,
      cont: cont ?? this.cont,
      dtlUrl: dtlUrl ?? this.dtlUrl,
      regrNm: regrNm ?? this.regrNm,
      regDt: regDt ?? this.regDt,
      branchId: branchId ?? this.branchId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'noticeNo': noticeNo,
      'title': title,
      'cont': cont,
      'dtlUrl': dtlUrl,
      'regrNm': regrNm,
      'regDt': regDt,
      'branchId': branchId,
    };
  }

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      noticeNo: json['noticeNo'],
      title: json['title'],
      cont: json['cont'],
      dtlUrl: json['dtlUrl'],
      regrNm: json['regrNm'],
      regDt: json['regDt'],
      branchId: json['branchId'],
    );
  }
}
