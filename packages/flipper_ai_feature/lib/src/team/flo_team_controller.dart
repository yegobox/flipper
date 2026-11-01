import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/flo_chat_service.dart';
import 'flo_team_models.dart';
import 'flo_team_repository.dart';

/// The Flo Team API. Overridden in tests.
final floTeamRepositoryProvider = Provider<FloTeamRepository>(
  (ref) => HttpFloTeamRepository(baseUrl: FloChatService().baseUrl),
);

/// How often the board is refreshed while Flo is open.
final floTeamPollIntervalProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 10),
);

class FloTeamState {
  const FloTeamState({
    this.loading = true,
    this.error,
    this.me,
    this.members = const [],
    this.board = const FloTeamBoard(),
    this.floBusy = const {},
  });

  /// The first load has not finished.
  final bool loading;
  final String? error;
  final FloTeamMe? me;
  final List<FloTeamMember> members;
  final FloTeamBoard board;

  /// Threads Flo is answering in right now.
  final Set<String> floBusy;

  bool get isMember => me?.isMember ?? false;
  bool get isManager => me?.isManager ?? false;

  String nameOf(String? userId) {
    if (userId == null || userId.isEmpty) return '';
    for (final m in members) {
      if (m.userId == userId) return m.displayName;
    }
    return userId;
  }

  FloTeamState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    FloTeamMe? me,
    List<FloTeamMember>? members,
    FloTeamBoard? board,
    Set<String>? floBusy,
  }) =>
      FloTeamState(
        loading: loading ?? this.loading,
        error: clearError ? null : (error ?? this.error),
        me: me ?? this.me,
        members: members ?? this.members,
        board: board ?? this.board,
        floBusy: floBusy ?? this.floBusy,
      );
}

/// Flo Team for the Team tab: loads once, then polls while anything watches
/// it (the Flo header's unread badge does, so it runs while Flo is open).
class FloTeamController extends Notifier<FloTeamState> {
  Timer? _timer;

  /// The refresh in flight, shared by everyone who asks while it runs.
  Future<void>? _running;

  /// Set when the provider is disposed, so a refresh still awaiting the
  /// server leaves the dead state alone.
  bool _disposed = false;

  FloTeamRepository get _repo => ref.read(floTeamRepositoryProvider);

  @override
  FloTeamState build() {
    final every = ref.watch(floTeamPollIntervalProvider);
    _timer = Timer.periodic(every, (_) => refresh());
    ref.onDispose(() {
      _disposed = true;
      _timer?.cancel();
    });
    Future.microtask(refresh);
    return const FloTeamState();
  }

  /// Who we are, then what changed. Someone not yet invited is asked again
  /// each time, so an invitation takes effect without a restart.
  Future<void> refresh() =>
      _running ??= _refresh().whenComplete(() => _running = null);

  Future<void> _refresh() async {
    if (_disposed) return;
    try {
      if (!state.isMember) {
        final me = await _repo.me();
        if (_disposed) return;
        if (!me.isMember) {
          state = state.copyWith(me: me, loading: false, clearError: true);
          return;
        }
        // Membership is kept only with the member list, so a failed list is
        // fetched again (with `me`) on the next poll instead of never.
        final members = await _repo.members();
        if (_disposed) return;
        state = state.copyWith(me: me, members: members);
      }
      final changes = await _repo.changes(since: state.board.since);
      if (_disposed) return;
      state = state.copyWith(
        loading: false,
        clearError: true,
        board: state.board.merge(changes),
      );
    } on FloTeamException catch (e) {
      if (_disposed) return;
      if (e.notMember) {
        // Removed from the team since the last poll.
        state = FloTeamState(
          loading: false,
          me: FloTeamMe(
            userId: state.me?.userId ?? '',
            isMember: false,
            isManager: state.isManager,
          ),
        );
      } else {
        state = state.copyWith(loading: false, error: e.message);
      }
    }
  }

  /// Runs [action], then refreshes so the board shows its result. A failure
  /// is surfaced to the caller (for a snackbar) rather than swallowed.
  Future<void> _act(
      Future<void> Function(FloTeamRepository repo) action) async {
    await action(_repo);
    // A poll already running may have read the server before the write, so
    // let it finish and load again.
    await _running;
    await refresh();
  }

  Future<void> createThread({
    required String kind,
    required String title,
    String body = '',
  }) =>
      _act((r) => r.createThread(kind: kind, title: title, body: body));

  Future<void> updateThread(String id, Map<String, Object?> changes) =>
      _act((r) => r.updateThread(id, changes));

  Future<void> post(String threadId, String body, List<String> mentions) =>
      _act((r) => r.post(threadId, body, mentions: mentions));

  Future<void> toggleVote(FloTeamThread thread) =>
      _act((r) => r.vote(thread.id, on: !thread.voted));

  Future<void> markRead(String threadId) async {
    if (state.board.unreadIn(threadId) == 0) return;
    await _act((r) => r.markRead(threadId: threadId));
  }

  /// Flo answers in the thread ([summarize] for a summary); the thread shows
  /// Flo as busy until its post arrives.
  Future<void> askFlo(String threadId,
      {String question = '', bool summarize = false}) async {
    state = state.copyWith(floBusy: {...state.floBusy, threadId});
    try {
      await _act(
        (r) => summarize
            ? r.summarize(threadId)
            : r.askFlo(threadId, question: question),
      );
    } finally {
      // Flo can take minutes; the user may have closed Flo meanwhile.
      if (!_disposed) {
        state = state.copyWith(floBusy: {...state.floBusy}..remove(threadId));
      }
    }
  }

  Future<List<FloTeamMember>> colleagues() => _repo.colleagues();

  Future<void> invite(String userId) async {
    await _repo.invite(userId);
    await _reloadMembers();
  }

  Future<void> remove(String userId) async {
    await _repo.remove(userId);
    await _reloadMembers();
  }

  Future<void> _reloadMembers() async {
    final members = await _repo.members();
    if (!_disposed) state = state.copyWith(members: members);
  }
}

final floTeamControllerProvider =
    NotifierProvider.autoDispose<FloTeamController, FloTeamState>(
  FloTeamController.new,
);

/// Unread @mentions of the signed-in user, for the Team tab's badge.
final floTeamUnreadProvider = Provider.autoDispose<int>(
  (ref) => ref.watch(
    floTeamControllerProvider.select((s) => s.board.mentions.length),
  ),
);
