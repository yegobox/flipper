import 'dart:async';
import 'dart:convert';

import 'package:flipper_ai_feature/src/support/flo_support_controller.dart';
import 'package:flipper_ai_feature/src/support/flo_support_repository.dart';
import 'package:flipper_ai_feature/src/support/flo_support_sheet.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

FloSupportPost _post(String id, String body,
        {bool support = false, bool mine = true, int minute = 0}) =>
    FloSupportPost(
      id: id,
      body: body,
      fromSupport: support,
      authorName: support ? 'Flipper Support' : 'Grace · Shop',
      mine: mine,
      createdAt: DateTime(2026, 11, 4, 10, minute),
    );

/// An in-memory support thread that records what was asked of it. Like the
/// server, a read with `since` answers only the posts new since then.
class _FakeSupport implements FloSupportRepository {
  String? threadId;
  bool resolved = false;
  final List<FloSupportPost> posts = [];
  final List<String> calls = [];

  /// The read (`s<n>`) that first returned each post.
  final Map<String, int> _firstRead = {};

  /// When set, every call throws it.
  Object? fail;

  /// When set, reads (not sends) throw it.
  Object? failReads;

  /// When set, `send` waits for it.
  Future<void>? gate;

  /// When set, reads wait for it.
  Future<void>? readGate;

  @override
  Future<FloSupportConversation> conversation({String? since}) async {
    calls.add('read($since)');
    final now = calls.length;
    await readGate;
    final f = fail ?? failReads;
    if (f != null) throw f;
    final after = since == null ? null : int.parse(since.substring(1));
    for (final p in posts) {
      _firstRead.putIfAbsent(p.id, () => now);
    }
    return FloSupportConversation(
      threadId: threadId,
      resolved: resolved,
      posts: [
        for (final p in posts)
          if (after == null || _firstRead[p.id]! > after) p,
      ],
      serverTime: 's$now',
    );
  }

  @override
  Future<FloSupportPost> send(String body,
      {String topic = 'general', Map<String, String>? context}) async {
    calls.add('send($body,$topic,$context)');
    await gate;
    final f = fail;
    if (f != null) throw f;
    threadId ??= 't1';
    resolved = false;
    final post = _post('p${posts.length}', body, minute: posts.length);
    posts.add(post);
    return post;
  }
}

List<Override> _overrides(_FakeSupport repo) => [
      floSupportRepositoryProvider.overrideWithValue(repo),
      floSupportPollIntervalProvider
          .overrideWithValue(const Duration(hours: 1)),
    ];

Future<void> _pump(WidgetTester tester, _FakeSupport repo,
    {Size size = const Size(400, 800), VoidCallback? onFallback}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: _overrides(repo),
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showFloSupportSheet(
                context,
                topic: 'payment',
                screenContext: const {'plan': 'Mobile'},
                onFallback: onFallback,
              ),
              child: const Text('Need help'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Need help'));
  await tester.pumpAndSettle();
}

void main() {
  group('HttpFloSupportRepository', () {
    late List<http.Request> sent;

    HttpFloSupportRepository repo(http.Response Function(http.Request) reply) {
      sent = [];
      return HttpFloSupportRepository(
        baseUrl: () async => 'https://dc.test/',
        client: MockClient((req) async {
          sent.add(req);
          return reply(req);
        }),
      );
    }

    http.Response ok(Object body) => http.Response(jsonEncode(body), 200);

    test('reads the conversation, then only what is new', () async {
      final r = repo((_) => ok({
            'thread': {'id': 't1', 'status': 'done'},
            'posts': [
              {
                'id': 'p1',
                'body': 'We are on it',
                'fromSupport': true,
                'authorName': 'Flipper Support',
                'createdAt': '2026-11-04T10:00:00Z',
              },
              'not a post',
            ],
            'serverTime': 's1',
          }));
      final first = await r.conversation();
      expect(
          sent.single.url.toString(), 'https://dc.test/api/flo/support/thread');
      expect(
        [first.threadId, first.resolved, first.serverTime, first.posts.length],
        ['t1', true, 's1', 1],
      );
      final post = first.posts.single;
      expect([post.body, post.fromSupport, post.mine, post.authorName],
          ['We are on it', true, false, 'Flipper Support']);
      expect(post.createdAt!.isUtc, isFalse);

      await r.conversation(since: '2026-11-04T10:00:00+00:00');
      expect(
          sent.last.url.queryParameters['since'], '2026-11-04T10:00:00+00:00');
    });

    test('no thread yet reads as an empty conversation', () async {
      final r = repo((_) => ok({'thread': null}));
      final c = await r.conversation();
      expect([c.threadId, c.resolved, c.posts, c.serverTime],
          [null, false, isEmpty, null]);
    });

    test('sends the message with its topic and context', () async {
      final r = repo((_) => ok({
            'post': {'id': 'p1', 'body': 'Help', 'mine': true}
          }));
      final post = await r
          .send('Help', topic: 'payment', context: const {'plan': 'Mobile'});
      expect(sent.single.method, 'POST');
      expect(sent.single.url.path, '/api/flo/support/messages');
      expect(jsonDecode(sent.single.body), {
        'body': 'Help',
        'topic': 'payment',
        'context': {'plan': 'Mobile'},
      });
      expect([post.id, post.mine], ['p1', true]);

      final bare = repo((_) => ok({}));
      expect((await bare.send('Hi')).id, '');
      expect(jsonDecode(sent.single.body), {'body': 'Hi', 'topic': 'general'});
    });

    test('failures are FloSupportExceptions', () async {
      Future<FloSupportException> failure(Future<Object?> call) async {
        try {
          await call;
        } on FloSupportException catch (e) {
          return e;
        }
        fail('expected a FloSupportException');
      }

      final off = await failure(repo((_) => http.Response(
              jsonEncode({'error': 'support chat is not configured'}), 503))
          .conversation());
      expect([
        off.message,
        off.unavailable,
        off.toString()
      ], [
        'support chat is not configured',
        true,
        'support chat is not configured'
      ]);

      final busy =
          await failure(repo((_) => http.Response('<html>', 429)).send('x'));
      expect([busy.message, busy.statusCode, busy.unavailable],
          ['Support request failed (429)', 429, false]);

      final list =
          await failure(repo((_) => http.Response('[]', 500)).send('x'));
      expect(list.message, 'Support request failed (500)');

      final offline = await failure(HttpFloSupportRepository(
        baseUrl: () async => throw StateError('no branch'),
      ).conversation());
      expect(offline.statusCode, isNull);

      final oddError = await failure(
          repo((_) => http.Response(jsonEncode({'error': 42}), 400)).send('x'));
      expect(oddError.message, 'Support request failed (400)');
    });

    test('a connector lookup that stalls times out like the request', () async {
      final stalled = HttpFloSupportRepository(
        baseUrl: () => Completer<String>().future,
        timeout: const Duration(milliseconds: 10),
      );
      await expectLater(
          stalled.conversation(), throwsA(isA<FloSupportException>()));
    });

    test('odd wire values read as missing, not as a crash', () async {
      final c = await repo((_) => ok({
            'thread': {'id': 't1'},
            'posts': {'p1': 'not a list'},
            'serverTime': 12,
          })).conversation();
      expect([c.threadId, c.posts, c.serverTime], ['t1', isEmpty, null]);
    });

    test('a message answered with a page, not JSON, was not sent', () async {
      final page = repo((_) => http.Response('<html>login</html>', 200));
      await expectLater(page.send('Help'), throwsA(isA<FloSupportException>()));
      // A read of the same is still just an empty conversation.
      expect((await page.conversation()).threadId, isNull);
    });
  });

  group('FloSupportController', () {
    late ProviderContainer container;
    late _FakeSupport repo;

    void start() {
      repo = _FakeSupport();
      container = ProviderContainer(overrides: _overrides(repo));
      addTearDown(container.dispose);
      container.listen(floSupportControllerProvider, (_, __) {});
    }

    FloSupportController support() =>
        container.read(floSupportControllerProvider.notifier);
    FloSupportState state() => container.read(floSupportControllerProvider);

    test('loads, sends, and polls with since', () async {
      start();
      await support().refresh();
      expect([state().loading, state().posts, state().threadId],
          [false, isEmpty, null]);

      expect(await support().send('  '), isFalse);
      expect(await support().send(' Help ', topic: 'payment'), isTrue);
      expect(repo.calls, [
        'read(null)',
        'send(Help,payment,null)',
        'read(s1)',
      ]);
      expect(state().posts.map((p) => p.body), ['Help']);
      expect(state().since, 's3');

      // A reply arrives with the next poll, after the customer's message.
      repo.posts.add(_post('r1', 'On it', support: true, minute: 5));
      repo.resolved = true;
      await support().refresh();
      expect(state().posts.map((p) => p.body), ['Help', 'On it']);
      expect(state().resolved, isTrue);
    });

    test('a poll merges what changed and keeps the rest', () async {
      start();
      await support().send('Help');
      repo.posts.add(_post('r1', 'On it', support: true, minute: 5));
      await support().refresh();
      expect(state().posts.map((p) => p.id), ['p0', 'r1']);

      // The next delta omits both older posts and adds one.
      repo.posts.add(_post('r2', 'Done', support: true, minute: 6));
      await support().refresh();
      expect(repo.calls.last, startsWith('read(s'));
      expect(state().posts.map((p) => p.id), ['p0', 'r1', 'r2']);

      // An empty delta changes nothing.
      final before = state().posts;
      await support().refresh();
      expect(state().posts, before);
    });

    test('a sent message shows even when the read after it fails', () async {
      start();
      await support().refresh();
      repo.failReads = FloSupportException('down');
      expect(await support().send('Help'), isTrue);
      expect(state().posts.map((p) => p.body), ['Help']);
      expect(state().sending, isFalse);
    });

    test('still sending until the read after it lands', () async {
      start();
      await support().refresh();
      final read = Completer<void>();
      repo.readGate = read.future;
      final first = support().send('Help');
      await pumpEventQueue();
      expect(repo.calls.where((c) => c.startsWith('send')), hasLength(1));
      expect(state().sending, isTrue);
      expect(await support().send('Help'), isFalse);

      read.complete();
      expect(await first, isTrue);
      expect(state().sending, isFalse);
      expect(repo.calls.where((c) => c.startsWith('send')), hasLength(1));
    });

    test('a failure keeps the conversation and says so', () async {
      start();
      await support().send('Help');
      repo.fail = FloSupportException('down', statusCode: 503);
      await support().refresh();
      expect([state().error, state().unavailable, state().posts.length],
          ['down', true, 1]);
      expect(await support().send('Again'), isFalse);
      expect(state().sending, isFalse);

      repo.fail = null;
      expect(await support().send('Again'), isTrue);
      expect(state().error, isNull);
    });

    test('an archived thread empties the chat; a new one starts over',
        () async {
      start();
      await support().send('Old');
      repo.threadId = null;
      repo.posts.clear();
      await support().refresh();
      expect([state().posts, state().threadId], [isEmpty, null]);

      repo.threadId = 't2';
      repo.posts.add(_post('n1', 'New', minute: 9));
      await support().refresh();
      expect(state().posts.map((p) => p.id), ['n1']);
    });

    test('nothing lands on a chat closed while it worked', () async {
      for (final failing in [false, true]) {
        start();
        await support().refresh();
        final controller = support();
        final gate = Completer<void>();
        repo.gate = gate.future;
        if (failing) repo.fail = FloSupportException('down');
        final sending = controller.send('late');
        container.dispose();
        await controller.refresh();
        gate.complete();
        expect(await sending, !failing);
      }
    });
  });

  group('showFloSupportSheet', () {
    testWidgets('a phone gets a sheet to write and read replies',
        (tester) async {
      final repo = _FakeSupport();
      await _pump(tester, repo);
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.byKey(const Key('flo-support-empty')), findsOneWidget);

      await tester.enterText(
          find.byKey(const Key('flo-support-message')), 'My payment failed');
      await tester.tap(find.byKey(const Key('flo-support-send')));
      await tester.pumpAndSettle();
      expect(repo.calls,
          contains('send(My payment failed,payment,{plan: Mobile})'));
      expect(find.text('My payment failed'), findsOneWidget);
      expect(find.textContaining('You · '), findsOneWidget);
      final field = tester
          .widget<TextField>(find.byKey(const Key('flo-support-message')));
      expect(field.controller!.text, isEmpty);

      repo.posts.add(
          _post('r1', 'We are on it', support: true, mine: false, minute: 5));
      repo.posts.add(_post('c1', 'From a colleague', mine: false, minute: 6));
      repo.resolved = true;
      final container = ProviderScope.containerOf(
          tester.element(find.byType(FloSupportChat)));
      await container.read(floSupportControllerProvider.notifier).refresh();
      await tester.pumpAndSettle();
      expect(find.text('We are on it'), findsOneWidget);
      expect(find.textContaining('Flipper Support · '), findsOneWidget);
      expect(find.textContaining('Grace · Shop · '), findsOneWidget);
      expect(find.byKey(const Key('flo-support-resolved')), findsOneWidget);

      await tester.tap(find.byKey(const Key('flo-support-close')));
      await tester.pumpAndSettle();
      expect(find.byType(FloSupportChat), findsNothing);
    });

    testWidgets('text typed while a message sends is kept', (tester) async {
      final repo = _FakeSupport();
      await _pump(tester, repo);
      final gate = Completer<void>();
      repo.gate = gate.future;
      final message = find.byKey(const Key('flo-support-message'));
      await tester.enterText(message, 'First');
      await tester.tap(find.byKey(const Key('flo-support-send')));
      await tester.pump();
      await tester.enterText(message, 'Second');
      gate.complete();
      await tester.pumpAndSettle();
      expect(repo.calls, contains('send(First,payment,{plan: Mobile})'));
      expect(tester.widget<TextField>(message).controller!.text, 'Second');
    });

    testWidgets('the composer stays above the keyboard on a short screen',
        (tester) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await _pump(tester, _FakeSupport(), size: const Size(400, 500));
      expect(tester.takeException(), isNull);
      final send = tester.getRect(find.byKey(const Key('flo-support-send')));
      expect(send.bottom, lessThanOrEqualTo(500 - 300));
      expect(send.top, greaterThanOrEqualTo(0));
    });

    testWidgets('a wide screen gets a dialog', (tester) async {
      await _pump(tester, _FakeSupport(), size: const Size(1200, 900));
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);
    });

    testWidgets('when support cannot be reached, the fallback is offered',
        (tester) async {
      var fellBack = 0;
      final repo = _FakeSupport()
        ..fail = FloSupportException('off', statusCode: 503);
      await _pump(tester, repo, onFallback: () => fellBack++);
      expect(find.byKey(const Key('flo-support-error')), findsOneWidget);
      final send =
          tester.widget<IconButton>(find.byKey(const Key('flo-support-send')));
      expect(send.onPressed, isNull);
      await tester.tap(find.byKey(const Key('flo-support-fallback')));
      expect(fellBack, 1);
    });

    testWidgets(
        'a failed send keeps the text and shows no fallback without one',
        (tester) async {
      final repo = _FakeSupport();
      await _pump(tester, repo);
      repo.fail = FloSupportException('down');
      await tester.enterText(
          find.byKey(const Key('flo-support-message')), 'Hello');
      await tester.tap(find.byKey(const Key('flo-support-send')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('flo-support-error')), findsOneWidget);
      expect(find.byKey(const Key('flo-support-fallback')), findsNothing);
      final field = tester
          .widget<TextField>(find.byKey(const Key('flo-support-message')));
      expect(field.controller!.text, 'Hello');
    });
  });

  test('the real providers talk HTTP and poll every 10 seconds', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(floSupportRepositoryProvider),
        isA<HttpFloSupportRepository>());
    expect(container.read(floSupportPollIntervalProvider),
        const Duration(seconds: 10));
  });
}
