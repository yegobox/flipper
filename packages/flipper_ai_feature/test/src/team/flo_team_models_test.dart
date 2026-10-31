import 'dart:convert';

import 'package:flipper_ai_feature/src/team/flo_team_models.dart';
import 'package:flipper_ai_feature/src/team/flo_team_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'fake_flo_team_repository.dart';

void main() {
  group('models', () {
    test('a thread reads the API row', () {
      final t = FloTeamThread.fromJson({
        'id': 't1',
        'kind': 'idea',
        'title': 'Sundays',
        'body': 'Open 10 to 4',
        'author_user_id': 'u2',
        'status': 'doing',
        'assignee_user_id': 'me',
        'due_date': '2026-11-06',
        'created_at': '2026-10-30T08:00:00Z',
        'updated_at': '2026-10-30T09:00:00Z',
        'votes': 3,
        'voted': true,
      });
      expect(
        [
          t.id,
          t.isIdea,
          t.status,
          t.assigneeUserId,
          t.dueDate,
          t.votes,
          t.voted
        ],
        ['t1', true, FloTeamStatus.doing, 'me', DateTime(2026, 11, 6), 3, true],
      );
      expect(t.createdAt!.isUtc, isFalse);
      expect(t.status.isTask, isTrue);

      final bare =
          FloTeamThread.fromJson({'kind': 'discussion', 'status': 'weird'});
      expect(
        [
          bare.isIdea,
          bare.status,
          bare.assigneeUserId,
          bare.dueDate,
          bare.votes,
          bare.voted
        ],
        [false, FloTeamStatus.idea, null, null, 0, false],
      );
      expect(FloTeamStatus.idea.isTask, isFalse);
    });

    test('a post carries Flo\'s blocks', () {
      final flo = FloTeamPost.fromJson({
        'id': 'p1',
        'thread_id': 't1',
        'author_kind': 'flo',
        'author_user_id': null,
        'body': 'Go',
        'blocks': {
          'flo_v1': true,
          'blocks': [
            {'type': 'text', 'html': 'Go'},
            'not a block',
          ],
        },
      });
      expect([flo.isFlo, flo.authorUserId, flo.blocks.length], [true, null, 1]);
      final member = FloTeamPost.fromJson(
          {'author_kind': 'member', 'author_user_id': 'u2'});
      expect([member.isFlo, member.authorUserId, member.blocks],
          [false, 'u2', isEmpty]);
    });

    test('members, me and mentions', () {
      final owner = FloTeamMember.fromJson(
          {'user_id': 'u1', 'name': 'Grace', 'role': 'owner'});
      final colleague = FloTeamMember.fromJson({'userId': 'u3', 'name': null});
      expect([owner.displayName, owner.isOwner], ['Grace', true]);
      expect([colleague.userId, colleague.displayName, colleague.isOwner],
          ['u3', 'u3', false]);
      final me = FloTeamMe.fromJson(
          {'userId': 'u1', 'isMember': true, 'isManager': false});
      expect([me.userId, me.isMember, me.isManager], ['u1', true, false]);
      final m = FloTeamMention.fromJson({'id': 'm1', 'thread_id': 't1'});
      expect([m.id, m.threadId], ['m1', 't1']);
    });

    test('the board folds polls in', () {
      final first = FloTeamChanges.fromJson({
        'threads': [
          {
            'id': 't1',
            'kind': 'idea',
            'title': 'A',
            'status': 'idea',
            'votes': 1
          },
        ],
        'posts': [
          {'id': 'p1', 'thread_id': 't1', 'body': 'hi'},
        ],
        'mentions': [
          {'id': 'm1', 'thread_id': 't1'},
        ],
        'serverTime': 's1',
      });
      var board = const FloTeamBoard().merge(first);
      expect([
        board.threads.length,
        board.posts['t1']!.length,
        board.unreadIn('t1'),
        board.since
      ], [
        1,
        1,
        1,
        's1'
      ]);

      // The same post again is not duplicated; a changed thread replaces its copy;
      // mentions are taken as they now stand; an empty serverTime keeps since.
      board = board.merge(FloTeamChanges.fromJson({
        'threads': [
          {
            'id': 't1',
            'kind': 'idea',
            'title': 'A2',
            'status': 'idea',
            'votes': 2
          },
        ],
        'posts': [
          {'id': 'p1', 'thread_id': 't1', 'body': 'hi'},
          {'id': 'p2', 'thread_id': 't1', 'body': 'again'},
        ],
        'serverTime': '',
      }));
      expect([
        board.threads['t1']!.title,
        board.posts['t1']!.length,
        board.unreadIn('t1'),
        board.since
      ], [
        'A2',
        2,
        0,
        's1'
      ]);
      expect(FloTeamChanges.fromJson({}).threads, isEmpty);
    });

    test('each column holds its threads, ideas by votes', () {
      final board = FloTeamBoard(threads: {
        for (final t in [
          idea('a', 'Few votes', votes: 1, updatedAt: DateTime(2026, 10, 3)),
          idea('b', 'Many votes', votes: 5, updatedAt: DateTime(2026, 10, 1)),
          idea('c', 'Same votes, newer',
              votes: 1, updatedAt: DateTime(2026, 10, 9)),
          idea('d', 'Todo', status: FloTeamStatus.todo),
          idea('e', 'Doing', status: FloTeamStatus.doing),
          idea('f', 'Done', status: FloTeamStatus.done),
          idea('g', 'Chat', kind: 'discussion'),
          idea('h', 'Old chat',
              kind: 'discussion', status: FloTeamStatus.archived),
          FloTeamThread(
              id: 'i',
              kind: 'idea',
              title: 'Undated',
              body: '',
              authorUserId: 'x',
              status: FloTeamStatus.todo),
        ])
          t.id: t,
      });
      List<String> ids(FloTeamFilter f) =>
          board.filtered(f).map((t) => t.id).toList();
      expect(ids(FloTeamFilter.ideas), ['b', 'c', 'a']);
      expect(ids(FloTeamFilter.todo), ['d', 'i']);
      expect(ids(FloTeamFilter.doing), ['e']);
      expect(ids(FloTeamFilter.done), ['f']);
      expect(ids(FloTeamFilter.discussions), ['g']);
    });
  });

  group('HttpFloTeamRepository', () {
    late List<http.Request> sent;

    HttpFloTeamRepository repo(http.Response Function(http.Request) reply) {
      sent = [];
      return HttpFloTeamRepository(
        baseUrl: () async => 'https://dc.test/',
        client: MockClient((req) async {
          sent.add(req);
          return reply(req);
        }),
      );
    }

    http.Response ok(Object body) => http.Response(jsonEncode(body), 200);

    test('every call goes to its route', () async {
      final r = repo((req) {
        final path = req.url.path;
        if (path.endsWith('/me'))
          return ok({'userId': 'u1', 'isMember': true, 'isManager': true});
        if (path.endsWith('/members') && req.method == 'GET') {
          return ok({
            'members': [
              {'user_id': 'u1', 'name': 'Grace'}
            ]
          });
        }
        if (path.endsWith('/colleagues'))
          return ok({
            'colleagues': [
              {'userId': 'u3'}
            ]
          });
        if (path.endsWith('/threads') && req.method == 'GET') {
          return ok(
              {'threads': [], 'posts': [], 'mentions': [], 'serverTime': 's'});
        }
        if (path.contains('/threads') &&
            (req.method == 'POST' || req.method == 'PATCH') &&
            !path.contains('/posts') &&
            !path.contains('/vote') &&
            !path.contains('/ask') &&
            !path.contains('/summarize')) {
          return ok({
            'thread': {
              'id': 't1',
              'kind': 'idea',
              'title': 'x',
              'status': 'idea'
            }
          });
        }
        return ok({});
      });

      expect((await r.me()).isManager, isTrue);
      expect((await r.members()).single.displayName, 'Grace');
      expect((await r.colleagues()).single.userId, 'u3');
      await r.invite('u3');
      await r.remove('u 3');
      expect((await r.changes()).serverTime, 's');
      await r.changes(since: '2026-10-30T10:00:00+02:00');
      expect((await r.createThread(kind: 'idea', title: 'x')).id, 't1');
      expect(
          (await r.updateThread('t1', {'status': 'todo', 'dueDate': null})).id,
          't1');
      await r.post('t1', 'hello', mentions: ['u2']);
      await r.post('t1', 'plain');
      await r.vote('t1', on: true);
      await r.vote('t1', on: false);
      await r.askFlo('t1', question: 'why?');
      await r.askFlo('t1');
      await r.summarize('t1');
      await r.markRead(threadId: 't1');
      await r.markRead();

      expect(
          sent.map((q) =>
              '${q.method} ${q.url.path}${q.url.hasQuery ? '?${q.url.query}' : ''}'),
          [
            'GET /api/flo/team/me',
            'GET /api/flo/team/members',
            'GET /api/flo/team/colleagues',
            'POST /api/flo/team/members',
            'DELETE /api/flo/team/members/u%203',
            'GET /api/flo/team/threads',
            'GET /api/flo/team/threads?since=2026-10-30T10%3A00%3A00%2B02%3A00',
            'POST /api/flo/team/threads',
            'PATCH /api/flo/team/threads/t1',
            'POST /api/flo/team/threads/t1/posts',
            'POST /api/flo/team/threads/t1/posts',
            'POST /api/flo/team/threads/t1/vote',
            'DELETE /api/flo/team/threads/t1/vote',
            'POST /api/flo/team/threads/t1/ask',
            'POST /api/flo/team/threads/t1/ask',
            'POST /api/flo/team/threads/t1/summarize',
            'POST /api/flo/team/mentions/read',
            'POST /api/flo/team/mentions/read',
          ]);
      Object? body(int i) =>
          sent[i].body.isEmpty ? null : jsonDecode(sent[i].body);
      expect(body(3), {'userId': 'u3'});
      expect(body(8), {'status': 'todo', 'dueDate': null});
      expect(body(9), {
        'body': 'hello',
        'mentions': ['u2']
      });
      expect(body(10), {'body': 'plain', 'mentions': []});
      expect(body(13), {'question': 'why?'});
      expect(body(14), {'question': ''});
      expect([
        body(16),
        body(17)
      ], [
        {'threadId': 't1'},
        {}
      ]);
      expect(
          sent.every(
              (q) => q.headers['Content-Type']!.startsWith('application/json')),
          isTrue);
    });

    test('errors carry the server message and status', () async {
      final r = repo(
          (req) => http.Response(jsonEncode({'error': 'Ask your admin'}), 403));
      await expectLater(
        r.changes(),
        throwsA(isA<FloTeamException>()
            .having((e) => e.notMember, 'notMember', isTrue)
            .having((e) => e.toString(), 'message', 'Ask your admin')),
      );
      final broken = repo((req) => http.Response('<html>', 502));
      await expectLater(
        broken.me(),
        throwsA(isA<FloTeamException>()
            .having((e) => e.statusCode, 'status', 502)
            .having((e) => e.notMember, 'notMember', isFalse)
            .having(
                (e) => e.message, 'message', 'Flo Team request failed (502)')),
      );
      final listy = repo((req) => http.Response('[1]', 200));
      expect((await listy.members()), isEmpty);
    });

    test('an unreachable server is a FloTeamException', () async {
      final r = HttpFloTeamRepository(
        baseUrl: () async => 'https://dc.test/',
        client: MockClient((req) => throw http.ClientException('offline')),
      );
      await expectLater(
        r.me(),
        throwsA(isA<FloTeamException>()
            .having((e) => e.statusCode, 'status', isNull)
            .having((e) => e.message, 'message',
                contains('Could not reach Flo Team'))),
      );
    });

    test('it uses its own client when given none', () {
      expect(HttpFloTeamRepository(baseUrl: () async => 'x'),
          isA<FloTeamRepository>());
    });
  });
}
