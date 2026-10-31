import 'dart:async';
import 'dart:io';

import 'package:flipper_ai_feature/src/team/flo_team_controller.dart';
import 'package:flipper_ai_feature/src/team/flo_team_models.dart';
import 'package:flipper_ai_feature/src/team/flo_team_repository.dart';
import 'package:flipper_ai_feature/src/team/flo_team_view.dart';
import 'package:flipper_ai_feature/src/widgets/flo/flo_header.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'fake_flo_team_repository.dart';

List<Override> _overrides(FakeFloTeamRepository repo, {Duration? every}) => [
      floTeamRepositoryProvider.overrideWithValue(repo),
      floTeamPollIntervalProvider
          .overrideWithValue(every ?? const Duration(hours: 1)),
    ];

Future<void> _pump(WidgetTester tester, FakeFloTeamRepository repo) async {
  tester.view.physicalSize = const Size(1000, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: _overrides(repo),
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: const Scaffold(body: FloTeamView()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

FakeFloTeamRepository _team() => FakeFloTeamRepository(
      threads: [
        idea('t1', 'Open on Sundays', votes: 2),
        idea('t2', 'Delivery',
            status: FloTeamStatus.todo,
            assignee: 'u2',
            due: DateTime(2026, 11, 6)),
        idea('t3', 'Weekly chat', kind: 'discussion'),
      ],
      posts: [
        const FloTeamPost(
            id: 'p1',
            threadId: 't1',
            isFlo: false,
            body: 'Sundays are slow',
            authorUserId: 'u2'),
        const FloTeamPost(
            id: 'p2', threadId: 't1', isFlo: true, body: 'plain Flo text'),
      ],
      mentions: [const FloTeamMention(id: 'm1', threadId: 't1')],
    );

void main() {
  group('FloTeamController', () {
    late ProviderContainer container;

    ProviderContainer start(FakeFloTeamRepository repo, {Duration? every}) {
      container = ProviderContainer(overrides: _overrides(repo, every: every));
      addTearDown(container.dispose);
      container.listen(floTeamControllerProvider, (_, __) {});
      return container;
    }

    FloTeamController team() =>
        container.read(floTeamControllerProvider.notifier);
    FloTeamState state() => container.read(floTeamControllerProvider);

    test('a member loads the board, then polls with since', () async {
      final repo = _team();
      start(repo);
      await team().refresh();
      expect([
        state().loading,
        state().isMember,
        state().board.threads.length,
        state().members.length
      ], [
        false,
        true,
        3,
        2
      ]);
      expect(container.read(floTeamUnreadProvider), 1);
      final since = state().board.since;
      await team().refresh();
      expect(repo.calls.where((c) => c == 'me').length, 1);
      expect(repo.calls.last, 'changes($since)');
    });

    test('names fall back to ids', () async {
      start(_team());
      await team().refresh();
      expect([
        state().nameOf(null),
        state().nameOf(''),
        state().nameOf('u2'),
        state().nameOf('zz')
      ], [
        '',
        '',
        'Eric',
        'zz'
      ]);
    });

    test('someone not invited is asked again on every poll', () async {
      final repo = _team()..isMember = false;
      start(repo);
      await team().refresh();
      expect([state().isMember, state().loading], [false, false]);
      repo.isMember = true;
      await team().refresh();
      expect(state().isMember, isTrue);
      expect(repo.calls.where((c) => c == 'me').length, 2);
    });

    test('being removed mid-poll empties the board; other errors are kept',
        () async {
      final repo = _team();
      start(repo);
      await team().refresh();
      repo.failChanges = FloTeamException('down', statusCode: 500);
      await team().refresh();
      expect([state().error, state().board.threads.length], ['down', 3]);
      repo.failChanges = FloTeamException('gone', statusCode: 403);
      await team().refresh();
      expect(
          [state().isMember, state().isManager, state().board.threads.length],
          [false, true, 0]);
    });

    test('overlapping refreshes run once', () async {
      final repo = _team();
      start(repo);
      await Future.wait([team().refresh(), team().refresh()]);
      expect(repo.calls.where((c) => c == 'me').length, 1);
    });

    test('it polls on its own', () async {
      final repo = _team();
      start(repo, every: const Duration(milliseconds: 20));
      await Future<void>.delayed(const Duration(milliseconds: 90));
      expect(repo.calls.where((c) => c.startsWith('changes')).length,
          greaterThan(1));
    });

    test('Flo is busy while answering, even when it fails', () async {
      final repo = _team();
      start(repo);
      await team().refresh();
      final gate = Completer<void>();
      repo.floGate = gate.future;
      final asking = team().askFlo('t1', question: 'why?');
      await Future<void>.delayed(Duration.zero);
      expect(state().floBusy, {'t1'});
      gate.complete();
      await asking;
      expect(state().floBusy, isEmpty);
      expect(repo.calls, contains('ask(t1,why?)'));

      repo.floGate = null;
      repo.failNext = FloTeamException('model down');
      await expectLater(team().askFlo('t1', summarize: true),
          throwsA(isA<FloTeamException>()));
      expect(state().floBusy, isEmpty);
    });

    test('members change, and reading a quiet thread asks nothing', () async {
      final repo = _team();
      start(repo);
      await team().refresh();
      await team().invite('u3');
      expect(state().members.map((m) => m.userId), ['me', 'u2', 'u3']);
      await team().remove('u2');
      expect(state().members.map((m) => m.userId), ['me', 'u3']);
      await team().markRead('t2');
      expect(repo.calls.where((c) => c.startsWith('read')), isEmpty);
      await team().markRead('t1');
      expect(repo.calls, contains('read(t1)'));
    });
  });

  group('FloTeamView', () {
    testWidgets('shows a spinner until the team loads', (tester) async {
      final repo = _team();
      await tester.pumpWidget(
        ProviderScope(
          overrides: _overrides(repo),
          child: MaterialApp(
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: const Scaffold(body: FloTeamView()),
          ),
        ),
      );
      expect(find.byKey(const Key('flo-team-loading')), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Open on Sundays'), findsOneWidget);
    });

    testWidgets('someone not invited is told to ask', (tester) async {
      await _pump(
          tester,
          _team()
            ..isMember = false
            ..isManager = false);
      expect(find.text('Flo Team is for invited members'), findsOneWidget);
      expect(find.byKey(const Key('flo-team-open-members')), findsNothing);
    });

    testWidgets('a manager who is not in the team can still open members',
        (tester) async {
      await _pump(tester, _team()..isMember = false);
      await tester.tap(find.byKey(const Key('flo-team-open-members')));
      await tester.pumpAndSettle();
      expect(find.text('Aline'), findsOneWidget);
      await tester.tap(find.byKey(const Key('flo-team-back')));
      await tester.pumpAndSettle();
      expect(find.text('Flo Team is for invited members'), findsOneWidget);
    });

    testWidgets('a failed first load can be retried', (tester) async {
      final repo = _team()..failChanges = FloTeamException('Flo Team is down');
      await _pump(tester, repo);
      expect(find.text('Couldn\'t load Flo Team'), findsOneWidget);
      repo.failChanges = null;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Open on Sundays'), findsOneWidget);
    });

    testWidgets('the board filters by column and posts new threads',
        (tester) async {
      final repo = _team();
      await _pump(tester, repo);
      expect(find.text('Open on Sundays'), findsOneWidget);
      expect(find.text('Delivery'), findsNothing);

      for (final (filter, title) in [
        ('todo', 'Delivery'),
        ('discussions', 'Weekly chat')
      ]) {
        await tester.tap(find.byKey(Key('flo-team-filter-$filter')));
        await tester.pumpAndSettle();
        expect(find.text(title), findsOneWidget);
      }
      await tester.tap(find.byKey(const Key('flo-team-filter-done')));
      await tester.pumpAndSettle();
      expect(find.text('Nothing here yet.'), findsOneWidget);

      // A new idea: nothing to post until it has a title; cancelling posts nothing.
      await tester.tap(find.byKey(const Key('flo-team-new-idea')));
      await tester.pumpAndSettle();
      final submit = find.byKey(const Key('flo-team-new-submit'));
      expect(tester.widget<FilledButton>(submit).onPressed, isNull);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(repo.calls.where((c) => c.startsWith('create')), isEmpty);

      await tester.tap(find.byKey(const Key('flo-team-filter-ideas')));
      await tester.tap(find.byKey(const Key('flo-team-new-idea')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const Key('flo-team-new-title')), ' Loyalty card ');
      await tester.enterText(find.byKey(const Key('flo-team-new-body')),
          'Stamp every 10th coffee');
      await tester.pump();
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(repo.calls,
          contains('create(idea,Loyalty card,Stamp every 10th coffee)'));
      expect(find.text('Loyalty card'), findsOneWidget);

      await tester.tap(find.byKey(const Key('flo-team-new-discussion')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const Key('flo-team-new-title')), 'Monday meeting');
      await tester.pump();
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('create(discussion,Monday meeting,)'));
    });

    testWidgets('votes toggle, and failures show in a snackbar',
        (tester) async {
      final repo = _team();
      await _pump(tester, repo);
      await tester.tap(find.byKey(const Key('flo-team-vote-t1')));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('vote(t1,true)'));
      expect(find.text('3'), findsOneWidget);

      repo.failNext = FloTeamException('Try again later');
      await tester.tap(find.byKey(const Key('flo-team-vote-t1')));
      await tester.pumpAndSettle();
      expect(find.text('Try again later'), findsOneWidget);
    });

    testWidgets(
        'a thread shows its posts, marks mentions read and takes replies',
        (tester) async {
      final repo = _team();
      await _pump(tester, repo);
      await tester.tap(find.byKey(const Key('flo-team-thread-t1')));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('read(t1)'));
      expect(find.text('Sundays are slow'), findsOneWidget);
      expect(find.text('Eric'), findsOneWidget);
      expect(find.text('plain Flo text'), findsOneWidget);

      // An empty reply sends nothing.
      await tester.tap(find.byKey(const Key('flo-team-send')));
      await tester.pumpAndSettle();
      expect(repo.calls.where((c) => c.startsWith('post')), isEmpty);

      // Mention Eric (and change your mind once), then reply.
      await tester.tap(find.byKey(const Key('flo-team-mention')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('flo-team-mention-me')), findsNothing);
      await tester.tap(find.byKey(const Key('flo-team-mention-u2')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('flo-team-mention-u2')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('flo-team-mention-u2')));
      await tester.pump();
      await tester.enterText(
          find.byKey(const Key('flo-team-reply')), 'Can you check?');
      await tester.tap(find.byKey(const Key('flo-team-send')));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('post(t1,Can you check?,[u2])'));
      expect(find.text('Can you check?'), findsOneWidget);
      expect(find.byKey(const Key('flo-team-mention-u2')), findsNothing);

      await tester.tap(find.byKey(const Key('flo-team-back')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('flo-team-new-idea')), findsOneWidget);
    });

    testWidgets('Flo answers in the thread', (tester) async {
      final repo = _team();
      final gate = Completer<void>();
      repo.floGate = gate.future;
      await _pump(tester, repo);
      await tester.tap(find.byKey(const Key('flo-team-thread-t1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('flo-team-ask-flo')));
      await tester.pump();
      expect(find.byKey(const Key('flo-team-flo-busy')), findsOneWidget);
      expect(
          tester
              .widget<OutlinedButton>(
                  find.byKey(const Key('flo-team-summarize')))
              .onPressed,
          isNull);
      gate.complete();
      await tester.pumpAndSettle();
      expect(find.text('Try it on two Sundays first.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('flo-team-summarize')));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('summarize(t1)'));
      expect(find.text('Everyone agrees.'), findsOneWidget);
    });

    testWidgets('an idea becomes a task', (tester) async {
      final repo = _team();
      await _pump(tester, repo);
      await tester.tap(find.byKey(const Key('flo-team-thread-t1')));
      await tester.pumpAndSettle();

      // Cancelling, or saving nothing, changes nothing.
      await tester.tap(find.byKey(const Key('flo-team-task')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('flo-team-task')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('flo-team-task-save')));
      await tester.pumpAndSettle();
      expect(repo.calls.where((c) => c.startsWith('update')), isEmpty);

      await tester.tap(find.byKey(const Key('flo-team-task')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('flo-team-task-status')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('To do').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('flo-team-task-assignee')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eric').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('flo-team-task-due')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('flo-team-task-due-clear')), findsOneWidget);
      await tester.tap(find.byKey(const Key('flo-team-task-due-clear')));
      await tester.pumpAndSettle();
      expect(find.text('Due: No date'), findsOneWidget);
      await tester.tap(find.byKey(const Key('flo-team-task-due')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('flo-team-task-due')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('flo-team-task-save')));
      await tester.pumpAndSettle();
      final update = repo.calls.singleWhere((c) => c.startsWith('update'));
      expect(update,
          startsWith('update(t1,{status: todo, assigneeUserId: u2, dueDate: '));
    });

    testWidgets('a manager invites and removes members', (tester) async {
      final repo = _team();
      await _pump(tester, repo);
      await tester.tap(find.byKey(const Key('flo-team-open-members')));
      await tester.pumpAndSettle();
      expect(find.text('Owner'), findsOneWidget);
      expect(find.byKey(const Key('flo-team-remove-me')), findsNothing);

      await tester.tap(find.byKey(const Key('flo-team-invite-u3')));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('invite(u3)'));
      expect(find.text('Everyone on your staff is already in the team.'),
          findsOneWidget);

      await tester.tap(find.byKey(const Key('flo-team-remove-u2')));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('remove(u2)'));
      expect(find.byKey(const Key('flo-team-remove-u2')), findsNothing);
    });

    testWidgets('the members list says when colleagues cannot load',
        (tester) async {
      final repo = _team();
      await _pump(tester, repo);
      repo.failNext = FloTeamException('staff list unavailable');
      await tester.tap(find.byKey(const Key('flo-team-open-members')));
      await tester.pumpAndSettle();
      expect(find.text('staff list unavailable'), findsOneWidget);
    });

    testWidgets('a non-manager member has no members button', (tester) async {
      await _pump(tester, _team()..isManager = false);
      expect(find.byKey(const Key('flo-team-open-members')), findsNothing);
      expect(find.byKey(const Key('flo-team-new-idea')), findsOneWidget);
    });
  });

  testWidgets('the header has a Team tab with unread mentions', (tester) async {
    FloPanelMode? picked;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(
          body: FloHeader(
            mode: FloPanelMode.askFlo,
            onModeChanged: (m) => picked = m,
            isMobile: true,
            actionsInAppBar: true,
            teamUnreadCount: 4,
          ),
        ),
      ),
    );
    expect(find.text('Team'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    await tester.tap(find.byKey(const Key('flo-mode-team')));
    expect(picked, FloPanelMode.team);
  });

  group('the desktop header', () {
    // The default test font draws every glyph as a full square, which makes
    // text several times wider than it is; widths only mean something in a
    // real font.
    setUpAll(() async {
      final root = Platform.environment['FLUTTER_ROOT'] ??
          File(Platform.resolvedExecutable)
              .parent
              .parent
              .parent
              .parent
              .parent
              .parent
              .path;
      final fonts = '$root/bin/cache/artifacts/material_fonts';
      final loader = FontLoader('Roboto');
      for (final weight in ['Regular', 'Medium', 'Bold']) {
        final bytes = File('$fonts/Roboto-$weight.ttf').readAsBytesSync();
        loader.addFont(Future.value(ByteData.sublistView(bytes)));
      }
      await loader.load();
    });

    for (final width in [
      1000.0,
      1199.0,
      1200.0,
      1280.0,
      1366.0,
      1440.0,
      1920.0
    ]) {
      for (final mode in [FloPanelMode.askFlo, FloPanelMode.team]) {
        testWidgets('fits at ${width.toInt()}px in ${mode.name}',
            (tester) async {
          tester.view.physicalSize = Size(width, 900);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(fontFamily: 'Roboto'),
              localizationsDelegates: FlipperLocalizationDelegates.delegates,
              supportedLocales: FlipperLocalizationDelegates.supportedLocales,
              home: Scaffold(
                body: FloHeader(
                  mode: mode,
                  onModeChanged: (_) {},
                  isMobile: false,
                  teamUnreadCount: 2,
                  // About the width of the real local/cloud model picker.
                  modelSelector: const SizedBox(width: 170, height: 32),
                ),
              ),
            ),
          );
          expect(tester.takeException(), isNull);
          expect(find.text('2'), findsOneWidget);
        });
      }
    }
  });

  test('the real repository and a 10 second poll are the defaults', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(floTeamRepositoryProvider),
        isA<HttpFloTeamRepository>());
    expect(container.read(floTeamPollIntervalProvider),
        const Duration(seconds: 10));
  });
}
