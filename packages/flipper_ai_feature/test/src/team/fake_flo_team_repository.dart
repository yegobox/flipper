import 'package:flipper_ai_feature/src/team/flo_team_models.dart';
import 'package:flipper_ai_feature/src/team/flo_team_repository.dart';

/// An in-memory Flo Team that records what was asked of it.
class FakeFloTeamRepository implements FloTeamRepository {
  FakeFloTeamRepository({
    this.isMember = true,
    this.isManager = true,
    List<FloTeamThread>? threads,
    List<FloTeamPost>? posts,
    List<FloTeamMention>? mentions,
    List<FloTeamMember>? memberList,
    List<FloTeamMember>? colleagueList,
  })  : threads = threads ?? [],
        posts = posts ?? [],
        mentions = mentions ?? [],
        memberList = memberList ??
            [
              const FloTeamMember(userId: 'me', name: 'Grace', isOwner: true),
              const FloTeamMember(userId: 'u2', name: 'Eric'),
            ],
        colleagueList =
            colleagueList ?? [const FloTeamMember(userId: 'u3', name: 'Aline')];

  bool isMember;
  bool isManager;
  final List<FloTeamThread> threads;
  final List<FloTeamPost> posts;
  List<FloTeamMention> mentions;
  final List<FloTeamMember> memberList;
  List<FloTeamMember> colleagueList;

  /// Every call, as `name(args)`.
  final List<String> calls = [];

  /// When set, the next call throws it (once).
  Object? failNext;

  /// When set, every `changes` call throws it.
  Object? failChanges;

  /// Completes `askFlo` / `summarize` only when the test says so.
  Future<void>? floGate;

  Future<void> _maybeFail() async {
    final f = failNext;
    if (f != null) {
      failNext = null;
      throw f;
    }
  }

  @override
  Future<FloTeamMe> me() async {
    calls.add('me');
    await _maybeFail();
    return FloTeamMe(userId: 'me', isMember: isMember, isManager: isManager);
  }

  @override
  Future<List<FloTeamMember>> members() async {
    calls.add('members');
    await _maybeFail();
    return List.of(memberList);
  }

  @override
  Future<List<FloTeamMember>> colleagues() async {
    calls.add('colleagues');
    await _maybeFail();
    return List.of(colleagueList);
  }

  @override
  Future<void> invite(String userId) async {
    calls.add('invite($userId)');
    await _maybeFail();
    memberList.add(FloTeamMember(userId: userId));
    colleagueList = colleagueList.where((c) => c.userId != userId).toList();
  }

  @override
  Future<void> remove(String userId) async {
    calls.add('remove($userId)');
    await _maybeFail();
    memberList.removeWhere((m) => m.userId == userId);
  }

  @override
  Future<FloTeamChanges> changes({String? since}) async {
    calls.add('changes($since)');
    final f = failChanges;
    if (f != null) throw f;
    await _maybeFail();
    return FloTeamChanges(
      threads: List.of(threads),
      posts: List.of(posts),
      mentions: List.of(mentions),
      serverTime: 't${calls.length}',
    );
  }

  @override
  Future<FloTeamThread> createThread({
    required String kind,
    required String title,
    String body = '',
  }) async {
    calls.add('create($kind,$title,$body)');
    await _maybeFail();
    final t = FloTeamThread(
      id: 'n${threads.length}',
      kind: kind,
      title: title,
      body: body,
      authorUserId: 'me',
      status: FloTeamStatus.idea,
      updatedAt: DateTime(2026, 10, 30),
    );
    threads.add(t);
    return t;
  }

  @override
  Future<FloTeamThread> updateThread(
      String id, Map<String, Object?> changes) async {
    calls.add('update($id,$changes)');
    await _maybeFail();
    final i = threads.indexWhere((t) => t.id == id);
    final t = threads[i];
    final updated = FloTeamThread(
      id: t.id,
      kind: t.kind,
      title: t.title,
      body: t.body,
      authorUserId: t.authorUserId,
      status: changes.containsKey('status')
          ? FloTeamStatus.parse(changes['status']! as String)
          : t.status,
      assigneeUserId: changes.containsKey('assigneeUserId')
          ? changes['assigneeUserId'] as String?
          : t.assigneeUserId,
      dueDate: t.dueDate,
      votes: t.votes,
      voted: t.voted,
      updatedAt: DateTime(2026, 10, 31),
    );
    threads[i] = updated;
    return updated;
  }

  @override
  Future<void> post(String threadId, String body,
      {List<String> mentions = const []}) async {
    calls.add('post($threadId,$body,$mentions)');
    await _maybeFail();
    posts.add(FloTeamPost(
      id: 'p${calls.length}',
      threadId: threadId,
      isFlo: false,
      body: body,
      authorUserId: 'me',
    ));
  }

  @override
  Future<void> vote(String threadId, {required bool on}) async {
    calls.add('vote($threadId,$on)');
    await _maybeFail();
    final i = threads.indexWhere((t) => t.id == threadId);
    final t = threads[i];
    threads[i] = FloTeamThread(
      id: t.id,
      kind: t.kind,
      title: t.title,
      body: t.body,
      authorUserId: t.authorUserId,
      status: t.status,
      votes: t.votes + (on ? 1 : -1),
      voted: on,
      updatedAt: t.updatedAt,
    );
  }

  @override
  Future<void> askFlo(String threadId, {String question = ''}) async {
    calls.add('ask($threadId,$question)');
    await (floGate ?? Future<void>.value());
    await _maybeFail();
    _floAnswer(threadId, 'Try it on two Sundays first.');
  }

  @override
  Future<void> summarize(String threadId) async {
    calls.add('summarize($threadId)');
    await (floGate ?? Future<void>.value());
    await _maybeFail();
    _floAnswer(threadId, 'Everyone agrees.');
  }

  void _floAnswer(String threadId, String text) {
    posts.add(FloTeamPost(
      id: 'f${calls.length}',
      threadId: threadId,
      isFlo: true,
      body: text,
      blocks: [
        {'type': 'text', 'html': text},
      ],
    ));
  }

  @override
  Future<void> markRead({String? threadId}) async {
    calls.add('read($threadId)');
    await _maybeFail();
    mentions = mentions.where((m) => m.threadId != threadId).toList();
  }
}

FloTeamThread idea(
  String id,
  String title, {
  FloTeamStatus status = FloTeamStatus.idea,
  int votes = 0,
  bool voted = false,
  String? assignee,
  DateTime? due,
  String kind = 'idea',
  DateTime? updatedAt,
}) =>
    FloTeamThread(
      id: id,
      kind: kind,
      title: title,
      body: 'About $title',
      authorUserId: 'u2',
      status: status,
      votes: votes,
      voted: voted,
      assigneeUserId: assignee,
      dueDate: due,
      updatedAt: updatedAt ?? DateTime(2026, 10, 1),
    );
