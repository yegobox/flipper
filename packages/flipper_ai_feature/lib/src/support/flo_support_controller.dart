import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/flo_chat_service.dart';
import 'flo_support_repository.dart';

/// The Flo Support API. Overridden in tests.
final floSupportRepositoryProvider = Provider<FloSupportRepository>(
  (ref) => HttpFloSupportRepository(baseUrl: FloChatService().baseUrl),
);

/// How often the conversation is refreshed while the chat is open.
final floSupportPollIntervalProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 10),
);

class FloSupportState {
  const FloSupportState({
    this.loading = true,
    this.sending = false,
    this.error,
    this.unavailable = false,
    this.resolved = false,
    this.posts = const [],
    this.threadId,
    this.since,
  });

  final bool loading;
  final bool sending;
  final String? error;

  /// Support chat is switched off on the server: offer another way.
  final bool unavailable;
  final bool resolved;
  final List<FloSupportPost> posts;
  final String? threadId;
  final String? since;

  FloSupportState copyWith({
    bool? loading,
    bool? sending,
    String? error,
    bool clearError = false,
    bool? unavailable,
    bool? resolved,
    List<FloSupportPost>? posts,
    String? threadId,
    String? since,
  }) =>
      FloSupportState(
        loading: loading ?? this.loading,
        sending: sending ?? this.sending,
        error: clearError ? null : (error ?? this.error),
        unavailable: unavailable ?? this.unavailable,
        resolved: resolved ?? this.resolved,
        posts: posts ?? this.posts,
        threadId: threadId ?? this.threadId,
        since: since ?? this.since,
      );
}

/// The support chat: loads the conversation, then polls for replies while
/// the chat is open.
class FloSupportController extends Notifier<FloSupportState> {
  Timer? _timer;
  Future<void>? _running;
  bool _disposed = false;

  FloSupportRepository get _repo => ref.read(floSupportRepositoryProvider);

  @override
  FloSupportState build() {
    final every = ref.watch(floSupportPollIntervalProvider);
    _timer = Timer.periodic(every, (_) => refresh());
    ref.onDispose(() {
      _disposed = true;
      _timer?.cancel();
    });
    Future.microtask(refresh);
    return const FloSupportState();
  }

  Future<void> refresh() =>
      _running ??= _refresh().whenComplete(() => _running = null);

  Future<void> _refresh() async {
    if (_disposed) return;
    try {
      final changes = await _repo.conversation(since: state.since);
      if (_disposed) return;
      _merge(changes);
    } on FloSupportException catch (e) {
      if (_disposed) return;
      state = state.copyWith(
        loading: false,
        error: e.message,
        unavailable: e.unavailable,
      );
    }
  }

  void _merge(FloSupportConversation changes) {
    // Support archived the old thread: start over rather than mix the two.
    final restarted =
        changes.threadId != null && changes.threadId != state.threadId;
    final known = restarted
        ? <String, FloSupportPost>{}
        : {
            for (final p in state.posts) p.id: p,
          };
    for (final p in changes.posts) {
      known[p.id] = p;
    }
    final posts = known.values.toList()
      ..sort((a, b) =>
          (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0)));
    state = FloSupportState(
      loading: false,
      sending: state.sending,
      resolved: changes.threadId == null ? false : changes.resolved,
      posts: changes.threadId == null ? const [] : posts,
      threadId: changes.threadId,
      since: changes.serverTime ?? state.since,
    );
  }

  /// Sends [body]. Returns false (with [FloSupportState.error] set) when it
  /// could not, so the caller keeps the text for another try.
  Future<bool> send(
    String body, {
    String topic = 'general',
    Map<String, String>? context,
  }) async {
    final text = body.trim();
    if (text.isEmpty || state.sending) return false;
    state = state.copyWith(sending: true, clearError: true);
    try {
      final sent = await _repo.send(text, topic: topic, context: context);
      if (_disposed) return true;
      // Shown now, so a failing follow-up read cannot hide a message the
      // server took.
      if (sent.id.isNotEmpty) {
        state = state.copyWith(
          posts: [...state.posts.where((p) => p.id != sent.id), sent],
        );
      }
      // The poll may already be reading; let it finish, then read again so
      // the new message (and a reopened thread) shows at once. Still
      // sending until then: the composer keeps the text until this returns,
      // so a second tap would post it twice.
      await _running;
      await refresh();
      return true;
    } on FloSupportException catch (e) {
      if (!_disposed) {
        state = state.copyWith(error: e.message, unavailable: e.unavailable);
      }
      return false;
    } finally {
      if (!_disposed) state = state.copyWith(sending: false);
    }
  }
}

final floSupportControllerProvider =
    NotifierProvider.autoDispose<FloSupportController, FloSupportState>(
  FloSupportController.new,
);
