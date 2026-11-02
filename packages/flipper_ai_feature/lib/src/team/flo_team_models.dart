/// Flo Team data, as data-connector's `/api/flo/team/*` returns it.
///
/// Flo Team is a shared workspace inside Flo: invited colleagues post ideas
/// (which can become tasks), discuss them with each other and with Flo,
/// upvote them and @mention one another.
library;

DateTime? _time(Object? raw) =>
    raw is String ? DateTime.tryParse(raw)?.toLocal() : null;

String _str(Object? raw) => raw is String ? raw : '';

/// Where an idea is in the task workflow. A discussion stays [idea] (open)
/// or [archived].
enum FloTeamStatus {
  idea,
  todo,
  doing,
  done,
  archived;

  static FloTeamStatus parse(String raw) => FloTeamStatus.values.firstWhere(
        (s) => s.name == raw,
        orElse: () => FloTeamStatus.idea,
      );

  /// In the task workflow (to do, doing, done) rather than an open idea.
  bool get isTask => this == todo || this == doing || this == done;
}

class FloTeamThread {
  const FloTeamThread({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.authorUserId,
    required this.status,
    this.assigneeUserId,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
    this.votes = 0,
    this.voted = false,
  });

  factory FloTeamThread.fromJson(Map<String, dynamic> json) {
    final assignee = _str(json['assignee_user_id']);
    final due = _str(json['due_date']);
    return FloTeamThread(
      id: _str(json['id']),
      kind: _str(json['kind']),
      title: _str(json['title']),
      body: _str(json['body']),
      authorUserId: _str(json['author_user_id']),
      status: FloTeamStatus.parse(_str(json['status'])),
      assigneeUserId: assignee.isEmpty ? null : assignee,
      dueDate: due.isEmpty ? null : DateTime.tryParse(due),
      createdAt: _time(json['created_at']),
      updatedAt: _time(json['updated_at']),
      votes: (json['votes'] as num?)?.toInt() ?? 0,
      voted: json['voted'] == true,
    );
  }

  final String id;

  /// `idea` or `discussion`.
  final String kind;
  final String title;
  final String body;
  final String authorUserId;
  final FloTeamStatus status;
  final String? assigneeUserId;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int votes;
  final bool voted;

  bool get isIdea => kind == 'idea';
}

class FloTeamPost {
  const FloTeamPost({
    required this.id,
    required this.threadId,
    required this.isFlo,
    required this.body,
    this.authorUserId,
    this.blocks = const [],
    this.createdAt,
  });

  factory FloTeamPost.fromJson(Map<String, dynamic> json) {
    final payload = json['blocks'];
    final blocks = payload is Map && payload['blocks'] is List
        ? (payload['blocks'] as List)
            .whereType<Map>()
            .map((b) => Map<String, dynamic>.from(b))
            .toList()
        : const <Map<String, dynamic>>[];
    final author = _str(json['author_user_id']);
    return FloTeamPost(
      id: _str(json['id']),
      threadId: _str(json['thread_id']),
      isFlo: json['author_kind'] == 'flo',
      body: _str(json['body']),
      authorUserId: author.isEmpty ? null : author,
      blocks: blocks,
      createdAt: _time(json['created_at']),
    );
  }

  final String id;
  final String threadId;

  /// Written by Flo rather than a colleague.
  final bool isFlo;
  final String body;
  final String? authorUserId;

  /// Flo's answer blocks (`flo_v1`), rendered like Ask Flo.
  final List<Map<String, dynamic>> blocks;
  final DateTime? createdAt;
}

/// An unread @mention of the signed-in user.
class FloTeamMention {
  const FloTeamMention({required this.id, required this.threadId});

  factory FloTeamMention.fromJson(Map<String, dynamic> json) => FloTeamMention(
        id: _str(json['id']),
        threadId: _str(json['thread_id']),
      );

  final String id;
  final String threadId;
}

class FloTeamMember {
  const FloTeamMember({
    required this.userId,
    this.name,
    this.isOwner = false,
  });

  factory FloTeamMember.fromJson(Map<String, dynamic> json) {
    final userId = _str(json['user_id']).isNotEmpty
        ? _str(json['user_id'])
        : _str(json['userId']);
    final name = _str(json['name']);
    return FloTeamMember(
      userId: userId,
      name: name.isEmpty ? null : name,
      isOwner: json['role'] == 'owner',
    );
  }

  final String userId;
  final String? name;
  final bool isOwner;

  /// The name when the server knows it, otherwise the user id.
  String get displayName => name ?? userId;
}

/// Who the signed-in user is to Flo Team.
class FloTeamMe {
  const FloTeamMe({
    required this.userId,
    required this.isMember,
    required this.isManager,
  });

  factory FloTeamMe.fromJson(Map<String, dynamic> json) => FloTeamMe(
        userId: _str(json['userId']),
        isMember: json['isMember'] == true,
        isManager: json['isManager'] == true,
      );

  final String userId;

  /// Invited (or the owner): may see and use the board.
  final bool isMember;

  /// The owner or an Admin: may invite and remove members.
  final bool isManager;
}

/// One poll of `GET /api/flo/team/threads?since=`.
class FloTeamChanges {
  const FloTeamChanges({
    required this.threads,
    required this.posts,
    required this.mentions,
    required this.serverTime,
  });

  factory FloTeamChanges.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> rows(String key) => (json[key] as List? ?? [])
        .whereType<Map>()
        .map((r) => Map<String, dynamic>.from(r))
        .toList();
    return FloTeamChanges(
      threads: rows('threads').map(FloTeamThread.fromJson).toList(),
      posts: rows('posts').map(FloTeamPost.fromJson).toList(),
      mentions: rows('mentions').map(FloTeamMention.fromJson).toList(),
      serverTime: _str(json['serverTime']),
    );
  }

  final List<FloTeamThread> threads;
  final List<FloTeamPost> posts;
  final List<FloTeamMention> mentions;

  /// The `since` for the next poll.
  final String serverTime;
}

/// Everything the Team tab shows, merged poll by poll.
class FloTeamBoard {
  const FloTeamBoard({
    this.threads = const {},
    this.posts = const {},
    this.mentions = const [],
    this.since,
  });

  /// By thread id.
  final Map<String, FloTeamThread> threads;

  /// Posts per thread id, oldest first.
  final Map<String, List<FloTeamPost>> posts;

  /// Unread mentions of the signed-in user (the server's full list each poll).
  final List<FloTeamMention> mentions;
  final String? since;

  /// Folds a poll in: changed threads replace their old copy, new posts are
  /// appended once, and the unread mentions are taken as they now stand.
  FloTeamBoard merge(FloTeamChanges changes) {
    final threads = {...this.threads};
    for (final t in changes.threads) {
      threads[t.id] = t;
    }
    final posts = {
      for (final e in this.posts.entries) e.key: [...e.value],
    };
    for (final p in changes.posts) {
      final list = posts.putIfAbsent(p.threadId, () => []);
      if (!list.any((existing) => existing.id == p.id)) list.add(p);
    }
    return FloTeamBoard(
      threads: threads,
      posts: posts,
      mentions: changes.mentions,
      since: changes.serverTime.isEmpty ? since : changes.serverTime,
    );
  }

  /// Threads for a board column, newest activity first. Ideas sort by votes.
  List<FloTeamThread> filtered(FloTeamFilter filter) {
    final list = threads.values.where(filter.includes).toList()
      ..sort((a, b) {
        if (filter == FloTeamFilter.ideas && a.votes != b.votes) {
          return b.votes.compareTo(a.votes);
        }
        final at = a.updatedAt ?? DateTime(0);
        final bt = b.updatedAt ?? DateTime(0);
        return bt.compareTo(at);
      });
    return list;
  }

  int unreadIn(String threadId) =>
      mentions.where((m) => m.threadId == threadId).length;
}

/// The board's columns.
enum FloTeamFilter {
  ideas,
  todo,
  doing,
  done,
  discussions;

  bool includes(FloTeamThread t) => switch (this) {
        FloTeamFilter.ideas => t.isIdea && t.status == FloTeamStatus.idea,
        FloTeamFilter.todo => t.status == FloTeamStatus.todo,
        FloTeamFilter.doing => t.status == FloTeamStatus.doing,
        FloTeamFilter.done => t.status == FloTeamStatus.done,
        FloTeamFilter.discussions =>
          !t.isIdea && t.status != FloTeamStatus.archived,
      };
}
